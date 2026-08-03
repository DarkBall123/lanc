#include "..\includes.hpp"
//params["_projectile", "_offset", "_speedArr"];

private _projectile = param [0,objNull];
private _offset 	= param [1, 2.0];
private _speedArr 	= param [2, []];
private _dialogName = param [3, "lancet_seeker"];

//Handle camera
private _camera = [_projectile, 2.0] call lancet_fnc_camCreate; // 2.0 def

//Create dialog
private _diag = createDialog ["lancet_seeker", true];

//Detect clicks
uiNamespace setVariable ["mouseClick", false];

//Change FOV / thermals / autolock
uiNamespace setVariable ["isSlewing", false];
uiNamespace setVariable ["_mainCamera", _camera];
uiNamespace setVariable ["_thermalState", true];
uiNamespace setVariable ["_autoLockState", true];
uiNamespace setVariable ["_zoomStatus", false];
uiNamespace setVariable ["_itemLock", false];
uiNamespace setVariable ["DB_isSlewing", false];

//Current projectile for manual detonation
uiNamespace setVariable ["lancet_currentProjectile", _projectile];

//Missile stuff
//Main variables
private _target = objNull;
private _posProj = []; //Projectile pos
private _posWorld = []; //World target position
private _v = []; //Target versor (from projectile)
private _timeManouver = 0; //Time for manouver
private _timeCheck = time; //Time now
private _targetEnabled = true; //Smart targetting
private _crossTarget = []; //Position for the crosshair
private _crtlSize = []; //Size of the control thing 
private _wordToScreenPos = []; //Position on the screen of the current target
private _targetOffset = [0,0,0]; //Offset from target center 
private _targetArr = []; 

//Fast cleanup when the missile dies
_projectile setVariable ["_projAttachedCamera", _camera, true];
_projectile addEventHandler ["Explode", {
	params ["_projectile"];
	//_camera is saved to uiNamespace meaning if you are using another projectile it's overwritten
	_camera = uiNamespace getVariable "_mainCamera";
	_attachedCam = _projectile getVariable "_projAttachedCamera";

	private _uav_temp = _projectile getVariable ["DB_lancet_subUAV", objNull];
	deleteVehicle _uav_temp;

	if(_camera == _attachedCam) then {
		[_camera] call lancet_fnc_cleanEffectsCam;
	};
}];

_projectile addEventHandler ["Explode", {
	[] spawn {
		if (isNull (uiNamespace getVariable ["_mainCamera", objNull])) exitWith {};
		
		PP_film = ppEffectCreate ["FilmGrain",2000]; 
		PP_film ppEffectAdjust [1,0,0,1.03,1.05,true];
		PP_film ppEffectCommit 0;
		PP_film ppEffectEnable true;

		waitUntil {isNull (uiNamespace getVariable "_mainCamera")};


		PP_film = ppEffectCreate ["FilmGrain",2000]; 
		PP_film ppEffectAdjust [1,0,0,1.03,1.05,true];
		PP_film ppEffectCommit 0;
		PP_film ppEffectEnable true;

		sleep 0.8;

		ppEffectDestroy PP_film;
	};
}];

//Effects
[] call lancet_fnc_handleEffects;

//Detect button presses
[_diag] call lancet_fnc_dialogEventHandlers;

if(count _speedArr > 0) then {
	[_projectile, _speedArr] spawn lancet_fnc_handleSpeed;
};

//Updates all the text values for the seeker
[_diag, _projectile] spawn lancet_fnc_handleText;

//Target cursor box and crosshair
private _crosshair = _diag displayCtrl seeker_head;
private _targetCursor = _diag displayCtrl target_cursor;
_targetCursor ctrlShow false;

//Main loop
while {alive _projectile and dialog} do {
	if(time - _timeCheck > 0.1) then {
		_targetEnabled = uiNamespace getVariable ["_autoLockState", true];

		if(!_targetEnabled) then {
			_target = objNull;
			_targetOffset = [0,0,0]; 
		};
		
		//Target cursor
		if(ctrlShown _targetCursor) then {
			_crtlSize = (ctrlPosition _targetCursor) # 3;
			_crossTarget = [];
			if(isNull _target) then {
				_wordToScreenPos = worldToScreen ((ASLTOAGL _posWorld) vectorAdd _targetOffset);
				if(count _wordToScreenPos > 0) then {
					_crossTarget = _wordToScreenPos vectorDiff [_crtlSize/2, _crtlSize/2];
				};
			} else {
				_wordToScreenPos = (worldToScreen ((ASLTOAGL getposASl _target) vectorAdd _targetOffset)); 
				if(count _wordToScreenPos > 0) then {
					_crossTarget = _wordToScreenPos vectorDiff [_crtlSize/2, _crtlSize/2];
				};
			};
			//Check if the cursor is outside the screen, in that case disable it
			if(count _crossTarget > 0) then {
				_crossTarget vectorAdd [random [-0.14, 0, 0.14], random [-0.15, 0, 0.15]];
				_crossTarget deleteAt 2;
				_targetCursor ctrlSetPosition _crossTarget;
				_targetCursor ctrlCommit 0;
			} else {
				_targetCursor ctrlShow false;
			};
			
			uiNamespace setVariable ["_itemLock", ctrlShown _targetCursor];
		};

		_timeCheck = time;
	};

	//Has clicked
	if(uiNamespace getVariable ["mouseClick", false]) then {
		uiNamespace setVariable ['mouseClick', false];
		_target = objNull;
		_targetOffset = [0,0,0]; 
		_projectile setMissileTarget objNull;

		//_posProj = getPosASL _projectile;	
		_posProj = AGLTOASL positionCameraToWorld [0,0,0];	
		_posWorld = AGLTOASL screenToWorld getMousePosition;
		_v = _posWorld vectorDiff _posProj; 

		if(_targetEnabled) then {
			_targetArr = [_projectile, _v] call lancet_fnc_findTarget;
			_target 		= _targetArr # 0;
			_targetOffset 	= _targetArr # 1;
			//More accurate
			if(!isNull _target) then {
				_v = ((getPosASL _target) vectorAdd _targetOffset) vectorDiff _posProj; 
			};
		};

		//Manouver time based on speed
		_angleFac = (1 - abs((vectorDir _projectile) vectorCos _v)); //high deviation means longer manouvers
		_timeManouver = [_projectile, 0.5 + _angleFac, 1] call lancet_fnc_manouverTime;
	
		//Crosshair
		[_diag, _crosshair, _timeManouver, nil, true]  spawn lancet_fnc_centerCursor;

		//Moves the missile
		[_projectile, _v, _timeManouver] spawn lancet_fnc_handleGuidance;


		//Finally show the cursor
		//_targetCursor ctrlShow _targetEnabled;
	} else {
		//If the missile has a target it will keep tracking it
		if(!isNull _target and _targetEnabled) then {
			//_projectile setMissileTarget _target; //Some projectiles allow handoff
			_posProj = AGLTOASL positionCameraToWorld [0,0,0];	
			_v = (getPosASL _target vectorAdd _targetOffset) vectorDiff _posProj; 

			_timeManouver = 0.3;
			/*
			Disabled because it would make switching targets hard when on final
			_wordToScreenPos = (worldToScreen ((ASLTOAGL getposASl _target) vectorAdd _targetOffset)); 
			//If the target is in the screen move the cursor over it
			if(count _wordToScreenPos > 0) then {
				_crtlSize = (ctrlPosition _crosshair) # 3;
				_crossTarget = _wordToScreenPos vectorDiff [_crtlSize/2, _crtlSize/2];
				_crossTarget vectorAdd [random [-0.2, 0, 0.2], random [-0.15, 0, 0.15]];
				[_diag, _crosshair, _timeManouver, _crossTarget]  spawn lancet_fnc_centerCursor;	
			};
			*/
			[_projectile, _v, _timeManouver] spawn lancet_fnc_handleGuidance;
			sleep (_timeManouver - 0.1);
		};
	};

	sleep 0.1;
};

//If we closed the dialog while the missile is still alive, it will auto track the target, if any
if(alive _projectile and !isNull _target) then {
	_projectile setMissileTarget _target; //Some projectiles allow handoff
};

//Clean 
if(!isNull _camera) then {
	closeDialog 1;
	false setCamUseTI 0;
	_camera cameraEffect ["terminate","back"];
	camDestroy _camera;
};

private _effects = (uiNamespace getVariable ["lancet_effectsArr", []]);
if(count _effects > 0) then {
	{
		ppEffectDestroy _x;
	}forEach _effects;
};
uiNamespace setVariable ["lancet_effectsArr",  []];

		//_id = [str _projectile, "onEachFrame", { drawLine3D [_this # 0, _this # 1, [1,1,1,1]]}, [aslToAGL positionCameraToWorld [0,0,0], (aslToAGL _posProj) vectorAdd _v]] call BIS_fnc_addStackedEventHandler;
		