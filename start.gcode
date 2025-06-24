; Model: Snapmaker J1 ({nozzle_diameter[0]}/{nozzle_diameter[1]})
; Update: 20241211
; Maintained by https://github.com/macdylan/3dp-configs
; Revised: 20250619 - Optimized Heating Sequence (20250619) by D. Shope
; Printer : [printer_preset]
; Profile : [print_preset]
; Plate   : [plate_name]
;Layers :[total_layer_count]
; --- initial_extruder: [initial_extruder]
; --- has_wipe_tower: [has_wipe_tower]
; --- total_toolchanges: [total_toolchanges]
; --- T0: {is_extruder_used[0]}
; --- T1: {is_extruder_used[1]}

; Select the initial extruder
T[initial_extruder]

; --- IDEX Mode Configuration ---
{if plate_name =~ /.*IDEXDupl.*/ || plate_name =~ /.*IDEXCopy.*/ }
    M605 S2 X162 R0 ; IDEX Duplication mode
{elsif plate_name =~ /.*IDEXMirr.*/}
    M605 S3 ; IDEX Mirror mode
{elsif plate_name =~ /.*IDEXBack.*/}
    M605 S4 ; IDEX Backup mode
{endif}

; --- Start Heating Bed and ALL Used Extruders Simultaneously (Non-blocking) ---
M140 S{first_layer_bed_temperature[initial_extruder]} ; Start heating bed (non-blocking)

; --- is extruder 0 used at all? if so, preheat to 200C
{if is_extruder_used[0]}
    M104 S200 T0 ; Preheat Extruder 0 to 200C (non-blocking, explicitly targets T0)
{endif}

; --- is extruder 1 used at all? if so, preheat to 200C
{if is_extruder_used[1]}
    M104 S200 T1 ; Preheat Extruder 1 to 200C (non-blocking, explicitly targets T1)
{endif}

; --- Homing and Initial Z-move ---
G28 ; Home all axes
G0 Z0.2 F240.0 ; Move Z up below the nozzles

; --- Wait for Bed to Reach Temperature ---
M190 R{first_layer_bed_temperature[initial_extruder]} ; Wait for the bed to reach its initial layer temperature

M83 ; Set extruder to relative positioning

; --- Flush Nozzles (Non-Initial Extruders First) ---

; Flush Nozzle 0 if it is used and is NOT the initial extruder
{if is_extruder_used[0] && initial_extruder != 0}
    T0 ; Select Extruder 0 (Left Nozzle)
    ; M104 already started heating. Now, wait for it.
    M109 S{nozzle_temperature_initial_layer[0]} C3 W1 ; Wait for temp

	G0 Z0.2 F240.0 ; Ensure Z is clear (redundant if already homed, can be removed if Z is always fine after first home)
    G0 X137.0 F6840.0 ; Move to flush start X position
    G1 E6 F200 ; Extrude a bit to prime
    G92 E0 ; Reset extruder position
    G1 X-15 E8.5437 F3000.0 ; Wipe/extrude line
    G92 E0 ; Reset extruder position

    G1 E-{retract_length_toolchange[0]} F200 ; Retract for tool change
    G92 E0 ; Reset extruder position
	G4 S2 ;
    M104 S200 ; Set to vitrification temp (for parking) S{temperature_vitrification[0]}
{endif}

; Flush Nozzle 1 if it is used and is NOT the initial extruder
{if is_extruder_used[1] && initial_extruder != 1}
    T1 ; Select Extruder 1 (Right Nozzle)
    ; M104 already started heating. Now, wait for it.
    M109 S{nozzle_temperature_initial_layer[1]} C3 W1 ; Wait for temp

	G0 Z0.2 F240.0 ; Ensure Z is clear (redundant if already homed, can be removed if Z is always fine after first home)
    G0 X187.0 F6840.0 ; Move to flush start X position
    G1 E8 F200 ; Extrude a bit to prime
    G92 E0 ; Reset extruder position
    G1 X344 E8.5437 F3000.0 ; Wipe/extrude line
    G92 E0 ; Reset extruder position

    G1 E-{retract_length_toolchange[1]} F200 ; Retract for tool change
    G92 E0 ; Reset extruder position
    G4 S2 ; Delay
    M104 S200 ; Set to vitrification temp (for parking)
{endif}

; --- Flush Initial Nozzle (Always Last) ---
T[initial_extruder] ; Select the initial extruder
; M104 already started heating. Now, wait for it.
M109 S{nozzle_temperature_initial_layer[initial_extruder]} C3 W1 ; Wait for temp (Simplified S-parameter, moved up)

G0 Z0.2 F240.0 ; Ensure Z is clear (redundant if already homed, can be removed if Z is always fine after first home)
G0 X{( initial_extruder % 2 == 0 ? 137.0 : 187.0 )} F3000.0 ; Move to flush start X position (Now happens AFTER temp is reached)

G1 E8 F200 ; Extrude a bit to prime
G92 E0 ; Reset extruder position
G1 X{( initial_extruder % 2 == 0 ? -15 : 344 )} E8.5437 F3000.0 ; Wipe/extrude line
G92 E0 ; Reset extruder position

G1 E-{retraction_length[initial_extruder]} F200 ; Retract filament
G92 E0 ; Reset extruder position
G0 Y20 F6840.0 ; Move Y to clear print area

; Ready to print the plate
; ready [plate_name]
