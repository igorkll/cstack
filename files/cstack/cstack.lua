if not term.isColor() then
    shell.run("/cstack/bsod.lua", "\"device is not supported\"", "\"screen is not colored\"")
end

fs.makeDir("/cstackData")
shell.setDir("/cstackData")

local function loadLibs()
    local libsPath = "/cstack/libs"
    for _, name in ipairs(fs.list(libsPath)) do
        name = name:sub(1, #name - 4)
        _G[name] = require(libsPath .. "/" .. name)
    end
end

local function addProgramsPath(path)
    shell.setPath(shell.path() .. ":" .. path)
end

local function updateSettings()
    local settingsFlag = "cstack.settingsApplied"
    local settingsVersion = "cstack.settingsVersion"
    local currentVersion = cstack.getCurrentVersion()
    
    if not settings.get(settingsFlag, false) or
        settings.get(settingsVersion, -1) != currentVersion then
        settings.clear()
        settings.set("shell.allow_disk_startup", false)
        settings.set("shell.allow_startup", true)
        settings.set("bios.use_multishell", true)
        settings.set("list.show_hidden", true)
        settings.set(settingsFlag, true)
        settings.set(settingsVersion, currentVersion)
        settings.save()
        os.reboot()
    end
end

loadLibs()

updateSettings()

addProgramsPath("/cstack/programs")
if turtle then
    addProgramsPath("/cstack/programs/turtle")
end

shell.run("/cstack/shell.lua")
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
print("")
print("shell execution aborted.")
print("press enter to continue.")
while true do
    local eventData = {os.pullEventRaw()}
    if eventData[1] == "key" and eventData[2] == keys.enter then
        break
    end
end