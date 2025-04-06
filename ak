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
    Teleport = Window:CreateTab({Title = "Teleport", Icon = "users"}),
    Dungeons = Window:CreateTab({Title = "Dungeons", Icon = "globe"}),
    Raids = Window:CreateTab({Title = "Raids", Icon = "apple"}),
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
PositionfileName = "Saved Position2.txt"
WorldfileName = "Saved World2.txt"    
PositionfolderPath = folderName .. "\\" .. PositionfileName
WorldfolderPath = folderName .. "\\" .. WorldfileName

-- Проверяем, существует ли папка
if not isfolder(folderName) then
    makefolder(folderName)  -- Создаем папку, если она не существует
    print("Папка '" .. folderName .. "' была создана.")
else
    print("Папка '" .. folderName .. "' уже существует.")
end

coroutine.wrap(function()
    while true do
    task.wait(5)
    game:GetService("VirtualInputManager"):SendKeyEvent(true,"Space",false,game)
    task.wait()
    game:GetService("VirtualInputManager"):SendKeyEvent(false,"Space",false,game)
    task.wait(1)
    game:GetService("VirtualInputManager"):SendKeyEvent(true,"Space",false,game)
    task.wait()
    game:GetService("VirtualInputManager"):SendKeyEvent(false,"Space",false,game)
    task.wait(1)
    game:GetService("VirtualInputManager"):SendKeyEvent(true,"Space",false,game)
    task.wait()
    game:GetService("VirtualInputManager"):SendKeyEvent(false,"Space",false,game)
    task.wait(120)
    end
end)()

-- Проверяем, существует ли файл
if not isfile(PositionfolderPath) or not isfile(WorldfolderPath) then
    local positionforsave = "2682.995361328125, 102.79471588134766, 84.51563262939453"
    local worldforsave = "1"
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


local function checkgamemode()
    local player = game:GetService("Players").LocalPlayer
    local atr = player:GetAttribute("Mode")
    if atr == "Raid" then
        getgenv().currentmode = atr
    elseif  atr == "Dungeon" then
        getgenv().currentmode = atr
    elseif not atr then
        getgenv().currentmode = "None"
    end
end

coroutine.wrap(function()
    while true do
        checkgamemode()
        task.wait()
    end
end)()


do

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
                    if  enemy:GetAttribute("Shield") == false or enemy:GetAttribute("Shield") == nil then
                        if rootPart then
                            local distance = (rootPart.Position - enemy.Position).Magnitude
                
                            if distance < closestDistance then
                                closestDistance = distance
                                closestEnemy = enemy
                            end
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
        local petsFolder = workspace._PETS:FindFirstChild(tostring(player.UserId))
        local nearestEnemy = findNearestEnemy(selectedEnemies)
        local targetRootPart = nearestEnemy
        local pets = getEquipedPets()
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
            if nearestEnemy then
                local success, petsAttribute = pcall(function()
                    return nearestEnemy:GetAttribute("Pets")
                end)
                if not success then
                    print("Ошибка при получении атрибута 'Pets':", petsAttribute) -- petsAttribute здесь будет сообщением об ошибке
                else
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
                    end
                end
            end
        end
    end

    local function sendPetsOnNearestEnemy()
        local nearestEnemy = findNearestEnemyWithoutContains()
        local EquipedPets = getEquipedPets()
        if nearestEnemy then 
            for i, v in ipairs(EquipedPets) do
                local rnpetcheck = v
                if nearestEnemy then
                    local success, petsAttribute = pcall(function()
                        return nearestEnemy:GetAttribute("Pets")
                    end)
                    if not success then
                        print("Ошибка при получении атрибута 'Pets':", petsAttribute) -- petsAttribute здесь будет сообщением об ошибке
                    else
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
                end
            end
        else
            print("Ближайший враг не найден.")
        end
    end
    local AutoFarmSelectedMobs = Tabs.Farm:CreateToggle("Auto Farm Selected Mobs", {Title = "Auto Farm Selected Mobs", Default = false, Description = ""})
    local FastAutoFarmSelectedMobs = Tabs.Farm:CreateToggle("Fast Auto Farm Selected Mobs", {Title = "Fast Auto Farm Selected Mobs", Default = false, Description = ""})

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
            if player:GetAttribute("Mode") == nil or player:GetAttribute("Mode") == "" then
                if getgenv().AutoFarm == true then
                    if getgenv().AutoFarmWithTeleport == true then
                        teleportMeToNearestEnemyWithContains()
                    end
                    sendPetsOnEnemy()
                end
            end
            wait(0.25)

        end
    end)

    FastAutoFarmSelectedMobs:OnChanged(function(state)
        getgenv().FastAutoFarm = state
    
        while getgenv().FastAutoFarm do
            task.wait(0)
            if player:GetAttribute("Mode") == nil or player:GetAttribute("Mode") == "" then
                if getgenv().FastAutoFarm == true then
                    local selectedEnemies = {}
                    for _, value in ipairs(EnemyDropdown:GetSelectedValues()) do
                        table.insert(selectedEnemies, value)
                    end
                    local nearestEnemy = findNearestEnemy(selectedEnemies)
                    local pets = getEquipedPets()
                
                    if getgenv().AutoFarmWithTeleport == true then
                        teleportMeToNearestEnemyWithContains()
                    end
                    if nearestEnemy then
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "PetSystem",
                                    [2] = "Attack",
                                    [3] = nearestEnemy.Name,
                                    [4] = true,
                                    ["n"] = 4
                                },
                                [2] = "\2"
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))  
                        for i, v in ipairs(pets) do
                            local args = {
                                [1] = {
                                    [1] = {
                                        [1] = "PetSystem",
                                        [2] = "Closest",
                                        [3] = v,
                                        ["n"] = 3
                                    },
                                    [2] = "\2"
                                }
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))                            
                        end                     
                    end
                end
            end
        end
    end)
    
    local AutoFarmNearest = Tabs.Farm:CreateToggle("Auto Farm Nearest", {Title = "Auto Farm Nearest", Default = false, Description = ""})
    AutoFarmNearest:OnChanged(function(state)
        getgenv().AutoFarmNearest = state
        while getgenv().AutoFarmNearest do
            task.wait()
            if player:GetAttribute("Mode") == nil or player:GetAttribute("Mode") == "" then
                if getgenv().AutoFarmNearest == true then
                    sendPetsOnNearestEnemy()
                    if getgenv().AutoFarmWithTeleport == true then
                        teleportMeToNearestEnemyWithoutContains()
                    end
                    wait(0.25)
                end
            end
        end
        
    end)

    local AutoFarmNearestFast = Tabs.Farm:CreateToggle("Auto Farm Nearest Fast", {Title = "Auto Farm Nearest Fast", Default = false, Description = "YOU MUST HAVE SET DISABLE RETREAT IN SETTINGS ON OFF "})
    AutoFarmNearestFast:OnChanged(function(state)
        getgenv().AutoFarmNearestFast = state
        while getgenv().AutoFarmNearestFast do
            task.wait(0)
            if player:GetAttribute("Mode") == nil or player:GetAttribute("Mode") == "" then
                if getgenv().AutoFarmNearestFast == true then
                    if getgenv().AutoFarmWithTeleport == true then
                        teleportMeToNearestEnemyWithoutContains()
                    end
                    local nearestEnemy = findNearestEnemyWithoutContains()
                    local pets = getEquipedPets()
                    if nearestEnemy then
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "PetSystem",
                                    [2] = "Attack",
                                    [3] = nearestEnemy.Name,
                                    [4] = true,
                                    ["n"] = 4
                                },
                                [2] = "\2"
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))  
                        for i, v in ipairs(pets) do
                            local args = {
                                [1] = {
                                    [1] = {
                                        [1] = "PetSystem",
                                        [2] = "Closest",
                                        [3] = v,
                                        ["n"] = 3
                                    },
                                    [2] = "\2"
                                }
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))                            
                        end                     
                    end
                end
            end
        end
        
    end)


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

    local AutoOpenEggsWhileFarm = Tabs.Eggs:CreateToggle("Auto Open Eggs While Farm", {Title = "Auto Open Selected Egg While Auto Farming", Default = false, Description = ""})

    AutoOpenEggsWhileFarm:OnChanged(function(state)
        getgenv().AutoOpenEggsWhileFarm = state
        while getgenv().AutoOpenEggsWhileFarm do
            local eggpart


            for _, v in pairs(workspace._MAP:GetDescendants()) do
                if v:IsA("Folder") and v.Name == "Eggs" then
                    local egg = v:FindFirstChild(currenteggforfarm)
                    if egg and egg:IsA("Model") and egg.PrimaryPart then
                        eggpart = egg.PrimaryPart
                        break
                    else
                        print('sosal')
                    end
                end
            end
            local atr = game:GetService("Players").LocalPlayer:GetAttribute("Mode")
            if atr == "" or atr == nil then
                if eggpart then
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(eggpart.Position)
                end
                task.wait(0.1)
                for i = 1, 25 do
                    task.wait()
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
            end
            wait(1)
        end
    end)


    local WalkSpeedSlider = Tabs.Misc:CreateSlider("Walk Speed Slider", {
        Title = "Walkspeed",
        Description = "",
        Default = 0,
        Min = 0,
        Max = 10,
        Rounding = 1,
        Callback = function(Value)
            -- Останавливаем предыдущий цикл, если он существует
            if getgenv().TpWalking then
                getgenv().TpWalking = false
                wait(0.1) -- Небольшая задержка, чтобы дать время завершить предыдущий цикл
            end
    
            -- Устанавливаем новое значение скорости
            getgenv().Speed = tonumber(Value)
    
            local speaker = game:GetService("Players").LocalPlayer
            local chr = speaker.Character
            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
            local hb = game:GetService("RunService").Heartbeat
    
            -- Запускаем новый цикл для перемещения
            if hum then
                getgenv().TpWalking = true
                while getgenv().TpWalking and chr and hum and hum.Parent do
                    local delta = hb:Wait()
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection * tonumber(getgenv().Speed) * delta * 10)
                    else
                        chr:TranslateBy(hum.MoveDirection * delta * 10)
                    end
                end
            end
        end
    })


    local AutoClick = Tabs.Misc:CreateToggle("Auto Click", {Title = "Auto Click", Default = false, Description = ""})

    AutoClick:OnChanged(function(State)-- Auto Click
        getgenv().AutoClicking = State
        while getgenv().AutoClicking == true do
            if not getgenv().AutoClicking == true then return end
                task.wait()
                local args = {
                    [1] = {
                        [1] = {
                            [1] = "PetSystem",
                            [2] = "Click",
                            ["n"] = 2
                        },
                        [2] = "\2"
                    }
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                
        end
    end)

    -- AUTO DUNGEON

    local function findNearestEnemyInDungeon()
        local closestEnemy = nil
        local closestDistance = math.huge
        local rootPart = findHumanoidRootPart()
            for _, enemy in pairs(workspace._ENEMIES.Server.Dungeon:GetDescendants()) do
                if enemy:IsA("Part") and tonumber(enemy:GetAttribute("HP")) > 0 then
                    if  enemy:GetAttribute("Shield") == false or enemy:GetAttribute("Shield") == nil then
                        if rootPart then
                            local distance = (rootPart.Position - enemy.Position).Magnitude
                
                            if distance < closestDistance then
                                closestDistance = distance
                                closestEnemy = enemy
                            end
                        end
                    end
                end
            end

    
        return closestEnemy
    end

    local function teleportMeToNearestEnemyInDungeon()

    
        local nearestEnemy = findNearestEnemyInDungeon()
        local rootPart = findHumanoidRootPart()
        if nearestEnemy then
            local targetRootPart = nearestEnemy
            local distanceToEnemy = (rootPart.Position - targetRootPart.Position).Magnitude
            if distanceToEnemy > teleportRadius then
                rootPart.CFrame = CFrame.new(targetRootPart.Position + Vector3.new(0, 0, 3), targetRootPart.Position)
            end
        end
    end

    local function teleportPetsToNearestEnemyInDungeon()
        local nearestEnemy = findNearestEnemyInDungeon()
    
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

    local function sendPetsOnNearestEnemyInDungeon()
        local nearestEnemy = findNearestEnemyInDungeon()
        local EquipedPets = getEquipedPets()
        if nearestEnemy then 
            for i, v in ipairs(EquipedPets) do
                local rnpetcheck = v
                if nearestEnemy then
                    local success, petsAttribute = pcall(function()
                        return nearestEnemy:GetAttribute("Pets")
                    end)
                    if not success then
                        print("Ошибка при получении атрибута 'Pets':", petsAttribute) -- petsAttribute здесь будет сообщением об ошибке
                    else
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
                                teleportPetsToNearestEnemyInDungeon()
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
                end
            end
        else
            print("Ближайший враг не найден.")
        end
    end


    local listofdungeon = game:GetService("ReplicatedStorage").Assets.Dungeons:GetChildren()
    local AreaDungeonList = Tabs.Dungeons:CreateDropdown("Area Dungeon List",{
        Title = "Select Area of Dungeon",
        Description = "",
        Values = listofdungeon,
        Multi = false,
        Default = 1,
    })

    local DifficultyDungeonList = Tabs.Dungeons:CreateDropdown("Difficulty Dungeon List", {
        Title = "Select Difficulty of Dungeon",
        Description = "",
        Values = {"Easy", "Medium", "Hard", "Insane", "Extreme", "Impossible"},
        Multi = false,
        Default = 1,
    })

    getgenv().DungeonWaveLimit = 1
    local DungeonWaveLimit = Tabs.Dungeons:CreateInput("DungeonWaveLimit", {
        Title = "Dungeon Wave Limit",
        Default = 1, 
        Description = "On this wave script will auto leave",
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            getgenv().DungeonWaveLimit = tonumber(Value)
        end
    })
    DungeonWaveLimit:OnChanged(function(Value)
        getgenv().DungeonWaveLimit = tonumber(Value)
    end)


    local AutoLeaveDungeon = Tabs.Dungeons:CreateToggle("Auto Leave Dungeon",{
        Title = "Auto Leave Dungeon",
        Default = false,
        Description = ""
    })

    local function teleportToSavedPosition()
        if getgenv().SavedPosition and getgenv().SavedWorld then
            local args = {
                [1] = {
                    [1] = {
                        [1] = "TeleportSystem",
                        [2] = "To",
                        [3] = tonumber(getgenv().SavedWorld),
                        ["n"] = 3
                    },
                    [2] = "\2"
                }
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
            
            wait(2)
    
            local HumanoidRootPart = findHumanoidRootPart()
            -- Телепортируем персонажа на сохраненную позицию
            if HumanoidRootPart then
                HumanoidRootPart.CFrame = getgenv().SavedPosition
            end
        else
            warn("Saved world or position is not set.")
        end
    end

    AutoLeaveDungeon:OnChanged(function(state)
        getgenv().AutoLeaveDungeon = state
        local function checkcurrentwave()
            while getgenv().AutoLeaveDungeon == true do
                task.wait(10)
                local UserId = player.UserId
                local dungeon = game:GetService("ReplicatedStorage").Server.Dungeon:FindFirstChild(tostring(UserId))
        
                -- Проверяем, существует ли объект dungeon
                if dungeon then
                    -- Проверяем, есть ли атрибут "Stage"
                    local waveNumber = dungeon:GetAttribute("Stage")
                    if waveNumber then
                        waveNumber = tonumber(waveNumber)
                        local DungeonWaveLimit = tonumber(getgenv().DungeonWaveLimit)
                        print(tostring(waveNumber) .. " | " .. tostring(DungeonWaveLimit))
        
                        if DungeonWaveLimit and waveNumber >= DungeonWaveLimit and getgenv().currentmode == "Dungeon" then
                            print("Достигнут лимит волн, телепортируем...")
                            wait(3)
                            teleportToSavedPosition()
                            wait(1)
                            teleportToSavedPosition()
                            wait(1)
                            teleportToSavedPosition()
                        end
                    else
                        print("Атрибут 'Stage' не найден для UserId: " .. tostring(UserId))
                    end
                else
                    print("Объект для UserId не найден: " .. tostring(UserId))
                end
            end
        end
            
            coroutine.wrap(checkcurrentwave)()

    end)

    local PrivateDungeon = Tabs.Dungeons:CreateToggle("Auto Private Dungeon", {Title = "Auto Private Dungeon", Default = false, Description = "Enable if you want your Dungeon to be private"})
    PrivateDungeon:OnChanged(function(state)
        getgenv().PrivateDungeon = state
    end)
    local AutoCreateDungeon = Tabs.Dungeons:CreateToggle("Auto Create Dungeon", {Title = "Auto Create Dungeon", Default = false, Description = ""})
    AutoCreateDungeon:OnChanged(function(state)
        getgenv().AutoCreateDungeon = state
        while getgenv().AutoCreateDungeon do
            task.wait()
            local atr = game:GetService("Players").LocalPlayer:GetAttribute("Mode")
                if getgenv().AutoCreateDungeon == true then
                    if getgenv().currentmode == "None" then
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "DungeonSystem",
                                    [2] = "Create",
                                    ["n"] = 2
                                },
                                [2] = "\2"
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                        task.wait(0.25)
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "DungeonSystem",
                                    [2] = "SelectMap",
                                    [3] = tostring(AreaDungeonList.Value),
                                    ["n"] = 3
                                },
                                [2] = "\2"
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                        task.wait(0.25)
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "DungeonSystem",
                                    [2] = "SelectDiff",
                                    [3] = tostring(DifficultyDungeonList.Value),
                                    ["n"] = 3
                                },
                                [2] = "\2"
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                        task.wait(0.25)
                        if getgenv().PrivateDungeon == true then
                            local args = {
                                [1] = {
                                    [1] = {
                                        [1] = "DungeonSystem",
                                        [2] = "MakePrivate",
                                        ["n"] = 2
                                    },
                                    [2] = "\2"
                                }
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))                            
                            task.wait(0.25)
                        end
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "DungeonSystem",
                                    [2] = "Start",
                                    ["n"] = 2
                                },
                                [2] = "\2"
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                        task.wait(10)                        
                    end
                end
            task.wait(60)

        end
        
    end)

    local AutoAttackInDungeon = Tabs.Dungeons:CreateToggle("Auto Attack Dungeon", {Title = "Auto Attack In Dungeon", Default = false, Description = ""})
    AutoAttackInDungeon:OnChanged(function(state)
        getgenv().AutoAttackInDungeon = state
        while getgenv().AutoAttackInDungeon do
            task.wait()
            local atr = game:GetService("Players").LocalPlayer:GetAttribute("Mode")
                if getgenv().AutoAttackInDungeon == true then
                    if atr == "Dungeon" then
                        teleportMeToNearestEnemyInDungeon()
                        sendPetsOnNearestEnemyInDungeon()
                        wait(0.25)
                    end
                end

        end
        
    end)

    local FastAutoAttackInDungeon = Tabs.Dungeons:CreateToggle("Fast Auto Attack Dungeon", {Title = "Fast Auto Attack In Dungeon", Default = false, Description = "YOU MUST HAVE SET DISABLE RETREAT IN SETTINGS ON OFF "})
    FastAutoAttackInDungeon:OnChanged(function(state)
        getgenv().AutoAttackInDungeon = state
        while getgenv().AutoAttackInDungeon do
            task.wait(0)
            local atr = game:GetService("Players").LocalPlayer:GetAttribute("Mode")
                if getgenv().AutoAttackInDungeon == true then
                    if atr == "Dungeon" then
                        teleportMeToNearestEnemyInDungeon()
                        local nearestEnemy = findNearestEnemyInDungeon()
                        local pets = getEquipedPets()
                        if nearestEnemy then
                            local args = {
                                [1] = {
                                    [1] = {
                                        [1] = "PetSystem",
                                        [2] = "Attack",
                                        [3] = nearestEnemy.Name,
                                        [4] = true,
                                        ["n"] = 4
                                    },
                                    [2] = "\2"
                                }
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))  
                            for i, v in ipairs(pets) do
                                local args = {
                                    [1] = {
                                        [1] = {
                                            [1] = "PetSystem",
                                            [2] = "Closest",
                                            [3] = v,
                                            ["n"] = 3
                                        },
                                        [2] = "\2"
                                    }
                                }
                                
                                game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))                            
                            end                     
                        end
                    end
                end
        end
        
    end)

    -- AUTO RAIDS


    local function findNearestEnemyInRaid()
        local closestEnemy = nil
        local closestDistance = math.huge
        local rootPart = findHumanoidRootPart()
            for _, enemy in pairs(workspace._ENEMIES.Server.Raid:GetDescendants()) do
                if enemy:IsA("Part") and tonumber(enemy:GetAttribute("HP")) > 0 then
                    if  enemy:GetAttribute("Shield") == false or enemy:GetAttribute("Shield") == nil then
                        if rootPart then
                            local distance = (rootPart.Position - enemy.Position).Magnitude
                
                            if distance < closestDistance then
                                closestDistance = distance
                                closestEnemy = enemy
                            end
                        end
                    end
                end
            end

    
        return closestEnemy
    end

    local function teleportMeToNearestEnemyInRaid()

    
        local nearestEnemy = findNearestEnemyInRaid()
        local rootPart = findHumanoidRootPart()
        if nearestEnemy then
            local targetRootPart = nearestEnemy
            local distanceToEnemy = (rootPart.Position - targetRootPart.Position).Magnitude
            if distanceToEnemy > teleportRadius then
                rootPart.CFrame = CFrame.new(targetRootPart.Position + Vector3.new(0, 0, 3), targetRootPart.Position)
            end
        end
    end

    local function teleportPetsToNearestEnemyInRaid()
        local nearestEnemy = findNearestEnemyInRaid()
    
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

    local function sendPetsOnNearestEnemyInRaid()
        local nearestEnemy = findNearestEnemyInRaid()
        local EquipedPets = getEquipedPets()
        if nearestEnemy then 
            for i, v in ipairs(EquipedPets) do
                local rnpetcheck = v
                if nearestEnemy then
                    local success, petsAttribute = pcall(function()
                        return nearestEnemy:GetAttribute("Pets")
                    end)
                    if not success then
                        print("Ошибка при получении атрибута 'Pets':", petsAttribute) -- petsAttribute здесь будет сообщением об ошибке
                    else
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
                                teleportPetsToNearestEnemyInRaid()
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
                end
            end
        else
            print("Ближайший враг не найден.")
        end
    end

    local listofraids = game:GetService("ReplicatedStorage").Assets.Raids:GetChildren()

    table.sort(listofraids, function(a, b)
        return a.Name < b.Name
    end)
    
    local AreaRaidList = Tabs.Raids:CreateDropdown("Area Raids List", {
        Title = "Select Area of Raid",
        Description = "NUMBER IS A NUMBER OF LOCATION",
        Values = listofraids,
        Multi = false,
        Default = 1,
    })

    local PrivateRaid = Tabs.Raids:CreateToggle("Auto Private Raid", {Title = "Auto Private Raid", Default = false, Description = "Enable if you want your Raid to be private"})
    PrivateRaid:OnChanged(function(state)
        getgenv().PrivateRaid = state
    end)
    local AutoCreateRaid = Tabs.Raids:CreateToggle("Auto Create Raid", {Title = "Auto Create Raid", Default = false, Description = ""})
    AutoCreateRaid:OnChanged(function(state)
        getgenv().AutoCreateRaid = state
        while getgenv().AutoCreateRaid do
            task.wait()
            local atr = game:GetService("Players").LocalPlayer:GetAttribute("Mode")
                if getgenv().AutoCreateRaid == true then
                    if getgenv().currentmode == "None" then
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "RaidSystem",
                                    [2] = "Create",
                                    ["n"] = 2
                                },
                                [2] = "\2"
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                        task.wait(0.25)
                        local sf = AreaRaidList.Value
                        local s3 = tostring(sf)
                        local sf2 = tonumber(s3)
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "RaidSystem",
                                    [2] = "SelectMap",
                                    [3] = sf2,
                                    ["n"] = 3
                                },
                                [2] = "\2"
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                        task.wait(0.25)
                        if getgenv().PrivateDungeon == true then
                            local args = {
                                [1] = {
                                    [1] = {
                                        [1] = "RaidSystem",
                                        [2] = "MakePrivate",
                                        ["n"] = 2
                                    },
                                    [2] = "\2"
                                }
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))                            
                            task.wait(0.25)
                        end
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "RaidSystem",
                                    [2] = "Start",
                                    ["n"] = 2
                                },
                                [2] = "\2"
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                        task.wait(10)                      
                    end
                end
            task.wait(60)

        end
        
    end)

    local AutoAttackInRaid = Tabs.Raids:CreateToggle("Auto Attack Raid", {Title = "Auto Attack In Raid", Default = false, Description = ""})
    AutoAttackInRaid:OnChanged(function(state)
        getgenv().AutoAttackInRaid = state
        while getgenv().AutoAttackInRaid do
            task.wait()
            local atr = game:GetService("Players").LocalPlayer:GetAttribute("Mode")
                if getgenv().AutoAttackInRaid == true then
                    if atr == "Raid" then
                        teleportMeToNearestEnemyInRaid()
                        sendPetsOnNearestEnemyInRaid()
                        wait(0.25)
                    end
                end
        end
        
    end)

    local FastAutoAttackInRaid = Tabs.Raids:CreateToggle("Fast Auto Attack Raid", {Title = "Fast Auto Attack In Raid", Default = false, Description = "YOU MUST HAVE SET DISABLE RETREAT IN SETTINGS ON OFF "})
    FastAutoAttackInRaid:OnChanged(function(state)
        getgenv().FastAutoAttackInRaid = state
        while getgenv().FastAutoAttackInRaid do
            task.wait(0)
            local atr = game:GetService("Players").LocalPlayer:GetAttribute("Mode")
                if getgenv().FastAutoAttackInRaid == true then
                    if atr == "Raid" then
                        teleportMeToNearestEnemyInRaid()
                        local nearestEnemy = findNearestEnemyInRaid()
                        local pets = getEquipedPets()
                        if nearestEnemy then
                            local args = {
                                [1] = {
                                    [1] = {
                                        [1] = "PetSystem",
                                        [2] = "Attack",
                                        [3] = nearestEnemy.Name,
                                        [4] = true,
                                        ["n"] = 4
                                    },
                                    [2] = "\2"
                                }
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))  
                            for i, v in ipairs(pets) do
                                local args = {
                                    [1] = {
                                        [1] = {
                                            [1] = "PetSystem",
                                            [2] = "Closest",
                                            [3] = v,
                                            ["n"] = 3
                                        },
                                        [2] = "\2"
                                    }
                                }
                                
                                game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))                            
                            end                     
                        end
                    end
                end
        end
        
    end)


    local savedWolrdString = readfile(WorldfolderPath)
    getgenv().SavedWorld = tostring(savedWolrdString)
        -- Чтение сохраненной позиции из файла
    local savedPositionString = readfile(PositionfolderPath)
    local positionValues = {}

    -- Разделяем строку на отдельные координаты
    for value in string.gmatch(savedPositionString, "[^,]+") do
        table.insert(positionValues, tonumber(value))
    end

    -- Проверяем, что у нас есть три координаты
    if #positionValues == 3 then
        -- Создаем CFrame из координат
        getgenv().SavedPosition = CFrame.new(positionValues[1], positionValues[2], positionValues[3])
        print("Сохраненная позиция установлена:", getgenv().SavedPosition)
    else
        warn("Ошибка: неверное количество координат в файле.")
    end

    local currentPositionParagraph = Tabs.Teleport:CreateParagraph("Current pos paragraph", {
        Title = "Current Position",
        Content = "World: "..savedWolrdString.."\nPosition: "..savedPositionString
    })
    
    local function updatePositionAndMap()
        for _, v in ipairs(workspace._ENEMIES.Server:GetChildren()) do
            -- Проверяем, является ли v папкой (Model или Folder)
            if v:IsA("Folder") then
                local hasParts = false
                
                -- Проверяем, есть ли в папке дочерние элементы, которые являются частями
                for _, child in ipairs(v:GetChildren()) do
                    if child:IsA("Part") then
                        hasParts = true
                        break
                    end
                end
                
                -- Если в папке есть части, сохраняем ее имя
                if hasParts then
                    getgenv().SavedWorld = v.Name
                    writefile(WorldfolderPath, v.Name)
                    break
                end
            end
        end
    
        -- Получаем новую позицию
        local HumanoidRootPart = findHumanoidRootPart()
        getgenv().SavedPosition = CFrame.new(HumanoidRootPart.Position)
        writefile(PositionfolderPath, tostring(getgenv().SavedPosition.x)..","..tostring(getgenv().SavedPosition.y)..","..tostring(getgenv().SavedPosition.z))
        -- Обновляем содержимое параграфа
        currentPositionParagraph:SetValue("World: " .. tostring(getgenv().SavedWorld) .. "\nPosition: " .. tostring(getgenv().SavedPosition))
    end
    
    Tabs.Teleport:CreateButton({
        Title = "Save New Position",
        Description = "Change your position for auto teleport",
        Callback = function()
            -- Вызываем функцию обновления позиции и карты
            updatePositionAndMap()
        end
    })
    
    Tabs.Teleport:CreateButton({
        Title = "Teleport To Saved Position",
        Description = "",
        Callback = function()
            -- Вызываем функцию обновления позиции и карты
            teleportToSavedPosition()
        end
    })

    local TeleportBack = Tabs.Teleport:CreateToggle("Auto Teleport Back",{
        Title = "Auto Teleport Back",
        Description = "",
        Default = false
    })

    TeleportBack:OnChanged(function(state)
        getgenv().TeleportBack = state
        local previousMode = getgenv().currentmode

        local function trackCurrentMode()
            while getgenv().TeleportBack do
                local currentMode = getgenv().currentmode
                if currentMode ~= previousMode then
                    print("Текущий режим изменился на:", currentMode) 
                    if previousMode ~= "None"  then
                        task.wait(2)
                        teleportToSavedPosition()
                    end
                    previousMode = currentMode
                end
                
                task.wait(5)
            end
        end

        coroutine.wrap(trackCurrentMode)()
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
