local config = load(remodel.readFile("Forge/config.lua"))()
local assetId = config.AssetId

if not assetId then
    error("Could not find asset ID for branch ".. config.Branch)
end

local args = {...}

-- Publish the DataModel to Roblox
local placeFilePath = remodel.readPlaceFile(args[1])
if not placeFilePath then
    error("Expected a place file path as first argument")
end

local assetId = args[2] or config.AssetId
if not assetId then
    error("Expected an asset id as second argument or in deployment config")
end

remodel.writeExistingPlaceAsset(placeFilePath, assetId)
