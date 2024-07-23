![image](https://github.com/user-attachments/assets/ee217cb6-fcf7-4a4b-855f-e41f2cf993db)
![image](https://github.com/user-attachments/assets/d93646d0-7a7d-475e-b07d-d9c24679d0cb)

The model of the HVAC can increase or decrease only when “run” signals is active. \n
The Energy Monitor Control block shall direct the HVAC Simulator Unit to increase or decrease \n
the temperature depending on the outputs coming from the Compx4 comparator. This shall
include driving the “run” signal to the active state. When the “current_temp” equals the
“mux_temp” the Energy Monitor Control shall deactivate the “run” signal. \n
The “run” signal to the HVAC shall NOT be active if either the “window_open” or “door_open”
sensors are detected as being OPEN (‘1’). \n
The “run” signal to the HVAC shall NOT be active if the “MC_test_mode” (for testing the
comparator) is ON (‘1’). \n
The indicator (leds) for “AC” shall be active when the “mux_temp” is lesser than “current_temp”. \n
The indicator (leds) for “furnace” shall be active when the “mux_temp” is greater than
“current_temp”. \n
The indicator (leds) for “at_temp” shall be active when the “mux_temp” = “current_temp” and
the “blower” led shall be OFF. \n
The indicator (leds) for “blower” shall be ON when “mux_temp” is different than “current_temp”
except for when the “MC_test_mode” input is active (‘1’) or when or if either a Window or
Door is OPEN. \n
The indicator (led) for ”door open” shall be active when the “door_open” sensor is detected as
ON. \n
The indicator (led) for “window open” shall be active when the “window_open” sensor is
detected as ON. \n
The indicator (led) for “vacation” shall be activate when the “vacation_mode” pb is detected as
ON \n
