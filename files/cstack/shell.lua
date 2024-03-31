multishell.setTitle(multishell.getCurrent(), "cstack")

local currentPage = 0
local selectedSnippedX, selectedSnippedY, selectedSnipped

local function getPageInfo()
    if cstack.config.pageinfo[currentPage] then
        return cstack.config.pageinfo[currentPage]
    end
    return {}
end

local function mathElements()
    for _, snippet in ipairs(cstack.config.snippets) do
        snippet.page = snippet.page or currentPage
        snippet.sizeX = snippet.sizeX or (#(snippet.title or "") + 2)
        snippet.sizeY = snippet.sizeY or 2
        snippet.color = snippet.color or colors.orange
        snippet.textcolor = snippet.textcolor or colors.white
    end
end

local function redraw()
    term.clear(colors.black)

    for i = #cstack.config.snippets, 1, -1 do
        local snippet = cstack.config.snippets[i]
        if snippet.page == currentPage then
            local textColor = snippet.textcolor
            if snippet.color == textColor then
                textColor = colors.black
            end
            gfx.centeredText(snippet.x, snippet.y, snippet.sizeX, snippet.sizeY, snippet.color, textColor, snippet.title:sub(1, snippet.sizeX - 2))
        end
    end
end

local function save()
    mathElements()
    cstack.saveConfig()
    redraw()
end

mathElements()
redraw()

while true do
    local eventData = {os.pullEvent()}
    if eventData[1] == "terminate" then
        os.shutdown()
    elseif eventData[1] == "mouse_drag" then
        if selectedSnipped and eventData[2] == 3 then
            local x, y = eventData[3], eventData[4]
            local dx, dy = x - selectedSnippedX, y - selectedSnippedY
            selectedSnipped.x = selectedSnipped.x + dx
            selectedSnipped.y = selectedSnipped.y + dy
            selectedSnippedX, selectedSnippedY = x, y
            save()
        end
    elseif eventData[1] == "mouse_click" then
        local index, element = gui.getCollisionElement(eventData, cstack.config.snippets)
        if element and element.page == currentPage then
            if eventData[2] == 1 then
                if element.command then
                    term.setCursorPos(1, 1)
                    menu.defaultColors()
                    term.clear()
                    shell.run(element.command)
                    term.setCursorBlink(false)
                elseif element.file then
                    shell.openTab(element.file)
                end
            elseif eventData[2] == 2 then
                local function setSnippedColor(obj)
                    element.color = colors[obj.title]
                    save()
                    return true
                end

                local function setSnippedSize(obj)
                    element.sizeX = obj.sizeX
                    element.sizeY = obj.sizeY
                    save()
                    return true
                end

                menu.context(eventData[3], eventData[4], {
                    redrawCallback = redraw,
                    {
                        title = element.pinned and "unpin" or "pin",
                        active = not element.readonly,
                        callback = function()
                            element.pinned = not element.pinned
                            save()
                            return true
                        end
                    },
                    {
                        title = "set title",
                        active = not element.readonly,
                        callback = function()
                            redraw()
                            element.title = menu.input("title", element.title) or element.title
                            save()
                            return true
                        end
                    },
                    {
                        title = "change size",
                        active = not element.readonly,
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
                        active = not element.readonly,
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
                        active = not element.readonly,
                        callback = function()
                            table.remove(cstack.config.snippets, index)
                            save()
                            return true
                        end
                    }
                })
            elseif eventData[2] == 3 then
                if not element.pinned then
                    gui.moveToUp(cstack.config.snippets, element)
                    save()
                    selectedSnipped = element
                    selectedSnippedX, selectedSnippedY = eventData[3], eventData[4]
                end
            end
        elseif eventData[2] == 2 then
            local locked = not not getPageInfo().locked
            menu.context(eventData[3], eventData[4], {
                {
                    title = "create command snipped",
                    active = not locked,
                    callback = function()
                        table.insert(cstack.config.snippets, {x = eventData[3], y = eventData[4], title = "untitled"})
                        save()
                        return true
                    end
                },
                {
                    title = "create code snipped",
                    active = not locked,
                    callback = function()
                        
                    end
                }
            })
        end
        redraw()
    elseif eventData[1] == "mouse_up" then
        selectedSnippedX, selectedSnippedY, selectedSnipped = nil, nil, nil
    end
end