os.loadAPI("quarry/inventory.lua")

local diveX, diveZ = 0, 0
local x, y, z, r = 0, 0, 0, 0
function loc() 
    return x, y, z
end

function saveState()
    local file = fs.open("quarry/movement_state", "w")
    file.write(textutils.serialize(table.pack(x, y, z, r, diveX, diveZ)))
    file.close()
end

function loadState()
    if fs.exists("quarry/movement_state") then
        local file = fs.open("quarry/movement_state", "r")
        x, y, z, r, diveX, diveZ = table.unpack(textutils.unserialize(file.readAll()))
        print("Loaded State: " .. x .. " " .. y .. " " .. z .. " " .. r .. " " .. diveX .. " " .. diveY)
    end
end

function tryUp()
    -- if no restriction
    if not turtle.up() then
        -- break block
        turtle.digUp()
        -- try move up again
        if not turtle.up() then
            -- try killing whatever is above
            while turtle.attackUp() do end
            -- try one last time
            if not turtle.up() then
                return false
            end
        end
    end
    y = y + 1
    saveState()
    return true
end

function tryDown()
    if not turtle.down() then
        turtle.digDown()
        if not turtle.down() then
            while turtle.attackDown() do end
            if not turtle.down() then
                return false
            end
        end
    end
    y = y - 1
    saveState()
    return true
end

function try()
    if not turtle.forward() then
        turtle.dig()
        if not turtle.forward() then
            while turtle.attack() do end
            if not turtle.forward() then
                return false
            end
        end
    end

    if r == 0 then
        x = x + 1
    elseif r == 1 then
        z = z + 1
    elseif r == 2 then
        x = x - 1
    elseif r == 3 then
        z = z - 1
    end
    saveState()
    return true
end

-- all relative to starting position
-- 0 = 'north'
-- 1 = 'east'
-- 2 = 'south'
-- 3 = 'west'
function face(dir)
    local delta = dir - r
    if delta > 0 then
        for i=1, delta do
            turtle.turnRight()
        end
    elseif delta < 0 then
        for i=1, math.abs(delta) do
            turtle.turnLeft()
        end
    end
    r = dir
    saveState()
end

-- checks if the turtle has enough fuel to return to a location
function hasFuel(fx, fy, fz)
    return inventory.hasFuel(math.abs(x - fx) + math.abs(y - fy) + math.abs(z - fz) + 1)
end

function navigate(fx, fy, fz)
    -- if below destination
    while fy > y do
        tryUp()
    end

    -- if above destination
    while fy < y do
        tryDown()
    end

    -- if behind destination
    if fx < x then
        face(2)
        while fx < x do
            try()
        end
    end

    -- if ahead of destination
    if fx > x then
        face(0)
        while fx > x do
            try()
        end
    end

     -- if right of destination
     if fz < z then
        face(3)
        while fz < z do
            try()
        end
    end

    -- if left of destination
    if fz > z then
        face(1)
        while fz > z do
            try()
        end
    end
end
