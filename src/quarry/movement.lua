os.loadAPI("quarry/inventory.lua")

distance = 0

function tryForward(force)
    -- if we have traveled farther than we can before running out of fuel
    -- then stop
    if not force and not inventory.hasFuel(distance + 1) then
        print("out of fuel!")
        return false
    end

    if not turtle.forward() then
        if turtle.dig() or turtle.attack() then
            return tryForward(force)
        end
        return false
    end
    distance = distance + 1
    return true
end

function tryBackward(force)
    if not force and not inventory.hasFuel(distance + 1) then
        print("out of fuel!")
        return false
    end

    if not turtle.back() then
        turtle.turnLeft()
        turtle.turnLeft()
        local result = false
        if turtle.dig() or turtle.attack() then
            result = tryForward(force)
            return 
        end
        turtle.turnRight()
        turtle.turnRight()
        return result
    end
    distance = distance + 1
    return true
end

function tryUp(force)
    if not force and not inventory.hasFuel(distance + 1) then
        print("out of fuel!")
        return false
    end

    if not turtle.up() then
        if turtle.digUp() or turtle.attackUp() then
            return tryUp(force)
        end
        return false
    end
    distance = distance + 1
    return true
end

function tryDown(force)
    if not force and not inventory.hasFuel(distance + 1) then
        return false
    end

    if not turtle.down() then
        if turtle.digDown() or turtle.attackDown() then
            return tryDown(force)
        end
        return false
    end
    distance = distance + 1
    return true
end

-- 0 = forward
-- 1 = right
-- 2 = back
-- 3 = left
function incrementForRotation(rotation, forward, side, altitude)
    rotation = rotation % 4
    if rotation == 0 then
        return forward+1, side, altitude
    elseif rotation == 1 then
        return forward, side+1, altitude
    elseif rotation == 2 then
        return forward-1, side, altitude
    elseif rotation == 3 then
        return forward, side-1, altitude
    end
    print("not found")
end