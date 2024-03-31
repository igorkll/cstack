multishell.setTitle(multishell.getCurrent(), "cstack")

local currentPage = 0
local selectedSnippedX, selectedSnippedY, selectedSnipped
local builtinFunctions = {
    nextPage = function()
        currentPage = currentPage + 1
        if currentPage > 16 then
            currentPage = 16
        end
    end,
    previousPage = function()
        currentPage = currentPage - 1
        if currentPage < 0 then
            currentPage = 0
        end
    end,
    homePage = function()
        currentPage = 0
    end,
    getPage = function()
        return currentPage
    end
}

local function getPageInfo()
    if cstack.config.pageinfo[currentPage] then
        return cstack.config.pageinfo[currentPage]
    end
    return {}
end

local function localMathElements()
    local snippets = {}
    for _, snippet in ipairs(cstack.config.snippets) do
        local lSnippet = cstack.clone(snippet)
        lSnippet.real = snippet
        if lSnippet.x == math.huge then
            lSnippet.x = menu.sizeX()
        elseif lSnippet.x == -math.huge then
            lSnippet.x = 0
        end
        if lSnippet.y == math.huge then
            lSnippet.y = menu.sizeY()
        elseif lSnippet.y == -math.huge then
            lSnippet.y = 0
        end
        table.insert(snippets, lSnippet)
    end
    return snippets
end

local function mathElements()
    for _, snippet in ipairs(cstack.config.snippets) do
        snippet.sizeX = snippet.sizeX or (#(snippet.title or "") + 2)
        snippet.sizeY = snippet.sizeY or 2
        snippet.color = snippet.color or colors.orange
    end
end

local function redraw()
    term.clear(colors.black)

    local snippets = localMathElements()
    for i = #snippets, 1, -1 do
        local snippet = snippets[i]
        if not snippet.page or snippet.page == currentPage then
            local textColor = snippet.textcolor or colors.white
            if snippet.color == textColor then
                textColor = colors.black
            end

            local title = tostring(snippet.title or "")
            if snippet.smartTitle and builtinFunctions[snippet.smartTitle] then
                title = title .. tostring(builtinFunctions[snippet.smartTitle]() or "")
            end
            gfx.centeredText(snippet.x, snippet.y, snippet.sizeX, snippet.sizeY, snippet.color, textColor, title:sub(1, snippet.sizeX))
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

parallel.waitForAny(function ()
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
            local index, element = gui.getCollisionElement(eventData, localMathElements())
            if element and (not element.page or element.page == currentPage) then
                element = element.real
                if eventData[2] == 1 then
                    if element.mode == -1 then
                        --not action
                    elseif not element.command or element.mode == 0 then
                        menu.message("snippet error", "the snippet launch mode is not set")
                    elseif element.mode == 1 then
                        term.setCursorPos(1, 1)
                        menu.defaultColors()
                        term.clear()
                        shell.run(element.command)
                        term.setCursorBlink(false)
                    elseif element.mode == 2 then
                        shell.openTab(element.command)
                    elseif element.mode == 3 then
                        local code, err = load(element.command)
                        if code then
                            local ok, err = pcall(code)
                            if not ok then
                                menu.message("runtime error", err)
                            end
                        else
                            menu.message("syntax error", err)
                        end
                    elseif element.mode == 4 then
                        if builtinFunctions[element.command] then
                            builtinFunctions[element.command]()
                        end
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
                            active = not element.readonly and not element.pinned,
                            callback = function()
                                redraw()
                                element.title = menu.input("title", element.title) or element.title
                                save()
                                return true
                            end
                        },
                        {
                            title = "set command",
                            active = not element.readonly and not element.pinned,
                            callback = function()
                                redraw()
                                element.command = menu.input("command", element.command) or element.command
                                save()
                                return true
                            end
                        },
                        {
                            title = "set mode",
                            active = not element.readonly and not element.pinned,
                            menu = {
                                {
                                    title = "none",
                                    active = not element.readonly and not element.pinned,
                                    callback = function()
                                        element.mode = 0
                                        save()
                                        return true
                                    end
                                },
                                {
                                    title = "command",
                                    active = not element.readonly and not element.pinned,
                                    callback = function()
                                        element.mode = 1
                                        save()
                                        return true
                                    end
                                },
                                {
                                    title = "tab",
                                    active = not element.readonly and not element.pinned,
                                    callback = function()
                                        element.mode = 2
                                        save()
                                        return true
                                    end
                                },
                                {
                                    title = "code",
                                    active = not element.readonly and not element.pinned,
                                    callback = function()
                                        element.mode = 3
                                        save()
                                        return true
                                    end
                                }
                            }
                        },
                        {
                            title = "set size",
                            active = not element.readonly and not element.pinned,
                            menu = {
                                {
                                    title = "automatic",
                                    callback = setSnippedSize
                                },
                                {
                                    sizeX = 4,
                                    sizeY = 4,
                                    title = "4x4",
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
                                    title = "8x7",
                                    callback = setSnippedSize
                                }
                            }
                        },
                        {
                            title = "set color",
                            active = not element.readonly and not element.pinned,
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
                            active = not element.readonly and not element.pinned,
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
                        title = "create snipped",
                        active = not locked,
                        callback = function()
                            table.insert(cstack.config.snippets, {
                                x = eventData[3],
                                y = eventData[4],
                                title = "untitled",
                                page = currentPage,
                                mode = 0
                            })
                            save()
                            return true
                        end
                    },
                    {
                        title = "next page",
                        callback = function()
                            builtinFunctions.nextPage()
                            return true
                        end
                    },
                    {
                        title = "previous page",
                        active = currentPage > 0,
                        callback = function()
                            builtinFunctions.previousPage()
                            return true
                        end
                    },
                    {
                        title = "home page",
                        active = currentPage ~= 0,
                        callback = function()
                            builtinFunctions.homePage()
                            return true
                        end
                    }
                })
            end
            redraw()
        elseif eventData[1] == "mouse_up" then
            selectedSnippedX, selectedSnippedY, selectedSnipped = nil, nil, nil
        end
    end
end, function ()
    local osx, osy
    while true do
        local sx, sy = term.getSize()
        if osx ~= sx or sy ~= osy then
            mathElements()
            redraw()
            osx, osy = sx, sy
        end
        sleep(0.1)
    end
end)