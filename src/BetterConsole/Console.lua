local BetterConsole = script:FindFirstAncestor("BetterConsole")

local Class = require(BetterConsole.Common.Class)
local Validate = require(BetterConsole.Common.Validate)


local function esc(a) return ""..a end

local rconsoleprint = rconsoleprint or consoleprint 
local rconsoleclear = rconsoleclear or consoleclear
local rconsolename = rconsolename or consolesettitle or rconsolesettitle
local rconsoleinput = rconsoleinput or consoleinput


function rconsoleclose()
    (rconsoledestroy or consoledestroy or function() warn("Exploit does not support terminal deletion") end)()
end

local Console = Class {
    __type = "console",
    constructor = function(name)
       
        local c = rconsolecreate or consolecreate or function() end
        c()
        rconsoleclear()
        rconsolename(name)
    end,

    setScreenSize = function(self, width, height)
        Validate(width, "number", 1, "setScreenSize")
        Validate(height, "number", 2, "setScreenSize")
        self:write(esc"[8;"..height..";"..width.."t")
    end,

    cursorTo = function(self, X, Y)
        Validate(X, "number", 1, "cursorTo")
        Validate(Y, "number", 2, "cursorTo")
        X = X or 1
        Y = Y or 1
        rconsoleprint(string.format(esc"[%s;%sH", Y, X))
    end,
    setName = function(self, name)
        Validate(name, "string", 1, "setName")
        rconsolename(name)
    end,
    escape = esc,
    inputAsync = function(self, callback, x, y)
        Validate(x, {"number", "nil"}, 2, "inputAsync")
        Validate(y, {"number", "nil"}, 3, "inputAsync")
        Validate(callback, "function", 1, "inputAsync")
        spawn(function()
            callback(rconsoleinput())
        end)
        if x and y then
            self:cursorTo(x, y)
        end
    end,
    input = function(self, x, y)
        Validate(x, {"number", "nil"}, 1, "input")
        Validate(y, {"number", "nil"}, 2, "input")
        if x and y then
            self:cursorTo(x, y)
        end
        return rconsoleinput()
    end,
    write = function(self, txt)
        Validate(txt, "string", 1, "write")
        rconsoleprint(txt)
    end,

    clearScreenDown = function(self)
        self:write(esc"[0J")
    end,

    destroy = function(self) rconsoleclose() end

}

return Console