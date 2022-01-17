-- TODO: work on this
local modem = {wrapped = nil}

function modem:getModems(name)
    local tPeripherals = peripheral.getNames()
    local tModems = {}

    if #tPeripherals > 0 then
        for n = 1, #tPeripherals do
            local sPeripheral = tPeripherals[n]
            local tPeripheral = peripheral.getType(sPeripheral)
            if tPeripheral == "modem" then
                tModems[n] = sPeripheral
            end
        end
    end

    return tModems
end

function modem:getByFace(face)
    if peripheral.getType(face) == "modem" then
        local wrapped = peripheral.wrap(face)
        return wrapped
    else
        return nil
    end
end

function modem:set(face)
    if peripheral.getType(face) == "modem" then
        local wrapped = peripheral.wrap(face)
        modem.wrapped = wrapped
    else
        return nil
    end
end

function modem:open(self, channel, ...)
    local v, _ = pcall(function()
        modem.wrapped.open(channel)
    end) 
    return v
end

function modem:close(self, channel)
    local v, _ = pcall(function()
        modem.wrapped.close(channel)
    end)
    return v
end

function modem:send(self, channel, replyChannel, message)
    local v, _ = pcall(function()
        modem.wrapped.transmit(channel, replyChannel, message)
    end)
    return v
end

function modem:listen(self, needed_channel, func, ...)
    local f = coroutine.create(function()
        print(1)
        while self.wrapped.isOpen(needed_channel) do
            local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
            if channel == needed_channel then
                func(event, side, channel, replyChannel, message, distance)
            end
        end
    end)
    
    coroutine.resume(f)

    return f
end

return modem