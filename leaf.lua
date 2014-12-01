leaf = {}

function leaf.new(bud)
    o = {}
    o.area = 1
    o.maxArea = math.random(species.minLeafArea,species.maxLeafArea)
    o.maxAge = math.random(1,species.leafAge)
    o.isGrowing = true
    o.isLeaf = true
    o.parent = bud.parent 
    o.ang = math.random()*math.pi*2
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
    local sproutLen = self.area/2
    local leafLen = self.area
    local leafX,leafY = vl.rotate(self.ang,sproutLen,0)
    leafX = leafX + x
    leafY = leafY + y
    local leafTX,leafTY = vl.rotate(self.ang,leafLen*3,0)
    leafTX = leafTX + x
    leafTY = leafTY + y
    local leafTX1,leafTY1 = vl.rotate(self.ang,leafLen*2,leafLen/2)
    leafTX1 = leafTX1 + x
    leafTY1 = leafTY1 + y
    local leafTX2,leafTY2 = vl.rotate(self.ang,leafLen*2,leafLen/-2)
    leafTX2 = leafTX2 + x
    leafTY2 = leafTY2 + y
    
    
    local r = math.sqrt(self.area)*8
    
    lg.setLineWidth(1)
    lg.setColor(colors.sprout)
    lg.line(x,y,leafX,leafY)
    lg.setColor(colors.leaf)
    lg.polygon("fill",leafX,leafY,leafTX1,leafTY1,leafTX,leafTY,leafTX2,leafTY2)
    --lg.circle("fill",leafX,leafY,r,10) --TODO: generator for leaf polygon shape
end

function leaf:drop()
    print("leaf died")
    self.isDead = true --TODO: dropping animation
end

return leaf
