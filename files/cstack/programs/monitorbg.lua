local args = {...}

gthread.createProgram(args[2], peripheral.wrap(args[1]), unpack(args, 3))