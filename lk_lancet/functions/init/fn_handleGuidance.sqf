params["_projectile", "_v", "_timeManouver"];

//Projectile 
private _posProj 	= getPosASL _projectile;	
private _vUpProj 	= vectorUp _projectile;
private _vDirProj	= vectorDir _projectile;

//The side vector is kept constant
private _sideVector = _v vectorCrossProduct _vUpProj;
private _localUpVector = _v vectorCrossProduct _sideVector;

//Up vector at the target  - technically not needed to normalize the vectors
private _vDirTgt = vectorNormalized _v;
private _vUpTgt = vectorNormalized _localUpVector;

//Handle going upward
private _diff = [0.5, 0.5] vectorDiff getMousePosition;
if((_diff # 1) > 0.3) then {
	_vDirTgt set [2, _vDirTgt # 2 + (_diff # 1 * 0.5)];
};

//Handle moving the mission
private _id = ["lancet_handleMissileRot", "onEachFrame", {
	params[ "_projectile","_timeArr", "_vUpArr", "_vDirArr"];
	_vDir = vectorLinearConversion [_timeArr # 0, _timeArr # 1, time, _vDirArr # 0, _vDirArr # 1];
	_vUp  = vectorLinearConversion [_timeArr # 0, _timeArr # 1, time, _vUpArr # 0, _vUpArr # 1];
	_projectile setVectorDirAndUp [_vDir, _vUp];
}, [_projectile, [time, time + _timeManouver], [_vUpProj, _vUpTgt], [_vDirProj, _vDirTgt]]] call BIS_fnc_addStackedEventHandler;

//Small buffer
//Wait for the missile to have manouvered 
private _timeZero = time;
waitUntil {
	!(alive _projectile) or (time - _timeZero) > _timeManouver
};
[_id, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;