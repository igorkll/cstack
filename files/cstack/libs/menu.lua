local menu = {}
menu.sep = string.rep(" ", 16)

function menu.sizeX()
    return (term.getSize())
end

function menu.sizeY()
    return (select(2, term.getSize()))
end

function menu.centerPrint(y, text)
    term.setCursorPos(((menu.sizeX() / 2) - (#text / 2)) + 1, y)
    term.write(text)
end

function menu.drawSelector(y)
    menu.centerPrint(y, menu.sep)
end

function menu.defaultColors()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end

function menu.invertColors()
    local bg, fg = term.getBackgroundColor(), term.getTextColor()
    term.setBackgroundColor(fg)
    term.setTextColor(bg)
end

function menu.menu(title, strs, callbacks, backTitle)
    local pointer = 1
    local textColor = term.getTextColor()

    local function redraw()
        term.clear()
        menu.invertColors()
        menu.drawSelector(2)
        menu.centerPrint(2, title)
        menu.invertColors()

        for i, str in ipairs(strs) do
            if pointer == i then
                menu.invertColors()
                menu.drawSelector(i + 3)
                menu.centerPrint(i + 3, str)
                menu.invertColors()
            else
                menu.centerPrint(i + 3, str)
            end
        end

        if backTitle ~= true then
            term.setTextColor(colors.red)
            local str = backTitle or "back"
            if pointer == #strs + 1 then
                menu.invertColors()
                menu.drawSelector(menu.sizeY() - 1)
                menu.centerPrint(menu.sizeY() - 1, str)
                menu.invertColors()
            else
                menu.centerPrint(menu.sizeY() - 1, str)
            end
            term.setTextColor(textColor)
        end
    end
    redraw()

    while true do
        local eventData = {os.pullEvent()}
        if eventData[1] == "key" then
            if eventData[2] == keys.up then
                pointer = pointer - 1
                if pointer < 1 then
                    pointer = 1
                else
                    redraw()
                end
            elseif eventData[2] == keys.down then
                pointer = pointer + 1
                if backTitle ~= true then
                    if pointer > #strs + 1 then
                        pointer = #strs + 1
                    else
                        redraw()
                    end
                else
                    if pointer > #strs then
                        pointer = #strs
                    else
                        redraw()
                    end
                end
            elseif eventData[2] == keys.enter then
                if pointer == #strs + 1 then
                    break
                elseif callbacks[pointer] then
                    callbacks[pointer]()
                    redraw()
                end
            end
        end
    end
end

function menu.context(x, y, actions)
    local selected
    local holded = false
    local sizeX = 0
    local sizeY = #actions
    for i, action in ipairs(actions) do
        if type(action) == "table" then
            local title = action.title
            if #title > sizeX then
                sizeX = #title
            end
        end
    end
    sizeX = sizeX + 2

    x = math.min(x, (menu.sizeX() - sizeX) + 1)
    y = math.min(y, (menu.sizeY() - sizeY) + 1)

    local function redraw()
        gfx.fill(x+1, y+1, sizeX, sizeY, colors.gray)
        for i, action in ipairs(actions) do
            if action == true then
                gfx.fill(x, (y + i) - 1, sizeX, 1, colors.white, colors.lightGray, "-")
            else
                if i == selected then
                    gfx.fill(x, (y + i) - 1, sizeX, 1, colors.blue)
                    gfx.set(x + 1, (y + i) - 1, colors.blue, colors.white, action.title)
                else
                    gfx.fill(x, (y + i) - 1, sizeX, 1, colors.white)
                    gfx.set(x + 1, (y + i) - 1, colors.white, action.active and colors.black or colors.lightGray, action.title)
                end
            end
        end
    end
    redraw()

    while true do
        local eventData = {os.pullEvent()}
        local isClick = eventData[1] == "mouse_click"
        if isClick or eventData[1] == "mouse_drag" then
            selected = nil
            holded = false
            local newSelected = (eventData[4] - y) + 1
            if eventData[3] >= x and eventData[3] < x + sizeX then
                if newSelected >= 1 and newSelected <= #actions then
                    if eventData[2] == 1 then
                        holded = true
                        if type(actions[newSelected]) == "table" and actions[newSelected].active then
                            selected = newSelected
                        end
                    elseif isClick then
                        os.queueEvent(unpack(eventData))
                        break
                    end
                elseif isClick then
                    os.queueEvent(unpack(eventData))
                    break
                end
            elseif isClick then
                os.queueEvent(unpack(eventData))
                break
            end
            redraw()
        elseif eventData[1] == "mouse_up" then
            if selected then
                if type(actions[selected]) == "table" and actions[selected].callback then
                    actions[selected].callback()
                end
                return selected
            end
        end
    end
end

function menu.mathZoneBox(sizeX, sizeY)
    return math.floor((menu.sizeX() / 2) - (sizeX / 2)) + 1, math.floor((menu.sizeY() / 2) - (sizeY / 2)) + 1, sizeX, sizeY
end

function menu.drawZoneBox(sizeX, sizeY, color)
    local x, y = menu.mathZoneBox(sizeX, sizeY)
    gfx.fill(x, y, sizeX, sizeY, color or colors.gray)
    return x, y, sizeX, sizeY
end

function menu.input(title, default, hiddenChar)
    local x, y, sizeX, sizeY = menu.drawZoneBox(32, 4)
    local closeButtonX = (x + sizeX) - 3
    gfx.set(closeButtonX, y, colors.red, colors.white, " X ")
    menu.defaultColors()
    menu.centerPrint(y, title or "input")
    local readWindow = window.create(term.native(), x + 2, y + 2, sizeX - 4, 1)
    term.redirect(readWindow)
    if default then
        os.queueEvent("paste", tostring(default))
    end
    if hiddenChar and type(hiddenChar) ~= "string" then
        hiddenChar = "*"
    end

    local inputResult
    parallel.waitForAny(function ()
        local ok, input = pcall(read, hiddenChar)
        if ok then
            inputResult = input
        end
    end, function ()
        while true do
            local eventData = {os.pullEventRaw()}
            if eventData[1] == "mouse_click" then
                if eventData[4] == y and eventData[3] >= closeButtonX and eventData[3] < (x + sizeX) then
                    break
                end
            end
        end
    end)

    term.redirect(term.native())
    menu.defaultColors()
    return inputResult
end

return menu