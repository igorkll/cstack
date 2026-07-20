local gthread = {}
gthread.threads = {}
gthread.mainthread = coroutine.running()

local function rawResume(th, ...)
    local _t = term.current()
    term.redirect(th.term or term.native())
    local coReturn = {coroutine.resume(th.co, ...)}
    term.redirect(_t)
    return coReturn
end

local idCounter = 0

function gthread.createProgram(ext, ...) --WITH MULTISHELL SUPPORT!!!
    local programEnv = {shell = shell}

    local th = gthread.create(function(...)
        os.run(programEnv, cstack.multishellPath, ...)
    end, ext, ...)
    th.programEnv = programEnv

    return th
end

function gthread.create(func, ext, ...)
    --[[
        ext: {
            term = monitorOrOtherTerminal
        }
    ]]

    local co = coroutine.create(func)
    local th = {
        id = idCounter,
        co = co,
        args = {...}
    }

    if ext then
        for k, v in pairs(ext) do
            th[k] = v
        end
    end

    idCounter = idCounter + 1

    table.insert(gthread.threads, th)
    rawResume(th, unpack(th.args))

    return th
end

function gthread.kill(id)
    for i = #gthread.threads, 1, -1 do
        local th = gthread.threads[i]

        if th.id == id then
            table.remove(gthread.threads, i)
        end
    end
end

local function resumeThreads(eventTbl)
    for i = #gthread.threads, 1, -1 do
        local th = gthread.threads[i]

        if th.dead then
            table.remove(gthread.threads, i)
        else
            local coReturn = rawResume(th, unpack(eventTbl))

            if coroutine.status(th.co) == "dead" then
                th.dead = true
                th.deadReason = coReturn
            end
        end
    end
end

local mainCoroutine = coroutine.running()
os.pullEventRaw = function(sFilter)
    while true do
        local eventTbl = {coroutine.yield()}
        if coroutine.running() == mainCoroutine then
            resumeThreads(eventTbl) --значит эвент прилетел с computercraft, разпостроняем его по потокам
        end

        if not sFilter or eventTbl[1] == sFilter then
            return unpack(eventTbl)
        end
    end
end

return gthread