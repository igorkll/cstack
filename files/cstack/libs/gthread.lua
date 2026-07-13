local gthread = {}
gthread.threads = {}
gthread.mainthread = coroutine.running()

local function rawResume(th, ...)
    local _t = term.current()
    term.redirect(th.term or term.native())
    th.lastCoReturn = {coroutine.resume(th.co, ...)}
    term.redirect(_t)
end

local idCounter = 0

function gthread.create(func, term, ...)
    local co = coroutine.create(func)
    local th = {
        id = idCounter,
        co = co,
        term = term,
        args = {...}
    }

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
        end

        if not th.dead then
            rawResume(th, "resume_thread", eventTbl)

            if coroutine.status(th.co) == "dead" then
                th.dead = true
                th.deadReason = th.lastCoReturn
            end
        end
    end
end

local pullEventRaw = os.pullEventRaw
os.pullEventRaw = function(sFilter)
    while true do
        local eventTbl = {coroutine.yield()}
        if eventTbl[1] == "resume_thread" then
            eventTbl = eventTbl[2] --значит прилетел как продолжение потока, не разпостроняем
        else
            resumeThreads(eventTbl) --значит эвент прилетел с computercraft, разпостроняем его по потокам
        end

        if not sFilter or eventTbl[1] == sFilter then
            return unpack(eventTbl)
        end
    end
end

return gthread