DEBUG_MODE = true

if DEBUG_MODE then
    require('lovedebug')
end

lg=love.graphics
vl=require('hump-master/vector-light')
tw=require('tween')
b = require('branch')
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
days = 500
sun = 90000
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
