-- ###############################################################
-- #                                                             #
-- #       Telemetry Lua Script APM/Pixhawk, Version 1.0.1       #
-- #                                                             #
-- #  + tested with D4r-II & D8R                                 #
-- #  + works with Pixhawk and AUAV-X2                           #
-- #                                                             #
-- #  License (Script & images): Share alike                     #
-- #  Can be used and changed non commercial                     #
-- #                                                             #
-- #  Inspired by SockEye, Richardoe, Schicksie, lichtl          #
-- #                                                             #
-- #  Modifiziert von: Jace25 FPV-Community                      #
-- #                                                             #
-- ###############################################################

    local function getTelemetryId(name)
      field = getFieldInfo(name)
      if field then
        return field.id
      end
      return -1
    end

    local function run(event)

    lcd.clear()

-- ###############################################################
-- Lipo Empty Warning
-- ###############################################################

    local four_low=13.4     -- 4 cells 4s | Warning
    local three_low=10.4    -- 3 cells 3s | Warning
    local two_low=7.0       -- 2 cells 2s | Warning

-- ###############################################################
-- Lipo Full
-- ###############################################################

    local four_high=16.8    -- 4 cells 4s
    local three_high=12.6   -- 3 cells 3s
    local two_high=8.5      -- 2 cells 2s

-- ###############################################################
-- Lipo Stats
-- ###############################################################

    local battype = 3
    local battypestr="3S, "
    local percent=0
    local battsumid = getTelemetryId("VFAS")
    local batt_sum =  getValue(battsumid)

    if batt_sum>3 then
        battype=math.ceil(batt_sum/4.25)
    if battype==4 then
      battypestr="4S, "
      percent = (batt_sum-four_low)*(100/(four_high-four_low))
    end
    if battype==3 then
      battypestr="3S, "
      percent = (batt_sum-three_low)*(100/(three_high-three_low))
    end
    if battype==2 then
      battypestr="2S, "
      percent = (batt_sum-two_low)*(100/(two_high-two_low))
    end
    end

    local myPxHeight = math.floor(percent * 0.37)
    local myPxY = 11 + 37 - myPxHeight

      lcd.drawPixmap(3, 1, "/SCRIPTS/BMP/battery.bmp")

    if percent > 0 then
      lcd.drawFilledRectangle(8, myPxY, 21, myPxHeight, FILL_WHITE )
    end

    local i = 36
    while (i > 0) do
        lcd.drawLine(8, 11 + i, 27, 11 +i, SOLID, GREY_DEFAULT)
        i= i-2
    end

    if (percent < 15) then
        lcd.drawNumber(4,55, batt_sum ,PREC2 + LEFT + BLINK)
    else
        lcd.drawNumber(4,55, batt_sum ,PREC2 + LEFT)
    end

    lcd.drawText(lcd.getLastPos(), 55, "v ", 0)
    lcd.drawText(lcd.getLastPos(), 55,battypestr,0)

--    local currId = getTelemetryId("CURR")
--    lcd.drawText(lcd.getLastPos(), 55, getValue(currId), 0)
--    lcd.drawText(lcd.getLastPos(), 55, ' mAh Total', 0)

-- ###############################################################
-- Timer
-- ###############################################################

    local timer = model.getTimer(0)
    lcd.drawText(38, 33, "Timer: ",SMLSIZE, 0)
    lcd.drawTimer(lcd.getLastPos(), 29, timer.value, MIDSIZE)

-- ###############################################################
-- Altitude
-- ###############################################################

    local altid = getTelemetryId("Alt")
    lcd.drawText(102,45, "Alt: ",SMLSIZE,0)
    lcd.drawText(lcd.getLastPos(), 41, getValue(altid), MIDSIZE)
    lcd.drawText(lcd.getLastPos(), 45, 'm', 0)

-- ###############################################################
-- Distance
-- ###############################################################

   -- local distanceid = getTelemetryId('distance')
   -- lcd.drawText(102,33, "Dist: ",SMLSIZE)
   -- lcd.drawText(lcd.getLastPos(), 29, getValue(distanceid), MIDSIZE)
   -- lcd.drawText(lcd.getLastPos(), 33, 'm', 0)

-- ###############################################################
-- Current
-- ###############################################################

    local currentid = getTelemetryId('Curr')
    lcd.drawText(38, 45, "Cur: ",SMLSIZE)
    lcd.drawText(lcd.getLastPos(), 41, getValue(currentid),MIDSIZE)
    lcd.drawText(lcd.getLastPos(), 45, 'A', 0)

-- ###############################################################
-- Flightmodes
-- ###############################################################

    local FlightMode = {}
    local i

    for i=1, 17 do
        FlightMode[i] = {}
        FlightMode[i].Name=""
    end

    FlightMode[1].Name="Stabilize"
    FlightMode[2].Name="Acro"
    FlightMode[3].Name="Alt Hold"
    FlightMode[4].Name="Auto"
    FlightMode[5].Name="Guided"
    FlightMode[6].Name="Loiter"
    FlightMode[7].Name="RTL"
    FlightMode[8].Name="Circle"
    FlightMode[9].Name="Invalid Mode"
    FlightMode[10].Name="Land"
    FlightMode[11].Name="Optical Loiter"
    FlightMode[12].Name="Drift"
    FlightMode[13].Name="Invalid Mode"
    FlightMode[14].Name="Sport"
    FlightMode[15].Name="Flip Mode"
    FlightMode[16].Name="Auto Tune"
    FlightMode[17].Name="Pos Hold"

    local flightmodeId = getTelemetryId("Tem1")
    local flightModeNumber = getValue(flightmodeId) + 1
    if flightModeNumber < 1 or flightModeNumber > 17 then
        flightModeNumber = 13
    end
    lcd.drawText(70, 1, FlightMode[flightModeNumber].Name, MIDSIZE)

-- ###############################################################
-- Flightmode Image
-- ###############################################################

    if flightModeNumber > -1 and flightModeNumber < 4 then
        lcd.drawPixmap(50, 1, "/SCRIPTS/BMP/fm.bmp")
    else
        lcd.drawPixmap(50, 1, "/SCRIPTS/BMP/gps.bmp")
    end

-- ###############################################################
-- GPS Fix
-- ###############################################################
    local gpsid = getTelemetryId("Temp")
    local satRaw = getValue(gpsid)
    local satCount =  (satRaw - (satRaw%10))/10
    local gpsFix = (satRaw%10)

    if gpsFix >= 3 then
        lcd.drawText(75, 15, "3D FIX, ", SMLSIZE)
        lcd.drawText(lcd.getLastPos(),15, satCount, SMLSIZE)
        lcd.drawText(lcd.getLastPos(),15, ' Sats', SMLSIZE)
    else
        lcd.drawText(75,15, "NO FIX, ", BLINK+SMLSIZE)
        lcd.drawText(lcd.getLastPos(),15, satCount, BLINK+SMLSIZE)
        lcd.drawText(lcd.getLastPos(),15, ' Sats', BLINK+SMLSIZE)
    end

-- ###############################################################
-- Display RSSI data
-- ###############################################################

    local rssiId = getTelemetryId("RSSI")
    if getValue(rssiId) > 38 then
      percent = ((math.log(getValue(rssiId)-28, 10)-1)/(math.log(72, 10)-1))*100
    else
      percent = 0
    end

    if percent > 90 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI10.bmp")
    elseif percent > 80 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI09.bmp")
    elseif percent > 70 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI08.bmp")
    elseif percent > 60 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI07.bmp")
    elseif percent > 50 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI06.bmp")
    elseif percent > 40 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI05.bmp")
    elseif percent > 30 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI04.bmp")
    elseif percent > 20 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI03.bmp")
    elseif percent > 10 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI02.bmp")
    elseif percent > 0 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI01.bmp")
    else
          lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI00.bmp")
    end

      lcd.drawChannel(178, 55, getValue(rssiId), LEFT)
      lcd.drawText(lcd.getLastPos(), 56, "dB", SMLSIZE)

end

return { run=run }