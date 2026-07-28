params ["_projectile"];

if (isNull _projectile || {!alive _projectile}) exitWith {[]};

private _config = configOf _projectile;
private _range = getNumber (_config >> "geranDetectionRange");
if (_range <= 0) then {
	_range = 1250;
};

private _thermal = _projectile getVariable ["lancet_geran_thermal", false];
private _visualUav = _projectile getVariable ["DB_lancet_subUAV", objNull];
private _targets = (_projectile nearEntities [["Air", "LandVehicle", "Ship", "StaticWeapon"], _range]) - [_projectile, _visualUav];
private _scored = [];

{
	if (alive _x && {!isObjectHidden _x}) then {
		private _bounds = boundingBoxReal _x;
		private _centerModel = ((_bounds # 0) vectorAdd (_bounds # 1)) vectorMultiply 0.5;
		private _screenPosition = worldToScreen (_x modelToWorldVisual _centerModel);

		if (_screenPosition isNotEqualTo []) then {
			private _confidence = [_projectile, _x, _thermal, _range] call lancet_fnc_getGeranConfidence;

			if (_confidence >= 0.4) then {
				_scored pushBack [
					-_confidence,
					_forEachIndex,
					_x,
					_confidence,
					3
				];
			};
		};
	};
} forEach _targets;

_scored sort true;

private _result = _scored apply {
	[_x # 2, _x # 3, _x # 4]
};

_result select [0, (count _result) min 16];
