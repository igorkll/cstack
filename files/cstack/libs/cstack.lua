local cstack = {}
cstack.configPath = "/.cstackSettings"
cstack.defaultConfig = {}

function cstack.readFile(path)
    local file, err = fs.open(path, "rb")
    if not file then
        return nil, tostring(err or "unknown error")
    end
    local data = file.readAll()
    file.close()
    return data
end

function cstack.writeFile(path, data)
    local file, err = fs.open(path, "wb")
    if not file then
        return nil, tostring(err or "unknown error")
    end
    file.write(data)
    file.close()
    return true
end

if fs.exists(cstack.configPath) then
    cstack.readFile(cstack.configPath)
end

return cstack