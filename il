    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
    local MarketplaceService = game:GetService("MarketplaceService")
    local gamename = MarketplaceService:GetProductInfo(game.PlaceId).Name

    local Window = Fluent:CreateWindow({
        Title = "Apel Hub",
        SubTitle = tostring(gamename),
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
        Theme = "Darker",
        MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
    })

    local Tabs = {
        Credits = Window:AddTab({Title = "Credits", Icon = "book"}),
        Farm = Window:AddTab({ Title = "Farming", Icon = "align-center" }),
        Misc = Window:AddTab({Title = "Misс", Icon = "diamond"}),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })

    }

    local Options = Fluent.Options
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character

        local bb=game:service'VirtualUser'
        game:service'Players'.LocalPlayer.Idled:connect(function()
        bb:CaptureController()bb:ClickButton2(Vector2.new())end)
    do
        local AutoRoll = Tabs.Farm:AddToggle("Auto Roll",{Title = "Auto Roll", Description = "Automatically rolling auras", Default = false})

        AutoRoll:OnChanged(function(roller)
            getgenv().rolling = roller
            while getgenv().rolling == true do
                if not getgenv().rolling then return end
                wait()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Roll"):InvokeServer()
            end
        end)

        local AutoFarm = Tabs.Farm:AddToggle("Auto Farm", {Title = "Auto Cultivate + Breakthrough", Description = "", Default = false})
        AutoFarm:OnChanged(function(farm)
            getgenv().farming = farm
            while getgenv().farming == true do
                wait(1)
                if not getgenv().farming then return end
                local cultivateStatus = player:GetAttribute("Cultivating")
                local breakStatus = player:GetAttribute("Breakthrough")
                if cultivateStatus == nil or cultivateStatus == false then
                    local args = {
                        [1] = true
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Cultivate"):FireServer(unpack(args))
                    wait(2)
                    character.Humanoid.WalkSpeed = 50    
                end
                wait()
                if breakStatus == nil or cultivateStatus == false then
                    local args = {
                        [1] = true
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Breakthrough"):FireServer(unpack(args))
                    wait(2)
                    character.Humanoid.WalkSpeed = 50                
                end
            end  
        end)
        Tabs.Farm:AddButton({
            Title = "Disable Cultivation",
            Description = "Disabling Cultivation",
            Callback = function()
                local args = {
                    [1] = true
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Cultivate"):FireServer(unpack(args))
                wait(0.5)
                character.Humanoid.WalkSpeed = 50      
            end
        })

        Tabs.Farm:AddButton({
            Title = "Disable Breakthrough",
            Description = "Disabling Breakthrough",
            Callback = function()
                local args = {
                    [1] = false
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Breakthrough"):FireServer(unpack(args))
                wait(0.5)
                character.Humanoid.WalkSpeed = 50      
            end
        })





        local SpeedSlider = Tabs.Misc:AddSlider("WalkSpeed",{
            Title = "WalkSpeed",
            Description = "WalkSpeed slider",
            Default = 50,
            Min = 1,
            Max = 200,
            Rounding = 1,
            Callback = function(Value)
                character.Humanoid.WalkSpeed = Value
            end
        })
        local DiscordButton = Tabs.Credits:AddButton({Title = "Discord Link", Content = "", Description = "Will copy in clipboard", Callback = function()
            setclipboard("https://discord.gg/4gDAbj2VXG")
        end})
    end

    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("Apel Hub")
    SaveManager:SetFolder("Apel Hub/".."Immortal Luck")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
    SaveManager:LoadAutoloadConfig()

    -- Gui to Lua
    -- Version: 3.2

    -- Instances:
-- Instances:
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
