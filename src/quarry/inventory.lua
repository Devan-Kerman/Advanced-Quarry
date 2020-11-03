function refuel()
    for i=1, 16 do
        local data = turtle.getItemDetail(i)
        if data then 
            if data.name == "minecraft:coal" or data.name == "minecraft:lava_bucket" then
                turtle.select(i)
                turtle.refuel(64)
            end
        end
    end
    turtle.select(1)
    return turtle.getFuelLevel()
end

function hasFuel(fuel)
    return turtle.getFuelLevel() > fuel or refuel() > fuel
end