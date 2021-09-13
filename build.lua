local config = load(remodel.readFile("Forge/config.lua"))()

local dataModels = {}

if #config.Paths > 0 then
    -- Read the place files into DataModels
    for i, fileParams in ipairs(config.Paths) do
        local path = fileParams.path
        local fileExt = path:sub(-5)

        if remodel.isFile(path) and fileExt == ".rbxl" or fileExt == ".rbxm" then
            table.insert(dataModels, remodel.readPlaceFile(path))
        elseif remodel.isDir(path) then
            local outputPath = i.. ".rbxl"
            os.execute(("rojo build --output %s %s"):format(outputPath, path))
            table.insert(dataModels, remodel.readPlaceFile(outputPath))
        end

        --[[
        local script = fileParams.script
        if script then

        end
        ]]
    end
else
    error("Expected 1 or more file paths")
end

local function findFirstChildOfClassAndName(parent, className, name)
    for _, child in ipairs(parent:GetChildren()) do
        if child.ClassName == className and child.Name == name then
            return child
        end
    end
end

local function mergeChildren(parent1, parent2)
    for _,child2 in ipairs(parent2:GetChildren()) do
        local child1 = findFirstChildOfClassAndName(parent1, child2.ClassName, child2.Name)
        if child1 then
            mergeChildren(child1, child2)
        else
            child2.Parent = parent1
        end
    end
end

local function mergeDataModels(dataModel1, dataModel2)
    -- Transfer services if DataModel1 is missing services that DataModel2 has
    for _,service in ipairs(dataModel2:GetChildren()) do
        if not dataModel1:FindFirstChildOfClass(service.ClassName) then
            service.Parent = dataModel1
        end
    end

    for _,service1 in ipairs(dataModel1:GetChildren()) do
        local service2 = dataModel2:FindFirstChildOfClass(service1.ClassName)

        if service2 then
            for _,child2 in ipairs(service2:GetChildren()) do
                local child1 = findFirstChildOfClassAndName(service1, child2.ClassName, child2.Name)
                if child1 then
                    print("Merging", child2:GetFullName())
                    mergeChildren(child1, child2)
                else
                    print("Copying", child2:GetFullName())
                    child2.Parent = service1
                end
            end
        end
    end
end

-- Merge all the DataModels in order of arguments
while #dataModels > 1 do
    mergeDataModels(dataModels[#dataModels - 1], table.remove(dataModels, #dataModels))
end

local dataModel = dataModels[1]

if config.IncludeMetadata then
    print("Adding metadata")

    -- Add commit metadata to the DataModel
    local metadata = Instance.new("ModuleScript")
    metadata.Name = "_GithubMetadata"
    remodel.setRawProperty(
        metadata,
        "Source",
        "String",
        [[
            return {
                Branch = "]] .. config.Branch .. [[",
                Commit = "]] .. config.Commit .. [[",
            }
        ]]
    )
    metadata.Parent = dataModel:GetService("ReplicatedStorage")
end

remodel.writePlaceFile(dataModel, ({...})[1] or "output.rbxl")