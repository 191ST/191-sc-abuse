-- ============================================================
-- SCRIPT FULLY NV + DANGER TP (TP LANGSUNG 12 LOKASI)
-- ============================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

repeat task.wait() until player.Character

local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- WARNA
-- ============================================================
local C = {
    bg = Color3.fromRGB(13, 13, 18),
    card = Color3.fromRGB(22, 22, 30),
    accent = Color3.fromRGB(148, 80, 255),
    red = Color3.fromRGB(220, 60, 75),
    green = Color3.fromRGB(52, 210, 110),
    orange = Color3.fromRGB(255, 160, 40),
    blue = Color3.fromRGB(82, 130, 255),
    text = Color3.fromRGB(230, 232, 240),
    textDim = Color3.fromRGB(145, 138, 175),
    border = Color3.fromRGB(38, 32, 62),
}

-- ============================================================
-- GUI UTAMA
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "NV_SCRIPT"
gui.Parent = playerGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 420, 0, 580)
main.Position = UDim2.new(0.5, -210, 0.5, -290)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", main).Color = C.border

-- Title bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = C.card
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "NV SCRIPT"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextColor3 = C.accent
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
closeBtn.BackgroundColor3 = C.red
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = C.text
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- TAB BUTTONS
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1, 0, 0, 38)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = C.card

local fullyTabBtn = Instance.new("TextButton", tabBar)
fullyTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
fullyTabBtn.Position = UDim2.new(0, 0, 0, 0)
fullyTabBtn.BackgroundTransparency = 1
fullyTabBtn.Text = "⚡ FULLY NV"
fullyTabBtn.Font = Enum.Font.GothamBold
fullyTabBtn.TextSize = 12
fullyTabBtn.TextColor3 = C.accent
fullyTabBtn.BorderSizePixel = 0

local dtpTabBtn = Instance.new("TextButton", tabBar)
dtpTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
dtpTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
dtpTabBtn.BackgroundTransparency = 1
dtpTabBtn.Text = "💀 DANGER TP"
dtpTabBtn.Font = Enum.Font.GothamBold
dtpTabBtn.TextSize = 12
dtpTabBtn.TextColor3 = C.textDim
dtpTabBtn.BorderSizePixel = 0

-- CONTENT AREA
local fullyContent = Instance.new("ScrollingFrame", main)
fullyContent.Size = UDim2.new(1, 0, 1, -78)
fullyContent.Position = UDim2.new(0, 0, 0, 78)
fullyContent.BackgroundTransparency = 1
fullyContent.ScrollBarThickness = 3
fullyContent.Visible = true
fullyContent.CanvasSize = UDim2.new(0, 0, 0, 650)

local dtpContent = Instance.new("ScrollingFrame", main)
dtpContent.Size = UDim2.new(1, 0, 1, -78)
dtpContent.Position = UDim2.new(0, 0, 0, 78)
dtpContent.BackgroundTransparency = 1
dtpContent.ScrollBarThickness = 3
dtpContent.Visible = false
dtpContent.CanvasSize = UDim2.new(0, 0, 0, 650)

local pad1 = Instance.new("UIPadding", fullyContent)
pad1.PaddingTop = UDim.new(0, 10)
pad1.PaddingLeft = UDim.new(0, 10)
pad1.PaddingRight = UDim.new(0, 10)

local pad2 = Instance.new("UIPadding", dtpContent)
pad2.PaddingTop = UDim.new(0, 10)
pad2.PaddingLeft = UDim.new(0, 10)
pad2.PaddingRight = UDim.new(0, 10)

fullyTabBtn.MouseButton1Click:Connect(function()
    fullyContent.Visible = true
    dtpContent.Visible = false
    fullyTabBtn.TextColor3 = C.accent
    dtpTabBtn.TextColor3 = C.textDim
end)

dtpTabBtn.MouseButton1Click:Connect(function()
    fullyContent.Visible = false
    dtpContent.Visible = true
    fullyTabBtn.TextColor3 = C.textDim
    dtpTabBtn.TextColor3 = C.accent
end)

-- ============================================================
-- FULLY NV SECTION
-- ============================================================

-- Header
local fHeader = Instance.new("Frame", fullyContent)
fHeader.Size = UDim2.new(1, 0, 0, 70)
fHeader.BackgroundColor3 = C.card
fHeader.LayoutOrder = 1
Instance.new("UICorner", fHeader).CornerRadius = UDim.new(0, 10)

local fTitle = Instance.new("TextLabel", fHeader)
fTitle.Size = UDim2.new(1, -16, 0, 20)
fTitle.Position = UDim2.new(0, 8, 0, 8)
fTitle.BackgroundTransparency = 1
fTitle.Text = "⚡ FULLY NV — CASINO APART"
fTitle.Font = Enum.Font.GothamBold
fTitle.TextSize = 13
fTitle.TextColor3 = C.accent

local fDesc = Instance.new("TextLabel", fHeader)
fDesc.Size = UDim2.new(1, -16, 0, 35)
fDesc.Position = UDim2.new(0, 8, 0, 28)
fDesc.BackgroundTransparency = 1
fDesc.Text = "Auto masak | BodyVelocity slow tween | Blink if stuck | Spam E 3x"
fDesc.Font = Enum.Font.Gotham
fDesc.TextSize = 9
fDesc.TextColor3 = C.textDim
fDesc.TextWrapped = true

-- Pilih Apart
local apartFrame = Instance.new("Frame", fullyContent)
apartFrame.Size = UDim2.new(1, 0, 0, 50)
apartFrame.BackgroundColor3 = C.card
apartFrame.LayoutOrder = 2
Instance.new("UICorner", apartFrame).CornerRadius = UDim.new(0, 10)

local apartLabel = Instance.new("TextLabel", apartFrame)
apartLabel.Size = UDim2.new(0, 100, 1, 0)
apartLabel.Position = UDim2.new(0, 12, 0, 0)
apartLabel.BackgroundTransparency = 1
apartLabel.Text = "Pilih Apart:"
apartLabel.Font = Enum.Font.GothamBold
apartLabel.TextSize = 12
apartLabel.TextColor3 = C.textDim
apartLabel.TextXAlignment = Enum.TextXAlignment.Left

local apartDropdown = Instance.new("TextButton", apartFrame)
apartDropdown.Size = UDim2.new(0, 150, 0, 34)
apartDropdown.Position = UDim2.new(1, -162, 0.5, -17)
apartDropdown.BackgroundColor3 = C.bg
apartDropdown.Text = "▼ Pilih Apart"
apartDropdown.Font = Enum.Font.Gotham
apartDropdown.TextSize = 11
apartDropdown.TextColor3 = C.text
Instance.new("UICorner", apartDropdown).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", apartDropdown).Color = C.border

local apartOptions = {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}
local selectedApart = nil
local dropdownOpen = false
local dropdownList = nil

apartDropdown.MouseButton1Click:Connect(function()
    if dropdownOpen then if dropdownList then dropdownList:Destroy() end dropdownOpen = false return end
    dropdownOpen = true
    dropdownList = Instance.new("Frame", fullyContent)
    dropdownList.Size = UDim2.new(0, 150, 0, #apartOptions * 34)
    dropdownList.Position = UDim2.new(1, -162, 0, apartFrame.AbsolutePosition.Y + 45)
    dropdownList.BackgroundColor3 = C.card
    Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", dropdownList).Color = C.border
    dropdownList.ZIndex = 10
    
    for i, opt in ipairs(apartOptions) do
        local optBtn = Instance.new("TextButton", dropdownList)
        optBtn.Size = UDim2.new(1, 0, 0, 34)
        optBtn.Position = UDim2.new(0, 0, 0, (i-1)*34)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 11
        optBtn.TextColor3 = C.text
        optBtn.MouseButton1Click:Connect(function()
            selectedApart = i
            apartDropdown.Text = opt
            if dropdownList then dropdownList:Destroy() end
            dropdownOpen = false
        end)
    end
end)

-- Pilih POT
local potFrame = Instance.new("Frame", fullyContent)
potFrame.Size = UDim2.new(1, 0, 0, 50)
potFrame.BackgroundColor3 = C.card
potFrame.LayoutOrder = 3
Instance.new("UICorner", potFrame).CornerRadius = UDim.new(0, 10)

local potLabel = Instance.new("TextLabel", potFrame)
potLabel.Size = UDim2.new(0, 100, 1, 0)
potLabel.Position = UDim2.new(0, 12, 0, 0)
potLabel.BackgroundTransparency = 1
potLabel.Text = "Pilih POT:"
potLabel.Font = Enum.Font.GothamBold
potLabel.TextSize = 12
potLabel.TextColor3 = C.textDim
potLabel.TextXAlignment = Enum.TextXAlignment.Left

local potDropdown = Instance.new("TextButton", potFrame)
potDropdown.Size = UDim2.new(0, 150, 0, 34)
potDropdown.Position = UDim2.new(1, -162, 0.5, -17)
potDropdown.BackgroundColor3 = C.bg
potDropdown.Text = "▼ Pilih POT"
potDropdown.Font = Enum.Font.Gotham
potDropdown.TextSize = 11
potDropdown.TextColor3 = C.text
Instance.new("UICorner", potDropdown).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", potDropdown).Color = C.border

local potOptions = {"POT KANAN", "POT KIRI"}
local selectedPot = nil
local potDropdownOpen = false
local potDropdownList = nil

potDropdown.MouseButton1Click:Connect(function()
    if potDropdownOpen then if potDropdownList then potDropdownList:Destroy() end potDropdownOpen = false return end
    potDropdownOpen = true
    potDropdownList = Instance.new("Frame", fullyContent)
    potDropdownList.Size = UDim2.new(0, 150, 0, #potOptions * 34)
    potDropdownList.Position = UDim2.new(1, -162, 0, potFrame.AbsolutePosition.Y + 45)
    potDropdownList.BackgroundColor3 = C.card
    Instance.new("UICorner", potDropdownList).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", potDropdownList).Color = C.border
    potDropdownList.ZIndex = 10
    
    for i, opt in ipairs(potOptions) do
        local optBtn = Instance.new("TextButton", potDropdownList)
        optBtn.Size = UDim2.new(1, 0, 0, 34)
        optBtn.Position = UDim2.new(0, 0, 0, (i-1)*34)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 11
        optBtn.TextColor3 = C.text
        optBtn.MouseButton1Click:Connect(function()
            selectedPot = i
            potDropdown.Text = opt
            if potDropdownList then potDropdownList:Destroy() end
            potDropdownOpen = false
        end)
    end
end)

-- Status
local fStatusFrame = Instance.new("Frame", fullyContent)
fStatusFrame.Size = UDim2.new(1, 0, 0, 40)
fStatusFrame.BackgroundColor3 = C.card
fStatusFrame.LayoutOrder = 4
Instance.new("UICorner", fStatusFrame).CornerRadius = UDim.new(0, 10)

local fStatusLabel = Instance.new("TextLabel", fStatusFrame)
fStatusLabel.Size = UDim2.new(1, -16, 1, 0)
fStatusLabel.Position = UDim2.new(0, 8, 0, 0)
fStatusLabel.BackgroundTransparency = 1
fStatusLabel.Text = "Belum dimulai"
fStatusLabel.Font = Enum.Font.Gotham
fStatusLabel.TextSize = 11
fStatusLabel.TextColor3 = C.textDim
fStatusLabel.TextXAlignment = Enum.TextXAlignment.Center

local fProgress = Instance.new("TextLabel", fullyContent)
fProgress.Size = UDim2.new(1, -20, 0, 30)
fProgress.BackgroundColor3 = C.card
fProgress.LayoutOrder = 5
fProgress.Font = Enum.Font.Gotham
fProgress.TextSize = 10
fProgress.TextColor3 = C.blue
fProgress.TextXAlignment = Enum.TextXAlignment.Center
Instance.new("UICorner", fProgress).CornerRadius = UDim.new(0, 8)

-- Buttons
local fBtnFrame = Instance.new("Frame", fullyContent)
fBtnFrame.Size = UDim2.new(1, 0, 0, 80)
fBtnFrame.BackgroundTransparency = 1
fBtnFrame.LayoutOrder = 6

local startBtn = Instance.new("TextButton", fBtnFrame)
startBtn.Size = UDim2.new(0.45, -5, 0, 38)
startBtn.Position = UDim2.new(0, 0, 0, 10)
startBtn.BackgroundColor3 = C.blue
startBtn.Text = "▶ START"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 12
startBtn.TextColor3 = C.text
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", fBtnFrame)
stopBtn.Size = UDim2.new(0.45, -5, 0, 38)
stopBtn.Position = UDim2.new(0.55, 0, 0, 10)
stopBtn.BackgroundColor3 = C.red
stopBtn.Text = "■ STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 12
stopBtn.TextColor3 = C.text
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)
stopBtn.Visible = false

-- ============================================================
-- KOORDINAT
-- ============================================================
local apartCoords = {
    [1] = {
        {cf = CFrame.new(1196.51, 3.71, -241.13)},
        {cf = CFrame.new(1199.75, 3.71, -238.12)},
        {cf = CFrame.new(1199.74, 6.59, -233.05)},
        {cf = CFrame.new(1199.66, 6.59, -227.75)},
        {kanan = CFrame.new(1199.91, 7.56, -219.75), kiri = CFrame.new(1199.75, 7.45, -217.66)},
        {kanan = CFrame.new(1199.87, 15.96, -215.33), kiri = CFrame.new(1199.38, 15.96, -220.53)},
    },
    [2] = {
        {cf = CFrame.new(1186.34, 3.71, -242.92)},
        {cf = CFrame.new(1183.00, 6.59, -233.78)},
        {cf = CFrame.new(1182.70, 7.32, -229.73)},
        {cf = CFrame.new(1182.75, 6.59, -224.78)},
        {kanan = CFrame.new(1183.43, 15.96, -229.66), kiri = CFrame.new(1183.22, 15.96, -225.63)},
    },
    [3] = {
        {cf = CFrame.new(1196.17, 3.71, -205.72)},
        {cf = CFrame.new(1199.76, 3.71, -196.51)},
        {cf = CFrame.new(1199.69, 6.59, -191.16)},
        {cf = CFrame.new(1199.42, 6.59, -185.27)},
        {kanan = CFrame.new(1199.42, 6.59, -185.27), kiri = CFrame.new(1199.95, 7.07, -177.69)},
        {kanan = CFrame.new(1199.55, 15.96, -181.89), kiri = CFrame.new(1199.46, 15.96, -177.81)},
    },
    [4] = {
        {cf = CFrame.new(1187.70, 3.71, -209.73)},
        {cf = CFrame.new(1182.27, 3.71, -204.65)},
        {cf = CFrame.new(1182.23, 3.71, -198.77)},
        {cf = CFrame.new(1183.06, 6.59, -193.92)},
        {kanan = CFrame.new(1182.60, 7.56, -191.29), kiri = CFrame.new(1183.36, 6.72, -187.25)},
        {kanan = CFrame.new(1183.24, 15.96, -191.25), kiri = CFrame.new(1183.08, 15.96, -187.36)},
    }
}

-- ============================================================
-- BODY VELOCITY
-- ============================================================
local nvRunning = false
local nvStopFlag = false
local currentBodyVel = nil
local currentBodyGyro = nil

local function stopBodyVelocity()
    if currentBodyVel then currentBodyVel:Destroy() currentBodyVel = nil end
    if currentBodyGyro then currentBodyGyro:Destroy() currentBodyGyro = nil end
end

local function moveToPosition(targetPos, targetCF, onComplete)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then if onComplete then onComplete(false) end return end
    
    stopBodyVelocity()
    
    currentBodyVel = Instance.new("BodyVelocity")
    currentBodyVel.MaxForce = Vector3.new(5000, 5000, 5000)
    currentBodyVel.Velocity = Vector3.zero
    currentBodyVel.Parent = hrp
    
    currentBodyGyro = Instance.new("BodyGyro")
    currentBodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    currentBodyGyro.CFrame = targetCF
    currentBodyGyro.Parent = hrp
    
    local speed = 12
    local lastDistance = (targetPos - hrp.Position).Magnitude
    local stuckTime = 0
    
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if not nvRunning or nvStopFlag or not hrp or not hrp.Parent then
            connection:Disconnect()
            stopBodyVelocity()
            if onComplete then onComplete(false) end
            return
        end
        
        local currentPos = hrp.Position
        local newDistance = (targetPos - currentPos).Magnitude
        local newDirection = (targetPos - currentPos).Unit
        
        if currentBodyVel then
            currentBodyVel.Velocity = newDirection * speed
        end
        if currentBodyGyro then
            currentBodyGyro.CFrame = CFrame.new(currentPos, targetPos)
        end
        
        if math.abs(newDistance - lastDistance) < 0.2 then
            stuckTime = stuckTime + dt
        else
            stuckTime = 0
        end
        lastDistance = newDistance
        
        if newDistance <= 3 or stuckTime > 2 then
            connection:Disconnect()
            stopBodyVelocity()
            if newDistance > 3 and stuckTime > 2 then
                hrp.CFrame = CFrame.new(targetPos)
            end
            if onComplete then onComplete(true) end
        end
    end)
end

local function blinkToPosition(pos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(pos) end
end

local function pressEOnce()
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function interactAndWait(toolName, waitTime, isSugarStep, isGelatinStep, sugarDoneFlag)
    if toolName then
        local char = player.Character
        local tool = player.Backpack:FindFirstChild(toolName) or char:FindFirstChild(toolName)
        if tool then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:EquipTool(tool) end
            task.wait(0.2)
        end
    end
    
    for i = 1, 3 do pressEOnce() task.wait(0.1) end
    
    if isSugarStep then
        while nvRunning and not nvStopFlag and not sugarDoneFlag[1] do task.wait(0.1) end
    elseif isGelatinStep then
        sugarDoneFlag[1] = true
    else
        task.wait(waitTime or 1)
    end
end

local function doCookSequence(tahapIndex, targetCF)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local targetPos = targetCF.Position
    blinkToPosition(Vector3.new(targetPos.X, targetPos.Y - 2, targetPos.Z))
    task.wait(0.1)
    
    local completed = false
    moveToPosition(targetPos, targetCF, function(success) completed = success end)
    while nvRunning and not nvStopFlag and not completed do task.wait(0.1) end
    if nvStopFlag then return false end
    
    if tahapIndex == 1 then
        interactAndWait("Water", 20, false, false, {false})
    elseif tahapIndex == 2 then
        local sugarFlag = {false}
        interactAndWait("Sugar Block Bag", 0, true, false, sugarFlag)
        while nvRunning and not nvStopFlag and not sugarFlag[1] do task.wait(0.1) end
    elseif tahapIndex == 3 then
        interactAndWait("Gelatin", 0, false, true, {false})
    else
        interactAndWait("Empty Bag", 45, false, false, {false})
    end
    return true
end

local function runFullyNV()
    if not selectedApart or not selectedPot then
        fStatusLabel.Text = "❌ Pilih Apart dan POT dulu!"
        fStatusLabel.TextColor3 = C.red
        return
    end
    
    nvRunning = true
    nvStopFlag = false
    fStatusLabel.Text = "⚡ FULLY NV berjalan..."
    fStatusLabel.TextColor3 = C.blue
    startBtn.Visible = false
    stopBtn.Visible = true
    
    local stages = apartCoords[selectedApart]
    if not stages then
        fStatusLabel.Text = "❌ Data apart tidak ditemukan"
        startBtn.Visible = true
        stopBtn.Visible = false
        nvRunning = false
        return
    end
    
    for i, stage in ipairs(stages) do
        if nvStopFlag then break end
        
        local targetCF = nil
        if stage.cf then
            targetCF = stage.cf
        elseif stage.kanan then
            targetCF = (selectedPot == 1) and stage.kanan or stage.kiri
        end
        
        if targetCF then
            fProgress.Text = string.format("Tahap %d/%d", i, #stages)
            doCookSequence(i, targetCF)
            task.wait(0.3)
        end
    end
    
    if nvStopFlag then
        fStatusLabel.Text = "⏹ Dihentikan"
        fStatusLabel.TextColor3 = C.orange
    else
        fStatusLabel.Text = "✅ Selesai!"
        fStatusLabel.TextColor3 = C.green
        fProgress.Text = "Selesai"
    end
    
    nvRunning = false
    stopBodyVelocity()
    startBtn.Visible = true
    stopBtn.Visible = false
end

startBtn.MouseButton1Click:Connect(function()
    if nvRunning then return end
    task.spawn(runFullyNV)
end)

stopBtn.MouseButton1Click:Connect(function()
    nvStopFlag = true
    nvRunning = false
    stopBodyVelocity()
    startBtn.Visible = true
    stopBtn.Visible = false
    fStatusLabel.Text = "⏹ Dihentikan"
    fStatusLabel.TextColor3 = C.orange
end)

-- ============================================================
-- DANGER TP SECTION (12 LOKASI JELAS)
-- ============================================================

-- Header DTP
local dHeader = Instance.new("Frame", dtpContent)
dHeader.Size = UDim2.new(1, 0, 0, 65)
dHeader.BackgroundColor3 = Color3.fromRGB(30, 8, 8)
dHeader.LayoutOrder = 1
Instance.new("UICorner", dHeader).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", dHeader).Color = C.red

local dTitle = Instance.new("TextLabel", dHeader)
dTitle.Size = UDim2.new(1, -16, 0, 20)
dTitle.Position = UDim2.new(0, 8, 0, 8)
dTitle.BackgroundTransparency = 1
dTitle.Text = "⚠️ DANGER TELEPORT ⚠️"
dTitle.Font = Enum.Font.GothamBold
dTitle.TextSize = 14
dTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
dTitle.TextXAlignment = Enum.TextXAlignment.Center

local dDesc = Instance.new("TextLabel", dHeader)
dDesc.Size = UDim2.new(1, -16, 0, 30)
dDesc.Position = UDim2.new(0, 8, 0, 30)
dDesc.BackgroundTransparency = 1
dDesc.Text = "Lukai diri hingga 1% (5ms) → 100ms → TP instan"
dDesc.Font = Enum.Font.Gotham
dDesc.TextSize = 9
dDesc.TextColor3 = C.textDim
dDesc.TextXAlignment = Enum.TextXAlignment.Center

-- Status DTP
local dStatusFrame = Instance.new("Frame", dtpContent)
dStatusFrame.Size = UDim2.new(1, 0, 0, 45)
dStatusFrame.BackgroundColor3 = C.card
dStatusFrame.LayoutOrder = 2
Instance.new("UICorner", dStatusFrame).CornerRadius = UDim.new(0, 10)

local dStatusLabel = Instance.new("TextLabel", dStatusFrame)
dStatusLabel.Size = UDim2.new(1, -16, 1, 0)
dStatusLabel.Position = UDim2.new(0, 8, 0, 0)
dStatusLabel.BackgroundTransparency = 1
dStatusLabel.Text = "✅ SIAP — Pilih lokasi"
dStatusLabel.Font = Enum.Font.GothamBold
dStatusLabel.TextSize = 11
dStatusLabel.TextColor3 = C.green
dStatusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Health bar
local healthBg = Instance.new("Frame", dStatusFrame)
healthBg.Size = UDim2.new(0.7, 0, 0, 6)
healthBg.Position = UDim2.new(0.15, 0, 1, -10)
healthBg.BackgroundColor3 = C.border
healthBg.BorderSizePixel = 0
Instance.new("UICorner", healthBg).CornerRadius = UDim.new(1, 0)

local healthFill = Instance.new("Frame", healthBg)
healthFill.Size = UDim2.new(1, 0, 1, 0)
healthFill.BackgroundColor3 = C.green
healthFill.BorderSizePixel = 0
Instance.new("UICorner", healthFill).CornerRadius = UDim.new(1, 0)

-- Label Lokasi
local locLabelFrame = Instance.new("Frame", dtpContent)
locLabelFrame.Size = UDim2.new(1, 0, 0, 30)
locLabelFrame.BackgroundTransparency = 1
locLabelFrame.LayoutOrder = 3

local locLabel = Instance.new("TextLabel", locLabelFrame)
locLabel.Size = UDim2.new(1, 0, 1, 0)
locLabel.BackgroundTransparency = 1
locLabel.Text = "📍 12 LOKASI TP"
locLabel.Font = Enum.Font.GothamBold
locLabel.TextSize = 12
locLabel.TextColor3 = C.accent
locLabel.TextXAlignment = Enum.TextXAlignment.Left

-- DAFTAR 12 LOKASI
local locations = {
    {name = "01. 🏪 Dealer NPC",    pos = Vector3.new(510.76, 3.59, 600.79)},
    {name = "02. 🍬 MS NPC",        pos = Vector3.new(510.06, 4.48, 600.55)},
    {name = "03. 🏠 Apart 1",       pos = Vector3.new(1137.99, 9.93, 449.75)},
    {name = "04. 🏠 Apart 2",       pos = Vector3.new(1139.17, 9.93, 420.56)},
    {name = "05. 🏠 Apart 3",       pos = Vector3.new(984.86, 9.93, 247.28)},
    {name = "06. 🏠 Apart 4",       pos = Vector3.new(988.31, 9.93, 221.66)},
    {name = "07. 🏠 Apart 5",       pos = Vector3.new(923.95, 9.93, 42.20)},
    {name = "08. 🏠 Apart 6",       pos = Vector3.new(895.72, 9.93, 41.93)},
    {name = "09. 🎰 Casino",        pos = Vector3.new(1166.33, 3.36, -29.77)},
    {name = "10. ⛽ GS UJUNG",      pos = Vector3.new(-466.53, 3.86, 357.66)},
    {name = "11. ⛽ GS MID",        pos = Vector3.new(218.43, 3.74, -176.98)},
    {name = "12. 🚔 Penjara",       pos = Vector3.new(551.35, 3.66, -564.90)},
}

local isBusy = false

local function updateHealth()
    pcall(function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local pct = hum.Health / hum.MaxHealth
            healthFill.Size = UDim2.new(pct, 0, 1, 0)
            if pct > 0.5 then healthFill.BackgroundColor3 = C.green
            elseif pct > 0.2 then healthFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            else healthFill.BackgroundColor3 = C.red end
        end
    end)
end

local function dangerTP(pos, name)
    if isBusy then
        dStatusLabel.Text = "⏳ Tunggu..."
        dStatusLabel.TextColor3 = C.orange
        return
    end
    
    isBusy = true
    dStatusLabel.Text = "💀 Melukai diri..."
    dStatusLabel.TextColor3 = C.red
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not hum then
        dStatusLabel.Text = "❌ Error"
        dStatusLabel.TextColor3 = C.red
        isBusy = false
        return
    end
    
    local targetHealth = hum.MaxHealth * 0.01
    local start = tick()
    
    while hum.Health > targetHealth and tick() - start < 0.4 do
        pcall(function() hum:TakeDamage(math.max(3, hum.MaxHealth * 0.08)) end)
        task.wait(0.005)
    end
    
    if hum.Health <= 0 then pcall(function() hum.Health = 1 end) end
    if hum.Health > targetHealth then pcall(function() hum.Health = targetHealth + 1 end) end
    
    updateHealth()
    dStatusLabel.Text = string.format("💉 %.1f%% → TP", (hum.Health / hum.MaxHealth) * 100)
    dStatusLabel.TextColor3 = C.orange
    
    task.wait(0.1)
    
    dStatusLabel.Text = "🌀 TP ke " .. name
    dStatusLabel.TextColor3 = C.blue
    
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then pcall(function() hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0)) end) end
    
    task.wait(0.05)
    dStatusLabel.Text = "✅ Selesai!"
    dStatusLabel.TextColor3 = C.green
    task.wait(0.5)
    dStatusLabel.Text = "✅ SIAP — Pilih lokasi"
    dStatusLabel.TextColor3 = C.green
    
    isBusy = false
end

-- Buat tombol untuk setiap lokasi
local order = 4
for _, loc in ipairs(locations) do
    local btnFrame = Instance.new("Frame", dtpContent)
    btnFrame.Size = UDim2.new(1, 0, 0, 44)
    btnFrame.BackgroundColor3 = C.card
    btnFrame.LayoutOrder = order
    order = order + 1
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)
    
    local nameLbl = Instance.new("TextLabel", btnFrame)
    nameLbl.Size = UDim2.new(0.6, 0, 1, 0)
    nameLbl.Position = UDim2.new(0, 12, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = loc.name
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 11
    nameLbl.TextColor3 = C.text
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local tpButton = Instance.new("TextButton", btnFrame)
    tpButton.Size = UDim2.new(0, 100, 0, 32)
    tpButton.Position = UDim2.new(1, -112, 0.5, -16)
    tpButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    tpButton.Text = "💀 TP"
    tpButton.Font = Enum.Font.GothamBold
    tpButton.TextSize = 11
    tpButton.TextColor3 = C.text
    Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 6)
    
    local targetPos = loc.pos
    local targetName = loc.name
    
    tpButton.MouseButton1Click:Connect(function()
        dangerTP(targetPos, targetName)
    end)
    
    tpButton.MouseEnter:Connect(function()
        TweenService:Create(tpButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
    end)
    tpButton.MouseLeave:Connect(function()
        TweenService:Create(tpButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(180, 40, 40)}):Play()
    end)
end

-- Warning
local warnFrame = Instance.new("Frame", dtpContent)
warnFrame.Size = UDim2.new(1, 0, 0, 50)
warnFrame.BackgroundColor3 = Color3.fromRGB(20, 8, 8)
warnFrame.LayoutOrder = order
Instance.new("UICorner", warnFrame).CornerRadius = UDim.new(0, 8)

local warnText = Instance.new("TextLabel", warnFrame)
warnText.Size = UDim2.new(1, -16, 1, 0)
warnText.Position = UDim2.new(0, 8, 0, 0)
warnText.BackgroundTransparency = 1
warnText.Text = "⚠️ Peringatan: Anda akan melukai diri!\nGunakan dengan bijak."
warnText.Font = Enum.Font.Gotham
warnText.TextSize = 9
warnText.TextColor3 = Color3.fromRGB(255, 100, 100)
warnText.TextXAlignment = Enum.TextXAlignment.Center
warnText.TextWrapped = true

-- Health updater
task.spawn(function()
    while gui and gui.Parent do
        updateHealth()
        task.wait(0.2)
    end
end)

-- Canvas updater
local function updateCanvas()
    task.wait(0.1)
    local th = 0
    for _, c in ipairs(fullyContent:GetChildren()) do
        if c:IsA("Frame") then th = th + c.Size.Y.Offset + 8 end
    end
    fullyContent.CanvasSize = UDim2.new(0, 0, 0, th + 20)
    
    th = 0
    for _, c in ipairs(dtpContent:GetChildren()) do
        if c:IsA("Frame") then th = th + c.Size.Y.Offset + 8 end
    end
    dtpContent.CanvasSize = UDim2.new(0, 0, 0, th + 20)
end

task.spawn(updateCanvas)

-- Drag
local dragStart, startPos
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = i.Position
        startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragStart and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function() dragStart = nil end)

print("✅ LOADED — Klik tab DANGER TP untuk lihat 12 lokasi!")
