/*
	Speed starts with _maxSpeed and stays constant for 1 second
	Speed linearly decreases to _minSpeed in _maxTime 
	Speed remains constant at _minSpeed for _graceTime
*/

params ["_projectile", "_speedArr"];

//A useless thing made for the sake of clarity 
private _maxSpeed 	= _speedArr # 0;
private _minSpeed 	= _speedArr # 1;
private _maxTime 	= _speedArr # 2;
private _graceTime 	= _speedArr # 3;
private _delaySpeed = _speedArr # 4;

if(!isNil "_delaySpeed") then {
	sleep _delaySpeed;
};

_graceTime = _graceTime + _maxTime;
private _deltaSpeed = _maxSpeed - _minSpeed;
private _time = time;
private _n = 0;
private _t = (time - _time);
private _index = 0;
while {alive _projectile} do {
	_t = (time - _time);

	//With a switch we check 1 condition at the time rather than 8
	switch (_index) do {
		case 0: {
			_projectile setVelocityModelSpace [0,_maxSpeed,0];
			if(_t > 1) then {_index = _index + 1};
		};
		case 1: {
			_n = _deltaSpeed * (((_maxTime - _t) / _maxTime) max 0) + _minSpeed;
			_projectile setVelocityModelSpace [0,_n,0];
			if(_t > _maxTime) then {_index = _index + 1};
		};
		case 2: {
			_projectile setVelocityModelSpace [0,_minSpeed,0];
		};
	};

	if(_t > _graceTime) exitWith {};
	sleep 0.025; //A faster refresh rate improves consitency (and accuracy)
};

true;