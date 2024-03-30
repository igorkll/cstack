local title, text = ...
local sizeX, sizeY = term.getSize()

local function centerPrint(y, text)
    term.setCursorPos(((sizeX / 2) - (#text / 2)) + 1, y)
    term.write(text)
end

term.setBackgroundColor(colors.blue)
term.setTextColor(colors.white)
term.clear()

term.setBackgroundColor(colors.white)
term.setTextColor(colors.blue)
centerPrint(2, " " .. (title or "BSOD") .. " ")


term.setBackgroundColor(colors.blue)
term.setTextColor(colors.white)
local lineNumber = 4
for line in string.gmatch((text or "unknown error") .. "\n", "(.-)\n") do
    if lineNumber >= sizeY - 3 then
        centerPrint(lineNumber, "(not enough screen space)")
        break
    end
    centerPrint(lineNumber, line)
    lineNumber = lineNumber + 1
end

-- menu
local menuPoints = {"shutdown", "reboot", "wipe computer"}
local currentPoint = 1
while true do
    centerPrint(sizeY - 1, "[" .. menuPoints[currentPoint] .. "]")
    local eventData = {os.pullEventRaw()}
    if eventData[1] == "terminate" then
        os.shutdown()
    elseif eventData[1]
    end
end