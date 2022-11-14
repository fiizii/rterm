local function type(a)
    if a == nil then return "nil" end
    if typeof(a) == "table" then
        if a.__type then return a.__type end
        return "table"
    end
    return typeof(a)
end
local function validateProp(prop, expectedTypes, propertyNumber, functionName)
    fName = functionName and "'"..functionName.."'" or "?"
    t = type(prop)
    if type(expectedTypes) ~= "table" then
        expectedTypes = {expectedTypes}
    end
    for i,v in pairs(expectedTypes) do
        if t == v then return end
    end
    error(string.format("invalid argument #%d to %s (%s expected, got %s)", propertyNumber, fName, table.concat(expectedTypes, ", "), t), 2)
end

return validateProp