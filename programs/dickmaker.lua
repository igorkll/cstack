local inventorySize = 16

local function refuel()
    for i = 1, inventorySize do
        turtle.select(i)
        turtle.refuel()
    end
end

local function autoRefuel()
    local fuelLevel = turtle.getFuelLevel()
    local fuelLimit = turtle.getFuelLimit()
    if fuelLimit ~= "unlimited" and fuelLevel < fuelLimit / 2 then
        refuel()
    end
end

while true do
    autoRefuel()
end