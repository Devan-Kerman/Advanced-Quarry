os.loadAPI("quarry/inventory.lua")
os.loadAPI("quarry/movement.lua")
os.loadAPI("quarry/config/ores.lua")

-- todo check surroundings for ore
function dive()
    local skip = true
    -- ensure we have enough fuel to return to the home chest
    while movement.hasFuel(0, 0, 0) do
        if skip then skip = false else
            for i=1, 4 do
                turtle.turnRight()
                ores.breakOre()
            end
        end

        -- go down
        if not movement.tryDown() then
            -- we escaped because we hit bedrock or some other inpenetrable barrier
            dump()
            return true
        end

        if inventory.isFull() then
            local x, y, z = movement.loc()
            dump()
            -- if we can go all the way back to where we were and still return incase we actually didn't have fuel
            if movement.hasFuel(x * 2, y * 2, z * 2) then
                movement.navigate(x, y, z)
            else
                -- out of fuel, we're done here!
                return false
            end
        end
    end
    -- we escaped becase we have exactly enough fuel to return, no use in risking it
    dump()
    return false
end

function dump()
    movement.navigate(0, 0, 0)
    -- face chest
    movement.face(2)
    inventory.dump()
end

local table = {0, 3, 1, 4, 2}
function nextDive(x, z, width, length)
    if x + 5 >= width then
        -- next row
        z = z + 1
        if z >= length then
            return nil
        else
            return table[z%#table + 1], z
        end
    else
        return x + 5, z
    end
end

function quarry(width, length)
    local x, z = 0, 0
    while x and movement.hasFuel(x * 2, 0, z * 2) do
        print(x, z)
        movement.navigate(x, 0, z)
        if dive() then
            x, z = nextDive(x, z, width, length)
            print(x, z)
        else
            return false
        end
    end

    -- we're done, return home
    dump()
    turtle.turnRight()
    turtle.turnRight()
    return true
end

width, length = ...
if not width then
    width = 16
end

if not length then
    length = width
end

quarry(tonumber(width), tonumber(length))
