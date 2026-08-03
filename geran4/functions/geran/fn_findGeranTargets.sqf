params ["_projectile"];

if (isNull _projectile || {!alive _projectile}) exitWith {[]};

private _config = configOf _projectile;
private _range = getNumber (_config >> "geranDetectionRange");
if (_range <= 0) then {
	_range = 1250;
};

private _thermal = _projectile getVariable ["geran4_thermal", false];
private _visualUav = _projectile getVariable ["DB_geran4_visualUAV", objNull];
private _targets = (_projectile nearEntities [["Air", "LandVehicle", "Ship", "StaticWeapon"], _range]) - [_projectile, _visualUav];
private _scored = [];

{
	if (alive _x && {!isObjectHidden _x}) then {
		private _bounds = boundingBoxReal _x;
		private _centerModel = ((_bounds # 0) vectorAdd (_bounds # 1)) vectorMultiply 0.5;
		private _eligible = true;

		if (_x isKindOf "Ship") then {
			_eligible = simulationEnabled _x;

			if (_eligible) then {
				private _topModel = [
					_centerModel # 0,
					_centerModel # 1,
					(_bounds # 1) # 2
				];
				private _topASL = AGLToASL (_x modelToWorldVisual _topModel);
				_eligible = (_topASL # 2) > 0.05;

				if (_eligible) then {
					private _sensorASL = getPosASLVisual _projectile;
					private _centerASL = AGLToASL (_x modelToWorldVisual _centerModel);
					private _rayDirection = vectorNormalized (_centerASL vectorDiff _sensorASL);
					private _rayEndASL = _centerASL vectorAdd (_rayDirection vectorMultiply 10);
					private _hits = lineIntersectsSurfaces [
						_sensorASL,
						_rayEndASL,
						_projectile,
						_visualUav,
						true,
						1,
						"VIEW",
						"GEOM"
					];

					if (_hits isEqualTo []) then {
						_eligible = false;
					} else {
						private _firstHit = _hits # 0;
						private _hitObject = _firstHit # 2;
						private _hitParent = _firstHit # 3;
						_eligible = (_hitObject isEqualTo _x) || {_hitParent isEqualTo _x};
					};
				};
			};
		};

		if (_eligible) then {
			private _screenPosition = worldToScreen (_x modelToWorldVisual _centerModel);

			if (_screenPosition isEqualTo []) then {
				_eligible = false;
			};
		};

		if (_eligible) then {
			private _confidence = [_projectile, _x, _thermal, _range] call geran4_fnc_getGeranConfidence;

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
