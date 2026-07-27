params ["_object"];

private _playerPos = getPosATL _object;
private _objectType = typeOf _object;

if ((_objectType find "geran") > -1) exitWith {
    (nearestObjects [_playerPos, ["Geran_AmmoBox"], 15]) isNotEqualTo []
};

private _containers = nearestObjects [_playerPos, ["All"], 15];
private _found = false;
private _magType = "lancet_dummy_mag";

if ((_objectType find "izdelie") > -1) then {
    _magType = "izdelie_dummy_mag";
};

{
    private _mags = getMagazineCargo _x # 0;
    if (_magType in _mags) then {
        _found = true;
    };
} forEach _containers;

_found;
