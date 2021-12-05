trash = {
    ["minecraft:stone"] = {}, 
    ["minecraft:dirt"] = {},
    ["minecraft:grass_block"] = {},
    ["minecraft:netherrak"]
}

function isTrash(success, data, error)
    if success then
        local table = trash[data.name]
        return table and not table[data.metadata]
    end
    if error then
        print(error)
    end
    return true
end

function breakOre()
    if inspectOre() then
        turtle.dig()
    end
end

function inspectOre()
    return not isTrash(turtle.inspect())
end
