local git_url = "https://raw.githubusercontent.com/rustysov/cc-web/main/src/"

local function download(file, dest)
    local request = http.get(git_url .. file)
    local content = request.readAll()

    local f = io.open(dest, "w")
    f:write(content)
    f:close()
    print("Downloaded: " .. file)
end

local to_download = {
    "main/json.lua",
    "main/log.lua",
    "main/client.lua",
    "main/host.lua",
}

print("being reworked")

--[[
for i, v in pairs(to_download) do
    download(v, "cc-web/" .. v:gsub("main/", ""))
end
]]