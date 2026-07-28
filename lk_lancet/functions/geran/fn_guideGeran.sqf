params ["_projectile"];

if (isNull _projectile || {!alive _projectile}) exitWith {-1};

private _currentHandle = _projectile getVariable ["lancet_geran_guidancePFH", -1];
if (_currentHandle >= 0) exitWith {_currentHandle};

private _handle = [{
	(_this # 0) params ["_projectile"];
	private _handle = _this # 1;

	if (isNull _projectile || {!alive _projectile}) exitWith {
		[_handle] call CBA_fnc_removePerFrameHandler;
	};

	if (!local _projectile) exitWith {};

	private _mode = _projectile getVariable ["lancet_geran_guidanceMode", "CRUISE"];
	if (_mode isEqualTo "CRUISE") exitWith {
		_projectile setVariable ["lancet_geran_guidancePFH", -1];
		[_handle] call CBA_fnc_removePerFrameHandler;
	};

	private _config = configOf _projectile;
	private _turnRate = getNumber (_config >> "geranGuidanceTurnRate");
	private _lockRange = getNumber (_config >> "geranTerminalLockRange");
	private _detectionRange = getNumber (_config >> "geranDetectionRange");

	if (_turnRate <= 0) then {
		_turnRate = 30;
	};
	if (_lockRange <= 0) then {
		_lockRange = 200;
	};
	if (_detectionRange <= 0) then {
		_detectionRange = 1250;
	};

	private _now = diag_tickTime;
	private _lastTick = _projectile getVariable ["lancet_geran_lastGuidanceTick", _now - 0.05];
	private _deltaTime = ((_now - _lastTick) max 0.001) min 0.1;
	_projectile setVariable ["lancet_geran_lastGuidanceTick", _now];

	private _desiredDirection = [0, 0, 0];

	if (_mode isEqualTo "RECOVER") then {
		private _heading = direction _projectile;
		_desiredDirection = vectorNormalized [sin _heading, cos _heading, 0.05];
	} else {
		private _target = _projectile getVariable ["lancet_geran_targetObject", objNull];
		private _aimPointASL = _projectile getVariable ["lancet_geran_aimPointASL", []];
		private _nextTrackCheck = _projectile getVariable ["lancet_geran_nextTrackCheck", 0];

		if (!isNull _target && {alive _target}) then {
			if (_now >= _nextTrackCheck) then {
				private _thermal = _projectile getVariable ["lancet_geran_thermal", false];
				private _confidence = [_projectile, _target, _thermal, _detectionRange] call lancet_fnc_getGeranConfidence;
				private _visible = _confidence >= 0.4;

				_projectile setVariable ["lancet_geran_targetVisible", _visible];
				_projectile setVariable ["lancet_geran_nextTrackCheck", _now + 0.25];

				if (_visible) then {
					private _offsetModel = _projectile getVariable ["lancet_geran_targetOffsetModel", [0, 0, 0]];
					private _basePointASL = AGLToASL (_target modelToWorldVisual _offsetModel);
					private _speed = (vectorMagnitude velocity _projectile) max 1;
					private _leadTime = ((_projectile distance _target) / _speed) min 2;
					_aimPointASL = _basePointASL vectorAdd ((velocity _target) vectorMultiply _leadTime);

					_projectile setVariable ["lancet_geran_aimPointASL", _aimPointASL];
					_projectile setVariable ["lancet_geran_lastKnownASL", _aimPointASL];
				};
			};
		} else {
			_projectile setVariable ["lancet_geran_targetVisible", false];
		};

		if (_aimPointASL isEqualTo []) then {
			_aimPointASL = _projectile getVariable ["lancet_geran_lastKnownASL", []];
		};

		if (_aimPointASL isEqualTo []) exitWith {
			_projectile setVariable ["lancet_geran_guidanceMode", "CRUISE"];
		};

		private _projectilePosASL = getPosASLVisual _projectile;
		private _distanceToAim = _projectilePosASL vectorDistance _aimPointASL;

		if (
			!(_projectile getVariable ["lancet_geran_terminalLocked", false])
			&& {_distanceToAim <= _lockRange}
		) then {
			_projectile setVariable ["lancet_geran_terminalLocked", true];
			_projectile setVariable ["lancet_geran_guidanceMode", "TERMINAL"];
		};

		_desiredDirection = vectorNormalized (_aimPointASL vectorDiff _projectilePosASL);
	};

	if (_desiredDirection isEqualTo [0, 0, 0]) exitWith {};

	private _currentDirection = vectorNormalized (vectorDir _projectile);
	private _angle = acos (((_currentDirection vectorCos _desiredDirection) max -1) min 1);
	private _turnStep = (_turnRate * _deltaTime) min _angle;
	private _nextDirection = if (_angle <= _turnStep || {_angle <= 0.01}) then {
		_desiredDirection
	} else {
		private _turnAxis = _currentDirection vectorCrossProduct _desiredDirection;

		if (vectorMagnitude _turnAxis < 0.001) then {
			_turnAxis = _currentDirection vectorCrossProduct [0, 0, 1];
		};
		if (vectorMagnitude _turnAxis < 0.001) then {
			_turnAxis = _currentDirection vectorCrossProduct [0, 1, 0];
		};

		_turnAxis = vectorNormalized _turnAxis;
		private _axisComponent = _turnAxis vectorMultiply (
			(_turnAxis vectorDotProduct _currentDirection) * (1 - cos _turnStep)
		);

		vectorNormalized (
			(_currentDirection vectorMultiply (cos _turnStep))
			vectorAdd
			((_turnAxis vectorCrossProduct _currentDirection) vectorMultiply (sin _turnStep))
			vectorAdd
			_axisComponent
		)
	};

	private _right = _nextDirection vectorCrossProduct (vectorUp _projectile);
	if (vectorMagnitude _right < 0.01) then {
		_right = _nextDirection vectorCrossProduct [0, 0, 1];
	};
	if (vectorMagnitude _right < 0.01) then {
		_right = [1, 0, 0];
	};

	_right = vectorNormalized _right;
	private _nextUp = vectorNormalized (_right vectorCrossProduct _nextDirection);
	_projectile setVectorDirAndUp [_nextDirection, _nextUp];

	if (_mode isEqualTo "RECOVER" && {abs (_nextDirection # 2) < 0.08}) then {
		_projectile setVariable ["lancet_geran_guidanceMode", "CRUISE"];
		_projectile setVariable ["lancet_geran_guidancePFH", -1];
		[_handle] call CBA_fnc_removePerFrameHandler;
	};
}, 0.05, [_projectile]] call CBA_fnc_addPerFrameHandler;

_projectile setVariable ["lancet_geran_guidancePFH", _handle];
_handle;
