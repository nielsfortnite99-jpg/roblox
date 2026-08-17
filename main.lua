--[[
███████╗ █████╗ ███╗   ██╗    ██████╗ ██╗███████╗ ██████╗ ██████╗ 
██╔════╝██╔══██╗████╗  ██║    ██╔══██╗██║██╔════╝██╔═══██╗██╔══██╗
███████╗███████║██╔██╗ ██║    ██║  ██║██║█████╗  ██║   ██║██████╔╝
╚════██║██╔══██║██║╚██╗██║    ██║  ██║██║██╔══╝  ██║   ██║██╔══██╗
███████║██║  ██║██║ ╚████║    ██████╔╝██║███████╗╚██████╔╝██║  ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝    ╚═════╝ ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
--]]

-- ============================================================
-- SAN DIEGO BORDER ULTIMATE HACK V5 - MIT MINIMIEREN
-- 100% Eigenes Skript - Mit Minimier-Button!
-- ============================================================

-- ============================================================
-- KONFIGURATION
-- ============================================================
local Settings = {
    Farming = {
        Enabled = true,
        Rings = true,
        Monalis = true, 
        ElDiablo = false,
        JobFarm = true,
        BoatFarm = true,
        BuyAmount = 999,
        Delay = 0.1,
        AutoRestart = true,
        RestartTime = 60
    },
    AntiAFK = {
        Enabled = true,
        Mode = "VirtualUser",
        Delay = 10
    },
    AutoDeath = {
        Enabled = true,
        AutoRespawn = true,
        RespawnDelay = 0.5
    },
    VehicleSpeed = {
        Enabled = true,
        Speed = 500,
        Key = Enum.KeyCode.LeftAlt,
        SmoothBoost = true
    },
    AutoClick = {
        Enabled = false,
        Delay = 0.05
    },
    GodMode = {
        Enabled = true,
        Mode = "Humanoid"
    },
    ESP = {
        Enabled = true,
        BoxColor = Color3.fromRGB(255, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255)
    },
    Aimbot = {
        Enabled = false,
        Smoothness = 0.3,
        Key = Enum.KeyCode.RightShift
    },
    Teleport = {
        Enabled = false,
        Key = Enum.KeyCode.T
    },
    GUI = {
        Theme = "Dark",
        Transparency = 0.95,
        AnimationSpeed = 0.3
    }
}

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
if not Player then
    Players.PlayerAdded:Wait()
    Player = Players.LocalPlayer
end

-- ============================================================
-- GLOBALS
-- ============================================================
local AllFarmingTasks = {}
local AllAutoClickTasks = {}
local ESPObjects = {}
local IsRunning = true
local IsMinimized = false

-- ============================================================
-- STOP FUNCTION
-- ============================================================
local function StopAll()
    IsRunning = false
    
    for _, taskId in ipairs(AllFarmingTasks) do
        task.cancel(taskId)
    end
    AllFarmingTasks = {}
    
    for _, taskId in ipairs(AllAutoClickTasks) do
        task.cancel(taskId)
    end
    AllAutoClickTasks = {}
    
    for _, obj in ipairs(ESPObjects) do
        obj:Destroy()
    end
    ESPObjects = {}
    
    local gui = CoreGui:FindFirstChild("SanDiegoUltimateV5")
    if gui then
        gui.Enabled = false
        task.wait(0.5)
        gui:Destroy()
    end
    
    print("🛑 ALLE SYSTEME GESTOPPT!")
    StarterGui:SetCore("SendNotification", {
        Title = "🛑 GESTOPPT",
        Text = "Alle Systeme wurden beendet!",
        Duration = 3
    })
end

-- ============================================================
-- MINIMIEREN / MAXIMIEREN
-- ============================================================
local function ToggleMinimize(MainFrame, TitleFrame, ContentFrame, StatusLabel)
    IsMinimized = not IsMinimized
    
    if IsMinimized then
        -- Minimieren
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 320, 0, 50)
        }):Play()
        
        ContentFrame.Visible = false
        StatusLabel.Visible = false
        
        TitleFrame.Size = UDim2.new(1, 0, 1, 0)
        
    else
        -- Maximieren
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 580, 0, 680)
        }):Play()
        
        task.wait(0.3)
        ContentFrame.Visible = true
        StatusLabel.Visible = true
        
        TitleFrame.Size = UDim2.new(1, 0, 0, 70)
    end
end

-- ============================================================
-- MEGA GUI SYSTEM
-- ============================================================
local function CreateMegaGUI()
    -- Haupt-ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SanDiegoUltimateV5"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    -- Hintergrund
    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.7
    Background.Parent = ScreenGui

    -- Haupt-Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 580, 0, 680)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -340)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    -- Glow-Effekt
    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, 20, 1, 20)
    Glow.Position = UDim2.new(-0.02, 0, -0.02, 0)
    Glow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Glow.BackgroundTransparency = 0.85
    Glow.BorderSizePixel = 0
    Glow.Parent = MainFrame
    Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 20)

    -- Title Frame (wird immer angezeigt)
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Size = UDim2.new(1, 0, 0, 70)
    TitleFrame.Position = UDim2.new(0, 0, 0, 0)
    TitleFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    TitleFrame.BorderSizePixel = 0
    TitleFrame.Parent = MainFrame
    Instance.new("UICorner", TitleFrame).CornerRadius = UDim.new(0, 16)

    -- Titel
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.8, -40, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 SD HACK V5 🔥"
    Title.TextColor3 = Color3.fromRGB(255, 50, 50)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleFrame

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(0.8, -40, 0, 16)
    SubTitle.Position = UDim2.new(0, 20, 0, 48)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "💀 MEGA HACK 💀"
    SubTitle.TextColor3 = Color3.fromRGB(200, 100, 100)
    SubTitle.TextSize = 10
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = TitleFrame

    -- Minimier-Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 36, 0, 36)
    MinBtn.Position = UDim2.new(1, -90, 0, 17)
    MinBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    MinBtn.BorderSizePixel = 0
    MinBtn.Text = "⬇"
    MinBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
    MinBtn.TextSize = 18
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = TitleFrame
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

    -- Schließen-Button (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 36, 0, 36)
    CloseBtn.Position = UDim2.new(1, -44, 0, 17)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleFrame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

    -- Content Frame (wird minimiert)
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -70)
    ContentFrame.Position = UDim2.new(0, 0, 0, 70)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- Player Info
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Size = UDim2.new(1, -40, 0, 80)
    InfoFrame.Position = UDim2.new(0, 20, 0, 15)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    InfoFrame.BorderSizePixel = 0
    InfoFrame.Parent = ContentFrame
    Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 10)

    local PlayerName = Instance.new("TextLabel")
    PlayerName.Size = UDim2.new(0.5, -10, 1, 0)
    PlayerName.Position = UDim2.new(0, 10, 0, 0)
    PlayerName.BackgroundTransparency = 1
    PlayerName.Text = "👤 " .. Player.Name
    PlayerName.TextColor3 = Color3.fromRGB(255, 200, 200)
    PlayerName.TextSize = 18
    PlayerName.Font = Enum.Font.GothamBold
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    PlayerName.Parent = InfoFrame

    local ServerLabel = Instance.new("TextLabel")
    ServerLabel.Size = UDim2.new(0.5, -10, 0.5, 0)
    ServerLabel.Position = UDim2.new(0.5, 10, 0.5, 0)
    ServerLabel.BackgroundTransparency = 1
    ServerLabel.Text = "🌐 " .. string.sub(game.JobId, 1, 8) .. "..."
    ServerLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    ServerLabel.TextSize = 12
    ServerLabel.Font = Enum.Font.Gotham
    ServerLabel.TextXAlignment = Enum.TextXAlignment.Right
    ServerLabel.Parent = InfoFrame

    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -40, 0, 30)
    StatusLabel.Position = UDim2.new(0, 20, 0, 110)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "🟢 HACK AKTIV"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    StatusLabel.TextSize = 18
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.Parent = ContentFrame

    -- Fortschrittsbalken
    local ProgressFrame = Instance.new("Frame")
    ProgressFrame.Size = UDim2.new(0.9, 0, 0, 8)
    ProgressFrame.Position = UDim2.new(0.05, 0, 0, 145)
    ProgressFrame.BackgroundColor3 = Color3.fromRGB(30, 33, 40)
    ProgressFrame.BorderSizePixel = 0
    ProgressFrame.Parent = ContentFrame
    Instance.new("UICorner", ProgressFrame).CornerRadius = UDim.new(0, 4)

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = ProgressFrame
    Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 4)

    -- Button Creator
    local function CreateHackButton(text, x, y, color, icon, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 240, 0, 44)
        btn.Position = UDim2.new(0, x, 0, y)
        btn.BackgroundColor3 = color or Color3.fromRGB(30, 0, 0)
        btn.BorderSizePixel = 0
        btn.Text = icon .. " " .. text
        btn.TextColor3 = Color3.fromRGB(255, 200, 200)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = ContentFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 0, 0)
            }):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = color or Color3.fromRGB(30, 0, 0)
            }):Play()
        end)
        
        if callback then
            btn.MouseButton1Click:Connect(callback)
        end
        return btn
    end

    -- ============================================================
    -- HACK BUTTONS
    -- ============================================================
    local farmBtn = CreateHackButton("MEGA FARMEN", 20, 165, Color3.fromRGB(40, 0, 0), "🌾")
    local afkBtn = CreateHackButton("ANTI AFK", 280, 165, Color3.fromRGB(40, 0, 0), "🛡️")
    local deathBtn = CreateHackButton("AUTO DEATH", 20, 215, Color3.fromRGB(40, 0, 0), "💀")
    local speedBtn = CreateHackButton("SPEED HACK", 280, 215, Color3.fromRGB(40, 0, 0), "🚗")
    local godBtn = CreateHackButton("GOD MODE", 20, 265, Color3.fromRGB(40, 0, 0), "👑")
    local espBtn = CreateHackButton("ESP WALLHACK", 280, 265, Color3.fromRGB(40, 0, 0), "👁️")
    local aimBtn = CreateHackButton("AIMBOT", 20, 315, Color3.fromRGB(40, 0, 0), "🎯")
    local teleBtn = CreateHackButton("TELEPORT", 280, 315, Color3.fromRGB(40, 0, 0), "🌀")
    local clickBtn = CreateHackButton("AUTO CLICK", 20, 365, Color3.fromRGB(40, 0, 0), "🖱️")
    local resetBtn = CreateHackButton("RESET ALL", 280, 365, Color3.fromRGB(40, 0, 0), "🔄")
    local stopBtn = CreateHackButton("🛑 STOP ALL", 150, 415, Color3.fromRGB(80, 0, 0), "🛑")

    -- ============================================================
    -- MINIMIEREN / MAXIMIEREN LOGIK
    -- ============================================================
    MinBtn.MouseButton1Click:Connect(function()
        ToggleMinimize(MainFrame, TitleFrame, ContentFrame, StatusLabel)
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        StopAll()
    end)

    -- ============================================================
    -- MEGA FARMING
    -- ============================================================
    local function StartMegaFarming()
        if not IsRunning then return end
        StatusLabel.Text = "🌾 MEGA FARMT... 🌾"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        ProgressBar.Size = UDim2.new(0.3, 0, 1, 0)
        
        local taskId = task.spawn(function()
            local farmGUI = Player.PlayerGui:FindFirstChild("FarmGUI")
            if not farmGUI then
                StatusLabel.Text = "❌ FARMGUI NICHT GEFUNDEN!"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                ProgressBar.Size = UDim2.new(0, 0, 1, 0)
                return
            end
            
            local farms = {
                "Rings",
                "Monalis",
                "JobFarm", 
                "BoatFarm"
            }
            
            local total = #farms * Settings.Farming.BuyAmount
            local current = 0
            
            while IsRunning do
                for _, name in ipairs(farms) do
                    if Settings.Farming[name] then
                        local btn = farmGUI:FindFirstChild(name .. "Button")
                        if btn then
                            for i = 1, Settings.Farming.BuyAmount do
                                if not IsRunning then return end
                                btn:Click()
                                current = current + 1
                                ProgressBar.Size = UDim2.new(current / total, 0, 1, 0)
                                task.wait(Settings.Farming.Delay)
                            end
                        end
                    end
                end
                current = 0
                if Settings.Farming.AutoRestart then
                    task.wait(Settings.Farming.RestartTime)
                else
                    break
                end
            end
            
            StatusLabel.Text = "✅ MEGA FARMING AKTIV!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            ProgressBar.Size = UDim2.new(1, 0, 1, 0)
        end)
        table.insert(AllFarmingTasks, taskId)
    end

    -- ============================================================
    -- GOD MODE
    -- ============================================================
    local godActive = false
    local function ToggleGodMode()
        godActive = not godActive
        godBtn.Text = (godActive and "👑" or "🔓") .. " GOD MODE"
        
        if godActive then
            local char = Player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                    hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                end
            end
            StatusLabel.Text = "👑 GOD MODE AKTIV"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        else
            StatusLabel.Text = "👑 GOD MODE DEAKTIVIERT"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end

    -- ============================================================
    -- ESP WALLHACK
    -- ============================================================
    local espActive = false
    local function ToggleESP()
        espActive = not espActive
        espBtn.Text = (espActive and "👁️" or "🔓") .. " ESP WALLHACK"
        
        if espActive then
            StatusLabel.Text = "👁️ ESP AKTIV"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            task.spawn(function()
                while IsRunning and espActive do
                    for _, otherPlayer in ipairs(Players:GetPlayers()) do
                        if otherPlayer ~= Player then
                            local char = otherPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local box = Instance.new("BoxHandleAdornment")
                                box.Size = Vector3.new(2, 5, 1)
                                box.Color3 = Settings.ESP.BoxColor
                                box.Transparency = 0.5
                                box.AlwaysOnTop = true
                                box.Adornee = char:FindFirstChild("HumanoidRootPart")
                                box.Parent = char
                                table.insert(ESPObjects, box)
                                
                                local label = Instance.new("BillboardGui")
                                label.Size = UDim2.new(0, 100, 0, 30)
                                label.Adornee = char:FindFirstChild("Head")
                                label.Parent = char
                                label.AlwaysOnTop = true
                                
                                local text = Instance.new("TextLabel")
                                text.Size = UDim2.new(1, 0, 1, 0)
                                text.BackgroundTransparency = 1
                                text.Text = otherPlayer.Name
                                text.TextColor3 = Settings.ESP.TextColor
                                text.TextSize = 14
                                text.Font = Enum.Font.GothamBold
                                text.Parent = label
                                table.insert(ESPObjects, label)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            StatusLabel.Text = "👁️ ESP DEAKTIVIERT"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            for _, obj in ipairs(ESPObjects) do
                obj:Destroy()
            end
            ESPObjects = {}
        end
    end

    -- ============================================================
    -- AIMBOT
    -- ============================================================
    local aimActive = false
    local function ToggleAimbot()
        aimActive = not aimActive
        aimBtn.Text = (aimActive and "🎯" or "🔓") .. " AIMBOT"
        
        if aimActive then
            StatusLabel.Text = "🎯 AIMBOT AKTIV"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            
            task.spawn(function()
                while IsRunning and aimActive do
                    local target = nil
                    local closest = math.huge
                    local char = Player.Character
                    if char then
                        for _, otherPlayer in ipairs(Players:GetPlayers()) do
                            if otherPlayer ~= Player then
                                local otherChar = otherPlayer.Character
                                if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
                                    local dist = (char.HumanoidRootPart.Position - otherChar.HumanoidRootPart.Position).Magnitude
                                    if dist < closest then
                                        closest = dist
                                        target = otherChar.HumanoidRootPart
                                    end
                                end
                            end
                        end
                    end
                    if target then
                        local mouse = Player:GetMouse()
                        local pos = target.Position
                        local camera = Workspace.CurrentCamera
                        local screenPos, onScreen = camera:WorldToViewportPoint(pos)
                        if onScreen then
                            local smoothX = mouse.X + (screenPos.X - mouse.X) * Settings.Aimbot.Smoothness
                            local smoothY = mouse.Y + (screenPos.Y - mouse.Y) * Settings.Aimbot.Smoothness
                            mouse.Move(smoothX, smoothY)
                        end
                    end
                    task.wait(0.05)
                end
            end)
        else
            StatusLabel.Text = "🎯 AIMBOT DEAKTIVIERT"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end

    -- ============================================================
    -- TELEPORT
    -- ============================================================
    local teleActive = false
    local function ToggleTeleport()
        teleActive = not teleActive
        teleBtn.Text = (teleActive and "🌀" or "🔓") .. " TELEPORT"
        
        if teleActive then
            StatusLabel.Text = "🌀 TELEPORT AKTIV (Drücke T)"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        else
            StatusLabel.Text = "🌀 TELEPORT DEAKTIVIERT"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end

    -- ============================================================
    -- ANTI AFK
    -- ============================================================
    local afkActive = true
    local function ToggleAFK()
        afkActive = not afkActive
        afkBtn.Text = (afkActive and "🛡️" or "🔓") .. " ANTI AFK"
        StatusLabel.Text = afkActive and "✅ ANTI AFK AKTIV" or "⏸️ ANTI AFK PAUSIERT"
        StatusLabel.TextColor3 = afkActive and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 200, 50)
    end

    -- ============================================================
    -- AUTO DEATH
    -- ============================================================
    local deathActive = true
    local function ToggleDeath()
        deathActive = not deathActive
        deathBtn.Text = (deathActive and "💀" or "🔓") .. " AUTO DEATH"
        StatusLabel.Text = deathActive and "✅ AUTO DEATH AKTIV" or "⏸️ AUTO DEATH PAUSIERT"
        StatusLabel.TextColor3 = deathActive and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 200, 50)
    end

    -- ============================================================
    -- SPEED HACK
    -- ============================================================
    local speedActive = true
    local function ToggleSpeed()
        speedActive = not speedActive
        speedBtn.Text = (speedActive and "🚗" or "🔓") .. " SPEED HACK"
        StatusLabel.Text = speedActive and "✅ SPEED HACK AKTIV" or "⏸️ SPEED HACK PAUSIERT"
        StatusLabel.TextColor3 = speedActive and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 200, 50)
    end

    -- ============================================================
    -- AUTO CLICK
    -- ============================================================
    local clickActive = false
    local function ToggleClick()
        clickActive = not clickActive
        clickBtn.Text = (clickActive and "🖱️" or "🔓") .. " AUTO CLICK"
        
        if clickActive then
            StatusLabel.Text = "🖱️ AUTO CLICK AKTIV"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            local taskId = task.spawn(function()
                while IsRunning and clickActive do
                    local mouse = Player:GetMouse()
                    if mouse then
                        mouse.Button1Click:Fire()
                    end
                    task.wait(Settings.AutoClick.Delay)
                end
            end)
            table.insert(AllAutoClickTasks, taskId)
        else
            StatusLabel.Text = "⏸️ AUTO CLICK PAUSIERT"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        end
    end

    -- ============================================================
    -- RESET
    -- ============================================================
    local function ResetAll()
        StatusLabel.Text = "🔄 RESET... 🔄"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        
        godActive = false
        espActive = false
        aimActive = false
        teleActive = false
        clickActive = false
        afkActive = true
        deathActive = true
        speedActive = true
        
        godBtn.Text = "👑 GOD MODE"
        espBtn.Text = "👁️ ESP WALLHACK"
        aimBtn.Text = "🎯 AIMBOT"
        teleBtn.Text = "🌀 TELEPORT"
        clickBtn.Text = "🖱️ AUTO CLICK"
        afkBtn.Text = "🛡️ ANTI AFK"
        deathBtn.Text = "💀 AUTO DEATH"
        speedBtn.Text = "🚗 SPEED HACK"
        
        for _, obj in ipairs(ESPObjects) do
            obj:Destroy()
        end
        ESPObjects = {}
        
        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        StatusLabel.Text = "🟢 ALLES ZURÜCKGESETZT"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end

    -- ============================================================
    -- BUTTON BINDINGS
    -- ============================================================
    farmBtn.MouseButton1Click:Connect(StartMegaFarming)
    afkBtn.MouseButton1Click:Connect(ToggleAFK)
    deathBtn.MouseButton1Click:Connect(ToggleDeath)
    speedBtn.MouseButton1Click:Connect(ToggleSpeed)
    godBtn.MouseButton1Click:Connect(ToggleGodMode)
    espBtn.MouseButton1Click:Connect(ToggleESP)
    aimBtn.MouseButton1Click:Connect(ToggleAimbot)
    teleBtn.MouseButton1Click:Connect(ToggleTeleport)
    clickBtn.MouseButton1Click:Connect(ToggleClick)
    resetBtn.MouseButton1Click:Connect(ResetAll)
    stopBtn.MouseButton1Click:Connect(StopAll)

    -- ============================================================
    -- KEYBINDS
    -- ============================================================
    UserInputService.InputBegan:Connect(function(input)
        if not IsRunning then return end
        
        if input.KeyCode == Enum.KeyCode.F1 then
            StartMegaFarming()
        elseif input.KeyCode == Enum.KeyCode.F2 then
            ToggleAFK()
        elseif input.KeyCode == Enum.KeyCode.F3 then
            ToggleDeath()
        elseif input.KeyCode == Enum.KeyCode.F4 then
            ToggleSpeed()
        elseif input.KeyCode == Enum.KeyCode.F5 then
            ToggleGodMode()
        elseif input.KeyCode == Enum.KeyCode.F6 then
            ToggleESP()
        elseif input.KeyCode == Enum.KeyCode.F7 then
            ToggleAimbot()
        elseif input.KeyCode == Enum.KeyCode.F8 then
            ToggleClick()
        elseif input.KeyCode == Enum.KeyCode.F9 then
            ResetAll()
        elseif input.KeyCode == Enum.KeyCode.F12 then
            StopAll()
        end
        
        if input.KeyCode == Settings.Teleport.Key and teleActive then
            local mouse = Player:GetMouse()
            local target = mouse.Hit.Position
            local char = Player.Character
            if char then
                char:SetPrimaryPartCFrame(CFrame.new(target))
            end
        end
    end)

    -- ============================================================
    -- ANIMATION
    -- ============================================================
    MainFrame.BackgroundTransparency = 1
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.05
    }):Play()

    return {
        ScreenGui = ScreenGui,
        StatusLabel = StatusLabel,
        ProgressBar = ProgressBar,
        MainFrame = MainFrame,
        TitleFrame = TitleFrame,
        ContentFrame = ContentFrame,
        ToggleMinimize = ToggleMinimize
    }
end

-- ============================================================
-- ANTI AFK SYSTEM
-- ============================================================
local function AntiAFKSystem()
    local vu = VirtualUser
    Player.Idled:Connect(function()
        if Settings.AntiAFK.Enabled and afkActive then
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end)
end

-- ============================================================
-- AUTO DEATH SYSTEM
-- ============================================================
local function AutoDeathSystem()
    if not Settings.AutoDeath.Enabled then return end
    
    local function onCharacterAdded(char)
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.HealthChanged:Connect(function(health)
                if health <= 0 and Settings.AutoDeath.AutoRespawn and deathActive then
                    task.wait(Settings.AutoDeath.RespawnDelay)
                    local respawnEvent = ReplicatedStorage:FindFirstChild("RespawnEvent")
                    if respawnEvent then
                        resp
