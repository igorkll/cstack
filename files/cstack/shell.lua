local gfx = require("libs/gfx")
local gui = require("libs/gui")
multishell.setTitle(multishell.getCurrent(), "cstack")

--------------------------------------

local function redraw()
    gfx.set(1, 1, colors.red, colors.white, "cstackOS")
end
redraw()

gui.context(1, 1, {
    {
        str = "TeSt",
        active = true
    }
})

shell.openTab("worm")

--------------------------------------

while true do
    local eventData = {os.pullEventRaw()}
    if eventData[1] == "terminate" then
        os.shutdown()
    end
end