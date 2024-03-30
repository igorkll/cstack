local gui = {}

function gui.context(x, y, actions)
    local selected
    local holded = false
    local sizeX = 0
    local sizeY = #actions
    for i, action in ipairs(actions) do
        if type(action) == "table" then
            local title = action.title
            if #title > sizeX then
                sizeX = #title
            end
        end
    end
    sizeX = sizeX + 2

    local function redraw()
        gfx.fill(x+1, y+1, sizeX, sizeY, colors.gray)
        for i, action in ipairs(actions) do
            if action == true then
                gfx.fill(x, (y + i) - 1, sizeX, 1, colors.white, colors.lightGray, "-")
            else
                if i == selected then
                    gfx.fill(x, (y + i) - 1, sizeX, 1, colors.blue)
                    gfx.set(x + 1, (y + i) - 1, colors.blue, colors.white, action.title)
                else
                    gfx.fill(x, (y + i) - 1, sizeX, 1, colors.white)
                    gfx.set(x + 1, (y + i) - 1, colors.white, action.active and colors.black or colors.lightGray, action.title)
                end
            end
        end
    end
    redraw()

    while true do
        local eventData = {os.pullEvent()}
        local isClick = eventData[1] == "mouse_click"
        if isClick or eventData[1] == "mouse_drag" then
            selected = nil
            holded = false
            local newSelected = (eventData[4] - y) + 1
            if eventData[3] >= x and eventData[3] < x + sizeX then
                if newSelected >= 1 and newSelected <= #actions then
                    holded = true
                    if type(actions[newSelected]) == "table" and actions[newSelected].active then
                        selected = newSelected
                    end
                elseif isClick then
                    break
                end
            elseif isClick then
                break
            end
            redraw()
        elseif eventData[1] == "mouse_up" then
            if selected then
                if type(actions[selected]) == "table" and actions[selected].callback then
                    actions[selected].callback()
                end
                return selected
            end
        end
    end
end

return gui