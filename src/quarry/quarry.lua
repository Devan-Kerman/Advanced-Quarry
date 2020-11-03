local maxBlocks = ...
os.loadAPI("quarry/config/ores.lua")
os.loadAPI("quarry/movement.lua")
os.loadAPI("quarry/inventory.lua")

function alwaysTrue()
    return true
end

function start(blocks)
    if blocks == nil then
        blocks = 100
    end
    print(string.format("Mining %s blocks!", blocks))

    -- keep going!
    local table = {}
    local i = 0
    while movement.tryForward() do
        i = i + 1
        recurseVein(table, 0, 0, 0, alwaysTrue, alwaysTrue, alwaysTrue, 0, true)

        -- return home
        if inventory.isFull() or i > blocks then
            break
        end
    end

    turtle.turnRight()
    turtle.turnRight()
    for c = 1, i do
        movement.tryForward(true)
    end
end

-- todo use absolute coordinates instead of relative coordinates
function recurseVein(coordinateTable, forward, side, altitude, moveFunction, reverseFunction, predicate, rotation, force)
    local toReturn = true
    forward, side, altitude = movement.incrementForRotation(rotation, forward, side, altitude)
    -- if we have not visited this coordinate yet, and there is ore
    if (force and (access(coordinateTable, forward, side, altitude) or true)) -- need to run function to prevent NPE
    or (not access(coordinateTable, forward, side, altitude) and predicate()) then
        -- visit coordinate and mine into the ore
        coordinateTable[forward][side][altitude] = true
        if moveFunction(false) then 
            -- try going forward in the vein
            recurseVein(coordinateTable, forward, side, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre, rotation, false)
            -- then up
            recurseVein(coordinateTable, forward, side, altitude, movement.tryUp, movement.tryDown, ores.inspectOreUp, rotation, false)
            -- then down
            recurseVein(coordinateTable, forward, side, altitude, movement.tryDown, movement.tryUp, ores.inspectOreDown, rotation, false)

            -- then right
            turtle.turnRight()
            recurseVein(coordinateTable, forward, side, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre, rotation+1, false)
            -- then back
            turtle.turnRight()
            recurseVein(coordinateTable, forward, side, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre, rotation+2, false)
            -- then left
            turtle.turnRight()
            recurseVein(coordinateTable, forward, side, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre, rotation+3, false)
            -- move backwards
            turtle.turnRight()
        else
            print("Returning!")
            toReturn = false
        end
        reverseFunction(true)
    end

    return toReturn
end

function access(coordinateTable, x, z, y)
    if not coordinateTable[x] then
        coordinateTable[x] = {}
    end

    if not coordinateTable[x][z] then
        coordinateTable[x][z] = {}
    end

    return coordinateTable[x][z][y]
end

start(tonumber(maxBlocks))