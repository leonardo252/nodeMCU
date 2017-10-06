-- init.lua --


-- Global Variables (Modify for your network)
station_cfg={}
station_cfg.ssid="My World !"
station_cfg.pwd="4011049574"

station_cfg2={}
station_cfg2.ssid="LIT_hard"
station_cfg2.pwd="l17@2017"

-- Configure Wireless Internet
--print('\nAll About Circuits init.lua\n')
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')\n')
print('MAC Address: ',wifi.sta.getmac())
print('Chip ID: ',node.chipid())
print('Heap Size: ',node.heap(),'\n')
-- wifi config start
wifi.sta.config(station_cfg2)
-- wifi config end

-- Run the main file
dofile("main.lua")
