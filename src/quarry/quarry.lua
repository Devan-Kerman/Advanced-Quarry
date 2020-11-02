

ores = {
    ["minecraft:coal_ore"] = {}, 
    ["minecraft:iron_ore"] = {},
    ["minecraft:diamond_ore"] = {},
    ["minecraft:gold_ore"] = {},
    ["minecraft:lapis_ore"] = {},
    ["minecraft:redstone_ore"] = {},
    ["minecraft:emerald_ore"] = {},
    ["thermalfoundation:ore"] = {},
    -- arrays start from 0 my ass
    ["techreborn:ore"] = {
        [0] = true, -- galena ore, useless fucking shit
    }
}

function isOre(success, data, error)
    if success then
        local table = ores[data.name]
        return table and not table[data.metadata]
    end
    print(error)
end



distance = 0
function advance()
    -- if we have enough fuel to head back
    if budget(distance) then
        turtle.dig()
        turtle.forward()
    end
end
    
