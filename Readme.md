# Readme
This Script should work with every Pixhawk (Pixhawk, Fixhawk, AUAV-X2, etc.) which
is connected to a FrSky D-Transmitter (D4R, D8R)

It displays the voltage and current, beside the current time and a simple timer below the currently used flightmode.
Also RSSI is displayed on the left side. All values are based on converted mavlink Data.
## Screenshots
![Displayed content while in user controlled mode](https://raw.githubusercontent.com/Jace25/LUA-Taranis-Pixhawk/master/lua1.JPG)
![Displayed content while in GPS controlled mode](https://raw.githubusercontent.com/Jace25/LUA-Taranis-Pixhawk/master/lua2.JPG)

## Flightcontroller Setup
1. Connect the Pixhawk with a RS232 TTL level converter (not need to be a FrSky, a cheaper one from Ebay also works fine (watch for correct specifications)) and connect RS232 TTL level converter with your Frysky Transmitter
2. Activate the FrSky D protocol in the parameters for the appropriate port

## Taranis Setup
1. Make sure you have LUA-Scripting enabled
2. If you dont have a folder "SCRIPTS", create it in your Sd's root
3. Download the scripts folder from here
3. Copy the "BMP" Folder from the just downloaded "SCRIPTS" Folder to your Taranis "SCRIPTS" folder
4. Create a new Folder inside the "SCRIPTS" folder, which has the exact name of your model (eg. Discovery)
5. Copy the lua script from the just downloaded "SCRIPTS/Modelname" folder inside your previously created folder
6 Start your Taranis an long press "PAGE"-Button