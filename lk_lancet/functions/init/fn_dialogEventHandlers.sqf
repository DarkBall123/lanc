#include "..\includes.hpp"
#define GRID_W( num ) ( num * ( pixelGridNoUIScale * pixelW * 2 ))
#define GRID_H( num ) ( num * ( pixelGridNoUIScale * pixelH * 2 ))
params ["_diag"];
private _cmdEH = _diag displayAddEventHandler ["KeyDown",  { 
	params ["_display", "_key"];

	switch (_key) do {
		//thermals N
		case 49: {
			private _camera = uiNamespace getVariable ["_mainCamera", objNull];
			if(isNull _camera) exitWith {}; 

			private _state = uiNamespace getVariable ["_thermalState", true];
			_state setCamUseTI 0;
			uiNamespace setVariable ["_thermalState", !_state];
		};
		//autolock T
		case 20: {
    		private _camera = uiNamespace getVariable ["_mainCamera", objNull];
    		if (isNull _camera) exitWith {}; 

    		private _state = uiNamespace getVariable ["_autoLockState", false];
    		uiNamespace setVariable ["_autoLockState", !_state];

    		private _targetCursor = _display displayCtrl target_cursor;
    		uiNamespace setVariable ["_itemLock", false];

    		private _isSlewing = uiNamespace getVariable ["DB_isSlewing", false];

    		if (!_isSlewing) then {
    		    uiNamespace setVariable ["DB_isSlewing", true];
				(uiNameSpace getVariable ["DB_targetCross", controlNull]) ctrlShow false;
				(uiNameSpace getVariable ["DB_full_screenplus", controlNull]) ctrlShow false;
				(uiNameSpace getVariable ["DB_AutoLockPicture", controlNull]) ctrlShow true;

				call lancet_fnc_lockTarget;
    		} else {
    		    uiNamespace setVariable ["DB_isSlewing", false];

				(uiNameSpace getVariable ["DB_targetCross", controlNull]) ctrlShow true;
				(uiNameSpace getVariable ["DB_full_screenplus", controlNull]) ctrlShow true;
				(uiNameSpace getVariable ["DB_AutoLockPicture", controlNull]) ctrlShow false;

				private _width = GRID_W(7);
				private _height = GRID_H(7);
		
				_seekerLockPicture ctrlSetPosition [0.5 - _width / 2, 0.5 - _height / 2, _width, _height];
				_seekerLockPicture ctrlCommit 0.0;
    		};
		};

		//zoom R 
		case 19: {
			private _camera = uiNamespace getVariable ["_mainCamera", objNull];
			if(isNull _camera) exitWith {}; 

			private _state = uiNamespace getVariable ["_zoomStatus", false];
			uiNamespace setVariable ["_zoomStatus", !_state];

			private _crosshair = _display displayCtrl seeker_head;
			private _targetCursor = _display displayCtrl target_cursor;
			
			if(_state) then {
				_camera camSetFov 0.55;
				//_crosshair ctrlSetPosition [0.5 - txtSize / 2, 0.5 - txtSize / 2, txtSize, txtSize];
				//_crosshair ctrlCommit 0;

				//_targetCursor ctrlSetPosition [0.5 - txtSize / 16, 0.5 - txtSize / 16, txtSize/16, txtSize/16];
				//_targetCursor ctrlCommit 0;
			} else {
				//private _t = txtSize * 1.5;
				_camera camSetFov 0.15;
				//_crosshair ctrlSetPosition [0.5 -_t / 2, 0.5 - _t / 2, _t, _t];
				_crosshair ctrlCommit 0;

				//_targetCursor ctrlSetPosition [0.5 - _t / 16, 0.5 - _t / 16, _t/16, _t/16];
				//_targetCursor ctrlCommit 0;
			};
			_camera camCommit 0;
			[_display] call lancet_fnc_handleMouse;
		};
		//Airburst - F
		case 33: {
			_projectile = uiNamespace getVariable ["lancet_currentProjectile", objNull];
			if(!isNull _projectile) then {
				triggerAmmo _projectile;
				closeDialog 1;
			};
		};
		//ESc
		case 1: {
			closeDialog 1;
		};
	};
}];

private _ehId = _diag displayAddEventHandler ["MouseButtonDown","uiNamespace setVariable ['mouseClick', true];"];
