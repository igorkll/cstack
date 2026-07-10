local inventorySize = 16

local function refuel()
    print("REFUEL")
    print("fuel level: ", turtle.getFuelLevel())
    print("fuel limit: ", turtle.getFuelLimit())
    for i = 1, inventorySize do
        if turtle.getItemDetail(i) then
            turtle.select(i)
            turtle.refuel()
        end
    end
end

local function autoRefuel()
    local fuelLevel = turtle.getFuelLevel()
    local fuelLimit = turtle.getFuelLimit()

    if fuelLimit ~= "unlimited" and fuelLevel < 500 then
        refuel()
    end
end

local function justMove()
    while turtle.down() do
    end

    while true do
        if turtle.forward() then
            break
        else
            turtle.turnLeft()
        end
    end
end

while true do
    autoRefuel()

    justMove()

    os.sleep(0.1)
end