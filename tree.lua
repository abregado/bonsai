local t={}

local massCost = 20

species = {
    minBranchLength = 60,
    maxBranchLength = 100,
    bendyness = 2,
    minThickness = 3,
    maxThickness = 40,
    budCost = 1,
    leafCost = 2,
    branchCost = 100,
    lengthCost = 0.1,
    widthCost = 0.2,
    minLeafArea = 10,
    maxLeafArea = 25,
    leafGrowthCost = 2,
    leafEnergy = 2,
    rootEnergy = 1,
    potSize = 20000,
    leafAge = 50,
    knosperChance = 20,
    branchSurvivalRate = 40,
    minSun = 2
}

--TODO: species branch, trunk and leaf colors
--TODO: species seasonal change functions
--TODO: species seasonal growth pattern functions


    
        

function t.new(x,y)
    o={}
    
    
    o.branches={}
    
    o.mass = 0
    o.rootMass = 2
    o.growingBranches = 0
    o.growingLeaves = 0
    o.leaves = {}
    o.buds = {}
    o.lack = "default lack"
    o.lastEnergy = 0
    o.lastMaint = 0
    o.leafArea = 0
    o.x = x
    o.y = y
    
    
    t.addFirstBranch(o,x,y)
    
    o.getPos = t.getPos
    o.display = t.display
    o.grow= t.grow 
    o.updateStats = t.updateStats
    o.countGrowingBranches = t.countGrowingBranches
    o.countGrowingLeaves = t.countGrowingLeaves
    o.addRootMass = t.addRootMass
    o.findEnergy = t.findEnergy
    o.findBranch = t.findBranch
    o.totalLeafArea = t.totalLeafArea
    o.convertBudtoBranch = t.convertBudtoBranch
    o.growLeaves = t.growLeaves
    o.convertBudstoLeaves = t.convertBudstoLeaves
    o.convertEnergytoBuds = t.convertEnergytoBuds
    o.convertBudstoBranches = t.convertBudstoBranches
    o.growBranches = t.growBranches
    o.untickAll = t.untickAll
    o.tick = t.tick
    o.drawPot = t.drawPot
    
    return o
end

function t:drawPot(x,y,color)
    lg.setColor(color)
    local pot = {x=x-80,y=y}
    lg.rectangle("fill",pot.x,pot.y,potW,potH)
    lg.rectangle("fill",pot.x-20,pot.y,potW+40,potH/5)
    lg.rectangle("fill",pot.x+10,pot.y+potH,potW/5,potH/10)
    lg.rectangle("fill",pot.x+potW-60,pot.y+potH,potW/5,potH/10)
end

function t.addFirstBranch(o,x,y)
    local newBranch = branch.new(bud.new())
    table.insert(o.branches,newBranch)
    o.branches[1].tree = o 
    o.branches[1].ang=math.pi/2
    o.branches[1].x=x
    o.branches[1].y=y
    o.branches[1].isTrunk=true
    local newBud = bud.new(o.branches[1])
    --local newLeaf = leaf.new(bud.new(o.branches[1]))
    --table.insert(o.leaves,leaf.new(newBud))
end

function t:addRootMass(mass)
    if mass > 0 then
        if self.rootMass < species.potSize then
            self.rootMass = self.rootMass + mass
        end
    else
        print("Negative rootmass growth")
    end
end

function t:convertBudtoBranch(bud)
    table.remove(self.buds,bud)
    local newBranch = branch.new(bud)
    table.insert(self.branches,newBranch)
end

function t:totalLeafArea()
    local result = 0
    for i,v in ipairs(self.leaves) do
        result = result + v.area
    end
    return result
end

function t:findEnergy()
    local rootEnergy = self.rootMass * species.rootEnergy
    local leafEnergy = (self.leafArea+10) * species.leafEnergy * environment.sunMod 
    
    if rootEnergy < leafEnergy then
        return "roots energy low", rootEnergy
    else
        return "leaf energy low", leafEnergy
    end

end

function t:growLeaves(energy,dt)
    --consumes all energy to grow leaves. If all leaves becomes grown because of this, the energy is wasted
    if self.leafEnergy < self.rootEnergy and environment.sunMod > species.minSun then
        local rEnergy = energy - (energy*0.5)
        energy = energy - rEnergy
        local rEnergy = self:convertBudstoLeaves(energy/2,dt)
        
    else
        rEnergy = energy
    end
    
    if #self.leaves == 0 and environment.sunMod > species.minSun then
        rEnergy = self:convertBudstoLeaves(energy,dt,true)
    else 
        local energyPerLeaf = (energy+rEnergy)/#self.leaves
        for i,v in ipairs(self.leaves) do
            if v.isGrowing then v:grow(energyPerLeaf,dt) else v:grow(0,dt) end
        end
        return 0
    end
    return rEnergy
end

function t:growBranches(energy,dt)
    if self.growingBranches < #self.leaves and self.leafEnergy < self.rootEnergy then 
        energy = self:convertBudstoBranches(energy)
    end

    local energyPerBranch = energy/#self.branches
    for i,v in ipairs(self.branches) do
        v:grow(energyPerBranch,dt)
    end
end

function t:convertBudstoLeaves(energy,dt,override)
    --uses energy to change buds into leaves. Returns the remaining energy.
    if (energy > (species.leafCost*dt) and #self.buds > 0 and #self.leaves < (#self.branches)) or (override and #self.buds>0) then
        --making a new leaf from bud
        r = math.random(1,#self.buds)
        local chosenBud = self.buds[r]
        --TODO: disable leaves growing on trunks unless the segment is on the end
        if override then
            local newLeaf = leaf.new(chosenBud)
            table.insert(self.leaves,newLeaf)
            table.remove(self.buds,r)
        elseif chosenBud.parent.isGrowing then
            local newLeaf = leaf.new(chosenBud)
            table.insert(self.leaves,newLeaf)
            table.remove(self.buds,r)
            energy = energy - (species.leafCost*dt)
        elseif chosenBud.parent.parent and chosenBud.parent.parent.isTrunk == false then
            local newLeaf = leaf.new(chosenBud)
            table.insert(self.leaves,newLeaf)
            table.remove(self.buds,r)
            energy = energy - (species.leafCost*dt)
        else
            local newLeaf = leaf.new(chosenBud)
            table.insert(self.leaves,newLeaf)
            table.remove(self.buds,r)
            energy = energy - (species.leafCost*dt)
        end
    elseif #self.buds == 0 then
        --no buds to make into leaves
        energy = self:convertEnergytoBuds(energy,dt)
    else
        --not enough energy for a leaf
    end
    return energy
end

function t:convertEnergytoBuds(energy,dt)
    --uses energy to create new buds. Returns the remaining energy.
    if energy > (species.budCost*dt) and #self.buds < (#self.branches+#self.leaves) then
        --making a new bud
        local r = math.random(1,#self.branches)
        local chosenBranch = self.branches[r]
        local newBud = bud.new(chosenBranch)
        table.insert(self.buds, newBud)
        energy = energy - (species.budCost*dt)
    else
        --not enough energy for a new bud
    end
    return energy
end

function t:convertBudstoBranches(energy)
    --uses energy to change buds into branches until there are no buds or energy is less than branch cost. Returns the remaining energy.
    
        if energy > species.branchCost and #self.buds > 0 then
            --local r = math.random()
            --while energy > species.branchCost and #self.buds > 0 do
                r = math.random(1,#self.buds)
                local chosenBud = self.buds[r]
                local newBranch = branch.new(chosenBud)
                table.insert(self.branches,newBranch)
                table.remove(self.buds,r)
                energy = energy - species.branchCost
           -- end
        end
    
    return energy
end
        

function t:grow(dt)
    self:updateStats()
    local lack,energy = self:findEnergy()
    self.lack = lack
    energy = energy * dt
    
    if energy > 0 then --TODO: add condition to only grow when the season is correct (sunlight is above potential energy)
        local leafGrowth = energy*0.8
        local branchGrowth = energy - leafGrowth
        leafGrowth = self:growLeaves(energy/2,dt)
        if self.rootMass < species.potSize or self.mass < self.rootMass then
            self:growBranches(energy/2,dt)
        else
            self:growBranches(energy/100,dt)
            self:convertEnergytoBuds(energy/2,dt)
        end
        --TODO: return unused energy, aka if there is nothing to grow
    end
    
    --TODO: Check for unused energy. grow fruit, which is very expensive to begin, and soaks up a lot of energy
    
    for i,v in ipairs(self.branches) do
        if not t.checkFor(v.parent,self.branches) and i > 1 then
            v.isDead = true
        end
    end
    
    for i,v in ipairs(self.leaves) do
        if not t.checkFor(v.parent,self.branches) then
            v.isDead = true
        end
    end
    for i,v in ipairs(self.buds) do
        if not t.checkFor(v.parent,self.branches) then
            v.isDead = true
        end
    end
    
    for i,v in ipairs(self.leaves) do
        if v.isDead then
            table.remove(self.leaves,i)
        end
    end
    
    for i,v in ipairs(self.branches) do
        if v.isDead then
            table.remove(self.branches,i)
        end
    end
    
    for i,v in ipairs(self.buds) do
        if v.isDead then
            table.remove(self.buds,i)
        end
    end
    
end

function t.checkFor(obj,array)
    for i,v in ipairs(array) do
        if v == obj then
            return true
        end
    end
    return false
end

function t:tick()
    self.branches[1]:tick()
end

function t:untick()
    self.branches[1]:untick()
end

function t:display()
    for i,v in ipairs(self.branches) do
        v:display(energy,dt)
    end
    
    if not selectedB then
        for i,v in ipairs(self.leaves) do
            v:draw()
        end
    end
    
    self:drawPot(self.x,self.y,colors.pot)
    
    
end

function t:report()
    return true
end

function t:updateStats()
    local mass = 0
    for i,v in ipairs(self.branches) do
        mass = mass + v.mass
    end
    self.mass = mass
    
    
    self.leafArea = self:totalLeafArea()
    
    self.rootEnergy = self.rootMass * species.rootEnergy
    self.leafEnergy = (self.leafArea+10) * species.leafEnergy * environment.sunMod 
    
    self:countGrowingBranches()
    self:countGrowingLeaves()
end

function t:countGrowingBranches()
    local count = 0
    for i,v in ipairs(self.branches) do
        if v.isGrowing then count = count +1 end
    end
    self.growingBranches = count
    return count
end


function t:countGrowingLeaves()
    local count = 0
    for i,v in ipairs(self.leaves) do
        if v.isGrowing then count = count +1 end
    end
    self.growingLeaves = count
    return count
end

function t:getPos()
    return {x=self.x,y=self.y}
end

function t:tick(tickBranch)
    selectedB = tickBranch
    local ind = 1
    for i,v in ipairs(self.branches) do
        if v == tickBranch then
            ind = i
            v.selected = true
        end
    end
    for i,v in ipairs(self.branches) do
        if v.parent and v.parent.selected then
            v.selected = true
        end
    end
end

function t:untickAll()
    for i,v in ipairs(self.branches) do
        v.selected = false
    end
end

function t:findBranch(x,y,exc)

    local dist= 9999999999
    local close = nil
    for i,v in ipairs(self.branches) do
        local vDist = vl.dist(v.x,v.y,x,y)
        if vDist <= dist then
            if v==selectedB then
                --this is the selected one so do nothing
            else
                close = v
                dist = vDist
            end
        end
    end
        
    
    return close
end

return t
