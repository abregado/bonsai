game = {}

function game:enter()
    
end


function game:openToolbox()
    gs.switch(state.toolbox)
end

function game:draw()
    local mx,my = love.mouse.getPosition()
    
    currentTool:draw()
    
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

        for i,v in ipairs(tree.buds) do
            v:draw()
        end
    end
    

    
end

function game:update(dt)
    dt = dt*5
    if storedTime > dt then
        doSeasons(dt)
        tree:grow(dt)
        storedTime = storedTime -dt
    elseif storedTime > 0 then
        doSeasons(storedTime)
        tree:grow(storedTime)
        storedTime = 0
    end
    
    
    --[[dt = dt*2
    if not PAUSE then
        doSeasons(dt)
        tree:grow(dt)
    end]]
    
    
   
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
    if button == 'l' then
        local uiInteraction = false
        for i,v in pairs(currentTool.buttons) do
            if v:check() and v.active then
                uiInteraction = true
                game.pressed = true
                
            end
        end
        
        if not uiInteraction then
            currentTool:tick(x,y)
            --sfx.blip:play()
        end
    end
end

function game:mousereleased(x,y,button)
    if button == 'l' and game.pressed then
        local uiInteraction = false
        for i,v in pairs(currentTool.buttons) do
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
