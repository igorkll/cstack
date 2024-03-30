multishell.setTitle(multishell.getCurrent(), "cstack")

local function mathElements()
    for _, snippet in ipairs(cstack.config.snippets) do
        snippet.sizeX = snippet.sizeX or (#(snippet.title or "") + 2)
        snippet.sizeY = snippet.sizeY or 2
        snippet.color = snippet.color or colors.orange
        snippet.textcolor = snippet.textcolor or colors.white
    end
end

local function redraw()
    term.clear(colors.black)

    for _, snippet in ipairs(cstack.config.snippets) do
        local textColor = snippet.textcolor
        if snippet.color == textColor then
            textColor = colors.black
        end
        gfx.fill(snippet.x, snippet.y, snippet.sizeX, snippet.sizeY, snippet.color, textColor)
        gfx.set(snippet.x + 1, snippet.y, snippet.color, textColor, snippet.title)
    end

    gfx.set(1, 1, colors.red, colors.white, "cstackOS")
end

mathElements()
redraw()

while true do
    local eventData = {os.pullEvent()}
    if eventData[1] == "terminate" then
        os.shutdown()
    elseif eventData[1] == "mouse_click" then
        local _, element = gui.getCollisionElement(eventData, cstack.config.snippets)
        if element then
            if eventData[2] == 1 then
                if element.command then
                    shell.run(element.command)
                elseif element.file then
                    shell.openTab(element.file)
                end
            else
                menu.context(eventData[3], eventData[4], {
                    {
                        title = "change snipped size",
                        active = true,
                        callback = function()
                            table.insert(cstack.config.snippets, {x = eventData[3], y = eventData[4], title = "untitled"})
                            mathElements()
                            cstack.saveConfig()
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
        elseif eventData[2] == 2 then
            menu.context(eventData[3], eventData[4], {
                {
                    title = "create command snipped",
                    active = true,
                    callback = function()
                        table.insert(cstack.config.snippets, {x = eventData[3], y = eventData[4], title = "untitled"})
                        mathElements()
                        cstack.saveConfig()
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