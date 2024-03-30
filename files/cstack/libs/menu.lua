local menu = {}

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

function menu.defaultColors()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end

function menu.invertColors()
    local bg, fg = term.getBackgroundColor(), term.getTextColor()
    term.setBackgroundColor(fg)
    term.setTextColor(bg)
end

function menu.menu(title, strs, callbacks)
    term.clear()
    menu.centerPrint(2, title)
    for i, str in ipairs(strs) do
        menu.centerPrint(i + 3, str)
    end
end

return menu