local title, text = ...
local sizeX, sizeY = term.getSize()

local function centerPrint(y, text, offset)
    term.setCursorPos(((sizeX / 2) - (#text / 2)) + 1 + (offset or 0), y)
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
local wipeValue = 0
local funcs = {
    function ()
        os.shutdown()
    end,
    function ()
        os.reboot()
    end,
    function ()
        wipeValue = (wipeValue or 0) + 1
        centerPrint(sizeY - 1, "%" .. math.floor(wipeValue))
        if wipeValue >= 100 then
            for _, name in ipairs(fs.list("/")) do
                local path = "/" .. name
                if not fs.isReadOnly(path) and not fs.isDriveRoot(path) then
                    fs.delete(path)
                end
            end
            os.reboot()
        end
    end
}

local currentPoint = 1
local offsetSize = math.floor(sizeX / 3)
while true do
    term.setCursorPos(0, sizeY - 1)
    term.clearLine()
    centerPrint(sizeY - 1, "[" .. menuPoints[currentPoint] .. "]")
    if sizeX >= 39 then
        if menuPoints[currentPoint - 1] then centerPrint(sizeY - 1, "[" .. menuPoints[currentPoint - 1] .. "]", -offsetSize) end
        if menuPoints[currentPoint + 1] then centerPrint(sizeY - 1, "[" .. menuPoints[currentPoint + 1] .. "]", offsetSize - 1) end
    else
        term.setCursorPos(3, sizeY - 1)
        term.write("<<")

        term.setCursorPos(sizeX - 3, sizeY - 1)
        term.write(">>")
    end
    
    local eventData = {os.pullEventRaw()}
    if eventData[1] == "terminate" then
        os.shutdown()
    elseif eventData[1] == "key" then
        if eventData[2] == keys.enter then
            funcs[currentPoint]()
        elseif eventData[2] == keys.left then
            currentPoint = currentPoint - 1
            if currentPoint < 1 then currentPoint = 1 end
        elseif eventData[2] == keys.right then
            currentPoint = currentPoint + 1
            if currentPoint > #menuPoints then currentPoint = #menuPoints end
        end
    elseif eventData[1] == "key_up" then
        wipeValue = nil
    end
end