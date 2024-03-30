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
        menu.centerPrint(2, " " .. title .. " ")
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
            if pointer == #strs + 1 then
                menu.invertColors()
                menu.drawSelector(menu.sizeY() - 1)
                menu.centerPrint(menu.sizeY() - 1, backTitle or "back")
                menu.invertColors()
            else
                menu.centerPrint(menu.sizeY() - 1, backTitle or "back")
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

return menu