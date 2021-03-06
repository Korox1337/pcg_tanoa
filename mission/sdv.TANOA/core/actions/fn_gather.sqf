#include "..\..\script_macros.hpp"
/*
	File: fn_gather.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Main functionality for gathering.
*/
if(isNil "life_action_gathering") then {life_action_gathering = false;};
private["_gather","_itemWeight","_diff","_itemName","_resourceZones","_zone"];
_resourceZones = ["banane_1","banane_2","kiwi_1","kirsche_1","gerste_1","hopfen_1","weizen_1","wasser_1","heroin_1","cocaine_1","weed_1","eichenholz_1","eichenholz_2","eichenholz_3","eichenholz_4","tropenholz_1","tropenholz_2","tropenholz_3","tropenholz_4","koralle_1","kakao_1];
_zone = "";

if(life_action_inUse) exitWith {}; //Action is in use, exit to prevent spamming.
life_action_inUse = true;
//Find out what zone we're near	
{
	if(player distance (getMarkerPos _x) < 30) exitWith {_zone = _x;};
} foreach _resourceZones;

if(EQUAL(_zone,"")) exitWith {life_action_inUse = false;};

//Get the resource that will be gathered from the zone name...
switch(true) do {
	case (_zone in ["banane_1","banane_2"]): {_gather = ["banane",2];};
	case (_zone in ["kiwi_1"]): {_gather = ["kiwi",3];};
	case (_zone in ["kirsche_1"]): {_gather = ["kirsche",3];};
	case (_zone in ["gerste_1"]): {_gather = ["gerste",3];};
	case (_zone in ["hopfen_1"]): {_gather = ["hopfen",3];};
	case (_zone in ["weizen_1"]): {_gather = ["weizen",3];};
	case (_zone in ["wasser_1"]): {_gather = ["wasser",1];};
	case (_zone in ["eichenholz_1","eichenholz_2","eichenholz_3","eichenholz_4"]): {_gather = ["eichenholz",2];};
	case (_zone in ["tropenholz_1","tropenholz_2","tropenholz_3","tropenholz_4"]): {_gather = ["tropenholz",2];};
	case (_zone in ["heroin_1"]): {_gather = ["heroin_unprocessed",1];};
	case (_zone in ["cocaine_1"]): {_gather = ["cocaine_unprocessed",1];};
	case (_zone in ["weed_1"]): {_gather = ["cannabis",1];};
	case (_zone in ["koralle_1"]): {_gather = ["koralle",1];};
	case (_zone in ["kakao_1"]): {_gather = ["kakao",2];};
	default {""};
};
//gather check??
if(vehicle player != player) exitWith {};

_diff = [SEL(_gather,0),SEL(_gather,1),life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
if(EQUAL(_diff,0)) exitWith {hint localize "STR_NOTF_InvFull"};
life_action_inUse = true;

for "_i" from 0 to 2 do {
	player playMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
	waitUntil{animationState player != "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";};
	sleep 2.5;
};

if(([true,SEL(_gather,0),_diff] call life_fnc_handleInv)) then {
	_itemName = M_CONFIG(getText,"VirtualItems",SEL(_gather,0),"displayName");
	titleText[format[localize "STR_NOTF_Gather_Success",(localize _itemName),_diff],"PLAIN"];
};

life_action_inUse = false;
