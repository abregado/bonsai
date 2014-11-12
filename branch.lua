b = {}

local masscost=0.4
local gspeed=20

function b.new(bud) 
    local o={} 
    --variables 
    b.clear(o)
    
    o.isBranch = true
    o.tree = bud.tree
    if bud.parent then
        o.parent = bud.parent
        o.splitChance = bud.parent.splitChance+((100-bud.parent.splitChance)*0.1)
        o.survivalRate = bud.parent.survivalRate*0.99
        if o.survivalRate < species.branchSurvivalRate then o.survivalRate = species.branchSurvivalRate end 
        o.maxWidth = bud.parent.maxWidth * 0.8
        
    else
        o.parent = nil
        o.maxWidth = species.maxThickness
        o.splitChance = species.knosperChance
        o.survivalRate = 105
    end
    
    if o.maxWidth < species.minThickness then o.maxWidth = species.minThickness end
    o.w=1 
    o.x=bud.ex
    o.y=bud.ey
    o.ex=o.x 
    o.ey=o.y
    
    o.sproutLength = math.random(species.minBranchLength,species.maxBranchLength)
    local r = math.random(-1,1)/species.bendyness
    if r < 0 then r = r-0.2 else r = r+0.2 end
    o.ang = bud.ang+r

    return o 
end 

function b.clear(o)
  o.mass=3 
  o.isGrowing=true 
  o.age=0 
  o.w=3 
  o.x=0 
  o.y=0 
  o.ex=0 
  o.ey=0 
  o.ang=0
  o.maxWidth = species.maxThickness
  o.l=0.1 
  
  o.id=id
  id=id+1

  o.getPos = b.getPos
  o.lengthen = b.lengthen
  o.widen = b.widen
  o.thicken = b.thicken
  o.display = b.display
  o.knosper = b.knosper
  o.grow=b.grow 
  
end

function b:knosper() 
    -- this segment is finished growing. 
    -- random chance to finish growing
    -- if continuing, always spawn one new branch segment
    -- chance for second segment
    
    local rp = math.random()*100
    if rp < self.survivalRate then
        local nb = branch.new(bud.new(self))
        nb.isTrunk = self.isTrunk
        table.insert(self.tree.branches,nb)
        rp = math.random()*100
        if rp < self.splitChance then
            nb = branch.new(bud.new(self,true))
            table.insert(self.tree.branches,nb)
        else
            table.insert(self.tree.buds,bud.new(self))
        end
    else
        table.insert(self.tree.buds,bud.new(self))
        table.insert(self.tree.buds,bud.new(self))
    end
    
    self.isGrowing = false
end

function b:display(colorOverride) 

    lg.setLineWidth(self.w)
    if colorOverride then
        lg.setColor(colorOverride)
    else
        if self.isTrunk then
            lg.setColor(colors.trunk)
        elseif self.isGrowing then
            lg.setColor(colors.sprout)
        else
            lg.setColor(colors.branch)
        end
    end

    lg.line(self.x,self.y,self.ex,self.ey)
    lg.circle("fill",self.x,self.y,self.w/1.5,20)
end 

function b:lengthen(energy)
    local extraLength = energy/self.mass/species.lengthCost
    self.l = self.l + extraLength
    local newMass = extraLength*self.w
    self.tree:addRootMass(newMass)
end

function b:widen(energy)
    if self.w < self.maxWidth then
        local extraWidth = energy/self.mass/species.widthCost
        if self.isTrunk then
            extraWidth = extraWidth *3
        end
        self.w = self.w + extraWidth
        local newMass = extraWidth*self.l
        self.tree:addRootMass(newMass)
    end
end

function b:grow(energy,dt) 

    --self.age = self.age +dt 
    if energy > 0 then
    
        if self.isGrowing and self.l > self.sproutLength then
            --knosper (creates two buds, and turns one into a branch)
            self:knosper(energy)
        elseif self.isGrowing then
            --increase length
            self:lengthen(energy/40*39)
            self:widen(energy/40)
        else
            --branch is not growing, but can still get wide
            self:widen(energy)
            --increase width (up to max), using a quarter of the energy
        end
    end
    
    
    self.mass = self.w*self.l
    
    local o= math.sin(self.ang)*self.l 
    local a= math.cos(self.ang)*self.l 
    self.ex=self.x+a
    self.ey=self.y-o
    
    
end 

function b:thicken(modifier) --increase max width by a percentage
    self.maxWidth = self.maxWidth/100*(100+modifier)
    if self.parent then
        self.parent:thicken(modifier)
    end
end

function b:getPos()
  if self.parent then
    local p= self.parent:getPos()
    table.insert(p.x,self.x)
    table.insert(p.y,self.y)
    return p
  else
    return {x={self.x},y={self.y}}
  end
end

return b
