local gthread = {}
gthread.threads = {}
gthread.mainthread = coroutine.running()

local function rawResume(th, ...)
    local _t = term.current()
    term.redirect(th.term or term.native())
    coroutine.resume(th.co, ...)
    term.redirect(_t)
end

function gthread.create(func, term, ...)
    local co = coroutine.create(func)
    local th = {
        co = co,
        term = term,
        args = {...}
    }

    table.insert(gthread.threads, th)
    rawResume(th, unpack(th.args))

    return th
end

local function resumeThreads(eventTbl)
    for i = #gthread.threads, 1, -1 do
        local th = gthread.threads[i]

        if coroutine.status(th.co) == "dead" then
            th.dead = true
            table.remove(i)
        else
            rawResume(th, "resume_thread", unpack(th.args))
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