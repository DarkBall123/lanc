params ["_vehicle"];

while { !isNull _vehicle } do {
	private _keepLoadedVisual = _vehicle getVariable ["geran4_keepLoadedVisual", false];
	private _hideLoadedModel = !(someAmmo _vehicle) && {!_keepLoadedVisual};
	private _animationPhase = if (_hideLoadedModel) then {1} else {0};
	_vehicle animateSource ["tubel_hide_full", _animationPhase];
	
	sleep 0.1;
};
