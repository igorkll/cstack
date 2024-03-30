local gfx = {}

function gfx.set(x, y, back, fore, text)
    term.setBackgroundColor(back)
    term.setTextColor(fore)
    term.setCursorPos(x, y)
    term.write(text)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end

function gfx.fill(x, y, sizeX, sizeY, back, fore, char)
    term.setBackgroundColor(back)
    if fore then
        term.setTextColor(fore)
    end
    for ix = x, (x + sizeX) - 1 do
        for iy = y, (y + sizeY) - 1 do
            term.setCursorPos(ix, iy)
            term.write(char or " ")
        end
    end
    term.setBackgroundColor(colors.black)
    term.setBackgroundColor(colors.white)
end

--[[
function gfx.copy(x, y, sizeX, sizeY)
    local dump = {sizeX = sizeX, sizeY = sizeY}
    for ix = x, sizeX do
        for iy = y, sizeY do
            
        end
    end
    return dump
end

function gfx.paste(x, y, dump)
    
end

function gfx.dump(x, y, sizeX, sizeY)
    local screenshot = gfx.copy(x, y, sizeX, sizeY)
    return function ()
        gfx.paste(x, y, screenshot)
    end
end
]]

return gfx