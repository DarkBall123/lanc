params ["_unit", "_gunner"];

_unit setVariable ["geran4_launchPending", false, true];
_unit setVariable ["geran4_keepLoadedVisual", false, true];
_unit animateSource ["tubel_hide_full", 1, true];

if (!alive _unit || {!alive _gunner}) exitWith {};

private _basePos = AGLToASL (_unit modelToWorld (_unit selectionPosition "konec hlavne"));
private _muzzlePos = AGLToASL (_unit modelToWorld (_unit selectionPosition "usti hlavne"));
private _launchPos = _muzzlePos vectorAdd (_basePos vectorFromTo _muzzlePos);
private _projectile = "m_geran_dummy" createVehicle _launchPos;
_projectile setPosASL _launchPos;
_projectile hideObject true;
[_projectile, true] remoteExec ["hideObjectGlobal", 2];

private _visualType = switch (side _gunner) do {
	case INDEPENDENT: {"geran_uav_i"};
	case EAST: {"geran_uav_o"};
	default {"geran_uav_b"};
};

private _visualUav = _visualType createVehicle _launchPos;
createVehicleCrew _visualUav;

if (local _visualUav) then {
	_visualUav lockDriver true;
} else {
	[_visualUav, true] remoteExec ["lockDriver", 0, true];
};

_projectile setVariable ["DB_geran4_visualUAV", _visualUav];
_visualUav setVariable ["DB_geran4_parentProjectile", _projectile];
_visualUav attachTo [_projectile, [0, 0, 0]];
_visualUav addEventHandler ["Killed", {
	params ["_visualUav"];

	private _projectile = _visualUav getVariable ["DB_geran4_parentProjectile", objNull];
	if (alive _projectile) then {
		triggerAmmo _projectile;
	};

	deleteVehicle _visualUav;
}];

{
	_x disableAI "ALL";
} forEach crew _visualUav;
_visualUav disableAI "ALL";

private _directionVector = _unit weaponDirection (currentWeapon _unit);
private _directionDegrees = (_directionVector # 0) atan2 (_directionVector # 1);
private _verticalAngle = (atan ((vectorDir _unit) # 2)) max 0;
_projectile setDir _directionDegrees;
_projectile engineOn true;
_projectile setVehicleAmmo 0;
[_projectile, [25, 0, direction _projectile]] call geran4_fnc_setAngleOfAttack;

private _launchSpeed = 90;
private _direction = direction _projectile;
_projectile setVelocity [
	sin _direction * _launchSpeed,
	cos _direction * _launchSpeed,
	50 + _verticalAngle
];
_projectile setDamage 0;
_projectile setVariable ["geran4_guidanceMode", "MANUAL"];
_projectile setVariable ["geran4_manualInput", [0, 0]];
_projectile setVariable ["geran4_manualInputSmoothed", [0, 0]];

[_unit, _projectile, [_gunner]] call geran4_fnc_initMissile;
[_projectile] call geran4_fnc_guideGeran;

[_projectile, _verticalAngle, _launchSpeed] spawn {
	params ["_projectile", "_verticalAngle", "_launchSpeed"];

	for "_i" from 1 to 5 do {
		[_projectile, [25, 0, direction _projectile]] call geran4_fnc_setAngleOfAttack;

		private _direction = direction _projectile;
		_projectile setVelocity [
			sin _direction * _launchSpeed,
			cos _direction * _launchSpeed,
			25 + _verticalAngle
		];
		_projectile setDamage 0;
		sleep 0.2;
	};

	_projectile setDamage 0;
};
