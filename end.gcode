G92 E0

G0 Z{max_layer_z + 2.0} F600
; retract the filament to make it easier to replace
G0 E-10 F200
G28

{if is_extruder_used[(initial_extruder % 2 == 0 ? min(initial_extruder + 0, 63) : max(initial_extruder - (1-0), 0))]}
M104 T{(initial_extruder % 2 == 0 ? min(initial_extruder + 0, 63) : max(initial_extruder - (1-0), 0))} S0
  {endif}
{if is_extruder_used[(initial_extruder % 2 == 0 ? min(initial_extruder + 1, 63) : max(initial_extruder - (1-1), 0))]}
M104 T{(initial_extruder % 2 == 0 ? min(initial_extruder + 1, 63) : max(initial_extruder - (1-1), 0))} S0
  {endif}
M140 S0
M107
M220 S100
M84

;
; DON'T REMOVE these lines if you're using the smfix (https://github.com/macdylan/SMFix)
; min_x = [first_layer_print_min_0]
; min_y = [first_layer_print_min_1]
; max_x = [first_layer_print_max_0]
; max_y = [first_layer_print_max_1]
; max_z = [max_layer_z]
; total_layer_number = [layer_num]
;
