local settingsFlag = "cstack.settingsApplied"
if not settings.get(settingsFlag, false) then
    settings.clear()
    settings.set("shell.allow_disk_startup", false)
    settings.set("shell.allow_startup", true)
    settings.set("bios.use_multishell", true)
    settings.set(settingsFlag, true)
    settings.save()
end