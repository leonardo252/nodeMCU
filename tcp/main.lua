-- main.lua --

----------------------------------
-- WiFi Connection Verification --
----------------------------------
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...\n")
   else
      ip, nm, gw=wifi.sta.getip()
      print("IP Info: \nIP Address: ",ip)
      print("Netmask: ",nm)
      print("Gateway Addr: ",gw,'\n')
      tmr.stop(0)
   end
end)

----------------------
-- Global Variables --
----------------------
print("Setting Up GPIO...")
led_pin = 1
rele_pin = 2
high = 'gpio.HIGH'
low = 'gpio.LOW'
mode = low
gpio.mode(rele_pin, gpio.OUTPUT)
gpio.mode(led_pin, gpio.OUTPUT)

gpio.write(rele_pin, gpio.HIGH)

----------------
-- Web Server --
----------------
print("Starting Web Server...")
-- Create a server object with 30 second timeout
srv = net.createServer(net.TCP, 30)

-- server listen on 80,
-- if data received, print data to console,
-- then serve up a sweet little website
srv:listen(80,function(conn)
    conn:on("receive", function(conn, payload)
        --print(payload) -- Print data from browser to serial terminal

        function esp_update()
            mcu_do=string.sub(payload,postparse[2]+1,#payload)

            if mcu_do == "Rele+Liga" then
                gpio.write(rele_pin, gpio.LOW )
                print('Rele_pin mode LOW\n')
            end

            if mcu_do == "Rele+Desliga" then
                gpio.write(rele_pin, gpio.HIGH)
                print('Rele_pin mode HIGH\n')
            end

            if mcu_do == "LED" then
                if mode == low then
                    gpio.write(led_pin, gpio.HIGH)
                    mode = high
                    print('LED mode',high,'\n')
                elseif mode == high then
                    gpio.write(led_pin, gpio.LOW)
                    mode = low
                    print('LED mode',low,'\n')
                end
            end
            if mcu_do == "LDR" then
                val = adc.read(0)
                print("Valor ADC - LDR",val)
            end
        end

        --parse position POST vaçue from header
        postparse={string.find(payload,"mcu_do=")}
        --If POST value exist, set LED power
        if postparse[2]~=nill then esp_update()end

        -- CREATE WEBSITE --

        -- HTML Header Stuff
        conn:send('HTTP/1.1 200 OK\n\n')
        conn:send('<!DOCTYPE HTML>\n')
        conn:send('<html>\n')
        conn:send('<head><meta  content="text/html; charset=utf-8">\n')
        conn:send('<title>ESP8266 RELE Function</title></head>\n')
        conn:send('<body><h1>ESP8266 Turn on and Turn off</h1>\n')

        --Labels
        conn:send('<p>ADC Value: '..val..'</p><br>')
        
        -- Buttons
        conn:send('<form action="" method="POST">\n')
        conn:send('<input type="submit" name="mcu_do" value="Rele Liga">\n')
        conn:send('<input type="submit" name="mcu_do" value="Rele Desliga">\n')
        conn:send('<input type="submit" name="mcu_do" value="LED">\n')
        conn:send('<input type="submit" name="mcu_do" value="LDR">\n')
        
        conn:send('</body></html>\n')
        conn:on("sent", function(conn) conn:close() end)
    end)
end)
