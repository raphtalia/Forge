local config = load(remodel.readFile("Forge/config.lua"))()

for i,v in ipairs({...}) do
    print(i, v)
end

-- Publish the DataModel to Roblox
local placeFilePath = remodel.readPlaceFile(({...})[1])

if not placeFilePath then
    error("Expected a place file path as first argument")
end

remodel.writeExistingPlaceAsset(placeFilePath, config.AssetId)