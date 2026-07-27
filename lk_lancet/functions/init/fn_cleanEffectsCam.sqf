_camera = param [0, objNull];

if(dialog) then {
	closeDialog 1;
};

//Clean 
if(!isNull _camera) then {
	false setCamUseTI 0;
	_camera cameraEffect ["terminate","back"];
	camDestroy _camera;
};

private _effects = (uiNamespace getVariable ["lancet_effectsArr", []]);
if(count _effects > 0) then {
	{
		ppEffectDestroy _x;
	}forEach _effects;
};
uiNamespace setVariable ["lancet_effectsArr",  []];