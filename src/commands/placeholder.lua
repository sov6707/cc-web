--// A placeholder for the new command management system.

-- Locals

-- Functions

return {
    name = "placeholder",
    desc = "Placeholder command",
    func = function(...)
        local args = {...}
        print(unpack(args))
    end
}