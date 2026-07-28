#include "..\..\geran_ui.hpp"

disableSerialization;

private _projectile = param [0, objNull];
private _dialogName = param [3, "geran_seeker"];

if (isNull _projectile || {!alive _projectile}) exitWith {};
if (!isNull (findDisplay GERAN_IDD_SEEKER)) exitWith {};

private _camera = [_projectile, 2] call lancet_fnc_camCreate;
private _display = createDialog [_dialogName, true];

if (isNull _display) exitWith {
	_camera cameraEffect ["terminate", "back"];
	camDestroy _camera;
};

uiNamespace setVariable ["lancet_geran_camera", _camera];
uiNamespace setVariable ["lancet_geran_projectile", _projectile];
uiNamespace setVariable ["lancet_geran_userFov", 0.75];
uiNamespace setVariable ["lancet_geran_dragStart", []];
uiNamespace setVariable ["lancet_geran_dragActive", false];
uiNamespace setVariable ["lancet_geran_drawnCandidates", []];

if ((_projectile getVariable ["lancet_geran_guidanceMode", "CRUISE"]) isEqualTo "MANUAL") then {
	_projectile setVariable ["lancet_geran_manualInput", [0, 0]];
	_projectile setVariable ["lancet_geran_manualInputSmoothed", [0, 0]];
	setMousePosition [0.5, 0.5];
	[_projectile] call lancet_fnc_guideGeran;
};

private _thermal = _projectile getVariable ["lancet_geran_thermal", false];
_thermal setCamUseTI 0;

private _hudGroup = _display displayCtrl GERAN_IDC_HUD_GROUP;
private _cursorControls = [
	_display displayCtrl GERAN_IDC_CURSOR_SHADOW_LEFT,
	_display displayCtrl GERAN_IDC_CURSOR_SHADOW_RIGHT,
	_display displayCtrl GERAN_IDC_CURSOR_SHADOW_TOP,
	_display displayCtrl GERAN_IDC_CURSOR_SHADOW_BOTTOM,
	_display displayCtrl GERAN_IDC_CURSOR_LEFT,
	_display displayCtrl GERAN_IDC_CURSOR_RIGHT,
	_display displayCtrl GERAN_IDC_CURSOR_TOP,
	_display displayCtrl GERAN_IDC_CURSOR_BOTTOM
];
private _selectionLines = [
	_display displayCtrl GERAN_IDC_SELECTION_TOP,
	_display displayCtrl GERAN_IDC_SELECTION_RIGHT,
	_display displayCtrl GERAN_IDC_SELECTION_BOTTOM,
	_display displayCtrl GERAN_IDC_SELECTION_LEFT
];
private _trackLines = [
	_display displayCtrl GERAN_IDC_TRACK_TOP,
	_display displayCtrl GERAN_IDC_TRACK_RIGHT,
	_display displayCtrl GERAN_IDC_TRACK_BOTTOM,
	_display displayCtrl GERAN_IDC_TRACK_LEFT
];

{
	_x ctrlShow false;
} forEach (_cursorControls + _selectionLines + _trackLines);

private _drawFrame = {
	params ["_lines", "_rect", "_color"];

	if (count _rect != 4) exitWith {
		{
			_x ctrlShow false;
		} forEach _lines;
	};

	_rect params ["_screenX", "_screenY", "_width", "_height"];
	private _x = _screenX - safeZoneX;
	private _y = _screenY - safeZoneY;
	private _lineWidth = 2 * pixelW;
	private _lineHeight = 2 * pixelH;

	(_lines # 0) ctrlSetPosition [_x, _y, _width, _lineHeight];
	(_lines # 1) ctrlSetPosition [_x + _width - _lineWidth, _y, _lineWidth, _height];
	(_lines # 2) ctrlSetPosition [_x, _y + _height - _lineHeight, _width, _lineHeight];
	(_lines # 3) ctrlSetPosition [_x, _y, _lineWidth, _height];

	{
		_x ctrlSetBackgroundColor _color;
		_x ctrlShow true;
		_x ctrlCommit 0;
	} forEach _lines;
};

uiNamespace setVariable ["lancet_geran_drawFrame", _drawFrame];

private _boxControls = [];
for "_boxIndex" from 0 to 15 do {
	private _lines = [];

	for "_lineIndex" from 0 to 3 do {
		private _line = _display ctrlCreate ["RscText", -1, _hudGroup];
		_line ctrlShow false;
		_lines pushBack _line;
	};

	_boxControls pushBack _lines;
};

private _getScreenRect = {
	params ["_target"];

	if (isNull _target || {!alive _target}) exitWith {[]};

	private _bounds = boundingBoxReal _target;
	private _minimum = _bounds # 0;
	private _maximum = _bounds # 1;
	private _centerModel = (_minimum vectorAdd _maximum) vectorMultiply 0.5;
	private _centerScreen = worldToScreen (_target modelToWorldVisual _centerModel);

	if (_centerScreen isEqualTo []) exitWith {[]};

	private _corners = [
		[_minimum # 0, _minimum # 1, _minimum # 2],
		[_maximum # 0, _minimum # 1, _minimum # 2],
		[_maximum # 0, _maximum # 1, _minimum # 2],
		[_minimum # 0, _maximum # 1, _minimum # 2],
		[_minimum # 0, _minimum # 1, _maximum # 2],
		[_maximum # 0, _minimum # 1, _maximum # 2],
		[_maximum # 0, _maximum # 1, _maximum # 2],
		[_minimum # 0, _maximum # 1, _maximum # 2]
	];
	private _screenPoints = [];

	{
		private _screen = worldToScreen (_target modelToWorldVisual _x);
		if (count _screen isEqualTo 2) then {
			_screenPoints pushBack _screen;
		};
	} forEach _corners;

	if (count _screenPoints < 4) exitWith {[]};

	private _screenXs = _screenPoints apply {_x # 0};
	private _screenYs = _screenPoints apply {_x # 1};
	private _left = (selectMin _screenXs) max safeZoneX;
	private _top = (selectMin _screenYs) max safeZoneY;
	private _right = (selectMax _screenXs) min (safeZoneX + safeZoneW);
	private _bottom = (selectMax _screenYs) min (safeZoneY + safeZoneH);
	private _width = _right - _left;
	private _height = _bottom - _top;

	if (_width < (6 * pixelW) || {_height < (6 * pixelH)}) exitWith {[]};

	[_left, _top, _width, _height]
};

private _grain = ppEffectCreate ["FilmGrain", 2001];
_grain ppEffectAdjust [0.18, 1, 1, 0.45, 0.45, true];
_grain ppEffectCommit 0;
_grain ppEffectEnable true;

private _blur = ppEffectCreate ["DynamicBlur", 501];
_blur ppEffectAdjust [0.08];
_blur ppEffectCommit 0;
_blur ppEffectEnable true;
uiNamespace setVariable ["lancet_geran_blur", _blur];

private _effects = [_grain, _blur];

if ((_projectile getVariable ["lancet_geran_explodeEH", -1]) < 0) then {
	private _explodeEH = _projectile addEventHandler ["Explode", {
		params ["_projectile"];
		deleteVehicle (_projectile getVariable ["DB_lancet_subUAV", objNull]);
	}];
	_projectile setVariable ["lancet_geran_explodeEH", _explodeEH];
};

_display displayAddEventHandler ["KeyDown", {
	params ["_display", "_key"];

	switch (_key) do {
		case 49: {
			private _projectile = uiNamespace getVariable ["lancet_geran_projectile", objNull];
			if (isNull _projectile) exitWith {true};

			private _thermal = !(_projectile getVariable ["lancet_geran_thermal", false]);
			_projectile setVariable ["lancet_geran_thermal", _thermal];
			_thermal setCamUseTI 0;
			true
		};
		case 20: {
			private _projectile = uiNamespace getVariable ["lancet_geran_projectile", objNull];
			if (
				isNull _projectile
				|| {_projectile getVariable ["lancet_geran_terminalLocked", false]}
			) exitWith {true};

			private _mode = _projectile getVariable ["lancet_geran_guidanceMode", "CRUISE"];
			_projectile setVariable ["lancet_geran_manualInput", [0, 0]];
			_projectile setVariable ["lancet_geran_manualInputSmoothed", [0, 0]];
			_projectile setVariable ["lancet_geran_turnSpeed", 0];
			uiNamespace setVariable ["lancet_geran_dragStart", []];
			uiNamespace setVariable ["lancet_geran_dragActive", false];

			{
				(_display displayCtrl _x) ctrlShow false;
			} forEach [
				GERAN_IDC_SELECTION_TOP,
				GERAN_IDC_SELECTION_RIGHT,
				GERAN_IDC_SELECTION_BOTTOM,
				GERAN_IDC_SELECTION_LEFT
			];

			if (_mode isEqualTo "MANUAL") then {
				_projectile setVariable ["lancet_geran_guidanceMode", "CRUISE"];
			} else {
				_projectile setVariable ["lancet_geran_targetObject", objNull];
				_projectile setVariable ["lancet_geran_objectTarget", false];
				_projectile setVariable ["lancet_geran_targetOffsetModel", [0, 0, 0]];
				_projectile setVariable ["lancet_geran_aimPointASL", []];
				_projectile setVariable ["lancet_geran_lastKnownASL", []];
				_projectile setVariable ["lancet_geran_targetVisible", false];
				_projectile setVariable ["lancet_geran_nextTrackCheck", 0];
				_projectile setVariable ["lancet_geran_guidanceMode", "MANUAL"];
				setMousePosition [0.5, 0.5];
				[_projectile] call lancet_fnc_guideGeran;
			};

			true
		};
		case 33: {
			private _projectile = uiNamespace getVariable ["lancet_geran_projectile", objNull];
			if (!isNull _projectile) then {
				triggerAmmo _projectile;
			};
			_display closeDisplay 1;
			true
		};
		case 1: {
			_display closeDisplay 1;
			true
		};
		default {
			false
		};
	};
}];

_display displayAddEventHandler ["MouseButtonDown", {
	params ["_display", "_button"];
	private _projectile = uiNamespace getVariable ["lancet_geran_projectile", objNull];
	private _mode = if (isNull _projectile) then {
		"CRUISE"
	} else {
		_projectile getVariable ["lancet_geran_guidanceMode", "CRUISE"]
	};

	switch (_button) do {
		case 0: {
			if (
				!isNull _projectile
				&& {_mode isNotEqualTo "MANUAL"}
				&& {!(_projectile getVariable ["lancet_geran_terminalLocked", false])}
			) then {
				uiNamespace setVariable ["lancet_geran_dragStart", getMousePosition];
				uiNamespace setVariable ["lancet_geran_dragActive", false];
			};
			true
		};
		case 1: {
			if (
				!isNull _projectile
				&& {_mode isNotEqualTo "MANUAL"}
				&& {!(_projectile getVariable ["lancet_geran_terminalLocked", false])}
				&& {_mode isNotEqualTo "CRUISE"}
			) then {
				_projectile setVariable ["lancet_geran_targetObject", objNull];
				_projectile setVariable ["lancet_geran_objectTarget", false];
				_projectile setVariable ["lancet_geran_targetOffsetModel", [0, 0, 0]];
				_projectile setVariable ["lancet_geran_aimPointASL", []];
				_projectile setVariable ["lancet_geran_lastKnownASL", []];
				_projectile setVariable ["lancet_geran_targetVisible", false];
				_projectile setVariable ["lancet_geran_guidanceMode", "RECOVER"];
				[_projectile] call lancet_fnc_guideGeran;
			};
			true
		};
		default {
			false
		};
	};
}];

_display displayAddEventHandler ["MouseMoving", {
	params ["_display"];
	private _projectile = uiNamespace getVariable ["lancet_geran_projectile", objNull];

	if (
		!isNull _projectile
		&& {(_projectile getVariable ["lancet_geran_guidanceMode", "CRUISE"]) isEqualTo "MANUAL"}
	) then {
		private _current = getMousePosition;
		private _radiusX = 0.18 * safeZoneW;
		private _radiusY = 0.18 * safeZoneH;
		private _inputX = ((_current # 0) - 0.5) / _radiusX;
		private _inputY = (0.5 - (_current # 1)) / _radiusY;
		private _inputMagnitude = sqrt ((_inputX * _inputX) + (_inputY * _inputY));

		if (_inputMagnitude > 1) then {
			_inputX = _inputX / _inputMagnitude;
			_inputY = _inputY / _inputMagnitude;
			setMousePosition [
				0.5 + (_inputX * _radiusX),
				0.5 - (_inputY * _radiusY)
			];
		};

		_projectile setVariable ["lancet_geran_manualInput", [_inputX, _inputY]];
	} else {
		private _start = uiNamespace getVariable ["lancet_geran_dragStart", []];

		if (_start isNotEqualTo []) then {
			private _current = getMousePosition;
			private _deltaX = ((_current # 0) - (_start # 0)) / pixelW;
			private _deltaY = ((_current # 1) - (_start # 1)) / pixelH;
			private _dragActive = uiNamespace getVariable ["lancet_geran_dragActive", false];

			if (!_dragActive && {sqrt ((_deltaX * _deltaX) + (_deltaY * _deltaY)) > 8}) then {
				_dragActive = true;
				uiNamespace setVariable ["lancet_geran_dragActive", true];
			};

			if (_dragActive) then {
				private _lines = [
					_display displayCtrl GERAN_IDC_SELECTION_TOP,
					_display displayCtrl GERAN_IDC_SELECTION_RIGHT,
					_display displayCtrl GERAN_IDC_SELECTION_BOTTOM,
					_display displayCtrl GERAN_IDC_SELECTION_LEFT
				];
				private _rect = [
					((_start # 0) min (_current # 0)),
					((_start # 1) min (_current # 1)),
					abs ((_current # 0) - (_start # 0)),
					abs ((_current # 1) - (_start # 1))
				];

				[_lines, _rect, [0.08, 0.48, 1, 0.95]] call (
					uiNamespace getVariable ["lancet_geran_drawFrame", {}]
				);
			};
		};
	};
}];

_display displayAddEventHandler ["MouseButtonUp", {
	params ["_display", "_button"];
	if (_button isNotEqualTo 0) exitWith {false};

	private _start = uiNamespace getVariable ["lancet_geran_dragStart", []];
	private _end = getMousePosition;
	private _dragActive = uiNamespace getVariable ["lancet_geran_dragActive", false];
	private _projectile = uiNamespace getVariable ["lancet_geran_projectile", objNull];

	{
		(_display displayCtrl _x) ctrlShow false;
	} forEach [
		GERAN_IDC_SELECTION_TOP,
		GERAN_IDC_SELECTION_RIGHT,
		GERAN_IDC_SELECTION_BOTTOM,
		GERAN_IDC_SELECTION_LEFT
	];

	uiNamespace setVariable ["lancet_geran_dragStart", []];
	uiNamespace setVariable ["lancet_geran_dragActive", false];

	if (
		!isNull _projectile
		&& {_start isNotEqualTo []}
		&& {!(_projectile getVariable ["lancet_geran_terminalLocked", false])}
		&& {(_projectile getVariable ["lancet_geran_guidanceMode", "CRUISE"]) isNotEqualTo "MANUAL"}
	) then {
		[
			_projectile,
			_start,
			_end,
			_dragActive,
			uiNamespace getVariable ["lancet_geran_drawnCandidates", []]
		] call lancet_fnc_selectGeranTarget;
	};

	true
}];

_display displayAddEventHandler ["MouseZChanged", {
	params ["_display", "_scroll"];
	private _camera = uiNamespace getVariable ["lancet_geran_camera", objNull];
	if (isNull _camera || {_scroll isEqualTo 0}) exitWith {false};

	private _fov = uiNamespace getVariable ["lancet_geran_userFov", 0.75];
	private _factor = if (_scroll > 0) then {0.86} else {1.16};
	_fov = ((_fov * _factor) max 0.08) min 0.75;

	uiNamespace setVariable ["lancet_geran_userFov", _fov];
	uiNamespace setVariable [
		"lancet_geran_fovPulse",
		(uiNamespace getVariable ["lancet_geran_fovPulse", 0]) + 1
	];
	_camera camSetFov _fov;
	_camera camCommit 0.15;

	private _blur = uiNamespace getVariable ["lancet_geran_blur", -1];
	if (_blur >= 0) then {
		_blur ppEffectAdjust [
			linearConversion [0.08, 0.75, _fov, 1.2, 0.08, true]
		];
		_blur ppEffectCommit 0.15;
	};
	true
}];

private _nextScan = 0;
private _targets = [];

while {alive _projectile && {!isNull _display}} do {
	private _now = diag_tickTime;
	private _mode = _projectile getVariable ["lancet_geran_guidanceMode", "CRUISE"];
	private _manual = _mode isEqualTo "MANUAL";
	private _selectedTarget = _projectile getVariable ["lancet_geran_targetObject", objNull];
	private _objectTarget = _projectile getVariable ["lancet_geran_objectTarget", !isNull _selectedTarget];
	private _targetVisible = _projectile getVariable ["lancet_geran_targetVisible", false];
	private _terminal = _projectile getVariable ["lancet_geran_terminalLocked", false];
	private _drawnCandidates = [];
	private _drawnCount = 0;
	private _selectedDrawn = false;

	if (_manual) then {
		_targets = [];
		_nextScan = 0;

		{
			_x ctrlShow false;
		} forEach _selectionLines;
	} else {
		if (_now >= _nextScan) then {
			_targets = [_projectile] call lancet_fnc_findGeranTargets;
			_nextScan = _now + 0.25;
		};

		{
			if (_drawnCount < 16) then {
				_x params ["_target", "_confidence", "_priority"];
				private _drawTarget = !(
					_target isEqualTo _selectedTarget
					&& {!_targetVisible}
				);

				if (_drawTarget) then {
					private _rect = [_target] call _getScreenRect;

					if (_rect isNotEqualTo []) then {
						private _selected = _target isEqualTo _selectedTarget;
						private _color = if (_selected) then {
							if (_terminal) then {
								[1, 0.08, 0.05, 0.96]
							} else {
								[0.12, 1, 0.28, 0.94]
							}
						} else {
							[1, 0.74, 0.04, 0.88]
						};

						[_boxControls # _drawnCount, _rect, _color] call _drawFrame;
						_drawnCandidates pushBack [_target, _confidence, _priority, _rect];
						_drawnCount = _drawnCount + 1;

						if (_selected) then {
							_selectedDrawn = true;
						};
					};
				};
			};
		} forEach _targets;
	};

	if (_drawnCount < 16) then {
		for "_index" from _drawnCount to 15 do {
			{
				_x ctrlShow false;
			} forEach (_boxControls # _index);
		};
	};

	uiNamespace setVariable ["lancet_geran_drawnCandidates", _drawnCandidates];

	private _aimPointASL = _projectile getVariable ["lancet_geran_aimPointASL", []];
	private _showTrackMarker = false;
	private _trackColor = [0.12, 1, 0.28, 0.95];

	if (!_manual && {_mode in ["DIVE", "TERMINAL"]} && {_aimPointASL isNotEqualTo []}) then {
		if (_terminal) then {
			_showTrackMarker = !_selectedDrawn;
			_trackColor = [1, 0.08, 0.05, 0.96];
		} else {
			if (!_objectTarget) then {
				_showTrackMarker = true;
			} else {
				if (!_targetVisible) then {
					_showTrackMarker = true;
					_trackColor = [1, 0.46, 0.03, 0.95];
				};
			};
		};
	};

	if (_showTrackMarker) then {
		private _aimScreen = worldToScreen (ASLToAGL _aimPointASL);

		if (_aimScreen isNotEqualTo []) then {
			private _trackWidth = 18 * pixelW;
			private _trackHeight = 18 * pixelH;
			private _trackRect = [
				(_aimScreen # 0) - (_trackWidth * 0.5),
				(_aimScreen # 1) - (_trackHeight * 0.5),
				_trackWidth,
				_trackHeight
			];

			[_trackLines, _trackRect, _trackColor] call _drawFrame;
		} else {
			{
				_x ctrlShow false;
			} forEach _trackLines;
		};
	} else {
		{
			_x ctrlShow false;
		} forEach _trackLines;
	};

	getMousePosition params ["_mouseX", "_mouseY"];
	private _cursorX = _mouseX - safeZoneX;
	private _cursorY = _mouseY - safeZoneY;
	private _gapX = 13 * pixelW;
	private _gapY = 13 * pixelH;
	private _armWidth = 18 * pixelW;
	private _armHeight = 18 * pixelH;
	private _cursorPositions = [
		[_cursorX - _gapX - _armWidth, _cursorY - (2 * pixelH), _armWidth, 4 * pixelH],
		[_cursorX + _gapX, _cursorY - (2 * pixelH), _armWidth, 4 * pixelH],
		[_cursorX - (2 * pixelW), _cursorY - _gapY - _armHeight, 4 * pixelW, _armHeight],
		[_cursorX - (2 * pixelW), _cursorY + _gapY, 4 * pixelW, _armHeight],
		[_cursorX - _gapX - _armWidth, _cursorY - pixelH, _armWidth, 2 * pixelH],
		[_cursorX + _gapX, _cursorY - pixelH, _armWidth, 2 * pixelH],
		[_cursorX - pixelW, _cursorY - _gapY - _armHeight, 2 * pixelW, _armHeight],
		[_cursorX - pixelW, _cursorY + _gapY, 2 * pixelW, _armHeight]
	];

	{
		_x ctrlSetPosition (_cursorPositions # _forEachIndex);
		_x ctrlShow true;
		_x ctrlCommit 0;
	} forEach _cursorControls;

	uiSleep 0.01;
};

if (
	!isNull _projectile
	&& {(_projectile getVariable ["lancet_geran_guidanceMode", "CRUISE"]) isEqualTo "MANUAL"}
) then {
	_projectile setVariable ["lancet_geran_manualInput", [0, 0]];
	_projectile setVariable ["lancet_geran_manualInputSmoothed", [0, 0]];
};

false setCamUseTI 0;

if (!isNull _display) then {
	_display closeDisplay 1;
};

if (!isNull _camera) then {
	_camera cameraEffect ["terminate", "back"];
	camDestroy _camera;
};

{
	ppEffectDestroy _x;
} forEach _effects;

if ((uiNamespace getVariable ["lancet_geran_camera", objNull]) isEqualTo _camera) then {
	uiNamespace setVariable ["lancet_geran_camera", nil];
	uiNamespace setVariable ["lancet_geran_projectile", nil];
	uiNamespace setVariable ["lancet_geran_drawFrame", nil];
	uiNamespace setVariable ["lancet_geran_drawnCandidates", nil];
	uiNamespace setVariable ["lancet_geran_dragStart", nil];
	uiNamespace setVariable ["lancet_geran_dragActive", nil];
	uiNamespace setVariable ["lancet_geran_blur", nil];
	uiNamespace setVariable [
		"lancet_geran_fovPulse",
		(uiNamespace getVariable ["lancet_geran_fovPulse", 0]) + 1
	];
};
