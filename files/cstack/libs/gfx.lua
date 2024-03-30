local gfx = {}

function gfx.set(x, y, back, fore, text)
    term.setBackgroundColor(back)
    term.setTextColor(fore)
    term.setCursorPos(x, y)
    term.write(text)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end

return gfx