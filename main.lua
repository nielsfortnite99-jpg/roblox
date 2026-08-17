--[[
SAN DIEGO TELEPORT HACK V1 - NUR TELEPORT + MINIMIERBAR + VERSCHIEBBAR
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
if not Player then
    Players.PlayerAdded:Wait()
    Player = Players.LocalPlayer
end

local IsMinimized = false
local IsRunning = true
local Dragging = false
local DragStart = nil
local DragStartPos = nil

-- ============================================================
-- TELEPORT FUNKTION
-- ============================================================
local function TeleportTo(targetPos)
    local char = Player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(targetPos)
            return true
        end
    end
    return false
end

-- ============================================================
-- GUI MIT MINIMIEREN + VERSCHIEBEN
-- ============================================================
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SanDiegoTeleportHack"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    -- Haupt-Frame (verschiebbar)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 180)
    MainFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    -- Titelzeile (zum Verschieben)
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
    Title.Text = "🌀 TELEPORT HACK"
    Title.TextColor3 = Color3.fromRGB(0, 200, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    -- Minimier Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 28, 0, 28)
    MinBtn.Position = UDim2.new(1, -65, 0, 6)
    MinBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    MinBtn.BorderSizePixel = 0
    MinBtn.Text = "➖"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 14
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = TitleBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

    -- Schließen Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -33, 0, 6)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.TextSize = 14
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
    Status.Size = UDim2.new(1, -20, 0, 25)
    Status.Position = UDim2.new(0, 10, 0, 8)
    Status.BackgroundTransparency = 1
    Status.Text = "✅ BEREIT - DRÜCKE T"
    Status.TextColor3 = Color3.fromRGB(100, 255, 150)
    Status.TextSize = 14
    Status.Font = Enum.Font.GothamBold
    Status.Parent = Content

    -- Teleport Button
    local TeleportBtn = Instance.new("TextButton")
    TeleportBtn.Size = UDim2.new(0, 200, 0, 50)
    TeleportBtn.Position = UDim2.new(0.5, -100, 0, 40)
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
    TeleportBtn.BorderSizePixel = 0
    TeleportBtn.Text = "🌀 TELEPORT (T)"
    TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportBtn.TextSize = 18
    TeleportBtn.Font = Enum.Font.GothamBold
    TeleportBtn.Parent = Content
    Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0, 10)

    -- Ziel-Anzeige
    local TargetLabel = Instance.new("TextLabel")
    TargetLabel.Size = UDim2.new(1, -20, 0, 20)
    TargetLabel.Position = UDim2.new(0, 10, 0, 100)
    TargetLabel.BackgroundTransparency = 1
    TargetLabel.Text = "🎯 Ziel: Mausposition"
    TargetLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    TargetLabel.TextSize = 12
    TargetLabel.Font = Enum.Font.Gotham
    TargetLabel.Parent = Content

    -- ============================================================
    -- VERSCHIEBEN LOGIK
    -- ============================================================
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            DragStartPos = MainFrame.Position
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(
                DragStartPos.X.Scale,
                DragStartPos.X.Offset + delta.X,
                DragStartPos.Y.Scale,
                DragStartPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ============================================================
    -- MINIMIEREN
    -- ============================================================
    local function ToggleMinimize()
        IsMinimized = not IsMinimized
        
        if IsMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 180, 0, 40)
            }):Play()
            Content.Visible = false
            MinBtn.Text = "➕"
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 280, 0, 180)
            }):Play()
            task.wait(0.3)
            Content.Visible = true
            MinBtn.Text = "➖"
        end
    end

    MinBtn.MouseButton1Click:Connect(ToggleMinimize)

    CloseBtn.MouseButton1Click:Connect(function()
        IsRunning = false
        ScreenGui:Destroy()
    end)

    -- ============================================================
    -- TELEPORT FUNKTION
    -- ============================================================
    local function DoTeleport()
        local mouse = Player:GetMouse()
        if not mouse then return end
        
        local targetPos = mouse.Hit.Position
        local success = TeleportTo(targetPos)
        
        if success then
            Status.Text = "✅ TELEPORTIERT!"
            Status.TextColor3 = Color3.fromRGB(100, 255, 150)
            TargetLabel.Text = "🎯 Ziel: " .. string.format("%.1f, %.1f, %.1f", targetPos.X, targetPos.Y, targetPos.Z)
            
            -- Kurzer Flash-Effekt
            TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
            task.wait(0.1)
            TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
        else
            Status.Text = "❌ TELEPORT FEHLGESCHLAGEN!"
            Status.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end

    TeleportBtn.MouseButton1Click:Connect(DoTeleport)

    -- T-Taste
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.T and IsRunning then
            DoTeleport()
        end
    end)

    -- Mausposition anzeigen (Live)
    task.spawn(function()
        while IsRunning do
            task.wait(0.1)
            local mouse = Player:GetMouse()
            if mouse then
                local pos = mouse.Hit.Position
                TargetLabel.Text = string.format("🎯 Maus: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            end
        end
    end)

    -- ============================================================
    -- ANIMATION
    -- ============================================================
    MainFrame.BackgroundTransparency = 1
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {
        BackgroundTransparency = 0
    }):Play()

    return ScreenGui
end

-- ============================================================
-- START
-- ============================================================
local success, err = pcall(CreateGUI)
if success then
    print("🌀 SAN DIEGO TELEPORT HACK GELADEN!")
    print("📋 Drücke T oder klicke auf Teleport")
    print("📋 Ziehe an der Titelzeile zum Verschieben")
    print("📋 Klicke ➖ zum Minimieren")
else
    warn("❌ Fehler: " .. tostring(err))
end
