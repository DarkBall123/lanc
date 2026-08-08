params ["_object"];

_object setVariable ["geran4_isAssembling", false, true];

private _boxes = nearestObjects [getPosATL _object, ["Geran_AmmoBox"], 15];
private _boxIndex = _boxes findIf {!(_x getVariable ["geran4_isConsumed", false])};
if (_boxIndex < 0) exitWith {};

private _box = _boxes # _boxIndex;
_box setVariable ["geran4_isConsumed", true, true];
deleteVehicle _box;
_object setVehicleAmmo 1;
_object setMagazineTurretAmmo ["FakeMagazine", 1, [0]];
