#define GRID_W( num ) ( num * ( pixelGridNoUIScale * pixelW * 2 ))
#define GRID_H( num ) ( num * ( pixelGridNoUIScale * pixelH * 2 ))

private _target = call lancet_fnc_searchTarget;

if ((isNil "_target") || {_target == objNull}) exitWith {
	uiNamespace setVariable ["DB_isSlewing", false]; 
	(uiNameSpace getVariable ["DB_targetCross", controlNull]) ctrlShow true;
	(uiNameSpace getVariable ["DB_full_screenplus", controlNull]) ctrlShow true;
	(uiNameSpace getVariable ["DB_AutoLockPicture", controlNull]) ctrlShow false;

	private _width = GRID_W(7);
	private _height = GRID_H(7);
		
	_seekerLockPicture ctrlSetPosition [0.5 - _width / 2, 0.5 - _height / 2, _width, _height];
	_seekerLockPicture ctrlCommit 0.0;
};

private _seekerLockPicture = uiNameSpace getVariable ["DB_seeker_lock", controlNull];
private _rocket = uiNamespace getVariable ["lancet_currentProjectile", objNull];

[getPosASL _rocket, "", _target, speed _rocket, false, [0.0, 0.0, 0.0], 5.0] spawn lancet_fnc_guideUAV;

addMissionEventHandler ["Draw3D", {
	_thisArgs params ["_target", "_seekerLockPicture", "_rocket"];
	
	private _uiPosition = worldToScreen (_target modelToWorld [0, 0, 0.5]);
	private _rocket = uiNamespace getVariable ["lancet_currentProjectile", objNull];

	if (_uiPosition isEqualTo []) exitWith {};
	if ((isNull _rocket) || (!(uiNamespace getVariable ["DB_isSlewing", false]))) exitWith {
		uiNamespace setVariable ["DB_isSlewing", false];

		removeMissionEventHandler ["Draw3D", _thisEventHandler];

		(uiNameSpace getVariable ["DB_targetCross", controlNull]) ctrlShow true;
		(uiNameSpace getVariable ["DB_full_screenplus", controlNull]) ctrlShow true;
		(uiNameSpace getVariable ["DB_AutoLockPicture", controlNull]) ctrlShow false;

		private _width = GRID_W(7);
		private _height = GRID_H(7);

		_seekerLockPicture ctrlSetPosition [0.5 - _width / 2, 0.5 - _height / 2, _width, _height];
		_seekerLockPicture ctrlCommit 0.0;
	};

	//_uiPosition params ["_xPos", "_yPos"];

	//_seekerLockPicture ctrlSetPositionX (_xPos - ((ctrlPosition _seekerLockPicture) # 2) / 2);
	//_seekerLockPicture ctrlSetPositionY (_yPos - ((ctrlPosition _seekerLockPicture) # 3) / 2);
	//_seekerLockPicture ctrlCommit 0.0;

	private _boundingBox = boundingBoxReal _target;
	private _corner1Model = (_boundingBox select 0);
	private _corner2Model = (_boundingBox select 1);

	private _centerModel = [
	    ((_corner1Model select 0) + (_corner2Model select 0)) / 2,
	    ((_corner1Model select 1) + (_corner2Model select 1)) / 2,
	    ((_corner1Model select 2) + (_corner2Model select 2)) / 2
	];

	private _centerWorld = _target modelToWorldVisual _centerModel;
	private _centerScreen = worldToScreen _centerWorld;

	if (_centerScreen isEqualTo []) exitWith {};

	private _widthWorld = (_corner2Model select 0) - (_corner1Model select 0);
	private _heightWorld = (_corner2Model select 1) - (_corner1Model select 1);

	private _vec1 = (worldToScreen (_centerWorld vectorAdd [(_widthWorld / 2), 0, 0]));
	private _vec2 = (worldToScreen (_centerWorld vectorAdd [0, (_heightWorld / 2), 0]));

	if (_vec1 isEqualTo [] || _vec2 isEqualTo []) exitWith {};

	private _widthScreen = abs ((_vec1 select 0) - (_centerScreen select 0)) * 2;
	private _heightScreen = abs ((_vec2 select 1) - (_centerScreen select 1)) * 2;

	if (_widthScreen isEqualTo [] || _heightScreen isEqualTo []) exitWith {};

	_widthScreen = (_widthScreen max GRID_W(2)) min GRID_W(10);
	_heightScreen = (_heightScreen max GRID_H(2)) min GRID_H(10);

	private _xScreen = (_centerScreen select 0) - (_widthScreen / 2);
	private _yScreen = (_centerScreen select 1) - (_heightScreen / 2);

	_seekerLockPicture ctrlSetPosition [_xScreen, _yScreen, _widthScreen, _heightScreen];
	_seekerLockPicture ctrlCommit 0;





}, [_target, _seekerLockPicture, _rocket]];