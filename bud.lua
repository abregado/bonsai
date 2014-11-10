bud = {}

function bud.new(parent,freeRot)
    local o={} 
    bud.clear(o)

    if parent then 
        o.parent=parent 
        o.tree = parent.tree
        o.w=1
        o.x=parent.ex
        o.y=parent.ey
        o.ex=o.x 
        o.ey=o.y
            
        --[[r = math.random(-1,1)/2
        if r<0 then
        r=r-0.2
        else
        r=r+0.2
        end

        if not angle then angle = 0 end]]
        local r = 0
        if freeRot then r = math.random(-1,1)/species.bendyness*2 end
        o.ang=parent.ang + r
    end 

    return o 
end

function bud.clear(o)
  o.mass=1 
  o.isGrowing=false 
  o.isBud = true
  o.age=0 
  o.w=1 
  o.x=0 
  o.y=0 
  o.ex=0 
  o.ey=0 
  o.ang=0
  o.l=1 
  
  o.id=id
  id=id+1
  
end

return bud
