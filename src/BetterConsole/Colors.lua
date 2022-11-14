local BetterConsole = script:FindFirstAncestor("BetterConsole")

local Validate = require(BetterConsole.Common.Validate)

local function esc(a) return ""..a end




local colors = {}
function colors.fromRGB(r,g,b)
    Validate(r, "number", 1, "fromRGB")
    Validate(g, "number", 2, "fromRGB")
    Validate(b, "number", 3, "fromRGB")
    return setmetatable({
        foreground = string.format(esc"[38;2;%d;%d;%dm", r, g, b),
        background = string.format(esc"[48;2;%d;%d;%dm", r, g, b),
        __type = "color"
    }, {
        __concat = function(a, b)
            return a.foreground..b
        end
    })
end

function colors.fromColor3(c3)
    Validate(c3, "Color3", 1, "fromColor3")
    return colors.fromRGB(c3.R*255, c3.G*255, c3.B*255)
end

colors.default = setmetatable({foreground = esc"[0m", __type = "color"}, {
    __concat = function(a, b)
        return a.foreground..b
    end
})

colors.reset = colors.default
colors.green = colors.fromRGB(0, 255, 0)
colors.red = colors.fromRGB(255, 0, 0)
colors.blue = colors.fromRGB(0, 0, 255)
colors.yellow = colors.fromRGB(255, 255, 0)
colors.purple = colors.fromRGB(255, 0, 255)
colors.cyan = colors.fromRGB(0, 255, 255)
colors.white = colors.fromRGB(255, 255, 255)


setmetatable(colors, {__index = function(self, index)
    if Color3[index] ~= nil then
        return function(...)
            return self.fromColor3(Color3[index](...))
        end
    end
end})

return colors