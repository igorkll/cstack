local sx, sy = term.getSize()

local function createBall()
    local ball = {}
    ball.x = math.floor(sx / 2)
    ball.y = math.floor(sy / 2)
    ball.dx = math.random() - 0.5
    ball.dy = math.random() - 0.5
    ball.color = 2 ^ math.random(0, 15)

    function ball.draw()
        term.setBackgroundColor(ball.color)
        term.setCursorPos(math.floor(ball.x) - 1, math.floor(ball.y) - 1)
        term.write("  ")
    end

    function ball.tick()
        ball.x = ball.x + ball.dx
        ball.y = ball.y + ball.dy
        if ball.x < 0 then
            ball.dx = math.abs(ball.dx)
        elseif ball.x > sx then
            ball.dx = -math.abs(ball.dx)
        end
        if ball.y < 0 then
            ball.dy = math.abs(ball.dy)
        elseif ball.y > sx then
            ball.dy = -math.abs(ball.dy)
        end
    end

    return ball
end

local balls = {}
for i = 1, 512 do
    table.insert(balls, createBall())
end

while true do
    term.setBackgroundColor(colors.black)
    term.clear()

    for i, v in ipairs(balls) do
        v.draw()
        v.tick()
    end

    sleep(0.1)
end