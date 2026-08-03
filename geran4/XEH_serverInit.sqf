if !(isServer) exitWith {};

DB_geran4Classes = [
	"geran_tripod_launcher_o",
	"geran_tripod_launcher_b",
	"geran_tripod_launcher_i"
];

["CAManBase", "WeaponAssembled", {
	params ["_unit", "_staticWeapon"];

	if !(typeOf _staticWeapon in DB_geran4Classes) exitWith {};
	if (local _staticWeapon) then {
		_staticWeapon setVehicleAmmo 0;
	} else {
		[_staticWeapon, 0] remoteExec ["setVehicleAmmo", 2];
	};
}] call CBA_fnc_addClassEventHandler;
