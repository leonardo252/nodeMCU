-- init.lua --


-- Global Variables (Modify for your network)
station_cfg={}
station_cfg.ssid="WIFI_SSID"
station_cfg.pwd="WIFI_PASSWORD"

-- Configure Wireless Internet
--print('\nAll About Circuits init.lua\n')
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')\n')
print('MAC Address: ',wifi.sta.getmac())
print('Chip ID: ',node.chipid())
print('Heap Size: ',node.heap(),'\n')
-- wifi config start
wifi.sta.config(station_cfg)
-- wifi config end

-- Run the main file
dofile("main.lua")
