
function ask(message)
    io.write(message)
    local read = io.read()
    return read
end

local cock = io.open("what.txt", "w")
cock:write('1')

local f = coroutine.create(function()
    local n = 0
    
    cock:write("dick")
    cock:write("dick")
    cock:write("dick")
    cock:write("dick")
    cock:write("dick")
end)


while true do
    local x = ask("hi: ")
    print(x)    
end


coroutine.resume(f)
