local c_id = os.getComputerID()
local version = os.version()

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
    log.info("Started, wont be outputting log messages.")

    local modem = peripheral.wrap(modem_loc)
    modem.open(54) -- recieving commands

    shell.execute("clear", "screen")

    while true do 
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    
        if channel == 54 then
            --print("Received a reply: " .. tostring(message) .. (" (%s)"):format(replyChannel))
            local decoded = json.decode(message)

            if decoded.command == "exit" then
                log.info("Closing channel 54")
                modem.transmit(replyChannel, 54, "exiting")
                modem.close(54)
                shell.execute("reboot")
                shell.exit()
            elseif decoded.command == "exec" then
                local args = decoded.args
                local backup = args
                local first = args[1]
                table.remove(backup, 1)
                shell.execute(first, unpack(backup))
            elseif decoded.command == "set_name" then

            elseif decoded.command == "" then

            elseif decoded.command == "" then

            end
        end
    end
end

checkModem()
main()