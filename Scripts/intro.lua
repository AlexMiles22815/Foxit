-- // Load 

local Renderer = Foxit:GetRenderer()

local Image = Object2D.new()
Image:LoadImage('Foxit/Assets/Engine.png')
Image.Scale = Vector2.new(0.5, 0.5)
Image.Transparency = 1

-- // Tween

local conn
conn = Renderer.PreRender:Connect(function(dt)
    Image.Transparency = math.clamp(Image.Transparency - dt, 0, 1)

    if Image.Transparency == 0 then
        conn:Disconnect()
    end
    
end)

repeat Renderer.PreRender:Wait()
until Image.Transparency == 0

task.wait(1)

local conn
conn = Renderer.PreRender:Connect(function(dt)
    Image.Transparency = math.clamp(Image.Transparency + dt, 0, 1)

    if Image.Transparency == 1 then
        _G.__introFinished = true
        conn:Disconnect()
    end
    
end)


-- // Destroy

repeat Renderer.PreRender:Wait()
until _G.__introFinished == true

print('Finished')

Image:Destroy()