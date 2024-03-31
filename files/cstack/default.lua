local rx, ry = term.getSize()

local defaultConfig = {
    snippets = {
        {
            x = 1,
            y = ry,
            sizeX = 2,
            sizeY = 1,
            title = "<<",
            color = colors.purple,
            func = "previousPage"
        },
        {
            x = rx - 1,
            y = ry,
            sizeX = 2,
            sizeY = 1,
            title = ">>",
            color = colors.purple,
            func = "nextPage"
        },
        {
            x = 3,
            y = ry,
            sizeX = rx - 4,
            sizeY = 1,
            title = "page: ",
            smartTitle = "getPage",
            color = colors.gray
        },




        {
            x = 1,
            y = 1,
            sizeX = 16,
            sizeY = 1,
            title = "cstackOS",
            color = colors.red
        },
        {
            x = 1,
            y = 2,
            sizeX = 16,
            sizeY = 1,
            title = "shell",
            color = colors.orange,
            command = "shell"
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