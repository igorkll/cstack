local gui = {}

function gui.context(x, y, actions)
    local sizeX = 0
    local sizeY = #actions
    for i, action in ipairs(actions) do
        local title = action.title
        if #title > sizeX then
            sizeX = #title
        end
    end
    sizeX = sizeX + 2

    local function redraw()
        gfx.fill(x+1, y+1, sizeX, sizeY, colors.gray)
        gfx.fill(x, y, sizeX, sizeY, colors.white)
        for i, action in ipairs(actions) do
            gfx.set(x + 1, (y + i) - 1, colors.white, action.active and colors.black or colors.lightGray, action.title)
        end
    end
    redraw()

end

return gui