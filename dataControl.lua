fs = love.filesystem

dataControl = {}

--savefile should be in the registry
saveFile,fileError = fs.newFile("tree2.txt")

function dataControl.draw()
    if DEBUG_MODE then
        love.graphics.setColor(0,255,0)
        love.graphics.print("Debug:",0,0)
        local y = 30
        for name,data in pairs(rawData) do
            love.graphics.print(name..": "..tostring(data),0,y)
            y=y+30
        end
    end
end

function dataControl.save()
    local data = {}
    data.branches = {}
    
    for i,v in ipairs(tree.branches) do
        dataControl.saveBranch(data.branches,v)
    end
    
    data.rootMass = tree.rootMass
    
    

    
    if saveFile:open("w") then
        local raw = serialize(data)
        rawData.saved = raw
        saveFile:write(raw)
        saveFile:close()
    end
end

function dataControl.saveBranch(data,b)
    local nb = {}
    nb.x = b.x
    nb.y = b.y
    nb.w = b.w
    nb.l = b.l
    nb.ang = b.ang
    nb.maxWidth = b.maxWidth
    nb.isGrowing = b.isGrowing
    nb.splitChance = b.splitChance
    nb.survivalRate = b.survivalRate
    nb.isFirst = b.isFirst
    nb.isTrunk = true
    
    table.insert(data,b)    
end

function dataControl.loadBranches(b)
    
    tree.branches={}
    
    for i,v in ipairs(b) do  
        table.insert(tree.branches,branch.import(v))
    end
    
    for i,v in ipairs(tree.branches) do
        v.parent = tree:findBranchEnd(v.x,v.y)
    end
    
    
        
end


function dataControl.load()
    if saveFile:open("r") then
        local raw = saveFile:read()
        local data = deserialize(raw)
        
        tree.branches = {}
        
        dataControl.loadBranches(data.branches)
        
        tree.rootMass = tonumber(data.rootMass)
        
        rawData.loaded = raw
        
        saveFile:close()
    end
end

return dataControl
