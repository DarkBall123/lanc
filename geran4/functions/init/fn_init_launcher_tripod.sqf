if !(alive player) exitWith {};

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

private _gunner = (getShotParents _projectile) param [1, objNull];
deleteVehicle _projectile;

private _controller = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];
if (_gunner isNotEqualTo _controller) exitWith {};

_unit setVariable ["geran4_launchPending", true, true];
_unit setVariable ["geran4_keepLoadedVisual", true, true];
_unit animateSource ["tubel_hide_full", 0, true];

[geran4_fnc_launch_tripod_projectile, [_unit, _gunner], 14] call CBA_fnc_waitAndExecute;
