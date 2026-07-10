local inventorySize = 16

local function move(dir)
    if dir == -1 then
        return turtle.down()
    elseif dir == 0 then
        return turtle.forward()
    elseif dir == 1 then
        return turtle.up()
    end
    return false
end

local function smartMove(dir)
    while true do
        move(dir)
    end
end

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

    if fuelLimit ~= "unlimited" and fuelLevel < 500 then
        refuel()
    end
end

while true do
    autoRefuel()
    os.sleep(0.1)
end