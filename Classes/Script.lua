local Script = {}
Script.__index = Script

local ModuleCache = {}
local unpack = table.unpack or unpack
local ocular = require('Foxit.Libs.ocular')


local sha = require('Foxit.Libs.sha2')


local restrictedGlobals = {
    ['love'] = true
}

local function BuildEnv(script)
    local env = {} 

    local function findModule(name)
        local modulePath = name:gsub("%.", "/")

        for template in package.path:gmatch("[^;]+") do
            local path = template:gsub("%?", modulePath)
            local file = io.open(path, 'r')

            if file then
                file:close()
                return path
            end
        end
    end


    function env.require(name)
       assert(type(name) == 'string',
            "bad argument #1 to 'require' (string expected, got " ..
            type(name) .. ")"
        )

        local loaded = ModuleCache[name]
        if loaded ~= nil then
            return loaded
        end

        local path = findModule(name)
        if not path then
            error(
                "module '" .. name .. "' not found:\n" ..
                "\tno file '" .. name:gsub("%.", "/") .. ".lua" .. "'"
            )
        end
        

        local file = assert(io.open(path, 'r'))
        local source = file:read("*a")
        file:close()

        local chunk, err = loadstring(source, '@' .. path)
        if not chunk then
            error(err, 2)
        end

        setfenv(chunk, env)
        ModuleCache[name] = chunk()


        return ModuleCache[name]
    end

    env.__index = function(self, k)
        if restrictedGlobals[k] then
            return nil
        else
            return _G[k]
        end
    end

    env.print = function(...)
        local args = {...}

        for i, arg in pairs(args) do
            if typeof(arg) == 'table' then
                args[i] = '\n' .. ocular.look(arg)
            end
        end

        args[1] = ('%s [%s]: %s'):format(tick(), script.Name, args[1])

        print(table.concat(args, ' '))
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