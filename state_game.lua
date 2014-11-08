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
    
    dataControl.draw()
end

function game:update(dt)
    if not PAUSE then
    tree:grow(sun,dt)
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

function game:mousepressed()
    tree:untick()
    local x,y = love.mouse.getPosition()
    local b=findBranch(x,y)
    if b then
        b:tick()
        selectedB = b
    end
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
        if PAUSE then dataControl.save() end
    end
    --lg.setCanvas(cav)
        
end

return game
