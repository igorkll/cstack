local cstack = {}
cstack.configPath = "/.cstackSettings"
cstack.defaultConfig = {}

function cstack.clone(tbl)
    local newtbl = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            newtbl[k] = cstack.clone(v)
        else
            newtbl[k] = v
        end
    end
    return newtbl
end

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
    local cfg = cstack.readFile(cstack.configPath)
    if cfg then
        textutils.unserialize(cfg)

    else
        cstack.config = cstack.clone(cstack.defaultConfig)
    end
end

return cstack