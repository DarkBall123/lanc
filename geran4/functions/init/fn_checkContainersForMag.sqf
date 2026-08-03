params ["_object"];

private _boxes = nearestObjects [getPosATL _object, ["Geran_AmmoBox"], 15];
(_boxes findIf {!(_x getVariable ["geran4_isConsumed", false])}) >= 0
