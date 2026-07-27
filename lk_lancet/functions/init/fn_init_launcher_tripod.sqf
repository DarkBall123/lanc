if (!(alive player)) exitWith {};

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

private _gunner = (getShotParents _projectile) # 1;

deleteVehicle _projectile;

// Locality fix - only spawn lancet on client shooting this, or client controlling this gunner
private _player = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];

if (_gunner != _player) exitWith {};

private _unitType = typeOf _unit;
private _isIzdelie = (_unitType find "izdelie") > -1;
private _isGeran = (_unitType find "geran") > -1;
private _uavType = "m_lancet_dummy";

if (_isIzdelie) then {
    _uavType = "m_izdelie_dummy";
};

if (_isGeran) then {
    _uavType = "m_geran_dummy";
};

private _launchArgs = [_unit, _gunner, _uavType, _isIzdelie, _isGeran];

if (_isGeran) then {
    [lancet_fnc_launch_tripod_projectile, _launchArgs, 19] call CBA_fnc_waitAndExecute;
} else {
    _launchArgs call lancet_fnc_launch_tripod_projectile;
};
