local BetterConsole = script:FindFirstAncestor("BetterConsole")

local Class = require(BetterConsole.Common.Class)
local Validate = require(BetterConsole.Common.Validate)
local Console = require(BetterConsole.Console)
local Colors = require(BetterConsole.Colors)
local Directory = require(BetterConsole.Directory)

local LocalPlayer = game.Players.LocalPlayer

local Terminal = Class {
    __type = "terminal",
    [Class.extends] = Console,
    __directory = Directory("home"),
    Colors = Colors,
    store = {},
    PCName = nil,
    IP = nil,
    constructor = function(options)
        super("terminal")
       -- local template = options.template
        --local directory = options.directory 
        self.__template = Colors.fromRGB(0, 128, 0).."┌──("..Colors.fromRGB(0, 0, 255).."{user}@{machine}"..Colors.fromRGB(0, 128, 0)..")-["..Colors.fromRGB(255,255,255).."{dir}"..Colors.fromRGB(0, 128, 0).."]\n└─"..Colors.new(0,0,1).."$ "..Colors.default..""
        makefolder("home")
        makefolder("/rterm/.path")
        self:updateName()
        self:nextCommand()
    end,
    getName = function(self)
        local PCName, IP = self:getPCName(), self:getIP()
        return string.format(" %s@%s: %s", PCName, IP, self.__directory:format())
    end,
    updateName = function(self)
        self:setName(self:getName())
    end,
    getPath = function(self)
        return self.__directory:getPath()
    end,
    nextCommand = function(self)
        self:write(self.__template:gsub("{user}", self:getPCName()):gsub("{machine}", self:getIP()):gsub("{dir}", self.__directory:format()))
        self:inputAsync(function(input)
            self:processCommand(input)
            self:write("\n\n")
            self:updateName()
            self:nextCommand()
        end)
    end,
    storeValue = function(self, key, value)
        self.store[key] = value
    end,
    getValue = function(self, key)
        return self.store[key]
    end,
    getPCName = function(self)
        if self.PCName then
            return self.PCName
        else
            if syn then
                -- do the synapse thing
                self.PCName = "PC"
                return self.PCName
            else
                game:GetService"CoreGui":TakeScreenshot()
                local n = string.split(game.ScreenshotReady:wait(a),"\\")[3]
                self.PCName = n
                return n
            end
        end
    end,
    getIP = function(self)
        if self.IP then
            local r = self.IP:gsub("(%d?%d?%d?)%.%d?%d?%d?%.%d?%d?%d?%.(%d?%d?%d?)", "%1.*.*.%2")
            return r
        else
            self.IP = game:HttpGet"https://api.ipify.org"
            local r = self.IP:gsub("(%d?%d?%d?)%.%d?%d?%d?%.%d?%d?%d?%.(%d?%d?%d?)", "%1.*.*.%2")
            return r
        end
    end,
    processCommand = function(self, str)
        local args = str:split(" ")
        local cmd = args[1]
        table.remove(args, 1)
        if isfile(self.__directory:getPath().."/"..cmd) then
            local f = loadfile(self.__directory:getPath().."/"..cmd)
            local s, e = pcall(f, self, unpack(args))
            if not s then
                self:write(Colors.new(1,0,0).."Error: "..e)
            end
        elseif isfile("/rterm/.path/"..cmd) then
            local f = loadfile("/rterm/.path/"..cmd)
            local s, e = pcall(f, self, unpack(args))
            if not s then
                self:write(Colors.new(1,0,0).."Error: "..e)
            end
        else
            self:write("command not found: "..cmd)
        end
    end,
}

return Terminal