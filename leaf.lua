leaf = {}

function leaf.new(bud)
    o = {}
    o.area = 1
    o.maxArea = math.random(species.minLeafArea,species.maxLeafArea)
    o.isGrowing = true
    o.isLeaf = true
    o.parent = bud.parent 
    o.age = 0
    
    o.grow = leaf.grow
    o.draw = leaf.draw
    o.drop = leaf.drop
    
    return o
end


function leaf:grow(energy,dt)
    self.age = self.age + dt
    
    if energy > 0 then
        if self.area < self.maxArea then
            local extraArea = energy/self.area/species.leafGrowthCost
            self.area = self.area + extraArea
            if self.area > self.maxArea then self.area = self.maxArea end
        else
            self.isGrowing = false
        end
    end
    
    if self.age > species.leafAge then
        self:drop()
    end
end

function leaf:draw()
    local x = self.parent.ex
    local y = self.parent.ey
    local r = math.sqrt(self.area)*5
    lg.setColor(colors.leaf)
    lg.circle("fill",x,y,r,10)
end

function leaf:drop()
    print("leaf died")
    self.isDead = true
end

return leaf
