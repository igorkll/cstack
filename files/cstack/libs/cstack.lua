local cstack = {}
cstack.configPath = "/cstackData/.cstackSettings"
cstack.defaultConfig = assert(loadfile("/cstack/default.lua", nil, _ENV))()

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

function cstack.fetchUrl(url)
    if not http then
        return nil, "HTTP API unavailable"
    end

    local response, err = http.get(url)
    if not response then
        return nil, err
    end

    local status = response.getResponseCode()
    if status ~= 200 then
        response.close()
        return nil, "HTTP Error: " .. tostring(status)
    end

    local content, readErr = response.readAll()
    response.close()

    if not content then
        return nil, readErr or "Failed to read response"
    end

    return content
end

function cstack.getCurrentBranch()
    return cstack.readFile("/cstack/branch.txt") or "main"
end

function cstack.getCurrentVersion()
    return tonumber(cstack.readFile("/cstack/version.txt"))
end

function cstack.getActualVersion()
    local url = "https://raw.githubusercontent.com/igorkll/cstack/" ..cstack.getCurrentBranch()  .. "/files/cstack/version.txt"
    local result, err = cstack.fetchUrl(url)
    if not result then return nil, err end
    return tonumber(result)
end

function cstack.update()
    local url = "https://raw.githubusercontent.com/igorkll/cstack/" ..cstack.getCurrentBranch()  .. "/installer/installer.lua"
    local installerCode, err = cstack.fetchUrl(url)
    if not installerCode then return nil, err end
    local installerFunc, err = load(installerCode, "=installer", "t", _ENV)
    if not installerFunc then return nil, err end
    return pcall(installerFunc)
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