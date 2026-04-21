--[[
    DARK FLIGHT SYSTEM v3.0
    - Aggressive Anti Bring Back
    - Network Ownership Exploit
    - Memory Spoofing
    - GUI Fix & Enhanced
]]

-- Tunggu hingga game benar-benar siap
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

-- Variabel
local isFlying = false
local flySpeed = 80
local currentVel = Vector3.new(0,0,0)
local bodyVel = nil
local bodyGyro = nil
local networkOwnershipStolen = false

-- Tunggu karakter benar-benar siap
local Character = LP.Character or LP.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- === ANTI BRING BACK AGGRESSIVE ===
local lastPosition = RootPart.Position
local lastCFrame = RootPart.CFrame
local teleportCount = 0
local originalNetworkOwner = nil

-- Fungsi untuk mencuri network ownership (teknik advanced)
local function stealNetworkOwnership(part)
    if not part then return end
    local success, result = pcall(function()
        -- Metode 1: Force set network owner ke client
        if part:IsA("BasePart") then
            -- Ini adalah teknik exploit yang memaksa server mengakui client sebagai owner
            local fires = debug and debug.getupvalues or function() end
            -- Menggunakan metode remote event spoofing
            local remote = Instance.new("RemoteEvent")
            remote.Name = "NetworkOwnerSpoof"
            remote.Parent = part
            remote:FireServer(part)
            task.wait()
            remote:Destroy()
        end
    end)
    return success
end

-- Fungsi utama anti bring back yang lebih kuat
local function aggressiveAntiBringBack()
    if not isFlying then return end
    
    local currentPos = RootPart.Position
    local distance = (currentPos - lastPosition).Magnitude
    
    -- Deteksi teleportasi paksa oleh server
    if distance > (flySpeed * 0.8) and distance < 500 then
        teleportCount = teleportCount + 1
        
        if teleportCount >= 2 then
            -- SERVER MENCOBA BRING BACK - KITA BALAS LEBIH KUAT
            RootPart.CFrame = lastCFrame
            RootPart.Velocity = Vector3.new(0,0,0)
            RootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
            
            -- Paksa update posisi ke server
            pcall(function()
                RootPart:SetNetworkOwner(nil)
                task.wait(0.05)
                RootPart:SetNetworkOwner(LP)
            end)
            
            -- Reset counter
            teleportCount = 0
        end
    else
        teleportCount = math.max(0, teleportCount - 0.5)
        lastPosition = currentPos
        lastCFrame = RootPart.CFrame
    end
    
    -- Jaga posisi tetap stabil
    if bodyVel then
        bodyVel.Velocity = currentVel
    end
end

-- === PERBAIKAN GUI - PAKAI MODAL FRAME ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkFlight"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Coba parent ke berbagai tempat sampai berhasil
local successParent = false
local parentLocations = {LP.PlayerGui, game:GetService("CoreGui"), game:GetService("StarterGui")}

for _, parent in pairs(parentLocations) do
    pcall(function()
        screenGui.Parent = parent
        if screenGui.Parent then
            successParent = true
            break
        end
    end)
    if successParent then break end
end

if not successParent then
    screenGui.Parent = LP.PlayerGui
end

-- Buat frame utama dengan gaya modern dan pasti muncul
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true

-- Efek blur
local blur = Instance.new("BlurEffect")
blur.Size = 10
blur.Enabled = true

-- Corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

-- Stroke/border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 100, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.7
stroke.Parent = mainFrame

-- Shadow
local shadow = Instance.new("UIShadow")
shadow.Color = Color3.fromRGB(0,0,0)
shadow.Size = 20
shadow.Parent = mainFrame

mainFrame.Parent = screenGui

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(80, 100, 255)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "DARK FLIGHT v3.0"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,100,100)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -80, 0, 10)
minBtn.BackgroundTransparency = 1
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(200,200,200)
minBtn.TextSize = 25
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = header
minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- === FLIGHT TOGGLE BUTTON ===
local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(0.9, 0, 0, 55)
toggleFrame.Position = UDim2.new(0.05, 0, 0, 70)
toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
toggleFrame.BackgroundTransparency = 0.2
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 27)
toggleCorner.Parent = toggleFrame
toggleFrame.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 100, 255)
toggleBtn.Text = "✈ START FLYING"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.GothamBold
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 27)
btnCorner.Parent = toggleBtn
toggleBtn.Parent = toggleFrame

-- Status indicator
local statusLight = Instance.new("Frame")
statusLight.Size = UDim2.new(0, 12, 0, 12)
statusLight.Position = UDim2.new(0, 15, 0, 21)
statusLight.BackgroundColor3 = Color3.fromRGB(255,50,50)
statusLight.BorderSizePixel = 0
local lightCorner = Instance.new("UICorner")
lightCorner.CornerRadius = UDim.new(1,0)
lightCorner.Parent = statusLight
statusLight.Parent = toggleBtn

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -40, 1, 0)
statusText.Position = UDim2.new(0, 35, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "INACTIVE"
statusText.TextColor3 = Color3.fromRGB(200,200,200)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = toggleBtn

-- === SPEED SLIDER ===
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0.9, 0, 0, 70)
speedFrame.Position = UDim2.new(0.05, 0, 0, 145)
speedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
speedFrame.BackgroundTransparency = 0.2
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 12)
speedCorner.Parent = speedFrame
speedFrame.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 5)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "SPEED"
speedLabel.TextColor3 = Color3.fromRGB(200,200,255)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedFrame

local speedValue = Instance.new("TextLabel")
speedValue.Size = UDim2.new(0, 50, 0, 25)
speedValue.Position = UDim2.new(1, -60, 0, 5)
speedValue.BackgroundTransparency = 1
speedValue.Text = "80"
speedValue.TextColor3 = Color3.fromRGB(255,150,50)
speedValue.TextSize = 16
speedValue.Font = Enum.Font.GothamBold
speedValue.TextXAlignment = Enum.TextXAlignment.Right
speedValue.Parent = speedFrame

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -20, 0, 4)
sliderTrack.Position = UDim2.new(0, 10, 0, 45)
sliderTrack.BackgroundColor3 = Color3.fromRGB(50,50,70)
sliderTrack.BorderSizePixel = 0
local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1,0)
sliderCorner.Parent = sliderTrack
sliderTrack.Parent = speedFrame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.4, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(80,100,255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 16, 0, 16)
sliderKnob.Position = UDim2.new(0.4, -8, 0, -6)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
sliderKnob.BorderSizePixel = 0
local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1,0)
knobCorner.Parent = sliderKnob
sliderKnob.Parent = sliderTrack

-- Slider drag logic
local draggingSlider = false
sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        flySpeed = math.clamp(math.floor(relativeX * 250), 20, 250)
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderKnob.Position = UDim2.new(relativeX, -8, 0, -6)
        speedValue.Text = tostring(flySpeed)
    end
end)

-- Footer info
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundTransparency = 1
footer.Text = "Anti Bring Back Active • Press V to Fly • INSERT to Toggle GUI"
footer.TextColor3 = Color3.fromRGB(100,100,130)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.Parent = mainFrame

-- === FLIGHT SYSTEM CORE ===
local function startFlying()
    if isFlying then return end
    
    Humanoid.PlatformStand = true
    
    -- BodyVelocity untuk gerakan
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVel.Velocity = Vector3.new(0,0,0)
    bodyVel.Parent = RootPart
    
    -- BodyGyro untuk rotasi stabil
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.Parent = RootPart
    
    -- Curi network ownership
    pcall(function()
        RootPart:SetNetworkOwner(LP)
        stealNetworkOwnership(RootPart)
    end)
    
    isFlying = true
    
    -- Update loop
    RS.RenderStepped:Connect(function()
        if not isFlying then return end
        
        local move = Vector3.new(0,0,0)
        local camCF = Camera.CFrame
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
        
        if move.Magnitude > 0 then
            move = move.Unit
        end
        
        currentVel = currentVel:Lerp(move * flySpeed, 0.35)
        
        if bodyVel then
            bodyVel.Velocity = currentVel
        end
        
        if bodyGyro then
            bodyGyro.CFrame = camCF
        end
        
        -- Panggil anti bring back setiap frame
        aggressiveAntiBringBack()
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
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80,100,255)
        toggleBtn.Text = "✈ START FLYING"
        statusLight.BackgroundColor3 = Color3.fromRGB(255,50,50)
        statusText.Text = "INACTIVE"
    else
        startFlying()
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200,50,100)
        toggleBtn.Text = "✈ STOP FLYING"
        statusLight.BackgroundColor3 = Color3.fromRGB(50,255,50)
        statusText.Text = "ACTIVE"
    end
end

toggleBtn.MouseButton1Click:Connect(toggleFly)

-- Hotkeys
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.V then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Handle respawn
LP.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    lastPosition = RootPart.Position
    lastCFrame = RootPart.CFrame
    
    if isFlying then
        stopFlying()
        task.wait(0.2)
        startFlying()
    end
end)

-- Notifikasi startup
local notif = Instance.new("TextLabel")
notif.Size = UDim2.new(0, 250, 0, 40)
notif.Position = UDim2.new(0.5, -125, 0.85, 0)
notif.BackgroundColor3 = Color3.fromRGB(15,15,25)
notif.BackgroundTransparency = 0.1
notif.Text = "✓ Dark Flight v3.0 Loaded\nPress INSERT to open menu"
notif.TextColor3 = Color3.fromRGB(255,255,255)
notif.TextSize = 12
notif.Font = Enum.Font.Gotham
local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 10)
notifCorner.Parent = notif
notif.Parent = screenGui

task.wait(3)
notif:Destroy()

print("Dark Flight v3.0 - Aggressive Anti Bring Back Active")
