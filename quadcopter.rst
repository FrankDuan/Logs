=====================
Quadcopter
=====================


APM
==========

Configuration
---------------

RTL
^^^^^^^^^^^^^^
RTL mode (Return To Launch mode) navigates Copter from its current position to hover above the home position. 
When RTL mode is selected, the copter will return to the home location. The copter will first rise to RTL_ALT 
before returning home or maintain the current altitude if the current altitude is higher than RTL_ALT. The 
default value for RTL_ALT is 15m.

RTL is a GPS-dependent move, so it is essential that GPS lock is acquired before attempting to use this mode. 
Before arming, ensure that the APM’s blue LED is solid and not blinking. For a GPS without compass, the LED 
will be solid blue when GPS lock is acquired. For the GPS+Compass module, the LED will be blinking blue when 
GPS is locked.

The home position is always supposed to be your copter’s actual GPS takeoff location. For Copter if you get 
GPS lock and then ARM your copter, the home position is the location the copter was in when it was armed. 

Warning
""""""""
In RTL mode the flight controller uses a barometer as the primary means for determining altitude (“Pressure 
Altitude”) and if the air pressure is changing in your flight area, the copter will follow the air pressure 
change rather than actual altitude (unless you are within 20 feet of the ground and have SONAR installed and 
enabled).
