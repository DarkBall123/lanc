_unit 		= param[0, objNull];
_projectile = param[1, objNull];
_speedArr 	= param[2, []];
_offset 	= param[3, 0.65];
_interface 	= param[4, "lancet_seeker"];

//Add the action to the unit and it's vehicle if the unit is inside one
private _unitsAction = crew (vehicle _unit);
//_unitsAction pushBackUnique (vehicle _unit);

//Init
_projectile setVariable ["lancet_launchTime", time];
//Add the action to the whole crew
{
	//Adds the main control action
	_id = _x addAction ["Enable control", {
		params ["_target", "_caller", "_actionId", "_arguments"];
		private _unit 		= _arguments # 0;
		private _projectile = _arguments # 1;
		private _offset 	= _arguments # 2;
		private _interface 	= _arguments # 3;

		[_projectile, _offset, [], _interface] spawn lancet_fnc_handleMissile;
	}, [_x, _projectile, _offset, _interface], 10, true, false, "","", 5, false];

	//Clean the action if the proj dies
	[_projectile, _id, _x] spawn {
		private _projectile = _this #0;
		private _actionId = _this # 1;
		private _unit 	= _this # 2;

		waitUntil {!alive _projectile};
		_unit removeAction _actionId;
	};
}forEach _unitsAction;

//Speed, override speed only for missiles with presets
if(_speedArr isEqualTo []) then {
	_speedArr = getArray (configOf _projectile >> "lancet_speedArray");
};
//found something
if(count _speedArr > 0) then {
	[_projectile, _speedArr] spawn lancet_fnc_handleSpeed;
};

//Autolevel 
if(isTouchingGround _unit) then {
	[_projectile, _unit] spawn {
		params["_projectile", "_unit"];
		private _altUnit = (getPosASL _unit) # 2;
		private _targetAlt = _altUnit + 350;

		waitUntil {
			(((getPosASL _projectile) # 2) > _targetAlt) or (!alive _projectile)
		};
		if(!alive _projectile) exitWith {};

		private _vDirTgt = vectorDir _projectile;
		_vDirTgt set [2,0];

		//Projectile 
		private _vUpProj 	= vectorUp _projectile;
		private _vDirProj	= vectorDir _projectile;

		//Handle moving the missile
		_id = ["lancet_handleMissileLevel", "onEachFrame", {
			params[ "_projectile","_timeArr", "_vUpArr", "_vDirArr"];
			_vDir = vectorLinearConversion [_timeArr # 0, _timeArr # 1, time, _vDirArr # 0, _vDirArr # 1];
			_vUp  = vectorLinearConversion [_timeArr # 0, _timeArr # 1, time, _vUpArr # 0, _vUpArr # 1];
			_projectile setVectorDirAndUp [_vDir, _vUp];
		}, [_projectile, [time, time + 1.5], [_vUpProj, [0,0,1]], [_vDirProj, _vDirTgt]]] call BIS_fnc_addStackedEventHandler;

		private _timeZero = time;
		waitUntil {
			!(alive _projectile) or (time - _timeZero) > 1.5
		};
		[_id, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	};
};


