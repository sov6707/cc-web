local ccweb = {loaded_commands = {}, util = {}}

function ccweb:start(self, ...)
    -- setup env
    if shell then 
        _G.os.execute = shell.execute 
    end

    -- setup libraries
    ccweb.util = {
        log = require("lib.log"),
        json = require("lib.json"),
        modem = require("lib.modem"),
        monitor = require("lib.monitor"),
        config = require("lib.config"),
        string = require("lib.string"),
        input = require("lib.input"),
    }

    -- setup commands
    for i,v in pairs(self) do
        local command = require(v)
        ccweb.loaded_commands[command.name] = command
    end

    -- setup modem's
    local modems = ccweb.util.modem:getModems()

    if #modems >= 1 then
        local chosen = ccweb.util.input.choose(modems, "Available modems\n", "Choose modem: ")
        ccweb.util.modem.wrapped = peripheral.wrap(chosen)
    end

    --// TODO: use the config file for channel numbers
    -- Open needed channels
    local modem = ccweb.util.modem
    modem:open(56) -- main channel, reserved
    modem:open(57) -- recieving channel

    print("Setting up listeners for channel 56 and channel 57")

    modem:listen(56, function(event, side, channel, replyChannel, message, distance) 
        print(("[CHANNEL 56] Recieved a reply: %s (%s) (%s)"):format(message, channel, distance))
    end)
    print("Set up channel 56")

    modem:listen(57, function(event, side, channel, replyChannel, message, distance) 
        print(("[CHANNEL 57] Recieved a reply: %s (%s) (%s)"):format(message, channel, distance))
        local f = io.open("fuck.txt", "w")
        f:write(("[CHANNEL 56] Recieved a reply: %s (%s) (%s)"):format(message, channel, distance))
        f:close()
    end)
    print("Set up channel 57")

    --// TODO: Make this work
    -- Setup command parsing
    
    -- Finalize
    print("Done setting up cc-web")

    while true do
        local choice = ccweb.util.input.ask("> ")

        print(choice)
    end
end

ccweb:start({
    "commands.placeholder"
})