game = {}

function game:enter()
    game.buttons = {}
    game.buttons.toolbox = button.new(res.w-(res.w/10)-5,res.h-(res.w/10)-5,res.w/10)
    game.buttons.toolbox.label = "Toolbox"
    --game.buttons.toolbox = button.new(0,0,100,100)
    
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
    game.buttons.toolbox:draw()
    
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

function game:mousepressed()
    tree:untickAll()
    local mx,my = love.mouse.getPosition()
    local nearest = tree:findBranch(mx,my)
    selectedB = nearest
    selectedB.selected = true
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
    elseif key == "=" then
        sun = sun + 1000
    elseif key == "-" then
        sun = sun - 1000
        if sun < 0 then sun = 0 end
    end
    --lg.setCanvas(cav)
        
end

return game
