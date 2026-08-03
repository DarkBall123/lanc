private _locationStart = AGLToASL positionCameraToWorld [0,0,0];
private _locationEnd = AGLToASL screenToWorld getMousePosition;

private _intersectPos = ((lineIntersectsSurfaces [_locationStart, _locationEnd, player, objNull, true, -1, "GEOM"]) # 0) # 0;
private _objects = (ASLToAGL _intersectPos) nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"], 50];

_objects # 0;