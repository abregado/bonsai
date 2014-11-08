b = {}

local masscost=0.4
local gspeed=20

function b.new(parent,trunk,angle) 
  local o={} 
  --variables 
  b.clear(o)
  o.isTrunk=trunk
  if parent then 
    o.parent=parent 
    o.w=math.ceil(parent.w/6) 
    o.x=parent.ex
    o.y=parent.ey
    o.ex=o.x 
    o.ey=o.y
    
    if o.isTrunk then
      r = math.random(-1,1)/4
    else
      r = math.random(-1,1)/2
      if r<0 then
        r=r-0.2
      else
        r=r+0.2
      end
    end
    
    if not angle then angle = 0 end
    o.ang=parent.ang+r+angle+wind
  end 
  
  if o.isTrunk then
    o.maxWidth = s.t.w
  else
    o.maxWidth = s.b.w
  end
  
  
  --methods  
  
  if o.isTrunk then o.split = b.trunkSplit end
  
  --global data 
  total = total+1 
  return o 
end 

function b.clear(o)
  o.mass=0 
  o.isGrowing=true 
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

  o.report=b.report 
  o.getPos = b.getPos
  o.display = b.display
  o.knosper = b.knosper
  o.grow=b.grow 
  o.split=b.split
  o.tick = b.tick
  o.untick = b.untick
  o.prune = b.prune
  o.thicken = b.thicken
  o.splitC = b.splitC
  
  o.branches={} 
  
end

function b:prune(b,split)
    local t=nil
    for i,v in ipairs(self.branches) do
        if v==b then
            t=i
        end
    end
    if t then
        table.remove(self.branches,t)
        if split then self:splitC() end
    end
    
    if self.isTrunk then
        self:thicken()
    end

end

function b:split() 
  r=math.random()
  
  local thr = 0.5

  if r < thr then
    local b1 = b.new(self) 
    local b2 = b.new(self,false,b1.ang/10) 
    table.insert(self.branches,b1) 
    table.insert(self.branches,b2) 
    self.isGrowing = false
  else
    local b2 = b.new(self)
    table.insert(self.branches,b2) 
    self.isGrowing = false
  end
    
end 

function b:trunkSplit(double)
  r=math.random()
  
  local thr = 0.5

  if r < 0.1 then
    local b1 = b.new(self,double) 
    local b2 = b.new(self,double,b1.ang/10) 
    table.insert(self.branches,b1) 
    table.insert(self.branches,b2) 
    self.isGrowing = false
  
  elseif r < thr then
    local b1 = b.new(self,true) 
    local b2 = b.new(self,double,b1.ang/10) 
    table.insert(self.branches,b1) 
    table.insert(self.branches,b2) 
    self.isGrowing = false
  end
end

function b:splitC()
    local b1 = b.new(self,self.isTrunk) 
    local b2 = b.new(self,self.isTrunk,b1.ang/10) 
    table.insert(self.branches,b1) 
    table.insert(self.branches,b2) 
    self.isGrowing = false
end

function b:knosper()
  local b1 = b.new(self,self.isTrunk)
  table.insert(self.branches,b1)
  self.isGrowing = false
end

function b:report() 
  local l,w,m = self.l,self.w,self.l*self.w 
  --print("branch is "..self.w.." wide and "..self.l.." long") 
  for i,v in ipairs(self.branches) do 
    local b = v:report() 
    l=l+b.l 
    w=w+b.w 
    m=m+b.m 
  end 
  if #self.branches ==0 then
    table.insert(tips,self)
  end
  table.insert(bsort,self)
  return {l=l,w=w,m=m} 
end 

function b:display() 
  for i,v in ipairs(self.branches) do 
    v:display()
  end 
  lg.setLineWidth(self.w)
  if self.selected then
    lg.setColor(colors.selected)
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

function b:tick()
    self.selected=true
    for i,v in ipairs(self.branches) do
        v:tick()
    end
end

function b:untick()
    self.selected=false
    for i,v in ipairs(self.branches) do
        v:untick()
    end
end

function b:grow(energy,dt) 
  local r = energy 
  r=r-(self.mass*masscost)
  if r>0 then 
    for i,v in ipairs(self.branches) do 
      local rm = math.random(1.5,2.5) 
      v:grow(r/rm/#self.branches,dt) 
    end 

    r=math.random()
    if r<0.3 and self.mass > 100 and self.isGrowing then 
      self:split() 
    elseif r<0.025 and self.isGrowing then
      r=math.random()
      if r<0.3 and self.isTrunk then
        self:split(true)
      elseif r>0.8 and self.isTrunk then
        --nothing
      elseif r<0.01 and not self.isTrunk then
        self.isGrowing=false
      elseif r<0.5 then
        self:split()  
      else
        self:knosper()
      end
    end

    if self.l > 100 and self.isGrowing then
      self:split()
    end

    if self.isGrowing then 
      self.l = self.l + (10*gspeed*dt) 
      self.w = self.w + (0.1*gspeed*dt) 
    elseif self.w < self.maxWidth then 
      self.w = self.w + (0.2*gspeed*dt)
    end 
     local o= math.sin(self.ang)*self.l 
      local a= math.cos(self.ang)*self.l 
      self.ex=self.x+a
      self.ey=self.y-o
      
      self.mass=self.l*self.w 
  end 
  
  self.age = self.age +dt 
 

end 

function b:thicken()
    self.maxWidth = self.maxWidth*1.05
    if self.parent then
        self.parent:thicken()
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
