local config = load(remodel.readFile("Forge/config.lua"))()

for i,v in pairs(config) do
    print(i,v)
end

-- Publish the DataModel to Roblox
local dataModel = remodel.readPlaceFile(({...})[1])

if not dataModel then
    error("Expected a place file path as first argument")
end

remodel.writeExistingPlaceAsset(dataModel, config.AssetId)