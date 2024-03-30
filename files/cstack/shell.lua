multishell.setTitle(multishell.getCurrent(), "cstack")
shell.openTab("worm")

local function mathElements()
    for _, snippet in ipairs(cstack.config.snippets) do
        snippet.sizeX = snippet.sizeX or (#(snippet.title) + 2)
        snippet.sizeY = snippet.sizeY or 2
    end
end

local function redraw()
    term.clear(colors.black)

    for _, snippet in ipairs(cstack.config.snippets) do
        local textColor = colors.white
        if snippet.color == textColor then
            textColor = colors.black
        end
        gfx.fill(snippet.x, snippet.y, snippet.sizeX, snippet.sizeY, snippet.color, textColor)
        gfx.set(snippet.x + 1, snippet.y, snippet.color, textColor, snippet.title)
    end

    gfx.set(1, 1, colors.red, colors.white, "cstackOS")
end
redraw()

while true do
    local eventData = {os.pullEvent()}
    if eventData[1] == "terminate" then
        os.shutdown()
    elseif eventData[1] == "mouse_click" then
        local _, element = gui.getCollisionElement(eventData, cstack.config.snippets)
        if element then
            if element.command then
                shell.run(element.command)
            elseif element.file then
                shell.openTab(element.file)
            end
        else
            menu.context(eventData[3], eventData[4], {
                {
                    title = "create command snipped",
                    active = true,
                    callback = function()
                        
                    end
                },
                {
                    title = "create code snipped",
                    active = true,
                    callback = function()
                        
                    end
                }
            })
        end
        redraw()
    end
end