os.loadAPI("quarry/config/ores.lua")
os.loadAPI("quarry/movement.lua")

table = {}
function start()
    recurseVein(table, 0, 0, 0, movement.tryForward, movement.tryBackward, ores.inspectOre, 0)
end

function clear()
    table = {}
end

-- todo use absolute coordinates instead of relative coordinates
function recurseVein(coordinateTable, forward, side, altitude, moveFunction, reverseFunction, predicate, rotation)
    forward, side, altitude = movement.incrementForRotation(rotation, forward, side, altitude)
    -- if we have not visited this coordinate yet, and there is ore
    if not access(coordinateTable, forward, side, altitude) and predicate() then
        -- visit coordinate and mine into the ore
        coordinateTable[forward][side][altitude] = true
        moveFunction()

        -- try going forward in the vein
        recurseVein(coordinateTable, forward, side, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre, rotation)
        -- then up
        recurseVein(coordinateTable, forward, side, altitude, movement.tryUp, movement.tryDown, ores.inspectOreUp, rotation)
        -- then down
        recurseVein(coordinateTable, forward, side, altitude, movement.tryDown, movement.tryUp, ores.inspectOreDown, rotation)

        -- then right
        turtle.turnRight()
        recurseVein(coordinateTable, forward, side, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre, rotation+1)
        -- then back
        turtle.turnRight()
        recurseVein(coordinateTable, forward, side, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre, rotation+2)
        -- then left
        turtle.turnRight()
        recurseVein(coordinateTable, forward, side, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre, rotation+3)
        -- move backwards
        turtle.turnRight()

        reverseFunction()
    end
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