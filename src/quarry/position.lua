-- imports
os.loadAPI("quarry/inventory.lua")

localForwards = 10
-- negative is left, positive is right
localSide = 3

localAltitude = -4
-- 0 = forward
-- 1 = right
-- 2 = back
-- 3 = left
localRotation = 0

function mineForwards()
    if not turtle.forward() then
        if not turtle.dig() then turtle.attack() end
        mineForwards()
    end
end

function mineVert(down)
    if down then
        if not turtle.down() then
            if not turtle.digDown() then turtle.attackDown() end
            mineVert(down)
        end
    else
        if not turtle.up() then
            if not turtle.digUp() then turtle.attackUp() end
            mineVert(down)
        end
    end
end

function canContinue()
    local required = returnFuel()
    return budget(required + 1)
end

function returnHome()
    print("hmst")
    -- return to quarry line
    if localSide >= 0 then
        -- turn sideways
        rotateRelative(3)
    else
        rotateRelative(1)
    end

    print("1121")
    for i=0, math.abs(localSide) do
        mineForwards()
    end

    print("223423")
    -- go down
    local down = localAltitude > 0
    for i=0, math.abs(localAltitude) do
        mineVert(down)
    end

    print("wdaw")
    -- turn backwards last
    if localForwards >= 0 then
        -- turn backwards
        rotateRelative(2)
    else
        rotateRelative(0)
    end

    for i=0, math.abs(localForwards) do
        mineForwards()
    end
end

-- total amount of fuel needed to return home
function returnFuel()
    return math.abs(localForwards) + math.abs(localSide) + math.abs(localAltitude)
end

-- true if we have enough fuel
function budget(fuel)
    return turtle.getFuelLevel() > fuel or inventory.refuel() > fuel
end

function rotateRelative(direction)
    -- how many times to rotate left
    local delta = localRotation - direction
    if delta > 0 then
        for i = 0, delta do
            turtle.turnLeft()
        end
    else
        for i = 0, math.abs(delta) do
            turtle.turnRight()
        end
    end
end