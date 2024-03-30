local gui = {}

function gui.context(x, y, actions)
    local selected
    local holded = false
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
            if i == selected then
                gfx.set(x + 1, (y + i) - 1, colors.blue, colors.white, action.title)
            else
                gfx.set(x + 1, (y + i) - 1, colors.white, action.active and colors.black or colors.lightGray, action.title)
            end
        end
    end
    redraw()

    while true do
        local eventData = {os.pullEvent()}
        if eventData[1] == "mouse_click" or eventData[1] == "mouse_drag" then
            selected = nil
            holded = false
            local newSelected = (eventData[4] - y) + 1
            if eventData[3] >= x and eventData[3] < x + sizeX then
                if newSelected >= 1 and newSelected <= #actions then
                    holded = false
                    if actions[newSelected].active then
                        selected = newSelected
                    end
                end
            end
        elseif eventData[1] == "mouse_up" then
            if holded then
                if selected then
                    if actions[selected].callback then
                        actions[selected].callback()
                    end
                    return selected
                end
            else
                break
            end
        end
    end
end

return gui