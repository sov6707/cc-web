local input = {}

function input.ask(message)
    io.write(message)
    local read = io.read()
    return read
end

function input.choose(object, message_available, message_choose)
    local chosen = nil
    if #object >= 1 then
        io.write(message_available)
        for i,v in pairs(object) do
            print("\t- ".. i ..". " .. v)
        end
        io.write(message_choose)
        read = io.read()
        chosen = object[tonumber(read)]
    end
    return chosen
end

return input