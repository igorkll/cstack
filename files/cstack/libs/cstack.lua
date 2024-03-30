local cstack = {}
cstack.configPath = "/.cstackSettings"
cstack.defaultConfig = {
    snippets = assert(loadfile("/cstack/snippets.lua", nil, _ENV))()
}

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

function cstack.readTable(path)
    local cfg, err = cstack.readFile(path)
    if not cfg then return nil, err end
    return textutils.unserialize(cfg)
end

function cstack.writeTable(path, tbl)
    return cstack.writeFile(path, textutils.serialize(tbl))
end

function cstack.saveConfig()
    return cstack.writeTable(cstack.configPath, cstack.config)
end

if fs.exists(cstack.configPath) then
    local cfg = cstack.readTable(cstack.configPath)
    if cfg then
        for k, v in pairs(cstack.defaultConfig) do
            if not cfg[k] then
                cfg[k] = cstack.defaultConfig[k]
            end
        end
        cstack.config = cfg
    else
        cstack.config = cstack.clone(cstack.defaultConfig)
    end
else
    cstack.config = cstack.clone(cstack.defaultConfig)
end

return cstack