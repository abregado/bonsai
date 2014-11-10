game = {}

function game:enter()
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
    
end

function game:update(dt)
    dt=dt*5
    if not PAUSE then
        doSeasons(dt)
        tree:grow(dt)
    end
    
    local mx,my = love.mouse.getPosition()
    
    
    if mPos.x == mx and mPos.y == my then
        mTime = mTime+dt
    else
        mTime=0
        hover=nil
        mPos={x=mx,y=my}
    end
    
    if mTime>0.5 and hover==nil then
        hover = findBranch(mx,my)
    end
    
    
    
        
    
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

end

function game:keypressed(key)
    --tree:grow(sun,10)
    if key == "r" then
        treeReset()
    elseif key == "a" then
        tree:tick()
    elseif key == "s" then
        tree:untick()
        selectedB=nil
    elseif key == "d" then
        bsort={}
        tree:report()
        for i,v in ipairs(bsort) do
            v.selected=true
        end
    elseif key == "p" and selectedB and selectedB.parent then
        selectedB.parent:prune(selectedB,true)
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
