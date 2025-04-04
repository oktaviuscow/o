local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
--local MarketplaceService = game:GetService("MarketplaceService")
--local gamename = MarketplaceService:GetProductInfo(game.PlaceId).Name


local Window = Library:CreateWindow({
    Title = "Apel Hub",
    SubTitle = tostring("Anime Kingdom"),
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 400),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Resize = true, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
    MinSize = Vector2.new(250, 250),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})


local Tabs = {
    Credits = Window:CreateTab({Title = "Credits", Icon = "book"}),
    Farm = Window:CreateTab({ Title = "Farming", Icon = "align-center" }),
    --Gamemodes = Window:CreateTab({Title = "Card Gamemode", Icon = "credit-card"}),
    --Trials = Window:CreateTab({Title = "Trial", Icon = "apple"}),
    --Portals = Window:CreateTab({Title = "Portals", Icon = "globe"}),
    Eggs = Window:CreateTab({Title = "Eggs", Icon = "egg"}),
    --AutoBuy = Window:CreateTab({Title = "Auto Buy", Icon = "shopping-cart"}),
    --Rerolls = Window:CreateTab({Title = "Auto Rolls", Icon = "refresh-ccw"}),
    --Teams = Window:CreateTab({Title = "Teams", Icon = "users"}),
    Misc = Window:CreateTab({Title = " Misc", Icon = "diamond"}),
    Settings = Window:CreateTab({ Title = "Settings", Icon = "settings" }),

}

Tabs.Credits:CreateParagraph("Aligned Paragraph", {
    Title = "Discord",
    Content = "https://discord.gg/4gDAbj2VXG\n Dev - Apelsinka",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

Tabs.Credits:CreateButton({
    Title = "Copy Discord link",
    Description = "Click it",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center,
    Callback = function()
        local link = "https://discord.gg/4gDAbj2VXG"
        setclipboard(link)
    end
})


local Options = Library.Options
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character
    local bb=game:service'VirtualUser'
    game:service'Players'.LocalPlayer.Idled:connect(function()
    bb:CaptureController()bb:ClickButton2(Vector2.new())end)

folderName = "Apel Hub"
PositionfileName = "Saved Position.txt"
WorldfileName = "Saved World.txt"    
PositionfolderPath = folderName .. "\\" .. PositionfileName
WorldfolderPath = folderName .. "\\" .. WorldfileName

-- Проверяем, существует ли папка
if not isfolder(folderName) then
    makefolder(folderName)  -- Создаем папку, если она не существует
    print("Папка '" .. folderName .. "' была создана.")
else
    print("Папка '" .. folderName .. "' уже существует.")
end

-- Проверяем, существует ли файл
if not isfile(PositionfolderPath) or not isfile(WorldfolderPath) then
    local positionforsave = "139.8529052734375, 377.14923095703125, 3295.7548828125"
    local worldforsave = "Piece Village"
    if not isfile(PositionfolderPath) then
    writefile(PositionfolderPath, tostring(positionforsave))
    end
    if not isfile(WorldfolderPath) then
    writefile(WorldfolderPath, worldforsave)
    end
    print("Файл '" .. PositionfileName.."and"..WorldfileName .. "' был создан и записан.")
else
    print("Файл '" .. PositionfileName.."and"..WorldfileName .. "' был создан и записан.")
end


do

    --[[local AutoClick = Tabs.Misc:CreateToggle("Auto Click", {Title = "Auto Click", Default = false, Description = ""})

    AutoClick:OnChanged(function(State)-- Auto Click
        getgenv().AutoClicking = State
        while getgenv().AutoClicking == true do
            if not getgenv().AutoClicking == true then return end
                task.wait(0.01)
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer("Enemies", "World", "Click")
        end
    end)]]


    local EnemiesFolder = workspace._ENEMIES.Client
    local ServerEnemiesFolder = workspace._ENEMIES.Server
    local Enemies = {}
        local nameSet = {}
        local EnemyDrop = {}
        if EnemiesFolder then
            for _, enemy in ipairs(EnemiesFolder:GetChildren()) do
                local enemyname = enemy.Name
                if enemyname and not nameSet[enemyname] then
                    table.insert(Enemies, enemyname)
                    nameSet[enemyname] = true
                end
            end

            for i, v in pairs(ServerEnemiesFolder:GetDescendants()) do
                if v and not nameSet[v:GetAttribute("Id")] then
                    if table.find(Enemies, v.Name) then
                        table.insert(EnemyDrop, v:GetAttribute("Id"))
                        nameSet[v:GetAttribute("Id")] = true
                    end
                end
            end
        end
    
    local EnemyDropdown = Tabs.Farm:CreateDropdown("Enemy", {Title = "Enemy Selector", Description = "Select enemy for farm", Values = EnemyDrop, Multi = true, Default = {}})

    local CurrentEnemy = {}
    EnemyDropdown:OnChanged(function(Value)
        for Value, State in next, Value do
            table.insert(CurrentEnemy, Value)
        end
    end)

    function EnemyDropdown:GetSelectedValues()
        local selected = {}
        for value, state in pairs(self.Value) do
            if state then
                table.insert(selected, value)
            end
        end
        return selected
    end

    local function RefreshEnemyDropdownWithNewEnemies()
        local Enemies = {}
        local nameSet = {}
        local EnemyDrop = {}
        if EnemiesFolder then
            for _, enemy in ipairs(EnemiesFolder:GetChildren()) do
                local enemyname = enemy.Name
                if enemyname and not nameSet[enemyname] then
                    table.insert(Enemies, enemyname)
                    nameSet[enemyname] = true
                end
            end

            for i, v in pairs(ServerEnemiesFolder:GetDescendants()) do
                if v and not nameSet[v:GetAttribute("Id")] then
                    if table.find(Enemies, v.Name) then
                        table.insert(EnemyDrop, v:GetAttribute("Id"))
                        nameSet[v:GetAttribute("Id")] = true
                    end
                end
            end
        end
        EnemyDropdown:SetValues(EnemyDrop)
    end
    Tabs.Farm:CreateButton({
        Title = "Refresh Enemies",
        Description = "Update Enemies Dropdown with your current enemies on map",
        Callback = function()
            RefreshEnemyDropdownWithNewEnemies()
        end
    })

    local function containsValue(value, table)
        for _, v in ipairs(table) do
            if v == value then
                return true
            end
        end
        return false
    end


    local teleportRadius = 10
    local teleportRadiusForPet = 20
    

    local function findHumanoidRootPart()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                return rootPart
            end
        end
    end

    local function findNearestEnemy(selectedEnemies)
        local closestEnemy = nil
        local closestDistance = math.huge
        local rootPart = findHumanoidRootPart()


            for _, enemy in pairs(ServerEnemiesFolder:GetDescendants()) do
                if enemy:IsA("Part") and tonumber(enemy:GetAttribute("HP")) > 0 then
                    local distance = (rootPart.Position - enemy.Position).Magnitude
        
                    if containsValue(enemy:GetAttribute("Id"), selectedEnemies) and distance < closestDistance then
                        closestDistance = distance
                        closestEnemy = enemy
                    end
                end
            end

    
        return closestEnemy
    end

    local function findNearestEnemyWithoutContains()
        local closestEnemy = nil
        local closestDistance = math.huge
        local rootPart = findHumanoidRootPart()
            for _, enemy in pairs(ServerEnemiesFolder:GetDescendants()) do
                if enemy:IsA("Part") and tonumber(enemy:GetAttribute("HP")) > 0 then
                    if rootPart then
                        local distance = (rootPart.Position - enemy.Position).Magnitude
            
                        if distance < closestDistance then
                            closestDistance = distance
                            closestEnemy = enemy
                        end
                    end
                end
            end

    
        return closestEnemy
    end

    local function getEquipedPets()
        local EquipedPets = {}
        local player = game:GetService("Players").LocalPlayer
    
        for _, value in ipairs(workspace._PETS:FindFirstChild(tostring(player.UserId)):GetChildren()) do
            local info = value.Name
            if info then
                table.insert(EquipedPets, value.Name)
            else
                print("Player не найден в Info.")
            end
        end
        return EquipedPets
    end

    local function teleportMeToNearestEnemyWithContains()
        local selectedEnemies = {}
        for _, value in ipairs(EnemyDropdown:GetSelectedValues()) do
            table.insert(selectedEnemies, value)
        end
        local rootPart = findHumanoidRootPart()
        local nearestEnemy = findNearestEnemy(selectedEnemies)

        if nearestEnemy then
            local targetRootPart = nearestEnemy
            local distanceToEnemy = (rootPart.Position - targetRootPart.Position).Magnitude
            if distanceToEnemy > teleportRadius then
                rootPart.CFrame = CFrame.new(targetRootPart.Position + Vector3.new(0, 0, 3), targetRootPart.Position)
            end
        end
    end

    local function teleportMeToNearestEnemyWithoutContains()

    
        local nearestEnemy = findNearestEnemyWithoutContains()
        local rootPart = findHumanoidRootPart()
        if nearestEnemy then
            local targetRootPart = nearestEnemy
            local distanceToEnemy = (rootPart.Position - targetRootPart.Position).Magnitude
            if distanceToEnemy > teleportRadius then
                rootPart.CFrame = CFrame.new(targetRootPart.Position + Vector3.new(0, 0, 3), targetRootPart.Position)
            end
        end
    end

    local function teleportPetsToNearestEnemyWithContains()
        local selectedEnemies = {}
        for _, value in ipairs(EnemyDropdown:GetSelectedValues()) do
            table.insert(selectedEnemies, value)
        end
    
        local nearestEnemy = findNearestEnemy(selectedEnemies)

        if nearestEnemy then
            local targetRootPart = nearestEnemy
            local pets = getEquipedPets()
            for i, v in pets do
                    local petrootpart = workspace._PETS:FindFirstChild(tostring(player.UserId)):FindFirstChild(v):FindFirstChildOfClass("Model"):FindFirstChild("HumanoidRootPart")
                    local distanceToPet = (targetRootPart.Position - petrootpart.Position).Magnitude
                    if petrootpart then
                    if distanceToPet > teleportRadiusForPet then
                        petrootpart.CFrame = CFrame.new(targetRootPart.Position + Vector3.new(0, 0, 3), targetRootPart.Position)
                    end
                end
            end
        end
    end

    local function teleportPetsToNearestEnemyWithoutContains()
        local nearestEnemy = findNearestEnemyWithoutContains()
    
        if nearestEnemy then
            local targetRootPart = nearestEnemy
            local pets = getEquipedPets()
    
            local petsFolder = workspace._PETS:FindFirstChild(tostring(player.UserId))
            if not petsFolder then
                warn("Pets folder not found in workspace.Client")
                return
            end
            
            for i, petName in ipairs(pets) do
                local pet = petsFolder:FindFirstChild(petName):FindFirstChildOfClass("Model")
                if pet then
                    local petrootpart = pet:FindFirstChild("HumanoidRootPart")
    
                    if petrootpart then
                        local distanceToPet = (targetRootPart.Position - petrootpart.Position).Magnitude
                        
                        if distanceToPet > teleportRadiusForPet then
                            petrootpart.CFrame = CFrame.new(targetRootPart.Position + Vector3.new(0, 0, 3), targetRootPart.Position)
                        end
                    else
                        warn("HumanoidRootPart not found for pet:", petName)
                    end
                else
                    warn("Pet not found:", petName)
                end
            end
        end
    end



    local function sendPetsOnEnemy()
        local selectedEnemies = {}
        for _, value in ipairs(EnemyDropdown:GetSelectedValues()) do
            table.insert(selectedEnemies, value)
        end
        local nearestEnemy = findNearestEnemy(selectedEnemies)
        local EquipedPets = getEquipedPets()
    
        for i, v in ipairs(EquipedPets) do
            local rnpetcheck = v
            local petsAttribute = nearestEnemy:GetAttribute("Pets")
    
            -- Проверяем, есть ли атрибут "Pets" и не является ли он пустым
            if petsAttribute then
                -- Убираем квадратные скобки и разбиваем строку на элементы
                petsAttribute = petsAttribute:sub(2, -2) -- Убираем первую и последнюю скобку
                local petsList = {}
                for pet in petsAttribute:gmatch('"%s*([^"]+)%s*"') do
                    table.insert(petsList, pet)
                end
    
                -- Проверяем, содержится ли rnpetcheck в petsList
                local petFound = false
                for _, pet in ipairs(petsList) do
                    if pet == rnpetcheck then
                        petFound = true
                        break
                    end
                end
    
                if not petFound then
                    teleportPetsToNearestEnemyWithContains()
                    local args = {
                        [1] = {
                            [1] = {
                                [1] = "PetSystem",
                                [2] = "Attack",
                                [3] = nearestEnemy.Name,
                                [4] = false,
                                ["n"] = 4
                            },
                            [2] = "\2"
                        }
                    }
    
                    game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                end
            else
                -- Если атрибут "Pets" не установлен, выполняем действие
                teleportPetsToNearestEnemyWithContains()
                local args = {
                    [1] = {
                        [1] = {
                            [1] = "PetSystem",
                            [2] = "Attack",
                            [3] = nearestEnemy.Name,
                            [4] = false,
                            ["n"] = 4
                        },
                        [2] = "\2"
                    }
                }
    
                game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
            end
        end
    end

    local function sendPetsOnNearestEnemy()
        local nearestEnemy = findNearestEnemyWithoutContains()
        local EquipedPets = getEquipedPets()
        if nearestEnemy then 
            for i, v in ipairs(EquipedPets) do
                local rnpetcheck = v
                local petsAttribute = nearestEnemy:GetAttribute("Pets")
                if petsAttribute then
                    -- Убираем квадратные скобки и разбиваем строку на элементы
                    petsAttribute = petsAttribute:sub(2, -2) -- Убираем первую и последнюю скобку
                    local petsList = {}
                    for pet in petsAttribute:gmatch('"%s*([^"]+)%s*"') do
                        table.insert(petsList, pet)
                    end
                    -- Проверяем, содержится ли rnpetcheck в petsList
                    local petFound = false
                    for _, pet in ipairs(petsList) do
                        if pet == rnpetcheck then
                            petFound = true
                            break
                        end
                    end
                    if not petFound then
                        teleportPetsToNearestEnemyWithoutContains()
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "PetSystem",
                                    [2] = "Attack",
                                    [3] = nearestEnemy.Name,
                                    [4] = false,
                                    ["n"] = 4
                                },
                                [2] = "\2"
                            }
                        }
        
                        game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                    end
                end
            end
        else
            print("Ближайший враг не найден.")
        end
    end
    local AutoFarmSelectedMobs = Tabs.Farm:CreateToggle("Auto Farm Selected Mobs", {Title = "Auto Farm Selected Mobs", Default = false, Description = ""})

    local AutoFarmWithTeleport = Tabs.Farm:CreateToggle("Auto Farm With Teleport", {Title = "Auto Farm With Teleport", Default = false, Description = ""})

    AutoFarmWithTeleport:OnChanged(function(state)
        getgenv().AutoFarmWithTeleport = state
    end)


    AutoFarmSelectedMobs:OnChanged(function(state)
        getgenv().AutoFarm = state
    
        while getgenv().AutoFarm do
            task.wait()
            local Values = {}
            for _, value in ipairs(EnemyDropdown:GetSelectedValues()) do
                table.insert(Values, value)
            end
            if getgenv().AutoFarm == true then
                if getgenv().AutoFarmWithTeleport == true then
                    teleportMeToNearestEnemyWithContains()
                end
                sendPetsOnEnemy()
            end
            wait(0.25)

        end
    end)
    
    local AutoFarmNearest = Tabs.Farm:CreateToggle("Auto Farm Nearest", {Title = "Auto Farm Nearest", Default = false, Description = ""})
    AutoFarmNearest:OnChanged(function(state)
        getgenv().AutoFarmNearest = state
        while getgenv().AutoFarmNearest do
            task.wait()
                if getgenv().AutoFarmNearest == true then
                    sendPetsOnNearestEnemy()
                    if getgenv().AutoFarmWithTeleport == true then
                        teleportMeToNearestEnemyWithoutContains()
                    end
                    wait(0.5)
                end

        end
        
    end)

    Tabs.Farm:CreateButton({
        Title = "Refresh Enemies",
        Description = "Update Enemies Dropdown with your current enemies on map",
        Callback = function()
            RefreshEnemyDropdownWithNewEnemies()
        end
    })

    local eggfolder = workspace._MAP
    local egglist = {}
    local eggset = {}
    if eggfolder then
        for _, egg in ipairs(eggfolder:GetDescendants()) do
            if egg.Name == "Eggs" then
                local eggname = egg:FindFirstChildOfClass("Model").Name
                if eggname and not eggset[eggname] then
                    table.insert(egglist, eggname)
                    eggset[eggname] = true
                end
            end
        end
    end

    local currenteggforfarm = nil
    local EggsDropDown = Tabs.Eggs:CreateDropdown("Eggs", {Title = "Select Egg For Auto Open", Description = "", Values = egglist, Multi = false, Default = 1,})
    EggsDropDown:OnChanged(function(Value)
        currenteggforfarm = Value
        print(currenteggforfarm)
    end)

    local AutoOpenEggs = Tabs.Eggs:CreateToggle("Auto Open Eggs", {Title = "Auto Open Selected Egg", Default = false, Description = ""})

    AutoOpenEggs:OnChanged(function(state)
        getgenv().AutoOpenEggs = state
        while getgenv().AutoOpenEggs do
            task.wait(0.01)
            local args = {
                [1] = {
                    [1] = {
                        [1] = "PetSystem",
                        [2] = "Open",
                        [3] = currenteggforfarm,
                        [4] = "Three",
                        ["n"] = 4
                    },
                    [2] = "\2"
                }
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
            
        end
    end)
    --[[local function delayedTeleport()
        task.wait(10)
        teleportToSavedPosition()
    end
    coroutine.wrap(delayedTeleport)()]]

end




SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Apel Hub")
SaveManager:SetFolder("Apel Hub/".."Anime Kingdom")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

local Menu = game:GetService("CoreGui"):FindFirstChild("Menu")
if Menu then
    print("Найдено меню")
else
    local Menu = Instance.new("ScreenGui")
Menu.Name = "Menu"
local Frame = Instance.new("Frame")
Frame.Name = "Menu Button"
local ImageButton = Instance.new("ImageButton")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")

--Properties:
local coreGui = game:GetService("CoreGui")
Menu.Parent = coreGui
Menu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = Menu
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.167999998, 0, 0.230493277, 0)
Frame.Size = UDim2.new(0.040533334, 0, 0.0681614354, 0)

ImageButton.Parent = Frame
ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Size = UDim2.new(1, 0, 1, 0)
ImageButton.Image = "http://www.roblox.com/asset/?id=181239831"
ImageButton.MouseButton1Up:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true,"LeftControl",false,game)
end)

UIAspectRatioConstraint.Parent = ImageButton

UIAspectRatioConstraint_2.Parent = Frame
end
