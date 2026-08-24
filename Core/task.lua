local task = {}
local tasks = {}
local currentTime = 0

local utils = require('Foxit.Core.Utills')
task.log = utils.BuildLogFuncs('task')

local config = require('Foxit.config')

local function newtask(f)
    local t = {}
    t.co = coroutine.create(f)
    t.waitUntil = 0
    t.active = true
    table.insert(tasks, t)
    return t
end

function task.update(dt)
    currentTime = currentTime + dt
    
    -- Loop backwards to safely remove dead tasks
    for i = #tasks, 1, -1 do
        local t = tasks[i]
        
        if coroutine.status(t.co) == "dead" then
            t.active = false
        end
        
        if t.active then
            if currentTime >= t.waitUntil then
                local success, res = coroutine.resume(t.co)
                
                if not success then
                    t.active = false

                    if config.softScriptErrors then
                        print("Task error: " .. tostring(res))
                    else
                        error("Task error: " .. tostring(res))
                    end

                    
                elseif type(res) == "number" then
                    t.waitUntil = currentTime + res
                end
            end
        else
            table.remove(tasks, i)
        end
    end
end

function task.spawn(f, ...)
    local t = newtask(f)
    local success, res = coroutine.resume(t.co, ...)
    if not success then
        t.active = false
        error("Task failed on spawn: " .. tostring(res))
    elseif type(res) == "number" then
        t.waitUntil = currentTime + res
    end
    return t.co
end

function task.wait(seconds)
    return coroutine.yield(seconds or 0)
end

function task.delay(seconds, f)
    local t = newtask(f)
    t.waitUntil = currentTime + (seconds or 0)
    return t.co
end

return task