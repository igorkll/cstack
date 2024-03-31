local gui = {}

function gui.isElementCollision(eventData, element)
    return eventData[3] >= element.x and eventData[4] >= element.y and eventData[3] < (element.x + element.sizeX) and eventData[4] < (element.y + element.sizeY)
end

function gui.getCollisionElement(eventData, elements)
    for i, element in ipairs(elements) do
        if gui.isElementCollision(eventData, element) then
            return i, element
        end
    end
end

function gui.moveToUp(elements, element)
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

return gui