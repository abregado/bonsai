local toolClass = require('tool')

local tool = {}

function tool.init()
    print("view tool init")
    o = toolClass.new()
    o.buttons.toolbox = button.new(buttonWidth,res.w-(res.w/10)-5,res.h-(res.w/10)-5)
    o.buttons.toolbox.label = "Toolbox"
    o.buttons.toolbox.icon = as.chest
    o.buttons.toolbox.active = true
    o.buttons.toolbox.click = function() gs.switch(state.toolbox) end
    o.buttons.time = button.new(buttonWidth,(res.w/10)+5,res.h-(res.w/10)-5)
    o.buttons.time.label = "Time"
    o.buttons.time.icon = as.time
    o.buttons.time.active = true
    o.buttons.time.click = function() if storedTime == 0 then storedTime = 60 end end
    
    o.draw = tool.draw
    
    return o
end

function tool:draw() 
    
    
    
    tree:display()
    local lightLevel = environment.sunMod/environment.maxSun*255
    lg.setBackgroundColor(lightLevel,lightLevel,lightLevel)
    
    if storedTime == 0 then
        for i,v in pairs(self.buttons) do
            v:draw()
        end
    end
end


function tool:update(dt) 

end

function tool:act() end
function tool:tick() end
function tool:untick() 

end
function tool:mousepressed(x,y,button) end
function tool:mousereleased(x,y,button) end
function tool:keypressed(button) end


return tool
