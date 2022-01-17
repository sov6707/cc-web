local c_id = os.getComputerID()
local version = os.version()

log = require "log"
json = require "json"
log.usecolor = false
log.outfile = "logs.txt"

local modem_loc = ""

local function input(inp)
    io.write(inp)
    local read = io.read()
    return read
end

local function split_str(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
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
    modem.open(56) -- recieving returned messages

    coroutine.wrap(function ()
        while true do 
            local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
            
            -- TODOO: Code does not work, dont know why tho 
            if channel == 56 then
                log.info("Received a reply: " .. tostring(message) .. (" (%s)"):format(replyChannel))
            end
        end
    end)

    while true do 
        local command = input("> ")
        local split = split_str(command, " ")
        local firstpart = split[1]
        
        if firstpart == "exit" then
            local returned = json.encode({ command = "exit" })
            modem.transmit(54, 56, returned)
            print("Sent command: " .. command)
        elseif firstpart == "exec" then
            local backup = split
            table.remove(backup, 1)
            local returned = json.encode({ command = "exec", args = {unpack(backup)} })
            modem.transmit(54, 56, returned)
        elseif firstpart == "clear" then
            shell.execute("clear", "all")
        elseif firstpart == "info" then
            local returned = json.encode({ command = "info" })
            modem.transmit(54, 56, returned)
        elseif firstpart == "exec_lua" then
            local returned = json.encode({ command = "exec_lua", code = split[2] })
            modem.transmit(54, 56, returned)
        elseif firstpart == "close" then
            modem.close(tonumber(split[2]))
            print("Closed channel: " .. split[2])
        elseif firstpart == "open" then
            modem.open(tonumber(split[2]))
            print("Opened channel: " .. split[2])
        else
            print("Command" .. command .. " does not exist")
        end


    end
end

checkModem()
main()