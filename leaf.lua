leaf = {}

function leaf.new(bud)
    o = {}
    o.area = 1
    o.maxArea = math.random(species.minLeafArea,species.maxLeafArea)
    o.maxAge = math.random(1,species.leafAge)
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
    self.age = self.age + dt --TODO: age faster based on environmental factors
    
    if energy > 0 then
        if self.area < self.maxArea then
            local extraArea = energy/self.area/species.leafGrowthCost
            self.area = self.area + extraArea
            if self.area > self.maxArea then self.area = self.maxArea end
        else
            self.isGrowing = false
            --TODO: begin color change to yellow(or species seasonal color)
            --TODO: fully grown leaves are drawn to a canvas and are not rendered every frame (to increase possible leaf count once they are complex polygons)
        end
    end
    
    if self.age > self.maxAge then
        self:drop() 
    end
end

function leaf:draw()
    local x = self.parent.ex
    local y = self.parent.ey
    local r = math.sqrt(self.area)*8
    lg.setColor(colors.leaf)
    lg.circle("fill",x,y,r,10) --TODO: generator for leaf polygon shape
end

function leaf:drop()
    print("leaf died")
    self.isDead = true --TODO: dropping animation
end

return leaf
