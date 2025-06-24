{if current_extruder != next_extruder}
    ; Change T[current_extruder] -> T[next_extruder] (layer [layer_num] [toolchange_count]/[total_toolchanges])
    ; layer [layer_num] at [layer_z]mm
    T[next_extruder]

    M107 P[current_extruder] ; Fan off for the current (outgoing) extruder

    ; Bed temp change (M140 is non-blocking, so no delay here)
    {if layer_num == 1 && (filament_type[current_extruder] == "PLA" || filament_type[current_extruder] == "TPU" || filament_type[next_extruder] == "PLA" || filament_type[next_extruder] == "TPU")}
        M140 S{min(bed_temperature[current_extruder], bed_temperature[next_extruder])}
    {endif}

    M2000 S200 V[travel_speed] A[travel_acceleration] ; Quick switch extruders
    
    ; WARNING: Replaced M109 (blocking) with M104 (non-blocking). This relies entirely on the 'Before Layer Change' G-code to ensure the nozzle is already at temperature.
    M104 T[next_extruder] S{if layer_num < 1}[nozzle_temperature_initial_layer]{else}[nozzle_temperature]{endif}

    {if layer_z > first_layer_height && layer_num >= close_fan_the_first_x_layers[next_extruder]}
        M106 P[next_extruder] S{fan_min_speed[next_extruder] * 255.0 / 100.0} ; Restore fan speed for the newly active extruder
    {endif}
{endif}
