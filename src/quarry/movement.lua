function tryForward()
    print("try forward!")
    if not turtle.forward() then
        if turtle.dig() or turtle.attack() then
            print("try again!")
            return tryForward()
        end
        return false
    end
    return true
end

function tryBackward()
    if not turtle.back() then
        turtle.turnLeft()
        turtle.turnLeft()
        local result = false
        if turtle.dig() or turtle.attack() then
            result = tryForward()
            return 
        end
        turtle.turnRight()
        turtle.turnRight()
        return result
    end
    return true
end

function tryUp()
    if not turtle.up() then
        if turtle.digUp() or turtle.attackUp() then
            return tryUp()
        end
        return false
    end
    return true
end

function tryDown()
    if not turtle.down() then
        if turtle.digDown() or turtle.attackDown() then
            return tryDown()
        end
        return false
    end
    return true
end