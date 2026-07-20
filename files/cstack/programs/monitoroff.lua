local args = {...}

local monitorName = args[1]

if not peripheral.wrap(monitorName) then
    print("Monitor not found!")
end

local threadNotFound = true

for i = #gthread.threads, 1, -1 do
    local th = gthread.threads[i]
    if th.monitorName == monitorName then
        gthread.kill(th.id)
        print("killing thread: " .. th.id)
        threadNotFound = false
        break
    end
end

if threadNotFound then
    print("there are no threads tied to the \"" .. monitorName .. "\" monitor")
end

print("clear monitor")
local monitorObj = peripheral.wrap(monitorName)
monitorObj.setCursorBlink(false)
monitorObj.clear()
