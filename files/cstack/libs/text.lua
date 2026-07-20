local text = {trimLetters = {" ", "\t", "\r", "\n"}}

function text.startwith(tool, str, startCheck)
    return tool.sub(str, 1, tool.len(startCheck)) == startCheck
end

function text.endwith(tool, str, endCheck)
    return tool.sub(str, tool.len(str) - (tool.len(endCheck) - 1), tool.len(str)) == endCheck
end

function text.trimLeft(tool, str, list)
    list = list or text.trimLetters

    local newstr = ""
    local allowTrim = true
    for i = 1, tool.len(str) do
        local char = tool.sub(str, i, i)
        if allowTrim then
            if not table.exists(list, char) then
                newstr = newstr .. char
                allowTrim = false
            end
        else
            newstr = newstr .. char
        end
    end
    return newstr
end

function text.trimRight(tool, str, list)
    list = list or text.trimLetters

    local newstr = ""
    local allowTrim = true
    for i = tool.len(str), 1, -1 do
        local char = tool.sub(str, i, i)
        if allowTrim then
            if not table.exists(list, char) then
                newstr = char .. newstr
                allowTrim = false
            end
        else
            newstr = char .. newstr
        end
    end
    return newstr
end

function text.trim(tool, str, list)
    str = text.trimLeft(tool, str, list)
    str = text.trimRight(tool, str, list)
    return str
end

function text.escapePattern(str)
    return str:gsub("([^%w])", "%%%1")
end

function text.split(tool, str, seps) --дробит строку по разделителям(сохраняяя пустые строки)
    local parts = {""}

    if type(seps) ~= "table" then
        seps = {seps}
    end

    local index = 1
    local strlen = tool.len(str)
    while index <= strlen do
        while true do
            local isBreak
            for i, sep in ipairs(seps) do
                if tool.sub(str, index, index + (tool.len(sep) - 1)) == sep then
                    table.insert(parts, "")
                    index = index + tool.len(sep)
                    isBreak = true
                    break
                end
            end
            if not isBreak then break end
        end

        parts[#parts] = parts[#parts] .. tool.sub(str, index, index)
        index = index + 1
    end

    return parts
end

function text.change(tool, str, list)
    for from, to in pairs(list) do
        str = table.concat(text.split(tool, str, from), to)
    end
    return str
end

function text.fastChange(str, list)
    for from, to in pairs(list) do
        local lfrom, lto
        if #from == 1 then
            lfrom = "%" .. from
        else
            lfrom = text.escapePattern(from)
        end
        if #to == 1 then
            lto = "%" .. to
        else
            lto = text.escapePattern(to)
        end
        str = str:gsub(lfrom, lto)
    end
    return str
end

function text.toParts(tool, str, max) --дробит строку на куски с максимальным размером
    local strs = {}
    while tool.len(str) > 0 do
        table.insert(strs, tool.sub(str, 1, max))
        str = tool.sub(str, tool.len(strs[#strs]) + 1)
    end
    return strs
end

function text.toLines(str, max)
    return text.toParts(unicode, str, max)
end

function text.toLinesLn(str, max)
    local raw_lines = text.split(unicode, str, "\n")
    local lines = {}
    for _, raw_line in ipairs(raw_lines) do
        if raw_line == "" then
            table.insert(lines, "")
        else
            local tmpLines = text.toParts(unicode, raw_line, max or 50)
            for _, line in ipairs(tmpLines) do
                table.insert(lines, line)
            end
        end
    end
    return lines
end

function text.parseTraceback(traceback, maxlen, maxlines, spaces)
    maxlen = maxlen or 50
    maxlines = maxlines or 15
    spaces = spaces or 2

    local tab = string.char(9)
    local space = string.rep(" ", spaces)

    local lines = {}
    for i, str in ipairs(text.toLinesLn(traceback, maxlen)) do
        table.insert(lines, (str:gsub(tab, space)))
        if #lines >= maxlines then
            break
        end
    end
    
    return lines
end

function text.formatTraceback(...)
    return table.concat(text.parseTraceback(...), "\n")
end

return text