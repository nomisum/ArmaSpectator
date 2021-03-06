/*
 * Author: Derzade
 * Handles all icon drawing on the map
 *
 * Arguments:
 * 0: Map <CONTROL>
 *
 * Return Value:
 * NONE
 *
 * Example:
 * n/a
 *
 * Public: No
 */

params ["_ctrl"];

private _mapScale = ctrlMapScale _ctrl;
private _dialog = ctrlParent _ctrl;

//get cursorTarget
     private _cursorTarget = objNull;
     private _mousePos = _ctrl ctrlMapScreenToWorld getMousePosition;
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
     //custom icons
     {
          _x param [0,"_object"];
          private _pos = if (typeName _object isEqualTo "OBJECT") then {getPos _object}else {_object};
          if (_pos distance2D _mousePos < _distance) then {_cursorTarget = _x};
     } forEach zade_spectator_customIcons;

//draw icons
     //normal units
     {
          //icon
          private _icon = if ([_x] call zade_spectator_fnc_isMedic) then {"iconManMedic"} else {"iconMan"};
          if (leader (group _x) isEqualTo _x) then {
               _icon = "iconManLeader";
          };
          if ([_x] call zade_spectator_fnc_isUnconscious) then {
               _icon = "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa";
          };

          //color
          private _color = [(side _x)] call BIS_fnc_sideColor;;
          if (_x isEqualTo _cursorTarget) then {_color = [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]), 1]};

          _ctrl drawIcon [_icon, _color, getPos _x, 24, 24, getDir _x, "", 0, 0.03, 'RobotoCondensed', 'right'];

          //name
          if ((_mapScale < 0.1) or (_x isEqualTo _cursorTarget)) then {
               private _textalpha = if (_mapScale > 0.05) then {(0.1 - _mapScale) / 0.05} else {1};
               _color set [3,_textalpha];
               if (_x isEqualTo _cursorTarget) then {_color = [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]), 1]};
               _ctrl drawIcon ["#(argb,8,8,3)color(0,0,0,0)", _color, getPos _x, 24, 24, 0, name _x, 0, 0.03, 'RobotoCondensed', 'right'];
          };
     } forEach ([] call zade_spectator_fnc_allUnits);


     //draw dead
     if (cbChecked (_dialog displayCtrl 16) and _mapScale < 0.5) then {
     {
          private _group = _x;
          if ((side (_group select 0)) in (missionNamespace getVariable ["zade_spectator_allowedSides",[west,east,resistance,civilian]])) then {
               {
               //icon
                    //color
                    private _color = [0.1,0.1,0.1,1];
                    private _alpha = if (_mapScale > 0.25 or !(_x isEqualTo _cursorTarget)) then {(0.3 - _mapScale) / 0.05} else {1};
                    _color set [3,_alpha];
                    if (_x isEqualTo _cursorTarget) then {_color = [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]), 1]};

                    _ctrl drawIcon ["\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa", _color, getPos _x, 24, 24,0, "", 0, 0.03, 'RobotoCondensed', 'right'];

               //name
                    if ((_mapScale < 0.1) or (_x isEqualTo _cursorTarget)) then {
                         //text color
                         private _textalpha = if (_mapScale > 0.05) then {(0.1 - _mapScale) / 0.05} else {1};
                         _color set [3,_textalpha];
                         if (_x isEqualTo _cursorTarget) then {_color = [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]), 1]};

                         _ctrl drawIcon ["#(argb,8,8,3)color(0,0,0,0)", _color, getPos _x, 24, 24, 0,  (_x getVariable "zade_spectator_name"), 0, 0.03, 'RobotoCondensed', 'right'];
                    };

               } forEach (_group select 1);
          };
          } forEach zade_spectator_dead;
     };

     //custom icons
     {
          _x params ["_object","_icon","_color","_text","_drawDistance","_size3D","_size2D"];

          private _pos = if (typeName _object isEqualTo "OBJECT") then {getPos _object}else {_object};
          if (_object isEqualTo _cursorTarget) then {_color = [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]), 1]};

          _ctrl drawIcon [_icon, _color,_pos, _size2D, _size2D, 0, "", 0, 0.03, 'RobotoCondensed', 'right'];

          //text
          if ((_mapScale < 0.5) or (_x isEqualTo _cursorTarget)) then {
               //text color
               private _textalpha = if (_mapScale > 0.45) then {(0.5 - _mapScale) / 0.05} else {1};
               _color set [3,_textalpha];
               if (_x isEqualTo _cursorTarget) then {_color = [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]), 1]};

               _ctrl drawIcon ["", _color, _pos, _size2D, _size2D, 0, _text, 0, 0.03, 'RobotoCondensed', 'right'];
          };
     } forEach zade_spectator_customIcons;

     //draw camera
     _ctrl drawIcon ["\a3\3den\data\cfg3den\camera\cameratexture_ca.paa", [0.2,0.2,0.2,1], getPos (call zade_spectator_fnc_camera), 25, 25, getDir (call zade_spectator_fnc_camera), "", 0, 0.03, 'RobotoCondensed', 'right'];
