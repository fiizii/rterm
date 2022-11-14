local BetterConsole = script:FindFirstAncestor("BetterConsole")

local Class = require(BetterConsole.Common.Class)
local Validate = require(BetterConsole.Common.Validate)

local Directory = Class {
    __type = "directory",
    constructor = function(path)
        Validate(path, "string", 1, "constructor")
        self.__path = path
    end,
    format = function(self)
        local path = self.__path:gsub("^/+", ""):gsub("/+$", "")
        if path:sub(1, 4) == "home" then
            path = "~"..path:sub(5)
        end
        if path == "" then
            path = "/"
        end
        return path
    end,
    getPath = function(self)
        return self.__path
    end,
    cd = function(self, path)
        Validate(path, "string", 1, "cd")
        local retpath = self.__path
        if path:sub(1, 1) == "/" then
            retpath = path
        elseif path:sub(1, 2) == "~/" then
            retpath = "home"..path:sub(2)
        elseif path:sub(1, 2) == "./" then
            retpath ..= path:sub(2)
        elseif path:sub(1, 3) == "../" then
            local pathS = self.__path:split("/")
            table.remove(pathS, #pathS)
            retpath = table.concat(pathS, "/")..path:sub(3)
        elseif path == ".." then
            local pathS = retpath:split("/")
            table.remove(pathS, #pathS)
            retpath = table.concat(pathS, "/")
        elseif path == "~" then
            retpath = "home"
        else
            retpath ..= "/"..path
        end
        retpath = retpath:gsub("^/+", ""):gsub("/+$", "")
        return retpath
    end,
    setPath = function(self, path)
        self.__path = path
    end
}

return Directory