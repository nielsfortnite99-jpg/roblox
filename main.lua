--[[
SAN DIEGO TELEPORT - NUR TELEPORT, NICHTS ANDERES
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

if not Player then
    Players.PlayerAdded:Wait()
    Player = Players.LocalPlayer
end

-- ============================================================
-- TELEPORT
-- ============================================================
local function Teleport(pos)
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
        return true
    end
    return false
end

-- ============================================================
-- EINFACHE GUI
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "Teleport"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Titel zum Verschieben
local title = Instance.new("Frame")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
title.BorderSizePixel = 0
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -40, 1, 0)
label.Position = UDim2.new(0, 10, 0, 0)
label.BackgroundTransparency = 1
label.Text = "🌀 Teleport"
label.TextColor3 = Color3.fromRGB(0, 200, 255)
label.TextSize = 14
label.Font = Enum.Font.GothamBold
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = title

-- Minimier Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -55, 0, 4)
minBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 40)
minBtn.BorderSizePixel = 0
minBtn.Text = "➖"
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.TextSize = 12
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = title
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -30, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,100,100)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = title
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 20)
status.Position = UDim2.new(0, 5, 0, 5)
status.BackgroundTransparency = 1
status.Text = "✅ Drücke T"
status.TextColor3 = Color3.fromRGB(100,255,150)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Parent = content

local teleBtn = Instance.new("TextButton")
teleBtn.Size = UDim2.new(0, 150, 0, 35)
teleBtn.Position = UDim2.new(0.5, -75, 0, 30)
teleBtn.BackgroundColor3 = Color3.fromRGB(0,100,200)
teleBtn.BorderSizePixel = 0
teleBtn.Text = "🌀 Teleport (T)"
teleBtn.TextColor3 = Color3.fromRGB(255,255,255)
teleBtn.TextSize = 14
teleBtn.Font = Enum.Font.GothamBold
teleBtn.Parent = content
Instance.new("UICorner", teleBtn).CornerRadius = UDim.new(0, 8)

-- ============================================================
-- VERSCHIEBEN
-- ============================================================
local drag, start, pos = false

title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        start = i.Position
        pos = frame.Position
    end
end)

title.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - start
        frame.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y)
    end
end)

-- ============================================================
-- MINIMIEREN
-- ============================================================
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame.Size = UDim2.new(0, 150, 0, 30)
        content.Visible = false
        minBtn.Text = "➕"
    else
        frame.Size = UDim2.new(0, 200, 0, 120)
        content.Visible = true
        minBtn.Text = "➖"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ============================================================
-- TELEPORT
-- ============================================================
local function DoTeleport()
    local mouse = Player:GetMouse()
    if not mouse then return end
    
    local pos = mouse.Hit.Position
    if Teleport(pos) then
        status.Text = "✅ Teleportiert!"
        status.TextColor3 = Color3.fromRGB(100,255,150)
        teleBtn.BackgroundColor3 = Color3.fromRGB(0,255,150)
        task.wait(0.1)
        teleBtn.BackgroundColor3 = Color3.fromRGB(0,100,200)
    else
        status.Text = "❌ Fehler!"
        status.TextColor3 = Color3.fromRGB(255,50,50)
    end
end

teleBtn.MouseButton1Click:Connect(DoTeleport)

UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.T then
        DoTeleport()
    end
end)

print("🌀 Teleport Hack geladen! Drücke T zum Teleportieren.")
