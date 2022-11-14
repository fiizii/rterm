local Class = require("Common.Class")

local Promise = Class {
    __string = "Promise { %s }",
    __type = "Promise",
    __tostring = function(self)
        local str = self.fufilled and tostring(self.result) or "<pending>"
        return self.__string:format(str)
    end,

    constructor = function(self, f)
        self.aftercb = function(...) end
        self.catchcb = function(...) end
        self.fufilled = false
        self.result = nil
        function resolve(...)
            local args = {...}
            self.result = (#args > 1 and args or args[1])
            self.fufilled = true
            self.aftercb(...)
        end
    
        function reject(...)
            self.fufilled = true
            self.catchcb(...)
        end

        coroutine.wrap(function()
            local status, error = pcall(func, resolve, reject)
            if not status then reject(error) end
        end)()
    end,

    after = function(self, cb)
        self.aftercb = cb
        return self
    end,
    
    catch = function(self, cb)
        self.catchcb = cb
        return self
    end
}

return Promise