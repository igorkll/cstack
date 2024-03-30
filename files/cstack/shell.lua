local function redraw()
    
end

while true do
    local eventData = {os.pullEventRaw()}
    if eventData[1] == "terminate" then
        os.shutdown()
    end
end