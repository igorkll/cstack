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

local function justMove(moveLimit, action)
    while true do
        if turtle.forward() then
            return true
        else
            action()
        end

        moveLimit = moveLimit - 1
        if moveLimit <= 0 then
            break
        end
    end

    return false
end

local function downMax()
    while turtle.down() do
    end
end

local function tryJustMove()
    local moveLimit = 20
    local actions

    local function getRandomAction(fromOne)
        return actions[math.random(fromOne and 1 or 2, #actions)]
    end

    actions = [getRandomAction, turtle.turnLeft, turtle.turnRight, turtle.up, turtle.down, turtle.back, downMax]

    downMax()

    for i = 1, 3 do
        justMove(moveLimit, getRandomAction(true))
    end
end

while true do
    autoRefuel()

    tryJustMove()

    os.sleep(0.1)
end