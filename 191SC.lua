--[[ 
    SCRIPT: Bring Back Brute Forcer v4 (With CFrame + Rotation)
    Support: Posisi + sudut (CFrame.Angles)
]]

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- VARIABEL
local attempting = false
local success = false
local attempts = 0
local targetCFrame = nil

-- Bikin GUI
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local presetBtn = Instance.new("TextButton")
local startBtn = Instance.new("TextButton")
local stopBtn = Instance.new("TextButton")
local statusLabel = Instance.new("TextLabel")
local attemptsLabel = Instance.new("TextLabel")

screenGui.Parent = game:GetService("CoreGui")
screenGui.Name = "BringBackBruteGUI"

mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true

title.Parent = mainFrame
title.Size = UDim2.new(0, 280, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "BRING BACK BRUTE FORCER v4"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextScaled = true

presetBtn.Parent = mainFrame
presetBtn.Size = UDim2.new(0, 280, 0, 40)
presetBtn.Position = UDim2.new(0, 10, 0, 45)
presetBtn.Text = "SET TARGET (Koord dari lo)"
presetBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

startBtn.Parent = mainFrame
startBtn.Size = UDim2.new(0, 130, 0, 35)
startBtn.Position = UDim2.new(0, 10, 0, 100)
startBtn.Text = "START SPAM"
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

stopBtn.Parent = mainFrame
stopBtn.Size = UDim2.new(0, 130, 0, 35)
stopBtn.Position = UDim2.new(0, 155, 0, 100)
stopBtn.Text = "STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stopBtn.Visible = false

statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(0, 280, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 145)
statusLabel.Text = "Status: Target belum diset"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)

attemptsLabel.Parent = mainFrame
attemptsLabel.Size = UDim2.new(0, 280, 0, 30)
attemptsLabel.Position = UDim2.new(0, 10, 0, 170)
attemptsLabel.Text = "Attempts: 0"

-- FUNGSI SPAM TELEPORT (CFrame version)
local function spamTeleport()
    while attempting and not success do
        attempts = attempts + 1
        attemptsLabel.Text = "Attempts: " .. attempts
        
        -- Teleport paksa dengan CFrame (posisi + rotasi)
        hrp.CFrame = targetCFrame
        
        wait(0.01)
        
        -- Cek jarak (abaikan rotasi)
        local distance = (hrp.Position - targetCFrame.Position).magnitude
        if distance < 5 then
            success = true
            statusLabel.Text = "STATUS: SUCCESS! TARGET TERCAPAI!"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            startBtn.Visible = true
            stopBtn.Visible = false
            break
        end
        
        if attempts % 10 == 0 then
            statusLabel.Text = "Status: Spamming... (" .. attempts .. "x)"
        end
        
        wait(0.005)
    end
    
    if not success and not attempting then
        statusLabel.Text = "Status: Stopped by user"
    end
end

-- TOMBOL SET TARGET (pake koordinat lo)
presetBtn.MouseButton1Click:Connect(function()
    -- Koordinat dari lo persis
    targetCFrame = CFrame.new(1202.31, 3.71, -182.55) * CFrame.Angles(3.14, 0.11, 3.14)
    
    statusLabel.Text = "Target set! Pos: 1202.31, 3.71, -182.55"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    print("[System] Target CFrame: " .. tostring(targetCFrame))
end)

-- TOMBOL START
startBtn.MouseButton1Click:Connect(function()
    if not targetCFrame then
        statusLabel.Text = "ERROR: Klik 'SET TARGET' dulu!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    attempting = true
    success = false
    attempts = 0
    attemptsLabel.Text = "Attempts: 0"
    statusLabel.Text = "Status: Spamming teleport..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    startBtn.Visible = false
    stopBtn.Visible = true
    
    spawn(spamTeleport)
end)

-- TOMBOL STOP
stopBtn.MouseButton1Click:Connect(function()
    attempting = false
    statusLabel.Text = "Status: Stopping..."
    wait(0.1)
    statusLabel.Text = "Status: Stopped"
    statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    startBtn.Visible = true
    stopBtn.Visible = false
end)

print("[System] GUI siap. Klik 'SET TARGET' -> START SPAM")
print("[System] Target koordinat: 1202.31, 3.71, -182.55 dengan rotasi tertentu")
