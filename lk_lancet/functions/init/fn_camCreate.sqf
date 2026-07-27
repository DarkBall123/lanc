params ["_projectile", "_offset"];

private _tcamera = "camera" camCreate getPosASL _projectile;
showCinemaBorder false;
cameraEffectEnableHUD true;
_tcamera cameraEffect ["External", "BACK"];
//_tcamera camSetTarget _projectile;
_tcamera camSetRelPos [0,15,0];
_tcamera camCommit 0;
_tcamera attachTo [_projectile, [0, _offset, 0]];
_tcamera camSetFov 0.75;
_tcamera camCommit 0;
_tcamera camSetFocus [-1, -1];
_tcamera camCommit 0;

_tcamera;