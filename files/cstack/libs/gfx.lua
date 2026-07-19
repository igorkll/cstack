local gfx = {}

function gfx.isElementCollision(eventData, element, filter)
    if filter and not filter(element, eventData) then
        return false
    end
    return eventData[3] >= element.x and eventData[4] >= element.y and eventData[3] < (element.x + element.sizeX) and eventData[4] < (element.y + element.sizeY)
end

function gfx.getCollisionElement(eventData, elements, filter)
    for i, element in ipairs(elements) do
        if gfx.isElementCollision(eventData, element, filter) then
            return i, element
        end
    end
end

function gfx.moveToUp(elements, element)
    local index
    for i, v in ipairs(elements) do
        if v == element then
            index = i
            break
        end
    end

    if index then
        table.remove(elements, index)
        table.insert(elements, 1, element)
        return true
    end
    return false
end

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

function gfx.centeredText(x, y, sizeX, sizeY, back, fore, text)
    local rx, ry = term.getSize()
    gfx.fill(x, y, sizeX, sizeY, back)
    gfx.set(math.floor((x + sizeX / 2) - (#text / 2)), y + math.floor((sizeY - 1) / 2), back, fore, text)
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