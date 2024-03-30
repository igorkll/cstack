local rx, ry = term.getSize()

local snippets = {
    {
        readonly = true,
        x = 1,
        y = 1,
        sizeX = 16,
        sizeY = 1,
        title = "cstackOS",
        color = colors.red
    },
    {
        readonly = true,
        x = 1,
        y = 2,
        sizeX = 16,
        sizeY = 1,
        title = "shell",
        color = colors.orange,
        command = "shell"
    }
}

return snippets