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
    print("liked cannot be launched from here: ", selfScriptPath)
    return
end

--------------------------------------- apply settings

local settingsFlag = "cstack.settingsApplied"
if not settings.get(settingsFlag, false) then
    settings.clear()
    settings.set("shell.allow_disk_startup", false)
    settings.set("shell.allow_startup", true)
    settings.set("bios.use_multishell", true)
    settings.set(settingsFlag, true)
    settings.save()
end

--------------------------------------- try start

shell.run("/cstack/shell.lua")