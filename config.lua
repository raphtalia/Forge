local success, config = pcall(function()
    return json.fromString(remodel.readFile("deployment.json"))
end)
if not success then
    error("Could not read deployment.json: " .. config)
end

local branchName = io.popen("git rev-parse --abbrev-ref HEAD"):read("*l")
local commitSHA = io.popen("git rev-parse HEAD"):read("*l")

local assetId
do
    local targetType = type(config.target)
    if targetType == "string" then
        assetId = config.target
    elseif targetType == "table" then
        assetId = config.target[branchName]

        if not assetId then
            error("Could not find asset ID for branch ".. branchName)
        end
    else
        error("Invalid targetType: ".. targetType)
    end
end

local paths = config.files
do
    local pathsType = type(paths)
    if pathsType ~= "table" then
        error("Invalid pathsType: ".. pathsType)
    end
end

return {
    Branch = branchName,
    Commit = commitSHA,
    AssetId = assetId,
    IncludeMetaData = config.includeMetaData,
    Paths = config.files,
}