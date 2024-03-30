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
centerPrint(2, " " .. title .. " ")


term.setBackgroundColor(colors.blue)
term.setTextColor(colors.white)
local lineNumber = 4
for line in string.gmatch(text .. "\n", "(.-)\n") do
    centerPrint(lineNumber, line)
end