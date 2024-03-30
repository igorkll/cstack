local settingsFlag = "cstack.settingsApplied"
if not settings.get(settingsFlag, false) then
    settings.clear()
    settings.set("shell.allow_disk_startup", false)
    settings.set("shell.allow_startup", true)
    settings.set("bios.use_multishell", true)
    settings.set(settingsFlag, true)
    settings.save()
end

shell.run("/cstack/shell.lua")
print("shell execution aborted.")
print("press enter to continue.")
while true do
    local eventData = {os.pullEvent()}
    if eventData[1] == "key" and eventData[2] == keys.enter then
        break
    end
end