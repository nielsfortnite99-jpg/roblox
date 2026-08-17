--[[
San Diego Border V2 - Complete Overhaul
100% neu geschrieben, optimiert, mit allen Features
--]]

-- ===== KONFIGURATION =====
local Settings = {
    Farming = {
        Enabled = true,
        Rings = true,
        Monalis = true,
        ElDiablo = false,
        JobFarm = true,
        BoatFarm = true,
        BuyAmount = 5,
        Delay = 0.5
    },
    AntiAFK = true,
    AutoDeath = true,
    VehicleSpeed = {
        Enabled = true,
        Speed = 200,
        Key = Enum.KeyCode.LeftAlt
    },
    Target = nil,
    GUI = {
        Theme = "Dark",
        Position = UDim2.new(0.5, -215, 0.5, -225)
    }
}

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
if not Player then
    Players.PlayerAdded:Wait()
    Player = Players.LocalPlayer
end

-- ===== GUI SYSTEM =====
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SanDiegoBorderV2"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 480, 0, 520)
    MainFrame.Position = Settings.GUI.Position
    MainFrame.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -48, 0, 40)
    Title.Position = UDim2.new(0, 24, 0, 16)
    Title.BackgroundTransparency = 1
    Title.Text = "🏜️ San Diego Border V2"
    Title.TextColor3 = Color3.fromRGB(245, 245, 248)
    Title.TextSize = 26
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    local ServerLabel = Instance.new("TextLabel")
    ServerLabel.Size = UDim2.new(1, -48, 0, 22)
    ServerLabel.Position = UDim2.new(0, 24, 0, 56)
    ServerLabel.BackgroundTransparency = 1
    ServerLabel.Text = "🌐 Server: " .. game.JobId
    ServerLabel.TextColor3 = Color3.fromRGB(130, 134, 145)
    ServerLabel.TextSize = 13
    ServerLabel.Font = Enum.Font.Gotham
    ServerLabel.TextXAlignment = Enum.TextXAlignment.Left
    ServerLabel.Parent = MainFrame

    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(1, -48, 0, 24)
    PlayerLabel.Position = UDim2.new(0, 24, 0, 82)
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Text = "👤 " .. Player.Name .. " (" .. Player.UserId .. ")"
    PlayerLabel.TextColor3 = Color3.fromRGB(215, 218, 225)
    PlayerLabel.TextSize = 15
    PlayerLabel.Font = Enum.Font.Gotham
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerLabel.Parent = MainFrame

    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -48, 0, 24)
    StatusLabel.Position = UDim2.new(0, 24, 0, 112)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "✅ Bereit"
    StatusLabel.TextColor3 = Color3.fromRGB(116, 210, 145)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = MainFrame

    -- Buttons
    local function CreateButton(text, x, y, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 190, 0, 44)
        btn.Position = UDim2.new(0, x, 0, y)
        btn.BackgroundColor3 = color or Color3.fromRGB(34, 37, 44)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(240, 241, 244)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = MainFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        if callback then
            btn.MouseButton1Click:Connect(callback)
        end
        return btn
    end

    -- Farming Buttons
    local farmBtn = CreateButton("🌾 Start Farm", 24, 150, Color3.fromRGB(34, 37, 44))
    local afkBtn = CreateButton("🔒 Anti AFK", 220, 150, Color3.fromRGB(34, 37, 44))
    local deathBtn = CreateButton("💀 Auto Death", 24, 204, Color3.fromRGB(34, 37, 44))
    local speedBtn = CreateButton("🚗 Speed Boost", 220, 204, Color3.fromRGB(34, 37, 44))

    -- Status Toggles
    local afkEnabled = true
    local deathEnabled = true
    local speedEnabled = true

    afkBtn.MouseButton1Click:Connect(function()
        afkEnabled = not afkEnabled
        afkBtn.Text = afkEnabled and "🔒 Anti AFK" or "🔓 Anti AFK"
        StatusLabel.Text = afkEnabled and "✅ Anti AFK aktiv" or "⏸️ Anti AFK pausiert"
        StatusLabel.TextColor3 = afkEnabled and Color3.fromRGB(116, 210, 145) or Color3.fromRGB(232, 112, 112)
    end)

    deathBtn.MouseButton1Click:Connect(function()
        deathEnabled = not deathEnabled
        deathBtn.Text = deathEnabled and "💀 Auto Death" or "💀 Auto Death OFF"
        StatusLabel.Text = deathEnabled and "✅ Auto Death aktiv" or "⏸️ Auto Death pausiert"
        StatusLabel.TextColor3 = deathEnabled and Color3.fromRGB(116, 210, 145) or Color3.fromRGB(232, 112, 112)
    end)

    speedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        speedBtn.Text = speedEnabled and "🚗 Speed Boost" or "🚗 Speed OFF"
        StatusLabel.Text = speedEnabled and "✅ Speed Boost aktiv" or "⏸️ Speed Boost pausiert"
        StatusLabel.TextColor3 = speedEnabled and Color3.fromRGB(116, 210, 145) or Color3.fromRGB(232, 112, 112)
    end)

    -- Farming Funktion
    farmBtn.MouseButton1Click:Connect(function()
        StatusLabel.Text = "🌾 Farme..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        
        task.spawn(function()
            local farmGui = Player.PlayerGui:FindFirstChild("FarmGUI")
            if not farmGui then
                StatusLabel.Text = "❌ FarmGUI nicht gefunden!"
                StatusLabel.TextColor3 = Color3.fromRGB(232, 112, 112)
                return
            end
            
            local farms = {
                Rings = Settings.Farming.Rings,
                Monalis = Settings.Farming.Monalis,
                ElDiablo = Settings.Farming.ElDiablo,
                JobFarm = Settings.Farming.JobFarm,
                BoatFarm = Settings.Farming.BoatFarm
            }
            
            for name, enabled in pairs(farms) do
                if enabled then
                    local btn = farmGui:FindFirstChild(name .. "Button")
                    if btn then
                        for i = 1, Settings.Farming.BuyAmount do
                            btn:Click()
                            task.wait(Settings.Farming.Delay)
                        end
                    end
                end
            end
            
            StatusLabel.Text = "✅ Farming abgeschlossen!"
            StatusLabel.TextColor3 = Color3.fromRGB(116, 210, 145)
        end)
    end)

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        StatusLabel = StatusLabel,
        AfkEnabled = afkEnabled,
        DeathEnabled = deathEnabled,
        SpeedEnabled = speedEnabled
    }
end

-- ===== ANTI AFK =====
local function AntiAFK()
    if not Settings.AntiAFK then return end
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ===== AUTO DEATH =====
local function AutoDeath()
    if not Settings.AutoDeath then return end
    local function onCharacterAdded(char)
        local hum = char:WaitForChild("Humanoid")
        hum.HealthChanged:Connect(function(health)
            if health <= 0 then
                local respawnEvent = ReplicatedStorage:FindFirstChild("RespawnEvent")
                if respawnEvent then
                    respawnEvent:FireServer()
                end
            end
        end)
    end
    
    if Player.Character then
        onCharacterAdded(Player.Character)
    end
    Player.CharacterAdded:Connect(onCharacterAdded)
end

-- ===== VEHICLE SPEED =====
local function VehicleSpeed()
    if not Settings.VehicleSpeed.Enabled then return end
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Settings.VehicleSpeed.Key then
            local char = Player.Character
            if char then
                local vehicle = char:FindFirstChildOfClass("Vehicle")
                if vehicle then
                    local speed = vehicle:FindFirstChild("Speed")
                    if speed then
                        speed.Value = Settings.VehicleSpeed.Speed
                    end
                end
            end
        end
    end)
end

-- ===== TARGET SYSTEM =====
local function GetTargets()
    local targets = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player then
            table.insert(targets, player.Name)
        end
    end
    return targets
end

-- ===== START =====
local function Start()
    -- GUI erstellen
    local gui = CreateGUI()
    
    -- Features starten
    task.spawn(AntiAFK)
    task.spawn(AutoDeath)
    task.spawn(VehicleSpeed)
    
    -- Status updaten
    gui.StatusLabel.Text = "✅ Alle Systeme aktiv"
    gui.StatusLabel.TextColor3 = Color3.fromRGB(116, 210, 145)
    
    print("🏜️ San Diego Border V2 geladen!")
    print("👤 Spieler: " .. Player.Name)
    print("🌐 Server: " .. game.JobId)
    print("📋 Features: AntiAFK, AutoDeath, SpeedBoost, Farming")
end

-- Fehlerbehandlung
local success, err = pcall(Start)
if not success then
    warn("❌ Fehler beim Start: " .. tostring(err))
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ Fehler",
        Text = "Skript konnte nicht gestartet werden: " .. tostring(err),
        Duration = 5
    })
end
