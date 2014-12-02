DEBUG_MODE = true

if DEBUG_MODE then
    require('lovedebug')
end

lg=love.graphics
la = love.audio
vl=require('hump-master/vector-light')
tw=require('tween')
branch = require('branch')
leaf = require('leaf')
bud = require('bud')
t= require('tree')
button = require('button')
gs = require('hump-master/gamestate')
dataControl = require('dataControl')
require('serialize')
viewTool = require('tool_view')
pruneTool = require('tool_prune')
sawTool = require('tool_saw')
debudTool = require('tool_debud')

storedTime = 0

fontD = lg.newFont()
rawData = {}
rawData.saved = "empty saved"
rawData.loaded = "empty loaded"

screen={w=lg.getWidth(),h=lg.getHeight()}
res = screen

buttonWidth = res.w/10

--gamestates
state={
    game = require('state_game'),
    toolbox = require('state_toolbox')
}



yearTime = 300
environment = {sunMod=0.5,state=1,minSun=0.5,maxSun=5}
sunTween = tw.new(yearTime,environment,{sunMod=environment.maxSun},'linear')
sunTween:set(yearTime/2)
id=0

bsort={}
selectedB=nil

wind = 0

s={}
s.t={w=10}
s.b={w=6}


potW = res.w/5
potH = 80
Xoff = 110
mTime=0
mPos={x=0,y=0}
r=math.random()



as = {}
as.saw = lg.newImage("assets/hand-saw.png")
as.scissors = lg.newImage("assets/scissors.png")
as.chest = lg.newImage("assets/locked-chest.png")
as.nuke = lg.newImage("assets/mass-driver.png")
as.tick = lg.newImage("assets/tick.png")
as.cancel = lg.newImage("assets/cancel.png")
as.back = lg.newImage("assets/back-arrow.png")
as.repot = lg.newImage("assets/repot.png")
as.leaf = lg.newImage("assets/falling-leaf.png")
as.time = lg.newImage("assets/sands-of-time.png")
as.buds = lg.newImage("assets/buds.png")

sfx = {}
sfx.blip = la.newSource("assets/coin.wav","static")

music = la.newSource("assets/music.ogg")
music:setLooping(true)

la.setVolume(0.1)



total = 0 
tips={}
cav = lg.newCanvas()

colors={}
colors.trunk = {85,29,0}
colors.branch = {128,57,21}
colors.sprout = {170,95,57}
colors.bud = {255,0,0}
colors.selected = {187,0,18}
colors.leaf = {0,255,0,125}
colors.pot = {0,125,250}
colors.toolboxBG = {90,90,90}

tools = {
    view = viewTool.init(),
    saw = sawTool.init(),
    debud = debudTool.init(),
    prune = pruneTool.init()
}

currentTool = tools.view
