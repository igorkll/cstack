local menu = {}

function menu.sizeX()
    return (term.getSize())
end

function menu.sizeY()
    return (select(2, term.getSize()))
end

function menu.centerPrint(y, text)
    term.setCursorPos((menu.sizeX() / 2) - (#text / 2), y)
end

function menu.defaultColors()
    term.setBackgroundColor(colors.black)
    term.setForegroundColor(colors.white)
end

function menu.menu(title, callbacks)
    menu.defaultColors()
    menu.centerPrint(2, title)
end

return menu