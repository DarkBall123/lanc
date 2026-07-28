params ["_unit", "_gunner", "_uavType", "_isIzdelie", "_isGeran"];

if (_isGeran) then {
    _unit setVariable ["lancet_launchPending", false, true];
    _unit setVariable ["lancet_keepLoadedVisual", false, true];
    _unit animateSource ["tubel_hide_full", 1, true];
};

if (!alive _unit || {!alive _gunner}) exitWith {};

private _basePos = AGLToASL (_unit modelToWorld (_unit selectionPosition "konec hlavne"));
private _muzzlePos = AGLToASL (_unit modelToWorld (_unit selectionPosition "usti hlavne"));
private _launchPos = _muzzlePos vectorAdd (_basePos vectorFromTo _muzzlePos);
private _uav = _uavType createVehicle _launchPos;
_uav setPosASL _launchPos;
_uav hideObject true;
[_uav, true] remoteExec ["hideObjectGlobal", 2];

private _uavTempType = "";

switch (true) do {
    case ((side _gunner == INDEPENDENT) && {_isGeran}): {
        _uavTempType = "lancet_geran_uav_i";
    };

    case ((side _gunner == EAST) && {_isGeran}): {
        _uavTempType = "lancet_geran_uav_o";
    };

    case ((side _gunner == WEST) && {_isGeran}): {
        _uavTempType = "lancet_geran_uav_b";
    };

    case ((side _gunner == INDEPENDENT) && {!_isIzdelie}): {
        _uavTempType = "I_uav_lancet3";
    };

    case ((side _gunner == EAST) && {_isIzdelie}): {
        _uavTempType = "O_uav_izdelie53";
    };

    case ((side _gunner == WEST) && {_isIzdelie}): {
        _uavTempType = "B_uav_izdelie53";
    };

    case ((side _gunner == WEST) && {!_isIzdelie}): {
        _uavTempType = "B_uav_lancet3";
    };

    case ((side _gunner == EAST) && {!_isIzdelie}): {
        _uavTempType = "O_uav_lancet3";
    };

    case ((side _gunner == INDEPENDENT) && {_isIzdelie}): {
        _uavTempType = "I_uav_izdelie53";
    };
};

private _uavTemp = _uavTempType createVehicle _launchPos;
createVehicleCrew _uavTemp;

if (local _uavTemp) then {
    _uavTemp lockDriver true;
} else {
    [_uavTemp, true] remoteExec ["lockDriver", 0, true];
};

_uav setVariable ["DB_lancet_subUAV", _uavTemp];
_uavTemp setVariable ["DB_lancet_parentProjectile", _uav];

_uavTemp attachTo [_uav, [0, 0, 0]];
_uavTemp addEventHandler ["Killed", {
    params ["_uavTemp"];

    private _projectile = _uavTemp getVariable ["DB_lancet_parentProjectile", objNull];

    if (alive _projectile) then {
        triggerAmmo _projectile;
    };

    deleteVehicle _uavTemp;
}];

(driver _uavTemp) disableAI "ALL";
(gunner _uavTemp) disableAI "ALL";
_uavTemp disableAI "ALL";

private _directionVector = _unit weaponDirection (currentWeapon _unit);
private _directionDegrees = (_directionVector select 0) atan2 (_directionVector select 1);
private _verticalAngle = (atan ((vectorDir _unit) # 2)) max 0;
_uav setDir _directionDegrees;

_uav engineOn true;
_uav setVehicleAmmo 0;
[_uav, [25, 0, direction _uav]] call lancet_fnc_setAngleOfAttack;

private _direction = direction _uav;
private _launchSpeed = if (_isGeran) then {90} else {60};
_uav setVelocity [
    sin _direction * _launchSpeed,
    cos _direction * _launchSpeed,
    50 + _verticalAngle
];
_uav setDamage 0;

private _controlUnits = if (_isGeran) then {[_gunner]} else {[]};
private _interface = if (_isGeran) then {"geran_seeker"} else {"lancet_seeker"};
[_unit, _uav, [], 0.65, _interface, _controlUnits] call lancet_fnc_initMissile;

[_uav, _verticalAngle, _launchSpeed] spawn {
    params ["_uav", "_verticalAngle", "_launchSpeed"];

    for "_i" from 1 to 5 do {
        [_uav, [25, 0, direction _uav]] call lancet_fnc_setAngleOfAttack;

        private _direction = direction _uav;
        _uav setVelocity [
            sin _direction * _launchSpeed,
            cos _direction * _launchSpeed,
            25 + _verticalAngle
        ];
        _uav setDamage 0;
        sleep 0.2;
    };

    _uav setDamage 0;
};
