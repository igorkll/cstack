local args = {...}

local monitorName = args[1]

gthread.createMonitorProgram(monitorName, true, unpack(args, 2))
