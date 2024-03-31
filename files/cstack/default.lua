local rx, ry = term.getSize()

local defaultConfig = {
    snippets = {
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