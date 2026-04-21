--[[
    MODERN FLY SYSTEM v2.0
    - Anti Bring Back Protection
    - Smooth Physics
    - Modern GUI Design
    - Universal Compatibility
]]

-- Inisialisasi GUI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Variabel state
local isFlying = false
local isMenuOpen = false
local flySpeed = 50
local smoothness = 0.3
local bodyVelocity = nil
local bodyGyro = nil
local currentVelocity = Vector3.new(0,0,0)

-- Anti-Bring Back Variables
local lastValidPosition = RootPart.Position
local lastValidCFrame = RootPart.CFrame
local positionHistory = {}
local antiLagTime = 0

-- Buat GUI utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernFlyGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

-- Fungsi untuk membuat UI modern dengan efek glassmorphism
local function createGlassPanel(parent, size, position, transparency)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = transparency or 0.15
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = parent
    
    -- Efek blur
    local blur = Instance.new("BlurEffect")
    blur.Size = 12
    blur.Enabled = true
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200,200,255))
    }
    gradient.Transparency = NumberSequence.new(0.9)
    gradient.Parent = frame
    
    -- Border tipis
    local border = Instance.new("UICorner")
    border.CornerRadius = UDim.new(0, 12)
    border.Parent = frame
    
    return frame
end

-- Buat main menu panel
local mainPanel = createGlassPanel(screenGui, UDim2.new(0, 280, 0, 360), UDim2.new(0.5, -140, 0.5, -180), 0.1)
mainPanel.Visible = false

-- Animasi slide in/out
local function toggleMenu()
    isMenuOpen = not isMenuOpen
    local targetPos = isMenuOpen and UDim2.new(0.5, -140, 0.5, -180) or UDim2.new(0.5, -140, 0.5, -200)
    local tween = TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
    tween:Play()
    mainPanel.Visible = true
    if not isMenuOpen then
        task.wait(0.3)
        mainPanel.Visible = false
    end
end

-- Header panel
local header = createGlassPanel(mainPanel, UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 0), 0.05)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "✧ FLIGHT SYSTEM ✧"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.5
title.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- Speed slider section
local speedSection = createGlassPanel(mainPanel, UDim2.new(0.9, 0, 0, 80), UDim2.new(0.05, 0, 0, 70), 0.1)
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 5)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "FLIGHT SPEED"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = speedSection

local speedValue = Instance.new("TextLabel")
speedValue.Size = UDim2.new(0, 50, 0, 25)
speedValue.Position = UDim2.new(1, -55, 0, 5)
speedValue.BackgroundTransparency = 1
speedValue.Text = tostring(flySpeed)
speedValue.TextColor3 = Color3.fromRGB(255, 200, 100)
speedValue.TextSize = 14
speedValue.Font = Enum.Font.GothamBold
speedValue.TextXAlignment = Enum.TextXAlignment.Right
speedValue.Parent = speedSection

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(1, -10, 0, 4)
speedSlider.Position = UDim2.new(0, 5, 0, 40)
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
speedSlider.BorderSizePixel = 0
speedSlider.Parent = speedSection

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(flySpeed/200, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = speedSlider

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 12, 0, 12)
sliderKnob.Position = UDim2.new(flySpeed/200, -6, 0, -4)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob
sliderKnob.Parent = speedSlider

-- Drag logic for slider
local dragging = false
sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp((input.Position.X - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X, 0, 1)
        flySpeed = math.clamp(math.floor(relativeX * 200), 10, 200)
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderKnob.Position = UDim2.new(relativeX, -6, 0, -4)
        speedValue.Text = tostring(flySpeed)
    end
end)

-- Toggle Fly Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 170)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
toggleBtn.Text = "✈ ACTIVATE FLIGHT"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.GothamBold
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 25)
btnCorner.Parent = toggleBtn
toggleBtn.Parent = mainPanel

-- Status indicator
local statusIndicator = Instance.new("Frame")
statusIndicator.Size = UDim2.new(0, 10, 0, 10)
statusIndicator.Position = UDim2.new(0, 15, 0, 20)
statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
statusIndicator.BorderSizePixel = 0
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = statusIndicator
statusIndicator.Parent = toggleBtn

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -40, 1, 0)
statusText.Position = UDim2.new(0, 35, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "INACTIVE"
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = toggleBtn

-- Smoothness slider
local smoothSection = createGlassPanel(mainPanel, UDim2.new(0.9, 0, 0, 70), UDim2.new(0.05, 0, 0, 240), 0.1)
local smoothLabel = Instance.new("TextLabel")
smoothLabel.Size = UDim2.new(1, 0, 0, 25)
smoothLabel.Position = UDim2.new(0, 0, 0, 5)
smoothLabel.BackgroundTransparency = 1
smoothLabel.Text = "CONTROL SMOOTHNESS"
smoothLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
smoothLabel.TextSize = 12
smoothLabel.Font = Enum.Font.Gotham
smoothLabel.Parent = smoothSection

local smoothSlider = Instance.new("Frame")
smoothSlider.Size = UDim2.new(1, -10, 0, 4)
smoothSlider.Position = UDim2.new(0, 5, 0, 40)
smoothSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
smoothSlider.BorderSizePixel = 0
smoothSlider.Parent = smoothSection

local smoothFill = Instance.new("Frame")
smoothFill.Size = UDim2.new(smoothness, 0, 1, 0)
smoothFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
smoothFill.BorderSizePixel = 0
smoothFill.Parent = smoothSlider

-- Footer info
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundTransparency = 1
footer.Text = "Press [INSERT] • Anti Bring Back Active"
footer.TextColor3 = Color3.fromRGB(100, 100, 120)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.Parent = mainPanel

-- Core flying function dengan anti-bring back
local function updateFly()
    if not isFlying then return end
    
    local moveDirection = Vector3.new(0,0,0)
    local cameraCFrame = Camera.CFrame
    
    -- WASD input
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cameraCFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cameraCFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cameraCFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cameraCFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0,1,0) end
    
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit
    end
    
    -- Target velocity dengan smooth interpolation
    local targetVelocity = moveDirection * flySpeed
    currentVelocity = currentVelocity:Lerp(targetVelocity, smoothness)
    
    if bodyVelocity then
        bodyVelocity.Velocity = currentVelocity
    end
    
    -- Anti Bring Back: Force position validation
    local currentPos = RootPart.Position
    local timeSinceLast = tick() - antiLagTime
    
    -- Simpan history posisi
    table.insert(positionHistory, {pos = currentPos, time = tick()})
    if #positionHistory > 10 then table.remove(positionHistory, 1) end
    
    -- Deteksi rubberbanding
    local distanceFromLast = (currentPos - lastValidPosition).Magnitude
    if distanceFromLast > flySpeed * 0.5 and timeSinceLast > 0.1 then
        -- Terjadi bring back, paksa posisi
        RootPart.CFrame = lastValidCFrame
        if bodyVelocity then
            bodyVelocity.Velocity = currentVelocity
        end
    else
        lastValidPosition = currentPos
        lastValidCFrame = RootPart.CFrame
    end
    
    antiLagTime = tick()
end

-- Start flying system
local function startFly()
    if isFlying then return end
    
    Humanoid.PlatformStand = true
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = RootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
    bodyGyro.CFrame = RootPart.CFrame
    bodyGyro.Parent = RootPart
    
    isFlying = true
    
    -- Connection untuk update loop
    local flyConnection
    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying then
            flyConnection:Disconnect()
            return
        end
        updateFly()
        if bodyGyro then
            bodyGyro.CFrame = Camera.CFrame
        end
    end)
end

-- Stop flying system
local function stopFly()
    isFlying = false
    
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    
    Humanoid.PlatformStand = false
end

-- Toggle flight
local function toggleFly()
    if isFlying then
        stopFly()
        statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        statusText.Text = "INACTIVE"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
        toggleBtn.Text = "✈ ACTIVATE FLIGHT"
    else
        startFly()
        statusIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        statusText.Text = "ACTIVE"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 100)
        toggleBtn.Text = "✈ DEACTIVATE FLIGHT"
    end
end

-- Button connections
toggleBtn.MouseButton1Click:Connect(toggleFly)

-- Hotkey INSERT untuk toggle menu
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleMenu()
    end
end)

-- Hotkey untuk toggle fly (optional: tekan V)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.V then
        toggleFly()
    end
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    lastValidPosition = RootPart.Position
    lastValidCFrame = RootPart.CFrame
    if isFlying then
        stopFly()
        task.wait(0.5)
        startFly()
    end
end)

-- Notifikasi startup dengan efek modern
local startupNotification = createGlassPanel(screenGui, UDim2.new(0, 250, 0, 60), UDim2.new(0.5, -125, 0.8, 0), 0.1)
local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1, 0, 1, 0)
notifText.BackgroundTransparency = 1
notifText.Text = "✓ FLIGHT SYSTEM LOADED\nPress [INSERT] to open menu"
notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
notifText.TextSize = 12
notifText.Font = Enum.Font.Gotham
notifText.TextWrapped = true
notifText.Parent = startupNotification

task.wait(2.5)
local fadeOut = TweenService:Create(startupNotification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
fadeOut:Play()
task.wait(0.5)
startupNotification:Destroy()

print("[System] Modern Flight System v2.0 Loaded - Anti Bring Back Active")
