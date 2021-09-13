local config = require("./Forge/config.lua")

-- Publish the DataModel to Roblox
local placeFilePath = remodel.readPlaceFile({...})[1]

if not placeFilePath then
    error("Expected a place file path as first argument")
end

remodel.writeExistingPlaceAsset(placeFilePath, config.AssetId)