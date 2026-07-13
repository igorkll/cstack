local gthread = {}
gthread.threads = {}
gthread.mainthread = coroutine.running()

function gthread.create(func, ...)
    local co = coroutine.create(func)
    local th = {
        co = co,
        args = {...}
    }

    table.insert(gthread.threads, th)
    coroutine.resume(co, unpack(th.args))

    return th
end

local function resumeThreads(eventTbl)
    for i = #gthread.threads, 1, -1 do
        local th = gthread.threads[i]

        if coroutine.status(th.co) == "dead" then
            th.dead = true
            table.remove(i)
        else
            coroutine.resume("resume_thread", eventTbl)
        end
    end
end

local pullEventRaw = os.pullEventRaw
os.pullEventRaw = function(sFilter)
    while true do
        local eventTbl = {pcall(coroutine.yield)}
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