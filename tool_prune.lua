tool = {}

local toolClass = require('tool')

local colors = {
    selected = {255,0,0},
    unselected = {0,0,0},
    background = {255,255,255}
}

function tool.new()
    o = toolClass.new()
    o.draw = tool.draw
    o.update = tool.update
    o.tick = tool.tick
    o.untick = tool.untick
    o.mousepressed = tool.mousepressed
    o.mousereleased = tool.mousereleased
    o.keypressed = tool.keypressed
    
    return o
end

function tool:draw() 
    lg.setBackgroundColor(colors.background)
    for i,v in ipairs(tree.branches) do
        if v.selected then
            v:display(colors.selected)
        else
            v:display(colors.unselected)
        end
    end
    
    tree:drawPot(tree.x,tree.y,colors.unselected)
end
function tool:update(dt) end
function tool:tick() end
function tool:untick() end
function tool:mousepressed(x,y,button) end
function tool:mousereleased(x,y,button) end
function tool:keypressed(button) end


return tool
