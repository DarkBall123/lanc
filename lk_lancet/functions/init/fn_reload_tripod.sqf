params ["_object"];

_object setVariable ['lancet_isAssembleing', false, true];

private _removeMagazineFromContainer = {
    private ["_container","_magazine","_cargo","_index"];
    _container = _this select 0;
    _magazine = _this select 1;
    _cargo = magazineCargo _container;
    _index = _cargo find _magazine;
    if (_index != -1) then
    {
	    private ["_i"];
	    _i = 0;
        clearMagazineCargoGlobal _container;
        {
		    if (_index != _i) then {_container addMagazineCargoGlobal [_x,1]};
		    _i = _i+1;
	    } forEach _cargo;
    };
};

private _playerPos = getPosATL _object;
private _containers = nearestObjects [_playerPos, ["All"], 15];
private _objectType = typeOf _object;
private _isIzdelie = (_objectType find "izdelie") > -1;
private _magType = "lancet_dummy_mag";
private _factor = 1;

if (_isIzdelie) then {
    _magType = "izdelie_dummy_mag";
    _factor = 0.25;
};

if ((_objectType find "geran") > -1) then {
    _magType = "geran_dummy_mag";
};

private _currentAmmo = (((magazinesAmmo _object) # 0) # 1) / 4;

if ((magazinesAmmo _object) isEqualTo []) then {
    _currentAmmo = 0;
};

if (_magType in magazines player) exitWith {
    player removeMagazine _magType;
    _object setVehicleAmmo (_currentAmmo + _factor);
};

_containers = _containers select { _magType in (getMagazineCargo _x # 0) };

if (_containers isNotEqualTo []) exitWith {
    [_containers # 0, _magType] call _removeMagazineFromContainer;
    _object setVehicleAmmo (_currentAmmo + _factor);
};
