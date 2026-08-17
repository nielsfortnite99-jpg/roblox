--[[
San Diego Border ULTIMATE - Komplett eigenes Skript
100% selbst geschrieben - Kein externer Code
--]]

-- ===== EIGENE KONFIGURATION =====
local config = {
    username = "Spieler",
    autoFarm = true,
    antiAFK = true,
    autoDeath = true,
    speedBoost = true,
    farmDelay = 0.3,
    buyAmount = 5
}

-- ===== EIGENE SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
if not player then
    Players.PlayerAdded:Wait()
    player = Players.LocalPlayer
end

-- ===== EIGENE GUI =====
local function createOwnGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MySanDiegoHub"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    -- Titel
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 45)
    title.Position = UDim2.new(0, 20, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = "🏜️ San Diego ULTIMATE"
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = mainFrame

    -- Spieler Info
    local playerInfo = Instance.new("TextLabel")
    playerInfo.Size = UDim2.new(1, -40, 0, 25)
    playerInfo.Position = UDim2.new(0, 20, 0, 60)
    playerInfo.BackgroundTransparency = 1
    playerInfo.Text = "👤 " .. player.Name
    playerInfo.TextColor3 = Color3.fromRGB(200, 200, 210)
    playerInfo.TextSize = 14
    playerInfo.Font = Enum.Font.Gotham
    playerInfo.TextXAlignment = Enum.TextXAlignment.Left
    playerInfo.Parent = mainFrame

    -- Status Label (eigenes)
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 25)
    statusLabel.Position = UDim2.new(0, 20, 0, 90)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "✅ Bereit"
    statusLabel.TextColor3 = Color3.fromRGB(100, 220, 150)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = mainFrame

    -- Eigene Button-Funktion
    local function createMyButton(text, x, y, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 190, 0, 42)
        btn.Position = UDim2.new(0, x, 0, y)
        btn.BackgroundColor3 = color or Color3.fromRGB(35, 40, 50)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(240, 240, 245)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = mainFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        if callback then
            btn.MouseButton1Click:Connect(callback)
        end
        return btn
    end

    -- Eigene Buttons
    local farmBtn = createMyButton("🌾 Farmen", 20, 140, Color3.fromRGB(40, 80, 60))
    local afkBtn = createMyButton("🛡️ Anti AFK", 230, 140, Color3.fromRGB(50, 60, 80))
    local deathBtn = createMyButton("💀 Auto Death", 20, 195, Color3.fromRGB(80, 50, 50))
    local speedBtn = createMyButton("🚗 Speed", 230, 195, Color3.fromRGB(50, 70, 90))

    -- Eigene Farming-Logik
    farmBtn.MouseButton1Click:Connect(function()
        statusLabel.Text = "🌾 Farme..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        
        task.spawn(function()
            -- Eigene Farm-Funktion
            local farmGUI = player.PlayerGui:FindFirstChild("FarmGUI")
            if not farmGUI then
                statusLabel.Text = "❌ FarmGUI nicht gefunden!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                return
            end
            
            -- Eigene Farm-Liste
            local myFarms = {
                "Rings",
                "Monalis",
                "JobFarm",
                "BoatFarm"
            }
            
            for _, name in ipairs(myFarms) do
                local btn = farmGUI:FindFirstChild(name .. "Button")
                if btn then
                    for i = 1, config.buyAmount do
                        btn:Click()
                        task.wait(config.farmDelay)
                    end
                end
            end
            
            statusLabel.Text = "✅ Farming fertig!"
            statusLabel.TextColor3 = Color3.fromRGB(100, 220, 150)
        end)
    end)

    -- Eigene Anti-AFK Toggle
    local afkActive = true
    afkBtn.MouseButton1Click:Connect(function()
        afkActive = not afkActive
        afkBtn.Text = afkActive and "🛡️ Anti AFK" or "🛡️ AFK AUS"
        statusLabel.Text = afkActive and "✅ Anti AFK aktiv" or "⏸️ Anti AFK pausiert"
        statusLabel.TextColor3 = afkActive and Color3.fromRGB(100, 220, 150) or Color3.fromRGB(255, 150, 50)
    end)

    -- Eigene Auto-Death Toggle
    local deathActive = true
    deathBtn.MouseButton1Click:Connect(function()
        deathActive = not deathActive
        deathBtn.Text = deathActive and "💀 Auto Death" or "💀 Death AUS"
        statusLabel.Text = deathActive and "✅ Auto Death aktiv" or "⏸️ Auto Death pausiert"
        statusLabel.TextColor3 = deathActive and Color3.fromRGB(100, 220, 150) or Color3.fromRGB(255, 150, 50)
    end)

    -- Eigene Speed Toggle
    local speedActive = true
    speedBtn.MouseButton1Click:Connect(function()
        speedActive = not speedActive
        speedBtn.Text = speedActive and "🚗 Speed" or "🚗 Speed AUS"
        statusLabel.Text = speedActive and "✅ Speed aktiv" or "⏸️ Speed pausiert"
        statusLabel.TextColor3 = speedActive and Color3.fromRGB(100, 220, 150) or Color3.fromRGB(255, 150, 50)
    end)

    return {
        ScreenGui = screenGui,
        StatusLabel = statusLabel,
        AfkActive = afkActive,
        DeathActive = deathActive,
        SpeedActive = speedActive
    }
end

-- ===== EIGENE ANTI-AFK =====
local function myAntiAFK()
    local vu = VirtualUser
    player.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end

-- ===== EIGENE AUTO-DEATH =====
local function myAutoDeath()
    local function onCharacterAdded(char)
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.HealthChanged:Connect(function(health)
                if health <= 0 then
                    local respawn = ReplicatedStorage:FindFirstChild("RespawnEvent")
                    if respawn then
                        respawn:FireServer()
                    end
                end
            end)
        end
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- ===== EIGENE SPEED =====
local function mySpeed()
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            local char = player.Character
            if char then
                local vehicle = char:FindFirstChildOfClass("Vehicle")
                if vehicle then
                    local speed = vehicle:FindFirstChild("Speed")
                    if speed then
                        speed.Value = 250
                    end
                end
            end
        end
    end)
end

-- ===== EIGENER START =====
local function startMyScript()
    print("🏜️ San Diego ULTIMATE - Mein eigenes Skript")
    print("👤 Spieler: " .. player.Name)
    print("🌐 Server: " .. game.JobId)
    
    -- GUI erstellen
    local gui = createOwnGUI()
    
    -- Features starten
    task.spawn(myAntiAFK)
    task.spawn(myAutoDeath)
    task.spawn(mySpeed)
    
    -- Status anzeigen
    gui.StatusLabel.Text = "✅ Alles aktiv!"
    gui.StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 150)
    
    -- Willkommens-Nachricht
    CoreGui:SetCore("SendNotification", {
        Title = "🏜️ San Diego ULTIMATE",
        Text = "Dein eigenes Skript läuft!",
        Duration = 5
    })
end

-- ===== START =====
local success, errorMsg = pcall(startMyScript)
if not success then
    warn("❌ Fehler: " .. tostring(errorMsg))
    CoreGui:SetCore("SendNotification", {
        Title = "❌ Fehler",
        Text = "Skript konnte nicht starten: " .. tostring(errorMsg),
        Duration = 5
    })
end
