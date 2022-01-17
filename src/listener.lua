--// Used for listening to messages to the host, doesnt work rn tho
-- TODO: fix this entire lua file
log = require "log"
json = require "json"
log.usecolor = false

local modem_loc = ""

local function input(inp)
    io.write(inp)
    local read = io.read()
    return read
end

function checkModem()
    log.info('Checking if there are peripherals')
    local tPeripherals = peripheral.getNames()
    local tModems = {}

    if #tPeripherals > 0 then
        io.write('Modems: \n')
        for n = 1, #tPeripherals do
            local sPeripheral = tPeripherals[n]
            local tPeripheral = peripheral.getType(sPeripheral)
            if tPeripheral == "modem" then
                io.write(n, ". ", sPeripheral, "\n")
                tModems[n] = sPeripheral
            end
        end
        
        local read = input('Choose the corresponding number for the modem: ')
        modem_loc = tModems[tonumber(read)]
    else
        log.error('There are no peripherals on this computer.')
    end
end


function main()
    local modem = peripheral.wrap(modem_loc)
    modem.open(56) -- recieving commands

    shell.execute("clear", "screen")

    while true do 
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    
        if channel == 56 then
            print("Received a reply: " .. tostring(message) .. (" (%s)"):format(replyChannel))
        end

        if channel == 54 then
            print("Received a reply: " .. tostring(message) .. (" (%s)"):format(replyChannel))
        end
    end
end

checkModem()
main()