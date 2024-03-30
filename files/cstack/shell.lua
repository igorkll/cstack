multishell.setTitle(multishell.getCurrent(), "cstack")
shell.openTab("worm")

local function redraw()
    gfx.set(1, 1, colors.red, colors.white, "cstackOS")
end
redraw()


gui.context(3, 3, {
    {
        title = "TeSt",
        active = true
    }
})

while true do
    local eventData = {os.pullEvent()}
    if eventData[1] == "terminate" then
        os.shutdown()
    end
end