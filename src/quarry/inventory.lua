function refuel()
    for i=1, 16 do
        local data = turtle.getItemDetail(i)
        if data then 
            turtle.select(i)
            turtle.refuel(64)
        end
    end
    turtle.select(1)
    return turtle.getFuelLevel()
end

function hasFuel(fuel)
    return turtle.getFuelLevel() > fuel or refuel() > fuel
end

-- todo better inventory full function
function isFull()
    for i=1, 16 do
        if turtle.getItemCount(i) == 0 then
            return false
        end
    end
    return true
end