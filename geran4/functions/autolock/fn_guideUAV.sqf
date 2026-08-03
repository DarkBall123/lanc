// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Can only be run on scheduled env
if (!canSuspend) exitWith
{
    "fn_guidedProjectile should run on Scheduled Env" call BIS_fnc_error;
};

// Parameters
params
[
    ["_startPos", [0.0 , 0.0, 0.0], [[]]],
    ["_class", "M_Titan_AT", ["", objNull]],
    ["_target", objNull, [objNull]],
    ["_speed", 100.0, [0.0]],
    ["_destroyTarget", true, [true]],
    ["_localOffset", [0.0, 0.0, 0.0], [[]]],
    ["_minDistanceToTarget", 5.0, [0.0]],
    ["_returnRocket", false, [false]],
    ["_isGlobalFunction", false, [true]]
];

// Validate parameters
if (count _startPos != 3 || {{typeName _x != typeName 0} count _startPos > 0}) exitWith {"fn_guidedProjectile invalid position, not a 3D vector" call BIS_fnc_error};
if (_startPos isEqualTo [0,0,0]) exitWith {"fn_guidedProjectile invalid position, at 0,0,0" call BIS_fnc_error};
if (isNull _target) exitWith {"fn_guidedProjectile invalid target provided" call BIS_fnc_error};

private _rocket = uiNamespace getVariable ["lancet_currentProjectile", objNull];

// Set correct initial position
_rocket setPosASL _startPos;

// Loop
while {!isNull _rocket && {!isNull _target}} do
{
    private _currentPos = getPosASLVisual _rocket;
    private _targetPos = if !(_localOffset isEqualTo [0.0, 0.0, 0.0]) then {AGLToASL (_target modelToWorldVisual _localOffset)} else {getPosASLVisual _target};

    private _forwardVector = vectorNormalized (_targetPos vectorDiff _currentPos);
    private _rightVector = (_forwardVector vectorCrossProduct [0,0,1]) vectorMultiply -1;
    private _upVector = _forwardVector vectorCrossProduct _rightVector;

    private _targetVelocity = _forwardVector vectorMultiply _speed;

    _rocket setVectorDirAndUp [_forwardVector, _upVector];
    _rocket setVelocity _targetVelocity;


    if ((isNull _rocket) || (!(uiNamespace getVariable ["DB_isSlewing", false])) || {isNull _target}) exitWith {
		uiNamespace setVariable ["DB_isSlewing", false];
	};
    if (isNull _rocket || {isNull _target} || {getPosASLVisual _rocket distance _targetPos <= _minDistanceToTarget}) exitWith
    {
        if (!isNull _rocket) then {_rocket setDamage 1; _rocket = objNull;};
        if (_destroyTarget && {!isNull _target}) then {_target setDamage 1;};
    };

    sleep 0.01;
};