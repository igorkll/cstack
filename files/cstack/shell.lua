multishell.setTitle(multishell.getCurrent(), "cstack")
shell.openTab("worm")

local function redraw()
    term.clear(colors.black)
    gfx.set(1, 1, colors.red, colors.white, "cstackOS")
end

redraw()
menu.context(3, 3, {
    {
        title = "TeSt",
        active = true
    },
    {
        title = "TeSt 2",
        active = false
    },
    true,
    {
        title = "TeSt 3",
        active = true
    },
    {
        title = "TeSt 4",
        active = true
    }
})
redraw()

while true do
    local eventData = {os.pullEvent()}
    if eventData[1] == "terminate" then
        os.shutdown()
    end
end