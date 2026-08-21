local Script = {}
Script.__index = Script

local ModuleCache = {}

local sha = require('Foxit.Libs.sha2')


local restrictedGlobals = {
    ['love'] = true
}

local function BuildEnv(script)
    local env = {} 
    env.script = script

    -- function env.reqire(path)
    -- end

    env.__index = function(self, k)
        if restrictedGlobals[k] then
            return nil
        else
            return _G[k]
        end
    end
    setmetatable(env, env)
    return env
end

function Script.new(path)
    local self = {}; setmetatable(self, Script)

    self.Name = 'Script'
    self.Source = ''
    self.Compiled = nil
    self.thread = nil
    self.Returned = nil

    if path then
        self:Load(path)
    end

    return self
end

function Script:Load(path)
    local file = io.open(path, "r")
    if file then
        local src = file:read('*a')
        self.Source = src
    end
end

function Script:Compile()
    local Compiled = nil
    local Source = self.Source
    local SourceHash = tostring(sha.sha256(Source))
    local env = BuildEnv(self)

    if self.Compiled and self.Compiled[2] == SourceHash then -- already compiled the same code
        return 
    end

    Compiled = loadstring(Source, '@'..self.Name)

    if Compiled then
        setfenv(Compiled, env)
    end

    self.Compiled = {Compiled, SourceHash}
end

function Script:Run()
    self:Compile() -- Compile Src

    task.spawn(function()
        self.Returned = {self.Compiled[1]()}-- run
    end)
end

return Script