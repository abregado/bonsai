local toolClass = require('tool')
local tool = {}

local colors = {
    selected = {255,0,0},
    unselected = {0,0,0},
    background = {255,255,255}
}

function tool.init()
    print("prune tool init")
    o = toolClass.new()
    o.buttons.cancel = button.new(buttonWidth,res.w-(res.w/10)-5,res.h-(res.w/10)-5)
    o.buttons.cancel.label = "Cancel"
    o.buttons.cancel.icon = as.cancel
    o.buttons.cancel.active = true
    o.buttons.cancel.click = tool.cancel
    o.buttons.confirm = button.new(buttonWidth,res.w-(res.w/10)-5,res.h-(res.w/2)-5)
    o.buttons.confirm.label = "Confirm"
    o.buttons.confirm.icon = as.tick
    o.buttons.confirm.active = false
    o.buttons.confirm.visible = false
    o.buttons.confirm.click = tool.act
    
    o.draw = tool.draw
    o.tick = tool.tick
    o.untick = tool.untick
    
    return o
end

function tool:act()
    if selectedB then
        selectedB.isDead = true
        tools.prune:untick()
    end
end

function tool.cancel()
    if selectedB then
        tools.prune:untick()
    else
        currentTool = tools.view
    end
end

function tool:draw() 
    for i,v in pairs(self.buttons) do
        v:draw()
    end
    
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

function tool:tick(mx,my) 
    local nearest = tree:findBranch(mx,my)
    if nearest then
        tree:untickAll()
        tree:tick(nearest)
        self.buttons.confirm.visible = true
        self.buttons.confirm.active = true
    end
end

function tool:untick()
    selectedB = nil
    tree:untickAll()
    self.buttons.confirm.visible = false
    self.buttons.confirm.active = false
end


function tool:mousepressed(x,y,button) end
function tool:mousereleased(x,y,button) end
function tool:keypressed(button) end


return tool
