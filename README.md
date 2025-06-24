# Snapmaker-J1S-Config
Custom G-Code for Snapmaker J1/J1S Printer

 *Note: Tested extensively using Snapmaker Orca, but regular OrcaSlicer should result in the same gcode behavior.*

## What is it?
Faster startup script that minimizes the time from nozzle heating to priming. Also preheats nozzles before layer swaps so the auto-swap usually doesn't have to pause. Combine these changes with a smaller prime tower, and you can significantly reduce print time while still getting great results. Testing is underway to bump most prints to 250mm/s maximum.

## Directions
Copy each of these files into the respective code blocks under "Printer settings" --> "Machine G-Code". Everything else under machine can use the recommended settings from the J1 profile built into the slicer. I've made small tweaks there but nothing necessary.

Most of the modifications you should play with are for the process (walls, support gaps, speeds, etc). Happy printing!
 
![Screenshot 2025-06-23 205213](https://github.com/user-attachments/assets/da5e52d4-a188-4e20-8c76-b380a36d26e7)

