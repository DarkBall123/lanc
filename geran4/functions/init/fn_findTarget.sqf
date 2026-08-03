params["_projectile", "_v"];

//Easy snap to targets near where you clicked
//_objs = lineIntersectsObjs [positionCameraToWorld [0,0,0], _posProj vectorAdd (_vDirTgt vectorMultiply 200), _projectile, objNull, true, 2 + 16 + 32];
private _currentTarget = objNull;
private _currentOffset = [0,0,0];
private _cameraPosASL = AGLTOASL positionCameraToWorld [0,0,0];
private _intersections = lineIntersectsSurfaces [_cameraPosASL, _cameraPosASL vectorAdd (_v vectorMultiply 200), _projectile, objNull, true, 1];
if(count _intersections > 0) then {
	_tempTarget = _intersections # 0 # 3;
	if(_tempTarget isKindOf "LandVehicle" or _tempTarget isKindOf "Man") then {
		_currentTarget = _tempTarget;

		if(_tempTarget isKindOf "Man") then {
			//Infatry aimpoint is always 1m above the ground
			_currentOffset = [0,0,1];
		} else {
			//For vehicles aim where the player aimed at
			_currentOffset =  ((_intersections # 0 # 0) vectorDiff (getPosASL _currentTarget));
		};
		
		//systemChat str (_intersections # 0 # 0);
	} else {
		//Allow easy snapping to vehicles 
		private _objsArr = nearestObjects [_intersections # 0 # 0, ["LandVehicle", "Man"], 10];
		if(count _objsArr > 0) then {
			_currentTarget = _objsArr # 0;
		};
	};
};

[_currentTarget,_currentOffset];
 