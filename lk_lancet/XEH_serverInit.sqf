if !(isServer) exitWith {}; // for safety

DB_lancetClasses =  [
    "lancet_tripod_launcher_o",
	"lancet_tripod_launcher_b",
    "lancet_tripod_launcher_i",
    "izdelie_tripod_launcher_o",
    "izdelie_tripod_launcher_b",
    "izdelie_tripod_launcher_i",
    "geran_tripod_launcher_o",
    "geran_tripod_launcher_b",
    "geran_tripod_launcher_i"
];

["CAManBase", "WeaponAssembled", {
    params ["_unit", "_staticWeapon"];

    if !(typeOf _staticWeapon in DB_lancetClasses) exitWith {};
    if (local _staticWeapon) then {
        _staticWeapon setVehicleAmmo 0;
    } else {
        [_staticWeapon, 0] remoteExec ["setVehicleAmmo", 2];
    };
}] call CBA_fnc_addClassEventHandler;
