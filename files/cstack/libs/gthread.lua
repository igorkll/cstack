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
            coroutine.resume(eventTbl)
        end
    end
end

local pullEventRaw = os.pullEventRaw
os.pullEventRaw = function(sFilter)
    while true do
        local eventTbl
        if coroutine.running() == gthread.mainthread then
            eventTbl = {pcall(pullEventRaw)}
            resumeThreads(eventTbl)
        else
            eventTbl = coroutine.yield()
        end

        if eventTbl[1] then
            if not sFilter or eventTbl[2] == sFilter then
                return unpack(eventTbl, 2)
            end
        else
            error(eventTbl[2], 2) -- для правильного положение ошибки относительно родительской функции, level ставлю на 2
        end
    end
end

return gthread