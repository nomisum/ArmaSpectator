/*
 * Author: Derzade
 * Triggered by the 'expand' button in the interface
 *
 * Arguments:
 * 0: Button <CONTROL>
 *
 * Return Value:
 * NONE
 *
 * Example:
 * _this call zade_spectator_fnc_btnClick_expand;
 *
 * Public: No
 */
params ["_ctrl"];

{
     private _tree = (ctrlParent _ctrl) displayCtrl _x;
     for "_i" from 0 to ((_tree tvCount []) - 1) do {
          _tree tvExpand [_i];
     };
} forEach [14,15]; //for normal and search results tree
