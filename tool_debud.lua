local toolClass = require('tool')
local tool = {}

local colors = {
    selected = {60,155,60},
    unselected = {0,0,0},
    branches = {255,255,255},
    background = {200,200,255}
}

function tool.init()
    print("debud tool init")
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
        for i,v in ipairs(tree.buds) do
            if v.selected then
                v.isDead = true
            end
        end
        selectedB.canBud = false
    end
end

function tool.cancel()
    if selectedB then
        tools.debud:untick()
    else
        currentTool = tools.view
    end
end

function tool:draw() 
    
    
    lg.setBackgroundColor(colors.background)
    for i,v in ipairs(tree.branches) do
            v:display(colors.branches)
    end
    
    tree:drawPot(tree.x,tree.y,colors.branches)
    
    for i,v in ipairs(tree.buds) do
        if v.selected then
            v:draw(colors.selected)
        else
            v:draw(colors.unselected)
        end
    end
    
    if storedTime == 0 then
        for i,v in pairs(self.buttons) do
            v:draw()
        end
    end
end

function tool:update(dt) end

function tool:tick(mx,my) 
    local nearest = tree:findBranchEnd(mx,my)
    if nearest then
        tree:untickAll()
        tree:tick(nearest)
        for i,v in ipairs(tree.buds) do
            if v.parent == nearest then
                v.selected = not v.selected
            end
        end
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
