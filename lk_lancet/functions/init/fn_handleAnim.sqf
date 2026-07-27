params ["_vehicle"];

while { !isNull _vehicle } do {
	_vehicle animateSource ["tubel_hide_full", parseNumber !(someAmmo _vehicle)];
	
	sleep 0.1;
};