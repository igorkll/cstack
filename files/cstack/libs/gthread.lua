local gthread = {}
gthread.threads = {}
gthread.mainthread = coroutine.running()

local directNamesList = {
    "top",
    "bottom",
    "left",
    "right",
    "back",
    "front"
}

--если монитор или клавиатура подключены напрямую к ПК то событие пройдет
--если оба подключены через модем, то индекс должен быть одинаковым
local function isKeyboardEventToMonitor(monitorName, keyboardName)
    for _, directName in ipairs(directNamesList) do
        if directName == monitorName or directName == keyboardName then
            return true
        end
    end

    local monitorIndex = text.split(string, monitorName, "_")
    monitorIndex = monitorIndex[#monitorIndex]

    local keyboardIndex = text.split(string, keyboardName, "_")
    keyboardIndex = keyboardIndex[#keyboardIndex]

    if monitorIndex == keyboardIndex then
        return true
    end

    return false
end

local tmKeyboardPrefix = "tm_keyboard_"

local function prepairEvent(th, eventTbl)
    if th.hookMonitorTouch then
        if eventTbl[1] == "mouse_scroll" or
        eventTbl[1] == "mouse_drag" or
        eventTbl[1] == "mouse_up" or
        eventTbl[1] == "mouse_click" or
        eventTbl[1] == "term_resize" then
            return {}
        elseif eventTbl[1] == "monitor_touch" then
            if eventTbl[2] == th.monitorName then
                return {
                    {"mouse_click", 1, eventTbl[3], eventTbl[4]},
                    {"mouse_up", 1, eventTbl[3], eventTbl[4]}
                }
            end
        elseif eventTbl[1] == "monitor_resize" then
            if eventTbl[2] == th.monitorName then
                return {
                    {"term_resize"}
                }
            end
        end
    end

    if th.hookKeyboard then
        if eventTbl[1] == "char" or
        eventTbl[1] == "key" or
        eventTbl[1] == "key_up" then
            return {}
        elseif text.startwith(string, eventTbl[1], tmKeyboardPrefix) then
            if isKeyboardEventToMonitor(th.monitorName, eventTbl[2]) then
                return {
                    {string.sub(eventTbl[1], #tmKeyboardPrefix + 1, #eventTbl[1]), unpack(eventTbl, 3)},
                }
            end
        end
    end

    return {eventTbl}
end

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
            local resumeEvents = prepairEvent(th, eventTbl)
            for _, resumeEvent in ipairs(resumeEvents) do
                local coReturn = rawResume(th, unpack(resumeEvent))

                if coroutine.status(th.co) == "dead" then
                    th.dead = true
                    th.deadReason = coReturn
                    break
                end
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

        if eventTbl[1] and not sFilter or eventTbl[1] == sFilter then
            return unpack(eventTbl)
        end
    end
end

return gthread