os.loadAPI("quarry/config/ores.lua")
os.loadAPI("quarry/movement.lua")

table = {}
function start()
    recurseVein(table, 0, 0, 0, movement.tryForward, movement.tryBackward, ores.inspectOre)
end

function clear()
    table = {}
end

function recurseVein(coordinateTable, forward, side, altitude, moveFunction, reverseFunction, predicate)
    -- if we have not visited this coordinate yet, and there is ore
    print(forward, side, altitude, not access(coordinateTable, forward, side, altitude), predicate())
    if not access(coordinateTable, forward, side, altitude) and predicate() then
        -- visit coordinate and mine into the ore
        coordinateTable[forward][side][altitude] = true
        moveFunction()

        -- try going forward in the vein
        recurseVein(coordinateTable, forward+1, side, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre)
        -- then up
        recurseVein(coordinateTable, forward, side, altitude+1, movement.tryUp, movement.tryDown, ores.inspectOreUp)
        -- then down
        recurseVein(coordinateTable, forward, side, altitude-1, movement.tryDown, movement.tryUp, ores.inspectOreDown)

        -- then right
        turtle.turnRight()
        recurseVein(coordinateTable, forward, side+1, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre)
        -- then back
        turtle.turnRight()
        recurseVein(coordinateTable, forward-1, side, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre)
        -- then left
        turtle.turnRight()
        recurseVein(coordinateTable, forward, side-1, altitude, movement.tryForward, movement.tryBackward, ores.inspectOre)
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