local inventorySize = 16

local function refuel()
    print("REFUEL")
    print("fuel level: ", turtle.getFuelLevel())
    print("fuel limit: ", turtle.getFuelLimit())
    for i = 1, inventorySize do
        turtle.select(i)
        turtle.refuel()
    end
end

local function autoRefuel()
    local fuelLevel = turtle.getFuelLevel()
    local fuelLimit = turtle.getFuelLimit()
    print("FUEL CHECK")
    print("fuel level: ", fuelLevel)
    print("fuel limit: ", fuelLimit)

    if fuelLimit ~= "unlimited" and fuelLevel < 500 then
        refuel()
    end
end

while true do
    autoRefuel()
end