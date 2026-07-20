local args = {...}

local monitorName = args[1]

gthread.createMonitorProgram(monitorName, false, unpack(args, 2))
