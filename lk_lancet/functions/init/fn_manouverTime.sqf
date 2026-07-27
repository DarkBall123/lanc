params ["_projectile","_base", "_max"];

_corr = linearConversion [0, 400, speed _projectile, 0, _max, true];
_corr = _max - _corr;
_timeManouver = _base * (1 +  _corr);

_timeManouver