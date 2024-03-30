local code, err = loadfile("/cstack/cstack.lua")
if not code then
    local ok, err = xpcall(code, debug.traceback)
    if not ok then
        shell.run("/cstack/bsod.lua", "system error (cstack.lua)", tostring(err))
    end
else
    shell.run("/cstack/bsod.lua", "syntax error (cstack.lua)", tostring(err))
    os.reboot()
end