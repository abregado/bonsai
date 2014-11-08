fs = love.filesystem

dataControl = {}

--savefile should be in the registry
saveFile,fileError = fs.newFile("tree1.txt")

function dataControl.draw()
    if DEBUG_MODE then
        love.graphics.setColor(0,255,0)
        local y = 30
        for name,data in pairs(rawData) do
            love.graphics.print(name..": "..tostring(data),0,y)
            y=y+30
        end
    end
end

function dataControl.save()
    local data = {}
    
    --allocate variables to the data object here, that will be saved
    data.branches = tree.branches[1]
    --end variable alloation
    
    if saveFile:open("w") then
        saveFile:write(serialize(data))
        saveFile:close()
    end
end

function dataControl.load()
    if saveFile:open("r") then
        local raw = saveFile:read()
        local data = deserialize(raw)
        if type(data)=='table' then
        
            --allocate variables to load and where to assign them
            --where numbers are required use tonumber!! else BUGS
            tree.branches = data.branches
            --end variable allocation
            rawData = raw
        end
        saveFile:close()
    end
end

return dataControl
