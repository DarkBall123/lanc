params ["_projectile", "_start", "_end", "_isDrag", "_candidates"];

if (
	isNull _projectile
	|| {!alive _projectile}
	|| {_projectile getVariable ["geran4_terminalLocked", false]}
	|| {(_projectile getVariable ["geran4_guidanceMode", "CRUISE"]) isEqualTo "MANUAL"}
) exitWith {false};

private _wasDiving = (_projectile getVariable ["geran4_guidanceMode", "CRUISE"]) isEqualTo "DIVE";
private _config = configOf _projectile;
private _detectionRange = getNumber (_config >> "geranDetectionRange");
if (_detectionRange <= 0) then {
	_detectionRange = 1250;
};

private _traceScreen = {
	params ["_screenPos"];

	private _originASL = AGLToASL positionCameraToWorld [0, 0, 0];
	private _terrainASL = AGLToASL (screenToWorld _screenPos);
	private _direction = vectorNormalized (_terrainASL vectorDiff _originASL);

	if (_direction isEqualTo [0, 0, 0]) exitWith {
		[objNull, _terrainASL]
	};

	private _rayEndASL = _originASL vectorAdd (_direction vectorMultiply ((_detectionRange * 4) max 5000));
	private _visualUav = _projectile getVariable ["DB_geran4_visualUAV", objNull];
	private _hits = lineIntersectsSurfaces [
		_originASL,
		_rayEndASL,
		_projectile,
		_visualUav,
		true,
		1,
		"FIRE",
		"GEOM"
	];

	if (_hits isEqualTo []) exitWith {
		[objNull, _terrainASL]
	};

	[_hits # 0 # 3, _hits # 0 # 0]
};

private _xMin = (_start # 0) min (_end # 0);
private _yMin = (_start # 1) min (_end # 1);
private _xMax = (_start # 0) max (_end # 0);
private _yMax = (_start # 1) max (_end # 1);
private _selectionCenter = [(_xMin + _xMax) * 0.5, (_yMin + _yMax) * 0.5];

private _targetObject = objNull;
private _targetOffsetModel = [0, 0, 0];
private _targetPointASL = [];
private _bestScore = -10000000000;

{
	_x params ["_candidate", "_confidence", "_priority", "_rect"];
	_rect params ["_boxX", "_boxY", "_boxW", "_boxH"];

	private _boxCenter = [_boxX + (_boxW * 0.5), _boxY + (_boxH * 0.5)];
	private _eligible = if (_isDrag) then {
		(_boxCenter # 0) >= _xMin
		&& {(_boxCenter # 0) <= _xMax}
		&& {(_boxCenter # 1) >= _yMin}
		&& {(_boxCenter # 1) <= _yMax}
	} else {
		(_end # 0) >= _boxX
		&& {(_end # 0) <= (_boxX + _boxW)}
		&& {(_end # 1) >= _boxY}
		&& {(_end # 1) <= (_boxY + _boxH)}
	};

	if (_eligible) then {
		private _centerDistance = _selectionCenter distance2D _boxCenter;
		private _score = (_priority * 1000) - (_centerDistance * 100) + (_confidence * 10);

		if (_score > _bestScore) then {
			_bestScore = _score;
			_targetObject = _candidate;
		};
	};
} forEach _candidates;

if (!isNull _targetObject) then {
	private _bounds = boundingBoxReal _targetObject;
	private _minimum = _bounds # 0;
	private _maximum = _bounds # 1;
	_targetOffsetModel = (_minimum vectorAdd _maximum) vectorMultiply 0.5;
	_targetOffsetModel set [
		2,
		(_minimum # 2) + (((_maximum # 2) - (_minimum # 2)) * 0.35)
	];

	_targetPointASL = AGLToASL (_targetObject modelToWorldVisual _targetOffsetModel);
} else {
	private _samplePoints = if (_isDrag) then {
		[
			_selectionCenter,
			[_xMin, _yMin],
			[_selectionCenter # 0, _yMin],
			[_xMax, _yMin],
			[_xMax, _selectionCenter # 1],
			[_xMax, _yMax],
			[_selectionCenter # 0, _yMax],
			[_xMin, _yMax],
			[_xMin, _selectionCenter # 1]
		]
	} else {
		[_end]
	};

	private _centerHit = [_selectionCenter] call _traceScreen;
	_targetPointASL = _centerHit # 1;
	private _buildingPointASL = [];
	private _objectPointASL = [];
	private _buildingDistance = 10000000000;
	private _objectDistance = 10000000000;

	{
		private _hit = [_x] call _traceScreen;
		private _hitObject = _hit # 0;
		private _sampleDistance = _selectionCenter distance2D _x;

		if (!isNull _hitObject) then {
			if (_hitObject isKindOf "House" || {_hitObject isKindOf "Building"}) then {
				if (_sampleDistance < _buildingDistance) then {
					_buildingPointASL = _hit # 1;
					_buildingDistance = _sampleDistance;
				};
			} else {
				if (_sampleDistance < _objectDistance) then {
					_objectPointASL = _hit # 1;
					_objectDistance = _sampleDistance;
				};
			};
		};
	} forEach _samplePoints;

	if (_buildingPointASL isNotEqualTo []) then {
		_targetPointASL = _buildingPointASL;
	} else {
		if (_objectPointASL isNotEqualTo []) then {
			_targetPointASL = _objectPointASL;
		};
	};
};

if (_targetPointASL isEqualTo []) exitWith {false};

_projectile setVariable ["geran4_targetObject", _targetObject];
_projectile setVariable ["geran4_objectTarget", !isNull _targetObject];
_projectile setVariable ["geran4_targetOffsetModel", _targetOffsetModel];
_projectile setVariable ["geran4_aimPointASL", _targetPointASL];
_projectile setVariable ["geran4_lastKnownASL", _targetPointASL];
_projectile setVariable ["geran4_targetVisible", !isNull _targetObject];
_projectile setVariable ["geran4_terminalLocked", false];
_projectile setVariable ["geran4_terminalMinDistance", -1];
_projectile setVariable ["geran4_terminalMissDetonateAt", -1];
_projectile setVariable ["geran4_terminalWasApproaching", false];
_projectile setVariable ["geran4_guidanceMode", "DIVE"];
_projectile setVariable ["geran4_nextTrackCheck", 0];
_projectile setVariable ["geran4_turnSpeed", 0];

[_projectile] call geran4_fnc_guideGeran;

private _camera = uiNamespace getVariable ["geran4_camera", objNull];
if (!isNull _camera && {!_wasDiving}) then {
	private _userFov = uiNamespace getVariable ["geran4_userFov", 0.75];
	private _pulse = (uiNamespace getVariable ["geran4_fovPulse", 0]) + 1;
	private _pulseFov = (_userFov * 1.12) min 0.9;

	uiNamespace setVariable ["geran4_fovPulse", _pulse];
	_camera camSetFov _pulseFov;
	_camera camCommit 0.2;

	[_pulseFov, 0.2] call (uiNamespace getVariable ["geran4_setZoomEffects", {}]);

	[_camera, _pulse] spawn {
		params ["_camera", "_pulse"];
		uiSleep 0.2;

		if (
			!isNull _camera
			&& {_pulse isEqualTo (uiNamespace getVariable ["geran4_fovPulse", -1])}
		) then {
			private _userFov = uiNamespace getVariable ["geran4_userFov", 0.75];
			_camera camSetFov _userFov;
			_camera camCommit 0.45;

			[_userFov, 0.45] call (
				uiNamespace getVariable ["geran4_setZoomEffects", {}]
			);
		};
	};
};

true;
