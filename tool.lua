tool = {}

function tool.new()
    o = {}
    o.draw = tool.draw
    o.update = tool.update
    o.tick = tool.tick
    o.act = tool.act
    o.untick = tool.untick
    o.mousepressed = tool.mousepressed
    o.mousereleased = tool.mousereleased
    o.keypressed = tool.keypressed
    
    return o
end

function tool:draw() 
    tree:display()
    local lightLevel = environment.sunMod/environment.maxSun*255
    lg.setBackgroundColor(lightLevel,lightLevel,lightLevel)
end
function tool:act() end
function tool:update(dt) end
function tool:tick() end
function tool:untick() end
function tool:mousepressed(x,y,button) end
function tool:mousereleased(x,y,button) end
function tool:keypressed(button) end


return tool
