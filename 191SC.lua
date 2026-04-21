--[[
    BLOOD FLIGHT SYSTEM v4.0
    - Aggressive Anti Bring Back
    - GUI di CoreGui (PRIORITAS TERTINGGI)
    - Dark Red & Black Theme
    - Minimize & Close Button
]]

-- Tunggu hingga game benar-benar siap
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

-- Tunggu karakter
local Character = LP.Character or LP.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Variabel flight
local isFlying = false
local flySpeed = 80
local currentVel = Vector3.new(0,0,0)
local bodyVel = nil
local bodyGyro = nil
local guiVisible = true

-- === ANTI BRING BACK SYSTEM ===
local lastPosition = RootPart.Position
local lastCFrame = RootPart.CFrame
local teleportDetectCount = 0
local lastValidTime = tick()

local function antiBringBack()
    if not isFlying then return end
    
    local currentPos = RootPart.Position
    local distance = (currentPos - lastPosition).Magnitude
    local currentTime = tick()
    
    -- Deteksi teleportasi paksa
    if distance > 50 and distance < 800 then
        teleportDetectCount = teleportDetectCount + 1
        
        if teleportDetectCount >= 2 then
            -- Paksa kembali ke posisi sebelumnya
            pcall(function()
                RootPart.CFrame = lastCFrame
                RootPart.Velocity = Vector3.new(0,0,0)
                RootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
                
                -- Reset network ownership
                if RootPart:IsA("BasePart") then
                    RootPart:SetNetworkOwner(nil)
                    task.wait(0.03)
                    RootPart:SetNetworkOwner(LP)
                end
            end)
            teleportDetectCount = 0
        end
    else
        teleportDetectCount = math.max(0, teleportDetectCount - 0.3)
        lastPosition = currentPos
        lastCFrame = RootPart.CFrame
    end
    
    lastValidTime = currentTime
end

-- === GUI DENGAN PRIORITAS TERTINGGI ===
-- Paksa buat GUI di CoreGui (paling atas)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloodFlightGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Coba parent ke CoreGui dulu, fallback ke PlayerGui
local guiParent = nil
pcall(function()
    screenGui.Parent = CoreGui
    if screenGui.Parent then guiParent = CoreGui end
end)

if not guiParent then
    pcall(function()
        screenGui.Parent = LP.PlayerGui
        if screenGui.Parent then guiParent = LP.PlayerGui end
    end)
end

if not guiParent then
    screenGui.Parent = LP:WaitForChild("PlayerGui")
end

-- === MAIN FRAME - THEMA MERAH HITAM ===
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 440)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true

-- Corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

-- Border merah
local borderStroke = Instance.new("UIStroke")
borderStroke.Color = Color3.fromRGB(180, 30, 30)
borderStroke.Thickness = 1.5
borderStroke.Transparency = 0.5
borderStroke.Parent = mainFrame

-- Shadow
local shadow = Instance.new("UIShadow")
shadow.Color = Color3.fromRGB(0,0,0)
shadow.Size = 15
shadow.Parent = mainFrame

mainFrame.Parent = screenGui

-- === HEADER (MERAH) ===
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = Color3.fromRGB(140, 20, 20)
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header
header.Parent = mainFrame

-- Title dengan icon
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 BLOOD FLIGHT v4.0 🔥"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

-- === MINIMIZE BUTTON ===
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 32, 0, 32)
minBtn.Position = UDim2.new(1, -70, 0, 8)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
minBtn.BackgroundTransparency = 0.3
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 24
minBtn.Font = Enum.Font.GothamBold
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minBtn
minBtn.Parent = header

-- === CLOSE BUTTON ===
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -38, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn
closeBtn.Parent = header

-- Status indicator di header
local headerStatus = Instance.new("Frame")
headerStatus.Size = UDim2.new(0, 10, 0, 10)
headerStatus.Position = UDim2.new(0, 10, 0, 19)
headerStatus.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
headerStatus.BorderSizePixel = 0
local headerStatusCorner = Instance.new("UICorner")
headerStatusCorner.CornerRadius = UDim.new(1, 0)
headerStatusCorner.Parent = headerStatus
headerStatus.Parent = header

-- === FLIGHT TOGGLE BUTTON (BESAR MERAH) ===
local toggleContainer = Instance.new("Frame")
toggleContainer.Size = UDim2.new(0.9, 0, 0, 60)
toggleContainer.Position = UDim2.new(0.05, 0, 0, 70)
toggleContainer.BackgroundColor3 = Color3.fromRGB(25, 20, 25)
toggleContainer.BackgroundTransparency = 0.2
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 12)
containerCorner.Parent = toggleContainer
toggleContainer.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -4, 1, -4)
toggleBtn.Position = UDim2.new(0, 2, 0, 2)
toggleBtn.BackgroundColor3 = Color3.fromRGB(160, 30, 30)
toggleBtn.Text = "🔥 ACTIVATE FLIGHT 🔥"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.GothamBold
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = toggleBtn
toggleBtn.Parent = toggleContainer

-- Status light di dalam button
local btnStatusLight = Instance.new("Frame")
btnStatusLight.Size = UDim2.new(0, 12, 0, 12)
btnStatusLight.Position = UDim2.new(0, 15, 0, 24)
btnStatusLight.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
btnStatusLight.BorderSizePixel = 0
local lightCorner = Instance.new("UICorner")
lightCorner.CornerRadius = UDim.new(1, 0)
lightCorner.Parent = btnStatusLight
btnStatusLight.Parent = toggleBtn

local btnStatusText = Instance.new("TextLabel")
btnStatusText.Size = UDim2.new(1, -45, 1, 0)
btnStatusText.Position = UDim2.new(0, 40, 0, 0)
btnStatusText.BackgroundTransparency = 1
btnStatusText.Text = "INACTIVE"
btnStatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
btnStatusText.TextSize = 13
btnStatusText.Font = Enum.Font.Gotham
btnStatusText.TextXAlignment = Enum.TextXAlignment.Left
btnStatusText.TextYAlignment = Enum.TextYAlignment.Center
btnStatusText.Parent = toggleBtn

-- === SPEED CONTROL SECTION ===
local speedSection = Instance.new("Frame")
speedSection.Size = UDim2.new(0.9, 0, 0, 85)
speedSection.Position = UDim2.new(0.05, 0, 0, 150)
speedSection.BackgroundColor3 = Color3.fromRGB(25, 20, 25)
speedSection.BackgroundTransparency = 0.2
local sectionCorner = Instance.new("UICorner")
sectionCorner.CornerRadius = UDim.new(0, 12)
sectionCorner.Parent = speedSection
speedSection.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 12, 0, 5)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ FLIGHT SPEED"
speedLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedSection

local speedValueDisplay = Instance.new("TextLabel")
speedValueDisplay.Size = UDim2.new(0, 60, 0, 30)
speedValueDisplay.Position = UDim2.new(1, -72, 0, 5)
speedValueDisplay.BackgroundTransparency = 1
speedValueDisplay.Text = "80"
speedValueDisplay.TextColor3 = Color3.fromRGB(255, 100, 100)
speedValueDisplay.TextSize = 18
speedValueDisplay.Font = Enum.Font.GothamBold
speedValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
speedValueDisplay.Parent = speedSection

-- Slider track
local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -24, 0, 5)
sliderTrack.Position = UDim2.new(0, 12, 0, 50)
sliderTrack.BackgroundColor3 = Color3.fromRGB(40, 30, 35)
sliderTrack.BorderSizePixel = 0
local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = sliderTrack
sliderTrack.Parent = speedSection

-- Slider fill (merah)
local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.32, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

-- Slider knob
local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 18, 0, 18)
sliderKnob.Position = UDim2.new(0.32, -9, 0, -6.5)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob
sliderKnob.Parent = sliderTrack

-- Min speed label
local minSpeedLabel = Instance.new("TextLabel")
minSpeedLabel.Size = UDim2.new(0, 30, 0, 20)
minSpeedLabel.Position = UDim2.new(0, 12, 0, 62)
minSpeedLabel.BackgroundTransparency = 1
minSpeedLabel.Text = "20"
minSpeedLabel.TextColor3 = Color3.fromRGB(150, 100, 100)
minSpeedLabel.TextSize = 10
minSpeedLabel.Font = Enum.Font.Gotham
minSpeedLabel.Parent = speedSection

local maxSpeedLabel = Instance.new("TextLabel")
maxSpeedLabel.Size = UDim2.new(0, 30, 0, 20)
maxSpeedLabel.Position = UDim2.new(1, -42, 0, 62)
maxSpeedLabel.BackgroundTransparency = 1
maxSpeedLabel.Text = "250"
maxSpeedLabel.TextColor3 = Color3.fromRGB(150, 100, 100)
maxSpeedLabel.TextSize = 10
maxSpeedLabel.Font = Enum.Font.Gotham
maxSpeedLabel.TextXAlignment = Enum.TextXAlignment.Right
maxSpeedLabel.Parent = speedSection

-- === INFO PANEL ===
local infoPanel = Instance.new("Frame")
infoPanel.Size = UDim2.new(0.9, 0, 0, 70)
infoPanel.Position = UDim2.new(0.05, 0, 0, 255)
infoPanel.BackgroundColor3 = Color3.fromRGB(25, 20, 25)
infoPanel.BackgroundTransparency = 0.2
local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 12)
infoCorner.Parent = infoPanel
infoPanel.Parent = mainFrame

local hotkeyInfo = Instance.new("TextLabel")
hotkeyInfo.Size = UDim2.new(1, 0, 1, 0)
hotkeyInfo.Position = UDim2.new(0, 0, 0, 5)
hotkeyInfo.BackgroundTransparency = 1
hotkeyInfo.Text = "[V] Start/Stop Flying\n[INSERT] Hide/Show GUI"
hotkeyInfo.TextColor3 = Color3.fromRGB(180, 150, 150)
hotkeyInfo.TextSize = 11
hotkeyInfo.Font = Enum.Font.Gotham
hotkeyInfo.TextXAlignment = Enum.TextXAlignment.Center
hotkeyInfo.TextYAlignment = Enum.TextYAlignment.Top
hotkeyInfo.Parent = infoPanel

-- === FOOTER ===
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 25)
footer.Position = UDim2.new(0, 0, 1, -22)
footer.BackgroundTransparency = 1
footer.Text = "⚡ ANTI BRING BACK ACTIVE ⚡"
footer.TextColor3 = Color3.fromRGB(180, 40, 40)
footer.TextSize = 10
footer.Font = Enum.Font.GothamBold
footer.Parent = mainFrame

-- === FLIGHT SYSTEM CORE ===
local function startFlying()
    if isFlying then return end
    
    Humanoid.PlatformStand = true
    
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    bodyVel.Velocity = Vector3.new(0,0,0)
    bodyVel.Parent = RootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
    bodyGyro.Parent = RootPart
    
    -- Paksa network ownership
    pcall(function()
        RootPart:SetNetworkOwner(LP)
    end)
    
    isFlying = true
    
    -- Update loop
    RS.RenderStepped:Connect(function()
        if not isFlying then return end
        
        local moveDir = Vector3.new(0,0,0)
        local camCF = Camera.CFrame
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end
        
        currentVel = currentVel:Lerp(moveDir * flySpeed, 0.35)
        
        if bodyVel then
            bodyVel.Velocity = currentVel
        end
        
        if bodyGyro then
            bodyGyro.CFrame = camCF
        end
        
        antiBringBack()
    end)
end

local function stopFlying()
    isFlying = false
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    Humanoid.PlatformStand = false
    currentVel = Vector3.new(0,0,0)
end

local function toggleFly()
    if isFlying then
        stopFlying()
        toggleBtn.BackgroundColor3 = Color3.fromRGB(160, 30, 30)
        toggleBtn.Text = "🔥 ACTIVATE FLIGHT 🔥"
        btnStatusLight.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        btnStatusText.Text = "INACTIVE"
        headerStatus.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    else
        startFlying()
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
        toggleBtn.Text = "🛑 DEACTIVATE FLIGHT 🛑"
        btnStatusLight.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        btnStatusText.Text = "ACTIVE"
        headerStatus.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    end
end

-- === SLIDER LOGIC ===
local dragging = false

sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        flySpeed = math.clamp(math.floor(relativeX * 230 + 20), 20, 250)
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderKnob.Position = UDim2.new(relativeX, -9, 0, -6.5)
        speedValueDisplay.Text = tostring(flySpeed)
    end
end)

-- === BUTTON CONNECTIONS ===
toggleBtn.MouseButton1Click:Connect(toggleFly)

minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    guiVisible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    guiVisible = false
end)

-- === HOTKEYS ===
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.V then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.Insert then
        guiVisible = not guiVisible
        mainFrame.Visible = guiVisible
    end
end)

-- === RESPAWN HANDLER ===
LP.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    lastPosition = RootPart.Position
    lastCFrame = RootPart.CFrame
    
    if isFlying then
        stopFlying()
        task.wait(0.3)
        startFlying()
    end
end)

-- === NOTIFICATION ===
local notif = Instance.new("Frame")
notif.Size = UDim2.new(0, 280, 0, 45)
notif.Position = UDim2.new(0.5, -140, 0.85, 0)
notif.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
notif.BackgroundTransparency = 0.1
local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 10)
notifCorner.Parent = notif

local notifBorder = Instance.new("UIStroke")
notifBorder.Color = Color3.fromRGB(180, 30, 30)
notifBorder.Thickness = 1
notifBorder.Parent = notif

local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1, 0, 1, 0)
notifText.BackgroundTransparency = 1
notifText.Text = "🔥 BLOOD FLIGHT v4.0 LOADED 🔥\nPress INSERT to open menu"
notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
notifText.TextSize = 11
notifText.Font = Enum.Font.Gotham
notifText.Parent = notif

notif.Parent = screenGui

task.wait(3)
notif:Destroy()

print("Blood Flight v4.0 - Loaded Successfully")
print("Anti Bring Back: ACTIVE")
print("GUI Theme: Red/Black")
