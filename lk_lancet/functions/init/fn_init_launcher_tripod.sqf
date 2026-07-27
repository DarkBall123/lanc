if(!(alive player)) exitWith {};

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

_gunner = (getShotParents _projectile) # 1;

deleteVehicle _projectile;

// Locality fix - only spawn lancet on client shooting this, or client controlling this gunner
private _player = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];

if(_gunner != _player) exitWith {};

_unitType = typeOf _unit;

_basePos = AGLToASL (_unit modelToWorld (_unit selectionPosition "konec hlavne"));
_muzzlePos = AGLToASL (_unit modelToWorld (_unit selectionPosition "usti hlavne"));

private _isIzdelie = (_unitType find "izdelie") > -1;
private _isGeran = (_unitType find "geran") > -1;
private _uavType = "m_lancet_dummy";

if (_isIzdelie) then {
    _uavType = "m_izdelie_dummy";
};

if (_isGeran) then {
    _uavType = "m_geran_dummy";
};

_launchPos = _muzzlePos vectorAdd (_basePos vectorFromTo _muzzlePos);
_uav = _uavType createVehicle _launchPos;
_uav setPosASL _launchPos;

[_uav, true] remoteExec ["hideObjectGlobal", 2];

private _uav_temp_type = "";

switch (true) do {
    case ((side _gunner == INDEPENDENT) && {!_isIzdelie}): {
        _uav_temp_type = "I_uav_lancet3";
    };

    case ((side _gunner == EAST) && {_isIzdelie}): {
        _uav_temp_type = "O_uav_izdelie53";
    };

    case ((side _gunner == WEST) && {_isIzdelie}): {
        _uav_temp_type = "B_uav_izdelie53";
    };

    case ((side _gunner == WEST) && {!_isIzdelie}): {
        _uav_temp_type = "B_uav_lancet3";
    };

    case ((side _gunner == EAST) && {!_isIzdelie}): {
        _uav_temp_type = "O_uav_lancet3";
    };

    case ((side _gunner == INDEPENDENT) && {_isIzdelie}): {
        _uav_temp_type = "I_uav_izdelie53";
    };
};

private _uav_temp = _uav_temp_type createVehicle _launchPos;
createVehicleCrew _uav_temp;

if (local _uav_temp) then {
	_uav_temp lockDriver true;
} else {
	[_uav_temp, true] remoteExec ["lockDriver", 0, true];
};

_uav setVariable ["DB_lancet_subUAV", _uav_temp];
_uav_temp setVariable ["DB_lancet_parentProjectile", _uav];

_uav_temp attachTo [_uav, [0, 0, 0]];
_uav_temp addEventHandler ["Killed", {
	params ["_uav_temp"];

	private _projectile = _uav_temp getVariable ["DB_lancet_parentProjectile", objNull];

	if (alive _projectile) then {
		triggerAmmo _projectile;
	};

	deleteVehicle _uav_temp;
}];

(driver _uav_temp) disableAI "ALL";
(gunner _uav_temp) disableAI "ALL";
_uav_temp disableAI "ALL";

_dir = _unit weaponDirection (currentWeapon _unit);
_dir_degrees = (_dir select 0) atan2 (_dir select 1);
_vertical_angle = (atan ((vectorDir _unit)#2)) max 0;
_uav setDir _dir_degrees;

_uav engineOn true;
_uav setVehicleAmmo 0;
[_uav, [25, 0, direction _uav]] call lancet_fnc_setAngleOfAttack;
_vel = velocity _uav;
_dir = direction _uav;
_speed = 60;
_uav setVelocity [
	(sin _dir * _speed), 
	(cos _dir * _speed), 
	(50 + _vertical_angle)
];
_uav setDamage 0;

[_unit, _uav] call lancet_fnc_initMissile;

_startTime = diag_tickTime;
[_uav, _gunner, _vertical_angle, _startTime] spawn {
	params ["_uav", "_gunner", "_vertical_angle", "_startTime"];

	for "_i" from 1 to 5 do {
		[_uav, [25, 0, direction _uav]] call lancet_fnc_setAngleOfAttack;
		_vel = velocity _uav;
		_dir = direction _uav;
		_speed = 60;
		_uav setVelocity [
			(sin _dir * _speed), 
			(cos _dir * _speed), 
			(25 + _vertical_angle)
			];
		_uav setDamage 0;
		sleep 0.2;
	};
	_uav setDamage 0;
};
