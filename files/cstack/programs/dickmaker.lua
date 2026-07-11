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
        if math.random() < 0.9 and turtle.forward() then
            if math.random() < 0.1 then
                return true
            end
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
    local moveLimit = 5
    local actions

    local function getRandomAction(fromOne)
        return actions[math.random(fromOne and 1 or 2, #actions)]
    end

    actions = {getRandomAction, turtle.turnLeft, turtle.turnRight, turtle.up, turtle.down}

    downMax()
    for i = 1, 3 do
        if justMove(moveLimit, getRandomAction(true)) then
            break
        end
    end
    downMax()
end

local lastBlockSlot

local function placeBlock(direction)
    local function tryPlace(slotIndex)
        turtle.select(slotIndex)

        if direction == 0 then
            return turtle.place()
        elseif direction == 1 then
            return turtle.placeUp()
        elseif direction == -1 then
            return turtle.placeDown()
        end
    end

    if lastBlockSlot then
        if tryPlace(lastBlockSlot) then
            return true
        end
    end
    
    for i = 1, inventorySize do
        if tryPlace(i) then
            lastBlockSlot = i
            return true
        end
    end

    return false
end

local function placeDick()
    if not placeBlock(0) then return false end
    turtle.turnLeft()
    turtle.turnLeft()
    if not placeBlock(0) then return false end
    if not turtle.up() then return false end
    if not turtle.up() then return false end
    if not placeBlock(-1) then return false end
    if not turtle.up() then return false end
    if not placeBlock(-1) then return false end
    return true
end

while true do
    autoRefuel()

    tryJustMove()
    placeDick()

    os.sleep(0.1)
end