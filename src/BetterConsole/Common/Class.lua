local ClassCreator = {}
ClassCreator.extends = {}

local function modifyFnEnv(f, env)
    setfenv(f, setmetatable(env, {__index = getfenv(f)}))
end

local ClassMt = {
    __call = function(self, ...)
        local newInstance = {}
        setmetatable(newInstance, {__index = self.prototype})
        getfenv(newInstance.constructor).self = newInstance -- set self
        newInstance.constructor(...)
        return newInstance
    end
}

local function makeClass(self, targs)
    local Class = {
        prototype = {}
    }
    setmetatable(Class, ClassMt)

    local constructor = targs.constructor or function() end
    local constructorEnv = {}
    modifyFnEnv(constructor, constructorEnv)

    local SuperClass = targs[ClassCreator.extends]
    if SuperClass then
        setmetatable(Class.prototype, {__index = SuperClass.prototype})
        function constructorEnv.super(...)
            local super = SuperClass.prototype.constructor
            getfenv(super).self = constructorEnv.self
            super(...)
        end
    end

    -- Copy prototype
    for k, v in pairs(targs) do
        Class.prototype[k] = v
    end
    -- Remove special non-method fields
    Class.prototype[ClassCreator.extends] = nil
    Class.prototype.constructor = nil

    Class.prototype.constructor = constructor
    return Class
end

setmetatable(ClassCreator, {
    __call = makeClass
})

return ClassCreator