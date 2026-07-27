#include "..\includes.hpp"
params ["_display", "_control",  "_timeManouver", "_endPosition", "_mouseCenter"];

if(uiNamespace getVariable ["isSlewing", false]) exitWith {};
uiNamespace setVariable ["isSlewing", true];

private _control = uiNamespace getVariable ["DB_seeker_lock", controlNull];//_display displayCtrl seeker_head;
private _startPos = ctrlPosition _control;

//Clean up 4 elements vec
_ctrlSize = _startPos select [2,2];
{_startPos deleteAt _x} forEach [3,2];
_startPos pushBack 0;


//Just center the cursor
if(isNil "_endPosition") then {
	_endPosition = [0.5 - _ctrlSize # 0 / 2, 0.5 - _ctrlSize # 1 / 2, 0];
};
if(count _endPosition == 2) then {
	_endPosition pushBack 0;
};

private _timeNow = time;
private _id = ["lancet_handleCursor", "onEachFrame", {
	params[ "_control","_startPos", "_endPosition","_timeNow", "_timeManouver"];
	private _ctrpos = vectorLinearConversion [_timeNow, _timeManouver, time, _startPos, _endPosition];

	_ctrpos deleteAt 2;
	_control ctrlSetPosition _ctrpos;
	_control ctrlCommit 0;
}, [_control, _startPos, _endPosition, _timeNow, _timeNow + _timeManouver]] call BIS_fnc_addStackedEventHandler;


waitUntil {(time - _timeNow) > _timeManouver};
uiNamespace setVariable ["isSlewing", false];
[_id, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;

if(!isNil "_mouseCenter") then {
	setMousePosition [0.5, 0.5];
};