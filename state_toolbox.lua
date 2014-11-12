toolbox = {}

local xStep = res.w/4
local yStep = res.h/3

local butPositions = {
    {x=xStep,y=yStep},
    {x=xStep*2,y=yStep},
    {x=xStep*3,y=yStep},
    {x=xStep,y=yStep*2},
    {x=xStep*2,y=yStep*2},
    {x=xStep*3,y=yStep*2}
}

local maxOff = res.w
toolbox.xOff = maxOff
toolbox.boxOff = 0

local buttonWait = 0.2
local waitTimer = 0

local easingOut = 'outBounce'
local easingIn = 'outQuad'
local slideTime = 1.1

function toolbox:startLeaving()
    for i,v in ipairs(toolbox.buttons) do
        v.active = false
    end
    toolbox.xOffTween = tw.new(slideTime/4,toolbox,{xOff=maxOff,boxOff=0},easingIn)
    toolbox.toolSelected = true
    
end

function toolbox:saw()
    tool = 'saw'
    toolbox.startLeaving()
end

function toolbox:prune()
    tool = 'prune'
    toolbox.startLeaving()
end

function toolbox:repot()
    tool = 'repot'
    toolbox.startLeaving()
end

function toolbox:pinch()
    tool = 'pinch'
    toolbox.startLeaving()
end

function toolbox:debud()
    tool = 'debud'
    toolbox.startLeaving()
end

function toolbox:cancel()
    tool = nil
    toolbox.startLeaving()
end

function toolbox:enter(from)
    waitTimer = 0
    toolbox.from = from
    toolbox.xOff = res.w
    toolbox.toolSelected = false
    toolbox.boxOff = 0
    toolbox.xOffTween = tw.new(slideTime,toolbox,{xOff=0,boxOff=maxOff},easingOut)
    
    toolbox.buttons = {}
    toolbox.buttons[1] = button.new(buttonWidth)
    toolbox.buttons[1].icon = as.saw
    toolbox.buttons[1].click = toolbox.saw
    toolbox.buttons[2] = button.new(buttonWidth)
    toolbox.buttons[2].icon = as.scissors
    toolbox.buttons[2].click = toolbox.prune
    toolbox.buttons[3] = button.new(buttonWidth)
    toolbox.buttons[3].icon = as.repot
    toolbox.buttons[3].click = toolbox.repot
    toolbox.buttons[4] = button.new(buttonWidth)
    toolbox.buttons[4].icon = as.leaf
    toolbox.buttons[4].click = toolbox.pinch
    toolbox.buttons[5] = button.new(buttonWidth)
    toolbox.buttons[5].icon = as.buds
    toolbox.buttons[5].click = toolbox.debud
    toolbox.buttons[6] = button.new(buttonWidth)
    toolbox.buttons[6].icon = as.cancel
    toolbox.buttons[6].click = toolbox.cancel
end

function toolbox:draw()
    local mx,my = love.mouse.getPosition()
    self.from:draw()

    
    --draw overlay
    lg.setColor(colors.toolboxBG)
    lg.rectangle("fill",toolbox.boxOff-res.w,yStep,res.w,yStep)
    
    for i,v in ipairs(butPositions) do
        toolbox.buttons[i]:draw(v.x+toolbox.xOff,v.y)
        lg.setColor(255,0,0)
        lg.circle("fill",v.x+toolbox.xOff,v.y,10,20)
    end
    
    --draw buttons
    
end

function toolbox:update(dt)
    local complete = toolbox.xOffTween:update(dt)
    if complete then
       waitTimer = waitTimer + dt 
    end
    
    if waitTimer > buttonWait then
        for i,v in ipairs(toolbox.buttons) do
            v.active = true
        end
    end
    
    if toolbox.toolSelected then
        local leavingComplete = toolbox.xOffTween:update(dt)
        if leavingComplete then
            gs.switch(state.game)
        end
    end
end

function toolbox:mousepressed(x,y,button)
    if button == 'l' then
        for i,v in ipairs(toolbox.buttons) do
            if v:check() and v.active then
                v:click()
            end
        end
    end
                
end

function toolbox:keypressed(key)
    if key == "escape" then
        gs.switch(state.game)
    end
        
end

return toolbox
