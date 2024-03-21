local function Find(data, key) 
    local toReturn = table.clone(data)

    for name, value in toReturn do 
        if name == key then return toReturn[name]
        elseif typeof(value) == "table" then return Find(value, key) end
    end

    return toReturn
end
return Find