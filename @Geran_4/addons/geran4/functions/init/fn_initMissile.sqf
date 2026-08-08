params ["_unit", "_projectile", ["_controlUnits", []]];

private _actionUnits = if (_controlUnits isEqualTo []) then {
	crew (vehicle _unit)
} else {
	_controlUnits
};

{
	private _actionId = _x addAction [
		"Enable control",
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			private _projectile = _arguments # 0;
			[_projectile, 2, [], "geran_seeker"] spawn geran4_fnc_handleGeranMissile;
		},
		[_projectile],
		10,
		true,
		false,
		"",
		"",
		5,
		false
	];

	[_projectile, _actionId, _x] spawn {
		params ["_projectile", "_actionId", "_unit"];
		waitUntil {
			sleep 0.25;
			!alive _projectile
		};
		_unit removeAction _actionId;
	};
} forEach _actionUnits;

private _speedArray = getArray (configOf _projectile >> "geranSpeedArray");
if (_speedArray isNotEqualTo []) then {
	[_projectile, _speedArray] spawn geran4_fnc_handleSpeed;
};
