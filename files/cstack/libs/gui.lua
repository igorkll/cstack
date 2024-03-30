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

return gui