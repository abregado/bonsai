game = {}

function game:enter()
    game.buttons = {}
    game.buttons.toolbox = button.new(buttonWidth,res.w-(res.w/10)-5,res.h-(res.w/10)-5)
    game.buttons.toolbox.label = "Toolbox"
    game.buttons.toolbox.icon = as.chest
    game.buttons.toolbox.active = true
    game.buttons.toolbox.click = function() gs.switch(state.toolbox) end
    game.buttons.time = button.new(buttonWidth,(res.w/10)+5,res.h-(res.w/10)-5)
    game.buttons.time.label = "Time"
    game.buttons.time.icon = as.time
    game.buttons.time.active = true
    game.buttons.time.click = function() PAUSE = not PAUSE end
    game.buttons.time.extraCode = function() if PAUSE then game.buttons.time.colors.ready = {255,0,0} else game.buttons.time.colors.ready = {100,100,100} end end
    game.buttons.cancel = button.new(buttonWidth,res.w-(res.w/10)-5,res.h-(res.w/10)-5)
    game.buttons.cancel.label = "Cancel"
    game.buttons.cancel.icon = as.cancel
    game.buttons.cancel.active = false
    game.buttons.cancel.visible = false
    game.buttons.cancel.click = function() tool = nil game.setButtons() end
    
    game.setButtons()
    
end

function game.setButtons()
    if tool then
        game.buttons.toolbox.active = false
        game.buttons.toolbox.visible = false
        game.buttons.cancel.active = true
        game.buttons.cancel.visible = true
    else
        game.buttons.toolbox.active = true
        game.buttons.toolbox.visible = true
        game.buttons.cancel.active = false
        game.buttons.cancel.visible = false
    end
end

function game:openToolbox()
    gs.switch(state.toolbox)
end

function game:draw()
    --lg.setCanvas()
    --lg.draw(cav,0,0,1,1)
    local mx,my = love.mouse.getPosition()
    
    tree:display()
    if hover then
        local b=hover
        lg.setColor(colors.selected)
        lg.setLineWidth(1)
        --lg.line(b.x,b.y,mx,my)
    end
    
    local lightLevel = environment.sunMod/environment.maxSun*255
    lg.setBackgroundColor(lightLevel,lightLevel,lightLevel)
    
    if DEBUG_MODE then
        lg.setColor(0,255,0)
        lg.print("Branch Mass: "..tree.mass,0,0)
        lg.print("Root Mass: "..tree.rootMass,0,15)
        lg.print("Leaves: "..#tree.leaves,0,30)
        lg.print("Branches: "..#tree.branches,0,45)
        lg.print("Buds: "..#tree.buds,0,60)
        lg.print("Lacking most: "..tree.lack,0,75)
        lg.print("rootEnergy: "..tree.rootEnergy,0,90)
        lg.print("leafEnergy: "..tree.leafEnergy,0,105)
        lg.print("Leaf Area: "..tree.leafArea,0,120)
        lg.print("Sunlight: "..environment.sunMod,0,135)
        lg.print("BG Color: "..lightLevel,0,150)
    end
    
    for i,v in ipairs(tree.buds) do
        v:draw()
    end
    
    game.buttons.toolbox:draw()
    game.buttons.time:draw()
    game.buttons.cancel:draw()
    
end

function game:update(dt)
    dt = dt*2
    if not PAUSE then
        doSeasons(dt)
        tree:grow(dt)
    end
    
    
   
    --[[if mPos.x == mx and mPos.y == my then
        mTime = mTime+dt
    else
        mTime=0
        hover=nil
        mPos={x=mx,y=my}
    end
    
    if mTime>0.5 and hover==nil then
        hover = findBranch(mx,my)
    end]]
    
    
    
        
    
end

function doSeasons(dt)
    local complete = sunTween:update(dt)
    if complete and environment.state == 1 then
        sunTween = tw.new(yearTime,environment,{sunMod=environment.minSun},'linear')
        environment.state = 0
    elseif complete and environment.state == 0 then
        sunTween = tw.new(yearTime,environment,{sunMod=environment.maxSun},'linear')
        environment.state = 1
    end
end

function game:mousepressed(x,y,button)
    if button == 'r' then
        tree:untickAll()
        selectedB = nil
    elseif button == 'l' then
        local uiInteraction = false
        for i,v in pairs(game.buttons) do
            if v:check() and v.active then
                uiInteraction = true
                game.pressed = true
            end
        end
        
        if not uiInteraction then               
            local mx,my = love.mouse.getPosition()
            local nearest = tree:findBranch(mx,my)
            if nearest then
                tree:untickAll()
                selectedB = nearest
                selectedB.selected = true
            end
        end
    end
end

function game:mousereleased(x,y,button)
    if button == 'l' and game.pressed then
        local uiInteraction = false
        for i,v in pairs(game.buttons) do
            if v:check() and v.active then
                v:click()
                break
            end
        end
        game.pressed = false
    end
end

function game:keypressed(key)
    --tree:grow(sun,10)
    if key == "r" then
        treeReset()
    elseif key == "s" then
        tree:untickAll()
        selectedB=nil
    elseif key == "k" and selectedB then
        selectedB.isDead = true
        selectedB = nil
    elseif key == "p" and selectedB and selectedB.parent then
        selectedB.parent:knosper()
        selectedB.isDead = true
        selectedB=nil
    elseif key == "o" and selectedB and selectedB.parent then
        selectedB.parent:prune(selectedB,false)
        selectedB=nil
    elseif key == " " then
        PAUSE = not PAUSE
    end
    --lg.setCanvas(cav)
        
end

return game
