DEBUG_MODE = false

if DEBUG_MODE then
    require('lovedebug')
end

lg=love.graphics
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


rawData = {}

--gamestates
state={
    game = require('state_game')
}

screen={w=lg.getWidth(),h=lg.getHeight()}
yearTime = 600
environment = {sunMod=1,state=1,minSun=3,maxSun=10}
sunTween = tw.new(yearTime,environment,{sunMod=environment.maxSun},'linear')
id=0

bsort={}
selectedB=nil

wind = 0

s={}
s.t={w=10}
s.b={w=6}

mTime=0
mPos={x=0,y=0}
r=math.random()



total = 0 
tips={}
cav = lg.newCanvas()

colors={}
colors.trunk = {85,29,0}
colors.branch = {128,57,21}
colors.sprout = {170,95,57}
colors.selected = {187,0,18}
colors.leaf = {0,255,0}
