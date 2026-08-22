-- // Load 

local Image = Object2D.new()
Image:LoadImage('Foxit/Assets/img.jpg')
Image.Scale = Vector2.new(0.15, 0.15)

-- // Tween


-- // Destroy

task.wait(3)

Image:Destroy()
Image = nil

_G.__introFinished = true