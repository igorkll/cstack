local args = {...}

local monitorName = args[1]
local monitorObj = peripheral.wrap(monitorName)

local threadExt = {
    term = monitorObj,
    monitorName = monitorName
}

gthread.createProgram(threadExt, unpack(args, 2))