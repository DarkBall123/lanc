params ["_projectile", "_target", "_thermal", "_range"];

if (isNull _projectile || {isNull _target} || {!alive _target}) exitWith {0};

private _bounds = boundingBoxReal _target;
private _centerModel = ((_bounds # 0) vectorAdd (_bounds # 1)) vectorMultiply 0.5;
private _sensorPosASL = AGLToASL (_projectile modelToWorldVisual [0, 2, 0]);
private _targetPosASL = AGLToASL (_target modelToWorldVisual _centerModel);
private _distance = _sensorPosASL vectorDistance _targetPosASL;
private _visualUav = _projectile getVariable ["DB_geran4_visualUAV", objNull];

if (_distance > _range) exitWith {0};

private _view = [_visualUav, "VIEW", _target] checkVisibility [_sensorPosASL, _targetPosASL];
private _geometry = [_visualUav, "GEOM", _target] checkVisibility [_sensorPosASL, _targetPosASL];

if (_thermal) then {
	_view = _view + (((_geometry - _view) max 0) * 0.65);
};

private _distanceFactor = linearConversion [0, _range, _distance, 1, 0.55, true];
private _rainFactor = 1 - (rain * 0.25);
private _fogFactor = 1 - ((fogParams # 0) * 0.35);
private _lightFactor = if (_thermal) then {1} else {0.45 + (sunOrMoon * 0.55)};

((_view min _geometry) * _distanceFactor * _rainFactor * _fogFactor * _lightFactor) max 0 min 1;
