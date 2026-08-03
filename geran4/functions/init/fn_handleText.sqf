#include "..\includes.hpp"

params ["_dialog", "_projectile"];

private _txElev = _dialog displayCtrl tx_elev;
private _txFlir = _dialog displayCtrl tx_camera;
private _txAzim = _dialog displayCtrl tx_azimuth;
private _txDate = _dialog displayCtrl tx_time;
private _txLock = _dialog displayCtrl tx_lock;
private _txTime = _dialog displayCtrl tx_eta;

_txElev ctrlSetFontHeight 0.07;
_txFlir ctrlSetFontHeight 0.07;
_txAzim ctrlSetFontHeight 0.07;
_txDate ctrlSetFontHeight 0.05;
_txLock ctrlSetFontHeight 0.05;

//Date
date params ["_year", "_month", "_day", "_hours", "_minutes"];
//Fix the date to a nicer format, just do it idc about perf
private _strHours = str _hours;
if(_hours < 10) then {
	_strHours = "0" + str _hours;
};
private _strMinutes = str _minutes;
if(_minutes < 10) then {
	_strMinutes = "0" + str _minutes;
};
_timeMessage = str _day + "/" + str _month + "/" + str _year + " - " + _strHours + ":" + _strMinutes;
_txDate ctrlSetText _timeMessage;

private _timeNow = _projectile getVariable ["lancet_launchTime", time];
private _t = 0;
while {alive _projectile and dialog} do {
	private _thermal 	= uiNamespace getVariable ["_thermalState", true];
	private _lock 		= uiNamespace getVariable ["_autoLockState", true];
	private _zoom 		= uiNamespace getVariable ["_zoomStatus", false];
	private _locked 	= uiNamespace getVariable ["_itemLock", false];

	//There has to be a better way
	_thermalMessage = "CAM";
	if(!_thermal) then {
		_thermalMessage = "THERMAL";
	};
	_zoomMessage = "";
	if(_zoom) then {
		_zoomMessage = "ZOOM";
	};
	_lockMessage = "LOCK: OFF";
	if(_locked) then {
		_lockMessage = "LOCK: ON";
	};
	if(!_lock) then {
		_lockMessage = "LOCKED";
	};

	_t = round(time - _timeNow);
	_txTime ctrlSetText str _t;
	_txLock ctrlSetText _lockMessage;
	_txAzim ctrlSetText str round (direction _projectile);
	_txElev ctrlSetText _zoomMessage;
	_txFlir ctrlSetText _thermalMessage;

	sleep 0.25;
};