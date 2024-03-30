--------------------------------------- check script location

local function getSelfScriptPath()
    for runLevel = 0, math.huge do
        local info = debug.getinfo(runLevel)

        if info then
            if info.what == "main" then
                return info.source:sub(2, -1)
            end
        else
            error("Failed to get debug info for runlevel " .. runLevel)
        end
    end
end

local selfScriptPath = getSelfScriptPath()
if selfScriptPath ~= "/startup.lua" then
    print("cstack cannot be launched from here: ", selfScriptPath)
    return
end

--------------------------------------- run cstack
term.clear()
term.setCursorPos(1, 1)
shell.run("/cstack/startup.lua")