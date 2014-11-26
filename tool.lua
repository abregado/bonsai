tool = {}

function tool.new()
    o = {}
    o.draw = tool.draw
    o.update = tool.update
    o.tick = tool.tick
    o.act = tool.act
    o.untick = tool.untick
    o.init = tool.init
    o.mousepressed = tool.mousepressed
    o.mousereleased = tool.mousereleased
    o.keypressed = tool.keypressed
    o.buttons = {}

    return o
end

function tool:init() print("blank tool init") end
function tool:draw() end
function tool:act() end
function tool:update(dt) end
function tool:tick() end
function tool:untick() end
function tool:mousepressed(x,y,button) end
function tool:mousereleased(x,y,button) end
function tool:keypressed(button) end


return tool
