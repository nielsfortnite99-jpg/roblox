--[[
SAN DIEGO HACK V6 - MIT MINIMIER BUTTON
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
if not Player then
    Players.PlayerAdded:Wait()
    Player = Players.LocalPlayer
end

local IsMinimized = false
local IsRunning = true

-- ============================================================
-- GUI MIT MINIMIER BUTTON
-- ============================================================
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SanDiegoHackV6"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    -- Haupt-Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    -- Titelzeile (wird immer angezeigt)
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 SD HACK V6"
    Title.TextColor3 = Color3.fromRGB(255, 50, 50)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    -- MINIMIER BUTTON (ganz rechts)
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 5)
    MinBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    MinBtn.BorderSizePixel = 0
    MinBtn.Text = "➖"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 16
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = TitleBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

    -- Schließen Button (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    -- Content (wird minimiert)
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, 0, 1, -40)
    Content.Position = UDim2.new(0, 0, 0, 40)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    -- Status
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -20, 0, 30)
    Status.Position = UDim2.new(0, 10, 0, 10)
    Status.BackgroundTransparency = 1
    Status.Text = "✅ HACK AKTIV"
    Status.TextColor3 = Color3.fromRGB(255, 50, 50)
    Status.TextSize = 16
    Status.Font = Enum.Font.GothamBold
    Status.Parent = Content

    -- Buttons
    local function MakeBtn(text, x, y, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 170, 0, 40)
        btn.Position = UDim2.new(0, x, 0, y)
        btn.BackgroundColor3 = color or Color3.fromRGB(30, 0, 0)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = Content
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        return btn
    end

    local farmBtn = MakeBtn("🌾 FARMEN", 20, 50, Color3.fromRGB(40, 0, 0))
    local afkBtn = MakeBtn("🛡️ ANTI AFK", 205, 50, Color3.fromRGB(40, 0, 0))
    local godBtn = MakeBtn("👑 GOD MODE", 20, 100, Color3.fromRGB(40, 0, 0))
    local espBtn = MakeBtn("👁️ ESP", 205, 100, Color3.fromRGB(40, 0, 0))
    local speedBtn = MakeBtn("🚗 SPEED", 20, 150, Color3.fromRGB(40, 0, 0))
    local clickBtn = MakeBtn("🖱️ CLICK", 205, 150, Color3.fromRGB(40, 0, 0))
    local resetBtn = MakeBtn("🔄 RESET", 20, 200, Color3.fromRGB(40, 0, 0))
    local stopBtn = MakeBtn("🛑 STOP", 205, 200, Color3.fromRGB(80, 0, 0))

    -- ============================================================
    -- MINIMIER FUNKTION
    -- ============================================================
    local function ToggleMinimize()
        IsMinimized = not IsMinimized
        
        if IsMinimized then
            -- Nur Titelzeile anzeigen (40px hoch)
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 200, 0, 40)
            }):Play()
            Content.Visible = false
            MinBtn.Text = "➕"
        else
            -- Volles GUI anzeigen
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 400, 0, 500)
            }):Play()
            task.wait(0.3)
            Content.Visible = true
            MinBtn.Text = "➖"
        end
    end

    -- Button Events
    MinBtn.MouseButton1Click:Connect(ToggleMinimize)

    CloseBtn.MouseButton1Click:Connect(function()
        IsRunning = false
        ScreenGui:Destroy()
    end)

    -- ============================================================
    -- FARMING
    -- ============================================================
    farmBtn.MouseButton1Click:Connect(function()
        Status.Text = "🌾 FARMT..."
        Status.TextColor3 = Color3.fromRGB(255, 200, 50)
        
        task.spawn(function()
            local farmGUI = Player.PlayerGui:FindFirstChild("FarmGUI")
            if not farmGUI then
                Status.Text = "❌ FARMGUI FEHLT!"
                Status.TextColor3 = Color3.fromRGB(255, 0, 0)
                return
            end
            
            local farms = {"Rings", "Monalis", "JobFarm", "BoatFarm"}
            for _, name in ipairs(farms) do
                local btn = farmGUI:FindFirstChild(name .. "Button")
                if btn then
                    for i = 1, 10 do
                        btn:Click()
                        task.wait(0.1)
                    end
                end
            end
            Status.Text = "✅ FARMING FERTIG!"
            Status.TextColor3 = Color3.fromRGB(100, 255, 100)
        end)
    end)

    -- ============================================================
    -- ANTI AFK
    -- ============================================================
    local afkActive = true
    afkBtn.MouseButton1Click:Connect(function()
        afkActive = not afkActive
        afkBtn.Text = afkActive and "🛡️ ANTI AFK" or "🔓 ANTI AFK"
        Status.Text = afkActive and "✅ ANTI AFK AKTIV" or "⏸️ ANTI AFK AUS"
        Status.TextColor3 = afkActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 200, 50)
    end)

    -- ============================================================
    -- GOD MODE
    -- ============================================================
    local godActive = false
    godBtn.MouseButton1Click:Connect(function()
        godActive = not godActive
        godBtn.Text = godActive and "👑 GOD ON" or "👑 GOD OFF"
        
        if godActive then
            local char = Player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                end
            end
            Status.Text = "👑 GOD MODE AKTIV"
            Status.TextColor3 = Color3.fromRGB(255, 215, 0)
        else
            Status.Text = "👑 GOD MODE AUS"
            Status.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)

    -- ============================================================
    -- ESP
    -- ============================================================
    local espActive = false
    espBtn.MouseButton1Click:Connect(function()
        espActive = not espActive
        espBtn.Text = espActive and "👁️ ESP ON" or "👁️ ESP OFF"
        Status.Text = espActive and "👁️ ESP AKTIV" or "👁️ ESP AUS"
        Status.TextColor3 = espActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    end)

    -- ============================================================
    -- SPEED
    -- ============================================================
    local speedActive = true
    speedBtn.MouseButton1Click:Connect(function()
        speedActive = not speedActive
        speedBtn.Text = speedActive and "🚗 SPEED ON" or "🚗 SPEED OFF"
        Status.Text = speedActive and "✅ SPEED AKTIV" or "⏸️ SPEED AUS"
        Status.TextColor3 = speedActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 200, 50)
    end)

    -- ============================================================
    -- AUTO CLICK
    -- ============================================================
    local clickActive = false
    local clickTask = nil
    clickBtn.MouseButton1Click:Connect(function()
        clickActive = not clickActive
        clickBtn.Text = clickActive and "🖱️ CLICK ON" or "🖱️ CLICK OFF"
        
        if clickActive then
            Status.Text = "🖱️ AUTO CLICK AKTIV"
            Status.TextColor3 = Color3.fromRGB(100, 255, 100)
            clickTask = task.spawn(function()
                while clickActive and IsRunning do
                    local mouse = Player:GetMouse()
                    if mouse then
                        mouse.Button1Click:Fire()
                    end
                    task.wait(0.05)
                end
            end)
        else
            if clickTask then
                task.cancel(clickTask)
                clickTask = nil
            end
            Status.Text = "⏸️ AUTO CLICK AUS"
            Status.TextColor3 = Color3.fromRGB(255, 200, 50)
        end
    end)

    -- ============================================================
    -- RESET
    -- ============================================================
    resetBtn.MouseButton1Click:Connect(function()
        godActive = false
        espActive = false
        clickActive = false
        afkActive = true
        speedActive = true
        
        godBtn.Text = "👑 GOD MODE"
        espBtn.Text = "👁️ ESP"
        clickBtn.Text = "🖱️ CLICK"
        afkBtn.Text = "🛡️ ANTI AFK"
        speedBtn.Text = "🚗 SPEED"
        
        if clickTask then
            task.cancel(clickTask)
            clickTask = nil
        end
        
        Status.Text = "🔄 ALLES ZURÜCKGESETZT"
        Status.TextColor3 = Color3.fromRGB(255, 200, 50)
    end)

    -- ============================================================
    -- STOP
    -- ============================================================
    stopBtn.MouseButton1Click:Connect(function()
        IsRunning = false
        ScreenGui:Destroy()
        StarterGui:SetCore("SendNotification", {
            Title = "🛑 GESTOPPT",
            Text = "Hack wurde beendet!",
            Duration = 3
        })
    end)

    -- ============================================================
    -- ANTI AFK SYSTEM
    -- ============================================================
    task.spawn(function()
        local vu = game:GetService("VirtualUser")
        Player.Idled:Connect(function()
            if afkActive and IsRunning then
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end
        end)
    end)

    -- ============================================================
    -- SPEED SYSTEM
    -- ============================================================
    task.spawn(function()
        local ui = game:GetService("UserInputService")
        ui.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.LeftAlt and speedActive and IsRunning then
                local char = Player.Character
                if char then
                    local veh = char:FindFirstChildOfClass("Vehicle")
                    if veh then
                        local spd = veh:FindFirstChild("Speed")
                        if spd then
                            spd.Value = 500
                        end
                    end
                end
            end
        end)
    end)

    -- ============================================================
    -- GOD MODE LOOP
    -- ============================================================
    task.spawn(function()
        while IsRunning do
            if godActive then
                local char = Player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.MaxHealth = math.huge
                        hum.Health = math.huge
                    end
                end
            end
            task.wait(0.5)
        end
    end)

    return ScreenGui
end

-- ============================================================
-- START
-- ============================================================
local success, err = pcall(CreateGUI)
if success then
    print("🔥 SAN DIEGO HACK V6 - MIT MINIMIER BUTTON!")
    print("💀 Drücke ➖ um das GUI zu minimieren!")
else
    warn("❌ Fehler: " .. tostring(err))
end
