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
    if error then
        print(error)
    end
    return false
end

function inspectOre()
    return isOre(turtle.inspect())
end

function inspectOreUp()
    return isOre(turtle.inspectUp())
end

function inspectOreDown()
    return isOre(turtle.inspectDown())
end