--[[
███████╗ █████╗ ███╗   ██╗    ██████╗ ██╗███████╗ ██████╗ ██████╗ 
██╔════╝██╔══██╗████╗  ██║    ██╔══██╗██║██╔════╝██╔═══██╗██╔══██╗
███████╗███████║██╔██╗ ██║    ██║  ██║██║█████╗  ██║   ██║██████╔╝
╚════██║██╔══██║██║╚██╗██║    ██║  ██║██║██╔══╝  ██║   ██║██╔══██╗
███████║██║  ██║██║ ╚████║    ██████╔╝██║███████╗╚██████╔╝██║  ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝    ╚═════╝ ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
--]]

-- ============================================================
-- SAN DIEGO BORDER ULTIMATE V3 - MEGA ULTRA DELUXE EDITION
-- 100% Eigenes Skript - Over 9000 Zeilen Power!
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
        BuyAmount = 10,
        Delay = 0.3,
        AutoRestart = true,
        RestartTime = 300
    },
    AntiAFK = {
        Enabled = true,
        Mode = "VirtualUser",
        Delay = 60
    },
    AutoDeath = {
        Enabled = true,
        AutoRespawn = true,
        RespawnDelay = 1
    },
    VehicleSpeed = {
        Enabled = true,
        Speed = 300,
        Key = Enum.KeyCode.LeftAlt,
        SmoothBoost = true
    },
    AutoClick = {
        Enabled = false,
        Delay = 0.1
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
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
if not Player then
    Players.PlayerAdded:Wait()
    Player = Players.LocalPlayer
end

-- ============================================================
-- SOUND SYSTEM
-- ============================================================
local function PlaySound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0.5
    sound.Parent = CoreGui
    sound:Play()
    task.wait(1)
    sound:Destroy()
end

-- ============================================================
-- MEGA GUI SYSTEM
-- ============================================================
local function CreateMegaGUI()
    -- Haupt-ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SanDiegoUltimateV3"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    -- Hintergrund-Effekte
    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.7
    Background.Parent = ScreenGui

    -- Haupt-Frame mit Animation
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 520, 0, 580)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -290)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
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
    Glow.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
    Glow.BackgroundTransparency = 0.9
    Glow.BorderSizePixel = 0
    Glow.Parent = MainFrame
    Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 20)

    -- Titel mit Gradient
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Size = UDim2.new(1, 0, 0, 60)
    TitleFrame.Position = UDim2.new(0, 0, 0, 0)
    TitleFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    TitleFrame.BorderSizePixel = 0
    TitleFrame.Parent = MainFrame
    Instance.new("UICorner", TitleFrame).CornerRadius = UDim.new(0, 16)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🏜️ SAN DIEGO BORDER ULTIMATE V3"
    Title.TextColor3 = Color3.fromRGB(255, 200, 100)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleFrame

    -- Untertitel
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, -40, 0, 20)
    SubTitle.Position = UDim2.new(0, 20, 0, 38)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "⚡ MEGA ULTRA DELUXE EDITION ⚡"
    SubTitle.TextColor3 = Color3.fromRGB(150, 150, 180)
    SubTitle.TextSize = 12
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = TitleFrame

    -- Player Info Bereich
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Size = UDim2.new(1, -40, 0, 70)
    InfoFrame.Position = UDim2.new(0, 20, 0, 75)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    InfoFrame.BorderSizePixel = 0
    InfoFrame.Parent = MainFrame
    Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 10)

    local PlayerName = Instance.new("TextLabel")
    PlayerName.Size = UDim2.new(0.5, -10, 1, 0)
    PlayerName.Position = UDim2.new(0, 10, 0, 0)
    PlayerName.BackgroundTransparency = 1
    PlayerName.Text = "👤 " .. Player.Name
    PlayerName.TextColor3 = Color3.fromRGB(220, 220, 230)
    PlayerName.TextSize = 16
    PlayerName.Font = Enum.Font.GothamBold
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    PlayerName.Parent = InfoFrame

    local UserIdLabel = Instance.new("TextLabel")
    UserIdLabel.Size = UDim2.new(0.5, -10, 0.5, 0)
    UserIdLabel.Position = UDim2.new(0.5, 10, 0, 0)
    UserIdLabel.BackgroundTransparency = 1
    UserIdLabel.Text = "🆔 " .. Player.UserId
    UserIdLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    UserIdLabel.TextSize = 12
    UserIdLabel.Font = Enum.Font.Gotham
    UserIdLabel.TextXAlignment = Enum.TextXAlignment.Right
    UserIdLabel.Parent = InfoFrame

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
    StatusLabel.Position = UDim2.new(0, 20, 0, 160)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "🟢 SYSTEM BEREIT"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    StatusLabel.TextSize = 16
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.Parent = MainFrame

    -- Fortschrittsbalken
    local ProgressFrame = Instance.new("Frame")
    ProgressFrame.Size = UDim2.new(0.9, 0, 0, 6)
    ProgressFrame.Position = UDim2.new(0.05, 0, 0, 195)
    ProgressFrame.BackgroundColor3 = Color3.fromRGB(30, 33, 40)
    ProgressFrame.BorderSizePixel = 0
    ProgressFrame.Parent = MainFrame
    Instance.new("UICorner", ProgressFrame).CornerRadius = UDim.new(0, 3)

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = ProgressFrame
    Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 3)

    -- Button Creator Funktion
    local function CreateUltraButton(text, x, y, color, icon, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 210, 0, 48)
        btn.Position = UDim2.new(0, x, 0, y)
        btn.BackgroundColor3 = color or Color3.fromRGB(30, 35, 45)
        btn.BorderSizePixel = 0
        btn.Text = icon .. " " .. text
        btn.TextColor3 = Color3.fromRGB(235, 235, 245)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = MainFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        -- Hover-Effekt
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 50, 65)
            }):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = color or Color3.fromRGB(30, 35, 45)
            }):Play()
        end)
        
        if callback then
            btn.MouseButton1Click:Connect(callback)
        end
        return btn
    end

    -- ============================================================
    -- BUTTONS
    -- ============================================================
    local farmBtn = CreateUltraButton("FARMEN", 20, 215, Color3.fromRGB(40, 80, 60), "🌾")
    local afkBtn = CreateUltraButton("ANTI AFK", 250, 215, Color3.fromRGB(50, 60, 90), "🛡️")
    local deathBtn = CreateUltraButton("AUTO DEATH", 20, 275, Color3.fromRGB(80, 50, 60), "💀")
    local speedBtn = CreateUltraButton("SPEED BOOST", 250, 275, Color3.fromRGB(50, 70, 100), "🚗")
    local clickBtn = CreateUltraButton("AUTO CLICK", 20, 335, Color3.fromRGB(60, 60, 80), "🖱️")
    local resetBtn = CreateUltraButton("RESET ALL", 250, 335, Color3.fromRGB(80, 40, 40), "🔄")

    -- Extra Buttons
    local statsBtn = CreateUltraButton("STATISTIK", 20, 395, Color3.fromRGB(40, 60, 80), "📊")
    local helpBtn = CreateUltraButton("HILFE", 250, 395, Color3.fromRGB(50, 50, 70), "❓")

    -- ============================================================
    -- FARMING LOGIK
    -- ============================================================
    local function StartFarming()
        StatusLabel.Text = "🌾 FARMT... 🌾"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        ProgressBar.Size = UDim2.new(0.3, 0, 1, 0)
        
        task.spawn(function()
            local farmGUI = Player.PlayerGui:FindFirstChild("FarmGUI")
            if not farmGUI then
                StatusLabel.Text = "❌ FARMGUI NICHT GEFUNDEN!"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
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
            
            for _, name in ipairs(farms) do
                if Settings.Farming[name] then
                    local btn = farmGUI:FindFirstChild(name .. "Button")
                    if btn then
                        for i = 1, Settings.Farming.BuyAmount do
                            btn:Click()
                            current = current + 1
                            ProgressBar.Size = UDim2.new(current / total, 0, 1, 0)
                            task.wait(Settings.Farming.Delay)
                        end
                    end
                end
            end
            
            StatusLabel.Text = "✅ FARMING ABGESCHLOSSEN!"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            ProgressBar.Size = UDim2.new(1, 0, 1, 0)
            
            if Settings.Farming.AutoRestart then
                task.wait(Settings.Farming.RestartTime)
                StartFarming()
            end
        end)
    end

    -- ============================================================
    -- ANTI AFK
    -- ============================================================
    local afkActive = true
    local function ToggleAFK()
        afkActive = not afkActive
        afkBtn.Text = (afkActive and "🛡️" or "🔓") .. " ANTI AFK"
        StatusLabel.Text = afkActive and "✅ ANTI AFK AKTIV" or "⏸️ ANTI AFK PAUSIERT"
        StatusLabel.TextColor3 = afkActive and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 200, 50)
    end

    -- ============================================================
    -- AUTO DEATH
    -- ============================================================
    local deathActive = true
    local function ToggleDeath()
        deathActive = not deathActive
        deathBtn.Text = (deathActive and "💀" or "🔓") .. " AUTO DEATH"
        StatusLabel.Text = deathActive and "✅ AUTO DEATH AKTIV" or "⏸️ AUTO DEATH PAUSIERT"
        StatusLabel.TextColor3 = deathActive and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 200, 50)
    end

    -- ============================================================
    -- SPEED BOOST
    -- ============================================================
    local speedActive = true
    local function ToggleSpeed()
        speedActive = not speedActive
        speedBtn.Text = (speedActive and "🚗" or "🔓") .. " SPEED BOOST"
        StatusLabel.Text = speedActive and "✅ SPEED BOOST AKTIV" or "⏸️ SPEED BOOST PAUSIERT"
        StatusLabel.TextColor3 = speedActive and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 200, 50)
    end

    -- ============================================================
    -- AUTO CLICK
    -- ============================================================
    local clickActive = false
    local clickConnection = nil
    local function ToggleClick()
        clickActive = not clickActive
        clickBtn.Text = (clickActive and "🖱️" or "🔓") .. " AUTO CLICK"
        
        if clickActive then
            StatusLabel.Text = "🖱️ AUTO CLICK AKTIV"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            clickConnection = RunService.Heartbeat:Connect(function()
                if clickActive then
                    local mouse = Player:GetMouse()
                    if mouse then
                        mouse.Button1Click:Fire()
                        task.wait(Settings.AutoClick.Delay)
                    end
                end
            end)
        else
            if clickConnection then
                clickConnection:Disconnect()
                clickConnection = nil
            end
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
        
        -- Alle Toggles zurücksetzen
        afkActive = true
        deathActive = true
        speedActive = true
        clickActive = false
        
        afkBtn.Text = "🛡️ ANTI AFK"
        deathBtn.Text = "💀 AUTO DEATH"
        speedBtn.Text = "🚗 SPEED BOOST"
        clickBtn.Text = "🖱️ AUTO CLICK"
        
        if clickConnection then
            clickConnection:Disconnect()
            clickConnection = nil
        end
        
        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        StatusLabel.Text = "🟢 SYSTEM ZURÜCKGESETZT"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    end

    -- ============================================================
    -- STATISTIK
    -- ============================================================
    local function ShowStats()
        StatusLabel.Text = "📊 STATISTIK ANZEIGEN..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        
        local stats = {
            "📊 STATISTIK",
            "━━━━━━━━━━━━━━━━",
            "👤 Spieler: " .. Player.Name,
            "🆔 ID: " .. Player.UserId,
            "🌐 Server: " .. game.JobId,
            "⏱️ Laufzeit: " .. math.floor(os.clock()) .. "s",
            "━━━━━━━━━━━━━━━━",
            "🛡️ Anti AFK: " .. (afkActive and "✅" or "❌"),
            "💀 Auto Death: " .. (deathActive and "✅" or "❌"),
            "🚗 Speed: " .. (speedActive and "✅" or "❌"),
            "🖱️ Auto Click: " .. (clickActive and "✅" or "❌")
        }
        
        local statText = table.concat(stats, "\n")
        
        StarterGui:SetCore("SendNotification", {
            Title = "📊 STATISTIK",
            Text = statText,
            Duration = 8
        })
        
        StatusLabel.Text = "📊 STATISTIK ANGEZEIGT"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    end

    -- ============================================================
    -- HILFE
    -- ============================================================
    local function ShowHelp()
        StatusLabel.Text = "❓ HILFE ANZEIGEN..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        
        local help = {
            "❓ HILFE",
            "━━━━━━━━━━━━━━━━",
            "🌾 FARMEN = Startet automatisches Farmen",
            "🛡️ ANTI AFK = Verhindert AFK-Kick",
            "💀 AUTO DEATH = Automatischer Respawn",
            "🚗 SPEED = Speed mit Alt-Taste",
            "🖱️ AUTO CLICK = Automatisches Klicken",
            "🔄 RESET = Setzt alles zurück",
            "📊 STATISTIK = Zeigt Infos an"
        }
        
        local helpText = table.concat(help, "\n")
        
        StarterGui:SetCore("SendNotification", {
            Title = "❓ HILFE",
            Text = helpText,
            Duration = 8
        })
        
        StatusLabel.Text = "❓ HILFE ANGEZEIGT"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    end

    -- ============================================================
    -- BUTTON BINDINGS
    -- ============================================================
    farmBtn.MouseButton1Click:Connect(StartFarming)
    afkBtn.MouseButton1Click:Connect(ToggleAFK)
    deathBtn.MouseButton1Click:Connect(ToggleDeath)
    speedBtn.MouseButton1Click:Connect(ToggleSpeed)
    clickBtn.MouseButton1Click:Connect(ToggleClick)
    resetBtn.MouseButton1Click:Connect(ResetAll)
    statsBtn.MouseButton1Click:Connect(ShowStats)
    helpBtn.MouseButton1Click:Connect(ShowHelp)

    -- ============================================================
    -- KEYBINDS
    -- ============================================================
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F1 then
            StartFarming()
        elseif input.KeyCode == Enum.KeyCode.F2 then
            ToggleAFK()
        elseif input.KeyCode == Enum.KeyCode.F3 then
            ToggleDeath()
        elseif input.KeyCode == Enum.KeyCode.F4 then
            ToggleSpeed()
        elseif input.KeyCode == Enum.KeyCode.F5 then
            ToggleClick()
        elseif input.KeyCode == Enum.KeyCode.F6 then
            ResetAll()
        end
    end)

    -- ============================================================
    -- ANIMATIONEN
    -- ============================================================
    -- Einblend-Animation
    MainFrame.BackgroundTransparency = 1
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.05
    }):Play()

    -- ============================================================
    -- RÜCKGABE
    -- ============================================================
    return {
        ScreenGui = ScreenGui,
        StatusLabel = StatusLabel,
        ProgressBar = ProgressBar,
        AfkActive = afkActive,
        DeathActive = deathActive,
        SpeedActive = speedActive,
        ClickActive = clickActive
    }
end

-- ============================================================
-- ANTI AFK SYSTEM
-- ============================================================
local function AntiAFKSystem()
    local vu = VirtualUser
    Player.Idled:Connect(function()
        if Settings.AntiAFK.Enabled then
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
                if health <= 0 and Settings.AutoDeath.AutoRespawn then
                    task.wait(Settings.AutoDeath.RespawnDelay)
                    local respawnEvent = ReplicatedStorage:FindFirstChild("RespawnEvent")
                    if respawnEvent then
                        respawnEvent:FireServer()
                    end
                end
            end)
        end
    end
    
    if Player.Character then
        onCharacterAdded(Player.Character)
    end
    Player.CharacterAdded:Connect(onCharacterAdded)
end

-- ============================================================
-- SPEED BOOST SYSTEM
-- ============================================================
local function SpeedBoostSystem()
    if not Settings.VehicleSpeed.Enabled then return end
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Settings.VehicleSpeed.Key then
            local char = Player.Character
            if char then
                local vehicle = char:FindFirstChildOfClass("Vehicle")
                if vehicle then
                    local speed = vehicle:FindFirstChild("Speed")
                    if speed then
                        if Settings.VehicleSpeed.SmoothBoost then
                            for i = speed.Value, Settings.VehicleSpeed.Speed, 5 do
                                speed.Value = i
                                task.wait(0.01)
                            end
                        else
                            speed.Value = Settings.VehicleSpeed.Speed
                        end
                    end
                end
            end
        end
    end)
end

-- ============================================================
-- AUTOMATISCHES FARMEN BEIM START
-- ============================================================
local function AutoStartFarm()
    task.wait(3)
    if Settings.Farming.Enabled then
        StartFarming()
    end
end

-- ============================================================
-- GUI EFFEKTE
-- ============================================================
local function AmbientEffects()
    local colors = {
        Color3.fromRGB(255, 100, 50),
        Color3.fromRGB(255, 200, 100),
        Color3.fromRGB(100, 200, 255),
        Color3.fromRGB(200, 100, 255)
    }
    
    local current = 1
    RunService.Heartbeat:Connect(function()
        current = current + 1
        if current > #colors then current = 1 end
        Lighting.Ambient = colors[current]
    end)
end

-- ============================================================
-- START SEQUENCE
-- ============================================================
local function StartUltimateScript()
    print("🏜️ SAN DIEGO BORDER ULTIMATE V3")
    print("═" .. string.rep("═", 40))
    print("👤 Spieler: " .. Player.Name)
    print("🆔 ID: " .. Player.UserId)
    print("🌐 Server: " .. game.JobId)
    print("📦 Version: 3.0 MEGA ULTRA")
    print("═" .. string.rep("═", 40))
    
    -- GUI erstellen
    local gui = CreateMegaGUI()
    
    -- Systeme starten
    task.spawn(AntiAFKSystem)
    task.spawn(AutoDeathSystem)
    task.spawn(SpeedBoostSystem)
    task.spawn(AutoStartFarm)
    task.spawn(AmbientEffects)
    
    -- Willkommens-Nachricht
    task.wait(1)
    StarterGui:SetCore("SendNotification", {
        Title = "🏜️ SAN DIEGO ULTIMATE V3",
        Text = "🚀 ALLE SYSTEME AKTIV!",
        Duration = 5
    })
    
    print("✅ Alle Systeme aktiv!")
    print("📋 F1 = Farm | F2 = Anti AFK | F3 = Auto Death")
    print("📋 F4 = Speed | F5 = Auto Click | F6 = Reset")
end

-- ============================================================
-- FEHLERBEHANDLUNG
-- ============================================================
local success, errorMsg = pcall(StartUltimateScript)
if not success then
    warn("❌ Fehler: " .. tostring(errorMsg))
    StarterGui:SetCore("SendNotification", {
        Title = "❌ FEHLER",
        Text = "Skript konnte nicht starten: " .. tostring(errorMsg),
        Duration = 8
    })
end

-- ============================================================
-- ENDE
-- ============================================================
print("🏜️ SAN DIEGO ULTIMATE V3 - Gestartet!")
print("❤️ Viel Spaß beim Farmen!")
