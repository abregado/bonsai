local t={}

function t.new(x,y)
    o={}
    o.branches={}
    table.insert(o.branches,b.new(nil,true)) 
    o.branches[1].ang=math.pi/2
    o.branches[1].x=x
    o.branches[1].y=y
    
    o.report= t.report 
    o.getPos = t.getPos
    o.display = t.display
    o.grow= t.grow 
    o.tick = t.tick
    o.untick = t.untick
    
    return o
end

function t:grow(energy,dt)
    self.branches[1]:grow(energy,dt)
end

function t:tick()
    self.branches[1]:tick()
end

function t:untick()
    self.branches[1]:untick()
end

function t:display()
    return self.branches[1]:display()
end

function t:report()
    return self.branches[1]:report()
end

function t:getPos()
    return {x=self.x,y=self.y}
end

function findBranch(x,y,exc)
    bsort={}
    tree.report(tree)
    local dist= 9999999999
    local close = nil
    for i,v in ipairs(bsort) do
        if vl.dist(v.x,v.y,x,y) <= dist then
            if v==selectedB then
            else
                close = v
                dist = vl.dist(v.x,v.y,x,y)
            end
        end
    end
        
    
    return close
end

return t
