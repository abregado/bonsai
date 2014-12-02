require('registry')

function love.load()
    initTools()
    treeReset()    
    --dataControl.load()
    gs.registerEvents()
    gs.switch(state.game)
end

function treeReset()
    math.randomseed(os.time()) 
    tree=t.new(screen.w/2,screen.h-100)
    for i=0,1000 do
        tree:grow(.2)
    end
end

function treeLoad()
    treeReset()
    tree.leaves = {}
    tree.buds = {}
    tree.branches = {}
    dataControl.load()
end

function treeSave()
    dataControl.save()
end

function love.quit()
    --dataControl.save()
end

function initTools()
    for i,v in ipairs(tools) do
        v:init()
    end
end

function tobool(v)
    return v and ( (type(v)=="number") and (v==1) or ( (type(v)=="string") and (v=="true") ) )
end

--load/save on restart
--button to grow a new tree
--playback on load
--amount of playback based on multiple of time since last save

--player effects on the tree
--wind direction and power
--button to open toolbox state, and when a tool is selected, the same button is to put the tool away
--player can place the tree in shade or add a lamp to effect (but not control) the sunlight
--pot size effect maximum root mass (which indirectly effects maximum branch mass
--new tree starts in small pot, season is randomised


--leaves grow from buds further from the trunk
--branches grow preferentially from the trunk
--trunk gets thicker at base

--graphical things
--leaf color determined by health
--display root mass as % of pot
