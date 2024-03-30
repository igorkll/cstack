local gfx = require("libs/gfx")

local function redraw()
    gfx.set(1, 1, colors.red, colors.white, "cstackOS")
end

while true do
    local eventData = {os.pullEventRaw()}
    if eventData[1] == "terminate" then
        os.shutdown()
    end
end