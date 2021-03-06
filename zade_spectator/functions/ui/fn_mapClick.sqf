/*
 * Author: Derzade
 * Triggred by a click on the map
 *
 * Arguments:
 * 0: Map <CONTROL>
 * 1: Mousebutton <NUMBER>
 *
 * Return Value:
 * NONE
 *
 * Example:
 * _this call zade_spectator_fnc_mapClick;
 *
 * Public: No
 */
params ["_ctrl","_btn"];

private _mapScale = ctrlMapScale _ctrl;
private _dialog = ctrlParent _ctrl;
private _mousePos = _ctrl ctrlMapScreenToWorld getMousePosition;

switch (_btn) do {
     case (0): { //set freecam
          if (zade_spectator_camMode isEqualTo "FREECAM") then {
               _mousePos set [2,(getPos zade_spectator_camera) select 2];
               zade_spectator_camera setPos _mousePos;
          };
     };
     case (1): { //switch target
          //get cursorTarget
          private _cursorTarget = objNull;
          private _distance = 200 * _mapScale;
          //normal units
          {
               if ((getPos _x) distance2D _mousePos < _distance) then {_cursorTarget = _x};
          } forEach ([] call zade_spectator_fnc_allUnits);
          //dead units
          if (cbChecked (_dialog displayCtrl 16) and _mapScale < 0.5) then {
               {
                    {
                    if ((getPos _x) distance2D _mousePos < _distance) then {_cursorTarget = _x};
                    } forEach (_x select 1);
               } forEach zade_spectator_dead;
          };

          if !(_cursorTarget isEqualTo objNull) exitWith {
                [_cursorTarget] call zade_spectator_fnc_switchTarget;
          };
     };
};
