local args = {...}

local monitorName = args[1]
local monitorObj = peripheral.wrap(monitorName)

local threadExt = {
    term = monitorObj
}

gthread.createProgram(threadExt, unpack(args, 2))