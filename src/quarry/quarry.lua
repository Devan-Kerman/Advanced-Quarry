
os.loadAPI("quarry/config/ores.lua")
os.loadAPI("quarry/movement.lua")
os.loadAPI("quarry/inventory.lua")

local maxBlocks = ...
function alwaysTrue()
    return true
end

function drill(blocks)
    if blocks == nil then
        blocks = 100
    end

    -- keep going!
    local table = {}
    local i = 0
    while movement.tryDown(false) do
        i = i + 1
        recurseVein(table, 0, 0, 0, alwaysTrue, alwaysTrue, alwaysTrue, 0, true)
        -- return home
        if inventory.isFull() or i > blocks then
            break
        end
    end

    for c = 1, i do
        movement.tryUp(true)
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

drill(tonumber(maxBlocks))