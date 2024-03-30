local code, err = loadfile("/cstack/cstack.lua")
if code then
    local ok, err = xpcall(code, debug.traceback)
    if not ok then
        shell.run("/cstack/bsod.lua", "system error (cstack.lua)", tostring(err))
    end
else
    shell.run("/cstack/bsod.lua", "\"syntax error (cstack.lua)\"", "\"" .. tostring(err) .. "\"")
end
shell.run("/cstack/bsod.lua", "\"unexpected system shutdown\" \"\"")
os.reboot()