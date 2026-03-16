-- 🚀 Space Admin Panel | Executor Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- État des features
local states = {
    fly = false,
    speed = false,
    noclip = false,
    inf_jump = false,
    esp = false,
    fullbright = false,
    freecam = false,
}

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "SpaceAdmin"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 520)
main.Position = UDim2.new(0.5, -170, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(5, 5, 20)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

-- Gradient background
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 5, 40))
})
grad.Rotation = 135
grad.Parent = main

-- Bordure brillante
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 50, 255)
stroke.Thickness = 2
stroke.Parent = main

-- Titre
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 10, 80)
titleBar.BorderSizePixel = 0
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 20, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 80, 255))
})
titleGrad.Rotation = 90
titleGrad.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🚀 SPACE ADMIN"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Bouton fermer
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -43, 0.5, -17)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 80)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Scroll pour les boutons
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -70)
scroll.Position = UDim2.new(0, 10, 0, 58)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 50, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = scroll

Instance.new("UIPadding", scroll).PaddingTop = UDim.new(0, 5)

-- Fonction créer bouton toggle
local function createToggle(name, icon, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 55)
    btn.BackgroundColor3 = Color3.fromRGB(15, 10, 40)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(60, 30, 120)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 1, 0)
    iconLabel.Position = UDim2.new(0, 10, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 24
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.Parent = btn

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -110, 1, 0)
    nameLabel.Position = UDim2.new(0, 58, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = btn

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 46, 0, 24)
    toggle.Position = UDim2.new(1, -56, 0.5, -12)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    toggle.BorderSizePixel = 0
    toggle.Parent = btn
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 3, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(150, 150, 180)
    circle.BorderSizePixel = 0
    circle.Parent = toggle
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local active = false

    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            toggle.BackgroundColor3 = color
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circle.Position = UDim2.new(1, -21, 0.5, -9)
            btnStroke.Color = color
        else
            toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            circle.BackgroundColor3 = Color3.fromRGB(150, 150, 180)
            circle.Position = UDim2.new(0, 3, 0.5, -9)
            btnStroke.Color = Color3.fromRGB(60, 30, 120)
        end
        callback(active)
    end)

    return btn
end

-- ========================
-- FEATURES
-- ========================

-- 1. FLY
local flyConn
createToggle("Fly", "🛸", Color3.fromRGB(100, 50, 255), function(on)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if on then
        hum.PlatformStand = true
        local bg = Instance.new("BodyGyro", hrp)
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
        bg.D = 100
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyVel"
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bv.Velocity = Vector3.zero
        flyConn = RunService.Heartbeat:Connect(function()
            local cam = workspace.CurrentCamera
            local vel = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CFrame.LookVector * 60 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CFrame.LookVector * 60 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CFrame.RightVector * 60 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CFrame.RightVector * 60 end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,60,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel - Vector3.new(0,60,0) end
            bv.Velocity = vel
            bg.CFrame = cam.CFrame
        end)
    else
        hum.PlatformStand = false
        if flyConn then flyConn:Disconnect() end
        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
        if hrp:FindFirstChild("FlyVel") then hrp.FlyVel:Destroy() end
    end
end)

-- 2. SPEED
createToggle("Speed Boost", "⚡", Color3.fromRGB(255, 200, 0), function(on)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = on and 80 or 16 end
end)

-- 3. NOCLIP
local noclipConn
createToggle("Noclip", "👻", Color3.fromRGB(0, 200, 255), function(on)
    if on then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end)

-- 4. INFINITE JUMP
local jumpConn
createToggle("Infinite Jump", "🌙", Color3.fromRGB(150, 255, 150), function(on)
    if on then
        jumpConn = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if jumpConn then jumpConn:Disconnect() end
    end
end)

-- 5. ESP
local espConn
createToggle("Player ESP", "🔭", Color3.fromRGB(255, 80, 80), function(on)
    if on then
        local function addESP(player)
            if player == LocalPlayer then return end
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local bb = Instance.new("BillboardGui")
            bb.Name = "ESP"
            bb.Size = UDim2.new(0, 100, 0, 40)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true
            bb.Parent = hrp
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1,0,1,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = player.Name
            lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 14
            lbl.Parent = bb

            -- Box ESP
            local hlight = Instance.new("SelectionBox")
            hlight.Name = "ESPBox"
            hlight.Color3 = Color3.fromRGB(255, 80, 80)
            hlight.LineThickness = 0.05
            hlight.Adornee = char
            hlight.Parent = char
        end
        for _, p in pairs(Players:GetPlayers()) do addESP(p) end
        espConn = Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function() task.wait(1) addESP(p) end)
        end)
    else
        if espConn then espConn:Disconnect() end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp:FindFirstChild("ESP") then hrp.ESP:Destroy() end
                local box = p.Character:FindFirstChild("ESPBox")
                if box then box:Destroy() end
            end
        end
    end
end)

-- 6. FULLBRIGHT
createToggle("Fullbright", "🌟", Color3.fromRGB(255, 255, 100), function(on)
    game:GetService("Lighting").Brightness = on and 10 or 1
    game:GetService("Lighting").ClockTime = on and 14 or 14
    game:GetService("Lighting").FogEnd = on and 1e6 or 1e4
    game:GetService("Lighting").GlobalShadows = not on
end)

-- 7. JUMP POWER
createToggle("High Jump", "🪐", Color3.fromRGB(255, 140, 0), function(on)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = on and 120 or 50 end
end)

-- 8. GOD MODE (local)
createToggle("God Mode (local)", "⭐", Color3.fromRGB(255, 215, 0), function(on)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = on and math.huge or 100
        hum.Health = on and math.huge or 100
    end
end)

-- Draggable
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

print("🚀 Space Admin Panel chargé !")
