local config = load(remodel.readFile("Forge/config.lua"))()
local assetId = config.AssetId

if not assetId then
    error("Could not find asset ID for branch ".. config.Branch)
end

-- Publish the DataModel to Roblox
local dataModel = remodel.readPlaceFile(({...})[1])

if not dataModel then
    error("Expected a place file path as first argument")
end

remodel.writeExistingPlaceAsset(dataModel, assetId)