#include "..\includes.hpp"

#define GRID_W( num ) ( num * ( pixelGridNoUIScale * pixelW * 2 ))
#define GRID_H( num ) ( num * ( pixelGridNoUIScale * pixelH * 2 ))

params ["_display"];

private _lockPicture = uiNamespace getVariable ["DB_seeker_lock", controlNull];

private _width = GRID_W(7);
private _height = GRID_H(7);

if (isNull _lockPicture) then {
    _lockPicture = _display ctrlCreate ["RscPicture", -1];
    _lockPicture ctrlSetText "\lk_lancet\pictures\targetLock.paa";
    _lockPicture ctrlSetPosition [0.5 - _width / 2, 0.5 - _height / 2, _width, _height];
    _lockPicture ctrlSetTextColor [1,1,1,1];
    _lockPicture ctrlCommit 0;
    uiNamespace setVariable ["DB_seeker_lock", _lockPicture];
};

if (uiNamespace getVariable ["isSlewing", false]) exitWith {};

getMousePosition params ["_x", "_y"];

private _lockWidth = (ctrlPosition _lockPicture # 2) / 2;
private _lockHeight = (ctrlPosition _lockPicture # 3)/ 2;

_x = _x max (safeZoneX + _lockWidth) min (safeZoneX + safeZoneW - _lockWidth);
_y = _y max (safeZoneY + _lockHeight) min (safeZoneY + safeZoneH - _lockHeight);

_lockPicture ctrlSetPosition [_x - _lockWidth, _y - _lockHeight];
_lockPicture ctrlCommit 0.0;