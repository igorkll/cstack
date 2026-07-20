local args = {...}

local monitorName = args[1]
local monitorObj = peripheral.wrap(monitorName)

local existsThread
for _, th in ipairs(gthread.threads) do
    if th.monitorName == monitorName then
        existsThread = th
        break
    end
end

if existsThread then
    existsThread.programEnv.shell.openTab(unpack(args, 2))
else
    local threadExt = {
        term = monitorObj,
        monitorName = monitorName
    }

    gthread.createProgram(threadExt, unpack(args, 2))
end
