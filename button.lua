-- menu button to be added to button lists and stacked vertically

lg = love.graphics
lm = love.mouse


local button = {}

button.font = lg.newFont(30)

local colors = {}
colors.ready = {100,100,100}
colors.clicked = {185,0,0}
colors.hover = {255,255,255}
colors.bg = {20,20,20}
colors.font = {200,200,200}


function button.new(xin,yin,win)
	local o = {}
	o.x = xin
	o.y = yin
	o.w = win
	o.qbase = lg.newQuad(0,0,320,32,320,96)
	o.qhover = lg.newQuad(0,32,320,32,320,96)
	o.qclick = lg.newQuad(0,64,320,32,320,96)
    o.label = "Unlabeled Button"
    
    o.colors={}
    o.colors.ready = colors.ready
    o.colors.clicked = colors.clicked
    o.colors.hover = colors.hover
    o.colors.bg = colors.bg
    o.colors.font = colors.font
    
	o.click = button.click
	o.draw = button.draw
	o.check = button.check
	
	return o
end

function button:click()
	return true
end

function button:draw()
	local label = self.label
	lg.setColor(self.colors.bg)
    --lg.rectangle("fill",self.x,self.y,self.w,self.h)
    lg.circle("fill",self.x,self.y,self.w,40)
    lg.setColor(0,0,0)
    lg.circle("line",self.x,self.y,self.w,40)
    lg.circle("fill",self.x,self.y,self.w-10,40)
    local osString = love.system.getOS()
    if self:check() and osString ~= "Android" then
        if lm.isDown("l") then
		lg.setColor(self.colors.clicked)
		else
		lg.setColor(self.colors.hover)
		end
	else
		lg.setColor(self.colors.ready)
	end
    --lg.rectangle("fill",self.x+5,self.y+5,self.w-10,self.h-10)
    local iconScale = self.w/as.chest:getWidth()*1.25
    local iconOffset = as.chest:getWidth()*iconScale*0.5
    lg.draw(as.chest,self.x-iconOffset,self.y-iconOffset,0,iconScale,iconScale)
    lg.setColor(0,0,0,125)
    lg.setLineWidth(2)
    --lg.rectangle("line",self.x+5,self.y+5,self.w-10,self.h-10)
    lg.circle("line",self.x,self.y,self.w-10,40)
    
    lg.setLineWidth(1)
	lg.setColor(self.colors.font)
    local font = button.font
	lg.setFont(font)
    local tw = font:getWidth(label)
    local th = font:getHeight(label)
    --lg.print(label,self.x-(tw/2),self.y-(th/2))
	
    lg.setFont(fontD)
	
end

function button:check()
	local mx,my = lm.getPosition()
    local dist = vl.dist(mx,my,self.x,self.y)
    if dist <= self.w then
        return true
    else
        return false
    end
end

return button
