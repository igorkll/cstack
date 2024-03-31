if not term.isColor() then
    shell.run("/cstack/bsod.lua", "\"device is not supported\"", "\"screen is not colored\"")
end

local settingsFlag = "cstack.settingsApplied"
if not settings.get(settingsFlag, false) then
    settings.clear()
    settings.set("shell.allow_disk_startup", false)
    settings.set("shell.allow_startup", true)
    settings.set("bios.use_multishell", true)
    settings.set(settingsFlag, true)
    settings.save()
end

fs.makeDir("/cstackData")
shell.setDir("/cstackData")

local libsPath = "/cstack/libs"
for _, name in ipairs(fs.list(libsPath)) do
    name = name:sub(1, #name - 4)
    _G[name] = require(libsPath .. "/" .. name)
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