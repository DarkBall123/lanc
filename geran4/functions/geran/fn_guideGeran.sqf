params ["_projectile"];

if (isNull _projectile || {!alive _projectile}) exitWith {-1};

private _currentHandle = _projectile getVariable ["geran4_guidancePFH", -1];
if (_currentHandle >= 0) exitWith {_currentHandle};

private _handle = [{
	(_this # 0) params ["_projectile"];
	private _handle = _this # 1;

	if (isNull _projectile || {!alive _projectile}) exitWith {
		if (!isNull _projectile) then {
			_projectile setVariable ["geran4_guidancePFH", -1];
		};
		[_handle] call CBA_fnc_removePerFrameHandler;
	};

	if (!local _projectile) exitWith {};

	private _mode = _projectile getVariable ["geran4_guidanceMode", "CRUISE"];
	if (_mode isEqualTo "CRUISE") exitWith {
		_projectile setVariable ["geran4_turnSpeed", 0];
		_projectile setVariable ["geran4_guidancePFH", -1];
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

	private _deltaTime = (diag_deltaTime max 0.001) min 0.1;
	private _currentDirection = vectorNormalized (vectorDir _projectile);

	if (_mode isEqualTo "MANUAL") then {
		private _rawInput = _projectile getVariable ["geran4_manualInput", [0, 0]];
		private _inputX = ((_rawInput # 0) max -1) min 1;
		private _inputY = ((_rawInput # 1) max -1) min 1;
		private _inputMagnitude = sqrt ((_inputX * _inputX) + (_inputY * _inputY));
		private _desiredInput = [0, 0];

		if (_inputMagnitude > 0.08) then {
			private _scaledMagnitude = (((_inputMagnitude - 0.08) / 0.92) min 1) / _inputMagnitude;
			_desiredInput = [_inputX * _scaledMagnitude, _inputY * _scaledMagnitude];
		};

		private _smoothedInput = _projectile getVariable ["geran4_manualInputSmoothed", [0, 0]];
		private _inputBlend = (_deltaTime / (0.2 + _deltaTime)) min 1;
		_smoothedInput = [
			(_smoothedInput # 0) + (((_desiredInput # 0) - (_smoothedInput # 0)) * _inputBlend),
			(_smoothedInput # 1) + (((_desiredInput # 1) - (_smoothedInput # 1)) * _inputBlend)
		];
		_projectile setVariable ["geran4_manualInputSmoothed", _smoothedInput];
		_projectile setVariable ["geran4_turnSpeed", 0];

		private _yawStep = -((_smoothedInput # 0) * _turnRate * _deltaTime);
		private _yawAxis = [0, 0, 1];
		private _yawDirection = _currentDirection;

		if (abs _yawStep > 0.0001) then {
			_yawDirection = vectorNormalized (
				(_currentDirection vectorMultiply (cos _yawStep))
				vectorAdd
				((_yawAxis vectorCrossProduct _currentDirection) vectorMultiply (sin _yawStep))
				vectorAdd
				(_yawAxis vectorMultiply (
					(_yawAxis vectorDotProduct _currentDirection) * (1 - cos _yawStep)
				))
			);
		};

		private _pitchStep = (_smoothedInput # 1) * 22 * _deltaTime;
		private _currentPitch = asin (((_yawDirection # 2) max -1) min 1);

		if (_currentPitch >= 35 && {_pitchStep > 0}) then {
			_pitchStep = 0;
		};
		if (_currentPitch <= -70 && {_pitchStep < 0}) then {
			_pitchStep = 0;
		};
		if (_currentPitch < 35 && {_currentPitch + _pitchStep > 35}) then {
			_pitchStep = 35 - _currentPitch;
		};
		if (_currentPitch > -70 && {_currentPitch + _pitchStep < -70}) then {
			_pitchStep = -70 - _currentPitch;
		};

		private _right = _yawDirection vectorCrossProduct [0, 0, 1];
		if (vectorMagnitude _right < 0.01) then {
			_right = [1, 0, 0];
		};
		_right = vectorNormalized _right;

		private _nextDirection = _yawDirection;
		if (abs _pitchStep > 0.0001) then {
			_nextDirection = vectorNormalized (
				(_yawDirection vectorMultiply (cos _pitchStep))
				vectorAdd
				((_right vectorCrossProduct _yawDirection) vectorMultiply (sin _pitchStep))
			);
		};

		private _nextRight = _nextDirection vectorCrossProduct [0, 0, 1];
		if (vectorMagnitude _nextRight < 0.01) then {
			_nextRight = _right;
		};
		_nextRight = vectorNormalized _nextRight;
		private _nextUp = vectorNormalized (_nextRight vectorCrossProduct _nextDirection);
		_projectile setVectorDirAndUp [_nextDirection, _nextUp];
	} else {
		private _desiredDirection = [0, 0, 0];

		if (_mode isEqualTo "RECOVER") then {
			private _heading = direction _projectile;
			_desiredDirection = vectorNormalized [sin _heading, cos _heading, 0.05];
		} else {
			private _target = _projectile getVariable ["geran4_targetObject", objNull];
			private _aimPointASL = _projectile getVariable ["geran4_aimPointASL", []];
			private _nextTrackCheck = _projectile getVariable ["geran4_nextTrackCheck", 0];

			if (!isNull _target && {alive _target}) then {
				if (diag_tickTime >= _nextTrackCheck) then {
					private _thermal = _projectile getVariable ["geran4_thermal", false];
					private _confidence = [
						_projectile,
						_target,
						_thermal,
						_detectionRange
					] call geran4_fnc_getGeranConfidence;

					_projectile setVariable ["geran4_targetVisible", _confidence >= 0.4];
					_projectile setVariable ["geran4_nextTrackCheck", diag_tickTime + 0.25];
				};

				if (_projectile getVariable ["geran4_targetVisible", false]) then {
					private _offsetModel = _projectile getVariable [
						"geran4_targetOffsetModel",
						[0, 0, 0]
					];
					private _basePointASL = AGLToASL (_target modelToWorldVisual _offsetModel);
					private _speed = (vectorMagnitude velocity _projectile) max 1;
					private _leadTime = (
						((getPosASLVisual _projectile) vectorDistance _basePointASL) / _speed
					) min 2;
					_aimPointASL = _basePointASL vectorAdd ((velocity _target) vectorMultiply _leadTime);

					_projectile setVariable ["geran4_aimPointASL", _aimPointASL];
					_projectile setVariable ["geran4_lastKnownASL", _aimPointASL];
				};
			} else {
				_projectile setVariable ["geran4_targetVisible", false];
			};

			if (_aimPointASL isEqualTo []) then {
				_aimPointASL = _projectile getVariable ["geran4_lastKnownASL", []];
			};

			if (_aimPointASL isEqualTo []) then {
				_projectile setVariable ["geran4_guidanceMode", "CRUISE"];
				_projectile setVariable ["geran4_turnSpeed", 0];
				_projectile setVariable ["geran4_guidancePFH", -1];
				[_handle] call CBA_fnc_removePerFrameHandler;
			} else {
				private _projectilePosASL = getPosASLVisual _projectile;
				private _guidancePointASL = +_aimPointASL;
				if !(_projectile getVariable ["geran4_objectTarget", false]) then {
					_guidancePointASL set [2, (_guidancePointASL # 2) - 0.75];
				};
				private _distanceToAim = _projectilePosASL vectorDistance _guidancePointASL;
				private _terminalLocked = _projectile getVariable [
					"geran4_terminalLocked",
					false
				];

				if (
					!_terminalLocked
					&& {_distanceToAim <= _lockRange}
				) then {
					_terminalLocked = true;
					_projectile setVariable ["geran4_terminalLocked", true];
					_projectile setVariable ["geran4_guidanceMode", "TERMINAL"];
					_projectile setVariable ["geran4_terminalMinDistance", _distanceToAim];
					_projectile setVariable ["geran4_terminalMissDetonateAt", -1];
					_projectile setVariable ["geran4_terminalWasApproaching", false];
				};

				private _missDetonateAt = _projectile getVariable [
					"geran4_terminalMissDetonateAt",
					-1
				];

				if (_missDetonateAt >= 0) then {
					if (diag_tickTime >= _missDetonateAt) then {
						triggerAmmo _projectile;
					};
				} else {
					private _velocity = velocity _projectile;
					private _toAim = _guidancePointASL vectorDiff _projectilePosASL;
					private _frameTravel = _velocity vectorMultiply _deltaTime;
					private _frameTravelSquared = _frameTravel vectorDotProduct _frameTravel;
					private _closestDistance = _distanceToAim;

					if (_frameTravelSquared > 0) then {
						private _travelFraction = (
							(_toAim vectorDotProduct _frameTravel) / _frameTravelSquared
						) max 0 min 1;
						private _closestPosition = _projectilePosASL vectorAdd (
							_frameTravel vectorMultiply _travelFraction
						);
						_closestDistance = _closestPosition vectorDistance _aimPointASL;
					};

					private _minimumDistance = _distanceToAim;
					private _passedAim = false;

					if (_terminalLocked) then {
						_minimumDistance = (
							_projectile getVariable [
								"geran4_terminalMinDistance",
								_distanceToAim
							]
						) min _closestDistance;
						_projectile setVariable [
							"geran4_terminalMinDistance",
							_minimumDistance
						];

						private _approachRate = _velocity vectorDotProduct _toAim;
						private _wasApproaching = _projectile getVariable [
							"geran4_terminalWasApproaching",
							false
						];

						if (_approachRate > 0) then {
							_wasApproaching = true;
							_projectile setVariable [
								"geran4_terminalWasApproaching",
								true
							];
						};

						_passedAim = _wasApproaching
							&& {_approachRate <= 0}
							&& {_distanceToAim >= (_minimumDistance + 3)};
					};

					if (_terminalLocked && {_passedAim}) then {
						_projectile setVariable [
							"geran4_terminalMissDetonateAt",
							diag_tickTime + 1.5
						];
						_projectile setVariable ["geran4_turnSpeed", 0];
					} else {
						_desiredDirection = vectorNormalized _toAim;
					};
				};
			};
		};

		if (_desiredDirection isNotEqualTo [0, 0, 0]) then {
			private _attackGuidance = _mode in ["DIVE", "TERMINAL"];
			private _activeTurnRate = if (_attackGuidance) then {_turnRate * 2} else {_turnRate};
			private _turnGain = if (_attackGuidance) then {6} else {2};
			private _angle = acos (((_currentDirection vectorCos _desiredDirection) max -1) min 1);
			private _desiredTurnSpeed = (_angle * _turnGain) min _activeTurnRate;
			private _turnSpeed = _projectile getVariable ["geran4_turnSpeed", 0];
			private _previousTurnSpeed = _turnSpeed;
			private _maxSpeedChange = (_activeTurnRate * 2) * _deltaTime;

			if (_turnSpeed < _desiredTurnSpeed) then {
				_turnSpeed = (_turnSpeed + _maxSpeedChange) min _desiredTurnSpeed;
			} else {
				_turnSpeed = (_turnSpeed - _maxSpeedChange) max _desiredTurnSpeed;
			};

			private _turnStep = (((_previousTurnSpeed + _turnSpeed) * 0.5) * _deltaTime) min _angle;
			private _nextDirection = _desiredDirection;

			if (_angle > _turnStep && {_angle > 0.01}) then {
				private _turnAxis = _currentDirection vectorCrossProduct _desiredDirection;

				if (vectorMagnitude _turnAxis < 0.001) then {
					_turnAxis = _currentDirection vectorCrossProduct [0, 0, 1];
				};
				if (vectorMagnitude _turnAxis < 0.001) then {
					_turnAxis = _currentDirection vectorCrossProduct [0, 1, 0];
				};

				_turnAxis = vectorNormalized _turnAxis;
				_nextDirection = vectorNormalized (
					(_currentDirection vectorMultiply (cos _turnStep))
					vectorAdd
					((_turnAxis vectorCrossProduct _currentDirection) vectorMultiply (sin _turnStep))
					vectorAdd
					(_turnAxis vectorMultiply (
						(_turnAxis vectorDotProduct _currentDirection) * (1 - cos _turnStep)
					))
				);
			};

			_projectile setVariable ["geran4_turnSpeed", _turnSpeed];

			private _right = _nextDirection vectorCrossProduct [0, 0, 1];
			if (vectorMagnitude _right < 0.01) then {
				_right = _nextDirection vectorCrossProduct (vectorUp _projectile);
			};
			if (vectorMagnitude _right < 0.01) then {
				_right = [1, 0, 0];
			};

			_right = vectorNormalized _right;
			private _nextUp = vectorNormalized (_right vectorCrossProduct _nextDirection);
			_projectile setVectorDirAndUp [_nextDirection, _nextUp];

			if (_mode isEqualTo "RECOVER" && {abs (_nextDirection # 2) < 0.08}) then {
				_projectile setVariable ["geran4_guidanceMode", "CRUISE"];
				_projectile setVariable ["geran4_turnSpeed", 0];
				_projectile setVariable ["geran4_guidancePFH", -1];
				[_handle] call CBA_fnc_removePerFrameHandler;
			};
		};
	};
}, 0, [_projectile]] call CBA_fnc_addPerFrameHandler;

_projectile setVariable ["geran4_guidancePFH", _handle];
_handle;
