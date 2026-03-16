local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Nettoyer ancien GUI
local oldGui = LocalPlayer.PlayerGui:FindFirstChild("SpaceAdmin")
if oldGui then oldGui:Destroy() end

-- Variables features
local flyConn, noclipConn, jumpConn, espConn, rainbowConn, toupieConn, moonwalkConn

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SpaceAdmin"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 270, 0, 320)
main.Position = UDim2.new(0.5, -135, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.Parent = gui

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 22)
header.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
header.BorderSizePixel = 1
header.BorderColor3 = Color3.fromRGB(255, 0, 0)
header.Parent = main

local leftArrow = Instance.new("TextButton")
leftArrow.Size = UDim2.new(0, 22, 1, 0)
leftArrow.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
leftArrow.BorderSizePixel = 1
leftArrow.BorderColor3 = Color3.fromRGB(255, 0, 0)
leftArrow.Text = "<"
leftArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
leftArrow.Font = Enum.Font.GothamBold
leftArrow.TextSize = 13
leftArrow.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -44, 1, 0)
titleLabel.Position = UDim2.new(0, 22, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SPACE ADMIN"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.Parent = header

local rightArrow = Instance.new("TextButton")
rightArrow.Size = UDim2.new(0, 22, 1, 0)
rightArrow.Position = UDim2.new(1, -22, 0, 0)
rightArrow.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
rightArrow.BorderSizePixel = 1
rightArrow.BorderColor3 = Color3.fromRGB(255, 0, 0)
rightArrow.Text = ">"
rightArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
rightArrow.Font = Enum.Font.GothamBold
rightArrow.TextSize = 13
rightArrow.Parent = header

-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(1, 0, 0, 20)
closeBtn.Position = UDim2.new(0, 0, 1, -20)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
closeBtn.BorderSizePixel = 1
closeBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "Close"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = main
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Draggable
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
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

-- Créer bouton
local cols = 3
local closeH = 20
local headerH = 22
local totalH = 320 - headerH - closeH
local totalW = 270
local btnNames = {
    "Fly", "Speed Boost", "Noclip", "Inf Jump",
    "ESP", "Fullbright", "High Jump", "God Mode",
    "Toupie", "Ragdoll", "Giga Head", "Invisible",
    "Super Tiny", "Moonwalk", "Rainbow", "Spawn Bombe",
    "Sound Play", "Spawn Obby",
}
local rows = math.ceil(#btnNames / cols)
local btnW = math.floor(totalW / cols)
local btnH = math.floor(totalH / rows)

local toggleStates = {}
local btnObjects = {}

for i, name in ipairs(btnNames) do
    local col = (i - 1) % cols
    local row = math.floor((i - 1) / cols)
    toggleStates[name] = false

    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, btnW, 0, btnH)
    btn.Position = UDim2.new(0, col * btnW, 0, headerH + row * btnH)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextWrapped = true
    btn.Parent = main
    btnObjects[name] = btn

    btn.MouseButton1Click:Connect(function()
        toggleStates[name] = not toggleStates[name]
        local on = toggleStates[name]
        btn.BackgroundColor3 = on and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(0, 0, 0)

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        -- FLY
        if name == "Fly" then
            if on then
                hum.PlatformStand = true
                local bg = Instance.new("BodyGyro", hrp)
                bg.Name = "FlyGyro" bg.MaxTorque = Vector3.new(1e9,1e9,1e9) bg.D = 100
                local bv = Instance.new("BodyVelocity", hrp)
                bv.Name = "FlyVel" bv.MaxForce = Vector3.new(1e9,1e9,1e9) bv.Velocity = Vector3.zero
                flyConn = RunService.Heartbeat:Connect(function()
                    local cam = workspace.CurrentCamera
                    local vel = Vector3.zero
                    local spd = 80
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += cam.CFrame.LookVector * spd end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel -= cam.CFrame.LookVector * spd end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel -= cam.CFrame.RightVector * spd end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += cam.CFrame.RightVector * spd end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0,spd,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel -= Vector3.new(0,spd,0) end
                    bv.Velocity = vel
                    bg.CFrame = cam.CFrame
                end)
            else
                hum.PlatformStand = false
                if flyConn then flyConn:Disconnect() end
                if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
                if hrp:FindFirstChild("FlyVel") then hrp.FlyVel:Destroy() end
            end

        -- SPEED
        elseif name == "Speed Boost" then
            if hum then hum.WalkSpeed = on and 80 or 16 end

        -- NOCLIP
        elseif name == "Noclip" then
            if on then
                noclipConn = RunService.Stepped:Connect(function()
                    if LocalPlayer.Character then
                        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                            if v:IsA("BasePart") then v.CanCollide = false end
                        end
                    end
                end)
            else
                if noclipConn then noclipConn:Disconnect() end
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = true end
                    end
                end
            end

        -- INF JUMP
        elseif name == "Inf Jump" then
            if on then
                jumpConn = UserInputService.JumpRequest:Connect(function()
                    local c = LocalPlayer.Character
                    local h = c and c:FindFirstChildOfClass("Humanoid")
                    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
                end)
            else
                if jumpConn then jumpConn:Disconnect() end
            end

        -- ESP
        elseif name == "ESP" then
            if on then
                local function addESP(player)
                    if player == LocalPlayer then return end
                    local c = player.Character
                    if not c then return end
                    local h = c:FindFirstChild("HumanoidRootPart")
                    if not h then return end
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "ESP" bb.Size = UDim2.new(0,100,0,30)
                    bb.StudsOffset = Vector3.new(0,3,0) bb.AlwaysOnTop = true bb.Parent = h
                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1,0,1,0) lbl.BackgroundTransparency = 1
                    lbl.Text = player.Name lbl.TextColor3 = Color3.fromRGB(255,0,0)
                    lbl.Font = Enum.Font.GothamBold lbl.TextSize = 12
                    local box = Instance.new("SelectionBox")
                    box.Name = "ESPBox" box.Color3 = Color3.fromRGB(255,0,0)
                    box.LineThickness = 0.05 box.Adornee = c box.Parent = c
                end
                for _, p in pairs(Players:GetPlayers()) do addESP(p) end
                espConn = Players.PlayerAdded:Connect(function(p)
                    p.CharacterAdded:Connect(function() task.wait(1) addESP(p) end)
                end)
            else
                if espConn then espConn:Disconnect() end
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local h = p.Character:FindFirstChild("HumanoidRootPart")
                        if h and h:FindFirstChild("ESP") then h.ESP:Destroy() end
                        local box = p.Character:FindFirstChild("ESPBox")
                        if box then box:Destroy() end
                    end
                end
            end

        -- FULLBRIGHT
        elseif name == "Fullbright" then
            local l = game:GetService("Lighting")
            l.Brightness = on and 10 or 1
            l.GlobalShadows = not on
            l.FogEnd = on and 1e6 or 1e4

        -- HIGH JUMP
        elseif name == "High Jump" then
            if hum then hum.JumpPower = on and 150 or 50 end

        -- GOD MODE
        elseif name == "God Mode" then
            if hum then
                hum.MaxHealth = on and math.huge or 100
                hum.Health = on and math.huge or 100
            end

        -- TOUPIE
        elseif name == "Toupie" then
            local angle = 0
            if on then
                toupieConn = RunService.Heartbeat:Connect(function()
                    if LocalPlayer.Character then
                        local h = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if h then
                            angle = angle + 10
                            h.CFrame = CFrame.new(h.Position) * CFrame.Angles(0, math.rad(angle), 0)
                        end
                    end
                end)
            else
                if toupieConn then toupieConn:Disconnect() end
            end

        -- RAGDOLL
        elseif name == "Ragdoll" then
            if hum then hum.PlatformStand = on end

        -- GIGA HEAD
        elseif name == "Giga Head" then
            if char then
                local head = char:FindFirstChild("Head")
                if head then head.Size = on and Vector3.new(4, 4, 4) or Vector3.new(2, 1, 1) end
            end

        -- INVISIBLE
        elseif name == "Invisible" then
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.Transparency = on and 1 or 0 end
                end
            end

        -- SUPER TINY
        elseif name == "Super Tiny" then
            if hum then hum.BodyDepthScale.Value = on and 0.2 or 1
                hum.BodyHeightScale.Value = on and 0.2 or 1
                hum.BodyWidthScale.Value = on and 0.2 or 1
                hum.HeadScale.Value = on and 0.2 or 1
            end

        -- MOONWALK
        elseif name == "Moonwalk" then
            if on then
                moonwalkConn = RunService.Heartbeat:Connect(function()
                    local c = LocalPlayer.Character
                    local h = c and c:FindFirstChild("HumanoidRootPart")
                    if h and UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        h.CFrame = h.CFrame * CFrame.new(0, 0, 0.5)
                    end
                end)
            else
                if moonwalkConn then moonwalkConn:Disconnect() end
            end

        -- RAINBOW
        elseif name == "Rainbow" then
            if on then
                rainbowConn = RunService.Heartbeat:Connect(function()
                    local c = LocalPlayer.Character
                    if c then
                        local t = tick()
                        for _, v in pairs(c:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                            end
                        end
                    end
                end)
            else
                if rainbowConn then rainbowConn:Disconnect() end
            end

        -- SPAWN BOMBE
        elseif name == "Spawn Bombe" then
            if hrp then
                local bomb = Instance.new("Part")
                bomb.Size = Vector3.new(3,3,3)
                bomb.Shape = Enum.PartType.Ball
                bomb.BrickColor = BrickColor.new("Really black")
                bomb.Position = hrp.Position + Vector3.new(0, 5, 0)
                bomb.Parent = workspace
                task.wait(2)
                local explosion = Instance.new("Explosion")
                explosion.Position = bomb.Position
                explosion.BlastRadius = 20
                explosion.BlastPressure = 1e6
                explosion.Parent = workspace
                bomb:Destroy()
            end

        -- SOUND PLAY
        elseif name == "Sound Play" then
            if on then
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://1369158752"
                sound.Volume = 1
                sound.Looped = true
                sound.Name = "AdminSound"
                sound.Parent = hrp or workspace
                sound:Play()
            else
                local s = (hrp or workspace):FindFirstChild("AdminSound")
                if s then s:Destroy() end
            end

        -- SPAWN OBBY
        elseif name == "Spawn Obby" then
            if hrp then
                local pos = hrp.Position + Vector3.new(0, 0, 10)
                for i = 1, 10 do
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(8, 1, 8)
                    p.Position = pos + Vector3.new(i * 10, i * 4, 0)
                    p.Anchored = true
                    p.BrickColor = BrickColor.random()
                    p.Parent = workspace
                end
            end
        end
    end)
end

print("✅ Space Admin chargé !")
