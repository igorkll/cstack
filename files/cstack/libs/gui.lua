local gui = {}

function gui.context(x, y, actions)
    local sizeX = 0
    local sizeY = #actions
    for i, action in ipairs(actions) do
        local str = actions.str
        if #str > sizeX then
            sizeX = #str
        end
    end
    sizeX = sizeX + 3

    paintutils.drawFilledBox(x, y, sizeX + 1, sizeY + 1, colors.gray)
    paintutils.drawFilledBox(x, y, sizeX, sizeY, colors.white)
end

return gui