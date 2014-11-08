require('registry')

function love.load()
    treeReset()    
    dataControl.load()
    gs.registerEvents()
    gs.switch(state.game)
end

function treeReset()
    --math.randomseed(os.time()) 
    math.randomseed(2) 
    tree=t.new(screen.w/2,screen.h)
end

function love.quit()
    dataControl.save()
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


--sunlight fluctuates over time to simulate seasons
--energy a function of (smaller of leaves, sunlight and root mass(water))
--total mass of the tree consumes some energy
--leaves will die if they are not needed (eg, less sunlight than they can absorb)
--leaves "closer" to the roots die first
--if no leaves then some of the rootmass can be consumed for energy, but only if there is less branch mass than root mass (cut a branch off to trigger)
--energy used to grow first leaves, then (root structure+branches) 
--roots + branch grow at the same time
--leaves grow if there is more potential for energy
--leaves grow only from new shoots
--growing leaves consume more energy

--graphical things
--leaf color determined by health
--display root mass as % of pot
