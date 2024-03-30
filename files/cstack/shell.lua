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
        local index, element = gui.getCollisionElement(eventData, cstack.config.snippets)
        if element then
            if eventData[2] == 1 then
                if element.command then
                    shell.run(element.command)
                elseif element.file then
                    shell.openTab(element.file)
                end
            else
                local function setSnippedColor(obj)
                    element.color = colors[obj.title]
                    mathElements()
                    cstack.saveConfig()
                    return true
                end

                local function setSnippedSize(obj)
                    element.sizeX = obj.sizeX
                    element.sizeY = obj.sizeY
                    mathElements()
                    cstack.saveConfig()
                    return true
                end

                menu.context(eventData[3], eventData[4], {
                    {
                        title = "set title",
                        callback = function()
                            redraw()
                            element.title = menu.input("title", element.title) or element.title
                            mathElements()
                            cstack.saveConfig()
                            return true
                        end
                    },
                    {
                        title = "change size",
                        menu = {
                            {
                                title = "automatic",
                                callback = setSnippedSize
                            },
                            {
                                sizeX = 8,
                                sizeY = 2,
                                title = "8x2",
                                callback = setSnippedSize
                            },
                            {
                                sizeX = 8,
                                sizeY = 3,
                                title = "8x3",
                                callback = setSnippedSize
                            },
                            {
                                sizeX = 8,
                                sizeY = 5,
                                title = "8x5",
                                callback = setSnippedSize
                            },
                            {
                                sizeX = 16,
                                sizeY = 8,
                                title = "16x8",
                                callback = setSnippedSize
                            }
                        }
                    },
                    {
                        title = "change color",
                        menu = {
                            {
                                title = "red",
                                callback = setSnippedColor
                            },
                            {
                                title = "orange",
                                callback = setSnippedColor
                            },
                            {
                                title = "green",
                                callback = setSnippedColor
                            },
                            {
                                title = "blue",
                                callback = setSnippedColor
                            }
                        }
                    },
                    {
                        title = "delete",
                        callback = function()
                            table.remove(cstack.config.snippets, index)
                            return true
                        end
                    }
                })
            end
        elseif eventData[2] == 2 then
            menu.context(eventData[3], eventData[4], {
                {
                    title = "create command snipped",
                    
                    callback = function()
                        table.insert(cstack.config.snippets, {x = eventData[3], y = eventData[4], title = "untitled"})
                        mathElements()
                        cstack.saveConfig()
                        return true
                    end
                },
                {
                    title = "create code snipped",
                    
                    callback = function()
                        
                    end
                }
            })
        end
        redraw()
    end
end