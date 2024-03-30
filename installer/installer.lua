local function clear(col)
    term.setBackgroundColor(col)
    term.setCursorPos(1, 1)
    term.clear()
end
clear(colors.blue)

---------------------------------------

local baseUrl = "https://raw.githubusercontent.com/igorkll/cstack/"
local branch = "main"

local function wget(url)
    local ok, err = assert(http.checkURL(url))
    if not ok then
        return nil, tostring(err or "unknown error")
    end

    local response, err = assert(http.get(url))
    if not response then
        return nil, tostring(err or "unknown error")
    end

    local data = response.readAll()
    response.close()
    return data
end

local function download(path, dpath)
    local url = baseUrl .. branch .. path
    local str, err = assert(wget(url))
    if not str then
        return nil, tostring(err or "unknown error")
    end

    fs.makeDir("/" .. fs.getDir(dpath))
    local file = fs.open(dpath, "wb")
    file.write(str)
    file.close()

    return true
end

local function split(str, sep)
    local parts, count, i = {}, 1, 1
    while 1 do
        if i > #str then break end
        local char = str:sub(i, #sep + (i - 1))
        if not parts[count] then parts[count] = "" end
        if char == sep then
            count = count + 1
            i = i + #sep
        else
            parts[count] = parts[count] .. str:sub(i, i)
            i = i + 1
        end
    end
    if str:sub(#str - (#sep - 1), #str) == sep then table.insert(parts, "") end
    return parts
end

local function processList(data)
    local tbl = split(data, "\n")
    for i = #tbl, 1, -1 do
        if tbl[i] == "" then
            table.remove(tbl, i)
        end
    end
    return tbl
end

local function downloadList(listUrl, mode)
    print("start downloading from list: ", listUrl)
    local lst = processList(assert(wget(listUrl)))
    for i, path in ipairs(lst) do
        print("downloading: ", path)
        assert(download(path, path, mode))
    end
end

---------------------------------------

term.setBackgroundColor(colors.blue)
print("do you really want to install cstack?")
print("type 'YES' to start installation")

if io.read() == "YES" then
    print("start of installation")
    downloadList(baseUrl .. branch .. "/installer/filelist.txt")
    os.reboot()
else
    clear(colors.black)
    print("the installation was canceled")
end