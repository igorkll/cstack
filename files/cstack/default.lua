local rx, ry = term.getSize()

local defaultConfig = {
    snippets = {
        {
            x = 1,
            y = math.huge,
            sizeX = 2,
            sizeY = 1,
            title = "<<",
            color = colors.purple,
            command = "previousPage",
            mode = 4
        },
        {
            x = 3,
            y = math.huge,
            sizeX = 2,
            sizeY = 1,
            title = "HM",
            color = colors.pink,
            command = "homePage",
            mode = 4
        },
        {
            x = rx - 1,
            y = math.huge,
            sizeX = 2,
            sizeY = 1,
            title = ">>",
            color = colors.purple,
            command = "nextPage",
            mode = 4
        },
        {
            x = 5,
            y = math.huge,
            sizeX = rx - 6,
            sizeY = 1,
            title = "page: ",
            smartTitle = "getPage",
            color = colors.gray,
            mode = -1
        },



        {
            page = 0,
            x = 1,
            y = 2,
            sizeX = 16,
            sizeY = 1,
            title = "shell",
            color = colors.orange,
            command = "shell",
            mode = 1
        }
    },
    pageinfo = {
        [0] = {
            locked = true
        }
    }
}

for i, snippet in ipairs(defaultConfig.snippets) do
    snippet.readonly = true
    snippet.pinned = true
end

return defaultConfig