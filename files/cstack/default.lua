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
            command = "previousPage",
            mode = 4
        },
        {
            x = 3,
            y = ry,
            sizeX = 2,
            sizeY = 1,
            title = "HM",
            color = colors.pink,
            command = "homePage",
            mode = 4
        },
        {
            x = rx - 1,
            y = ry,
            sizeX = 2,
            sizeY = 1,
            title = ">>",
            color = colors.purple,
            command = "nextPage",
            mode = 4
        },
        {
            x = 5,
            y = ry,
            sizeX = rx - 6,
            sizeY = 1,
            title = "page: ",
            smartTitle = "getPage",
            color = colors.gray
        },



        {
            page = 0,
            x = 1,
            y = 2,
            sizeX = 16,
            sizeY = 1,
            title = "shell",
            color = colors.orange,
            command = "shell"
        },
        {
            page = 0,
            x = 1,
            y = 2,
            sizeX = 16,
            sizeY = 1,
            title = "shell",
            color = colors.orange,
            command = "shell"
        },
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