; layer_num: [layer_num]
G92 E0

; In your "Before layer change G-code" section
{if current_extruder == 0 && is_extruder_used[1]} ; If T0 is active and T1 will be used
    M104 S{nozzle_temperature[1]} T1 ; Start heating T1 without waiting
{elsif current_extruder == 1 && is_extruder_used[0]} ; If T1 is active and T0 will be used
    M104 S{nozzle_temperature[0]} T0 ; Start heating T0 without waiting
{endif}
