-- ============================================================
-- SCRIPT FULLY NV + DANGER TP (LENGKAP DENGAN 12 LOKASI TP)
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
local buyRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")

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
main.Size = UDim2.new(0, 450, 0, 550)
main.Position = UDim2.new(0.5, -225, 0.5, -275)
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
title.Text = "NV SCRIPT — FULLY + DANGER TP"
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextColor3 = C.text
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

-- Tab buttons
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1, 0, 0, 36)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = C.card

local tabs = {"FULLY NV", "DANGER TP"}
local tabBtns = {}
local contents = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0.5, 0, 1, 0)
    btn.Position = UDim2.new((i-1)*0.5, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = i == 1 and C.accent or C.textDim
    btn.BorderSizePixel = 0
    
    local content = Instance.new("ScrollingFrame", main)
    content.Size = UDim2.new(1, 0, 1, -76)
    content.Position = UDim2.new(0, 0, 0, 76)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 3
    content.Visible = i == 1
    content.CanvasSize = UDim2.new(0, 0, 0, 800)
    
    local pad = Instance.new("UIPadding", content)
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    
    tabBtns[i] = btn
    contents[i] = content
    
    btn.MouseButton1Click:Connect(function()
        for j, cb in pairs(contents) do
            cb.Visible = (j == i)
            tabBtns[j].TextColor3 = (j == i) and C.accent or C.textDim
        end
        -- update canvas size
        task.wait(0.05)
        local totalH = 0
        for _, child in ipairs(content:GetChildren()) do
            if child:IsA("Frame") then
                totalH = totalH + child.Size.Y.Offset + 8
            end
        end
        content.CanvasSize = UDim2.new(0, 0, 0, totalH + 20)
    end)
end

-- ============================================================
-- SECTION FULLY NV (sama seperti sebelumnya, tapi disederhanakan)
-- ============================================================
local fullyContent = contents[1]

-- Header
local header = Instance.new("Frame", fullyContent)
header.Size = UDim2.new(1, 0, 0, 80)
header.BackgroundColor3 = C.card
header.LayoutOrder = 1
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local headerTitle = Instance.new("TextLabel", header)
headerTitle.Size = UDim2.new(1, -16, 0, 20)
headerTitle.Position = UDim2.new(0, 8, 0, 8)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "⚡ FULLY NV — CASINO APART"
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 14
headerTitle.TextColor3 = C.accent

local headerDesc = Instance.new("TextLabel", header)
headerDesc.Size = UDim2.new(1, -16, 0, 50)
headerDesc.Position = UDim2.new(0, 8, 0, 28)
headerDesc.BackgroundTransparency = 1
headerDesc.Text = "Auto masak di Casino Apart | BodyVelocity slow tween\nBlink if stuck | Spam E 3x | Sugar → tunggu gelatin"
headerDesc.Font = Enum.Font.Gotham
headerDesc.TextSize = 9
headerDesc.TextColor3 = C.textDim
headerDesc.TextWrapped = true

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
apartLabel.Font = Enum.Font.GothamSemibold
apartLabel.TextSize = 11
apartLabel.TextColor3 = C.textDim
apartLabel.TextXAlignment = Enum.TextXAlignment.Left

local apartDropdown = Instance.new("TextButton", apartFrame)
apartDropdown.Size = UDim2.new(0, 160, 0, 32)
apartDropdown.Position = UDim2.new(1, -172, 0.5, -16)
apartDropdown.BackgroundColor3 = C.bg
apartDropdown.Text = "Pilih Apart"
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
    dropdownList.Size = UDim2.new(0, 160, 0, #apartOptions * 32)
    dropdownList.Position = UDim2.new(1, -172, 0, apartFrame.AbsolutePosition.Y + 40)
    dropdownList.BackgroundColor3 = C.card
    Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", dropdownList).Color = C.border
    
    for i, opt in ipairs(apartOptions) do
        local optBtn = Instance.new("TextButton", dropdownList)
        optBtn.Size = UDim2.new(1, 0, 0, 32)
        optBtn.Position = UDim2.new(0, 0, 0, (i-1)*32)
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
potLabel.Font = Enum.Font.GothamSemibold
potLabel.TextSize = 11
potLabel.TextColor3 = C.textDim
potLabel.TextXAlignment = Enum.TextXAlignment.Left

local potDropdown = Instance.new("TextButton", potFrame)
potDropdown.Size = UDim2.new(0, 160, 0, 32)
potDropdown.Position = UDim2.new(1, -172, 0.5, -16)
potDropdown.BackgroundColor3 = C.bg
potDropdown.Text = "Pilih POT"
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
    potDropdownList.Size = UDim2.new(0, 160, 0, #potOptions * 32)
    potDropdownList.Position = UDim2.new(1, -172, 0, potFrame.AbsolutePosition.Y + 40)
    potDropdownList.BackgroundColor3 = C.card
    Instance.new("UICorner", potDropdownList).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", potDropdownList).Color = C.border
    
    for i, opt in ipairs(potOptions) do
        local optBtn = Instance.new("TextButton", potDropdownList)
        optBtn.Size = UDim2.new(1, 0, 0, 32)
        optBtn.Position = UDim2.new(0, 0, 0, (i-1)*32)
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
local statusFrame = Instance.new("Frame", fullyContent)
statusFrame.Size = UDim2.new(1, 0, 0, 40)
statusFrame.BackgroundColor3 = C.card
statusFrame.LayoutOrder = 4
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 10)

local statusLabel = Instance.new("TextLabel", statusFrame)
statusLabel.Size = UDim2.new(1, -16, 1, 0)
statusLabel.Position = UDim2.new(0, 8, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Belum dimulai"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextColor3 = C.textDim
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Progress
local progressLabel = Instance.new("TextLabel", fullyContent)
progressLabel.Size = UDim2.new(1, -24, 0, 30)
progressLabel.BackgroundColor3 = C.card
progressLabel.LayoutOrder = 5
progressLabel.Font = Enum.Font.Gotham
progressLabel.TextSize = 10
progressLabel.TextColor3 = C.blue
progressLabel.TextXAlignment = Enum.TextXAlignment.Center
Instance.new("UICorner", progressLabel).CornerRadius = UDim.new(0, 8)

-- Buttons
local btnFrame = Instance.new("Frame", fullyContent)
btnFrame.Size = UDim2.new(1, 0, 0, 90)
btnFrame.BackgroundTransparency = 1
btnFrame.LayoutOrder = 6

local startBtn = Instance.new("TextButton", btnFrame)
startBtn.Size = UDim2.new(0.45, -6, 0, 40)
startBtn.Position = UDim2.new(0, 0, 0, 10)
startBtn.BackgroundColor3 = C.blue
startBtn.Text = "▶ START FULLY NV"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 11
startBtn.TextColor3 = C.text
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", btnFrame)
stopBtn.Size = UDim2.new(0.45, -6, 0, 40)
stopBtn.Position = UDim2.new(0.55, 0, 0, 10)
stopBtn.BackgroundColor3 = C.red
stopBtn.Text = "■ STOP FULLY NV"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 11
stopBtn.TextColor3 = C.text
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)
stopBtn.Visible = false

-- ============================================================
-- KOORDINAT CASINO APART (SEDERHANA)
-- ============================================================
local apartCoords = {
    [1] = { -- APART CASINO 1
        {
            {cf = CFrame.new(1196.51, 3.71, -241.13), name = "Tahap 1"},
            {cf = CFrame.new(1199.75, 3.71, -238.12), name = "Tahap 2"},
            {cf = CFrame.new(1199.74, 6.59, -233.05), name = "Tahap 3"},
            {cf = CFrame.new(1199.66, 6.59, -227.75), name = "Tahap 4"},
            {kanan = CFrame.new(1199.91, 7.56, -219.75), kiri = CFrame.new(1199.75, 7.45, -217.66), name = "Tahap 5"},
            {kanan = CFrame.new(1199.87, 15.96, -215.33), kiri = CFrame.new(1199.38, 15.96, -220.53), name = "Tahap 6"},
        }
    },
    [2] = { -- APART CASINO 2
        {
            {cf = CFrame.new(1186.34, 3.71, -242.92), name = "Tahap 1"},
            {cf = CFrame.new(1183.00, 6.59, -233.78), name = "Tahap 2"},
            {cf = CFrame.new(1182.70, 7.32, -229.73), name = "Tahap 3"},
            {cf = CFrame.new(1182.75, 6.59, -224.78), name = "Tahap 4"},
            {kanan = CFrame.new(1183.43, 15.96, -229.66), kiri = CFrame.new(1183.22, 15.96, -225.63), name = "Tahap 5"},
        }
    },
    [3] = { -- APART CASINO 3
        {
            {cf = CFrame.new(1196.17, 3.71, -205.72), name = "Tahap 1"},
            {cf = CFrame.new(1199.76, 3.71, -196.51), name = "Tahap 2"},
            {cf = CFrame.new(1199.69, 6.59, -191.16), name = "Tahap 3"},
            {cf = CFrame.new(1199.42, 6.59, -185.27), name = "Tahap 4"},
            {kanan = CFrame.new(1199.42, 6.59, -185.27), kiri = CFrame.new(1199.95, 7.07, -177.69), name = "Tahap 5"},
            {kanan = CFrame.new(1199.55, 15.96, -181.89), kiri = CFrame.new(1199.46, 15.96, -177.81), name = "Tahap 6"},
        }
    },
    [4] = { -- APART CASINO 4
        {
            {cf = CFrame.new(1187.70, 3.71, -209.73), name = "Tahap 1"},
            {cf = CFrame.new(1182.27, 3.71, -204.65), name = "Tahap 2"},
            {cf = CFrame.new(1182.23, 3.71, -198.77), name = "Tahap 3"},
            {cf = CFrame.new(1183.06, 6.59, -193.92), name = "Tahap 4"},
            {kanan = CFrame.new(1182.60, 7.56, -191.29), kiri = CFrame.new(1183.36, 6.72, -187.25), name = "Tahap 5"},
            {kanan = CFrame.new(1183.24, 15.96, -191.25), kiri = CFrame.new(1183.08, 15.96, -187.36), name = "Tahap 6"},
        }
    }
}

-- ============================================================
-- BODY VELOCITY TWEEN
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

-- Interaksi
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

local function doCookSequenceForTahap(tahapIndex, targetCF)
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
        statusLabel.Text = "❌ Pilih Apart dan POT dulu!"
        statusLabel.TextColor3 = C.red
        return
    end
    
    nvRunning = true
    nvStopFlag = false
    statusLabel.Text = "⚡ FULLY NV berjalan..."
    statusLabel.TextColor3 = C.blue
    startBtn.Visible = false
    stopBtn.Visible = true
    
    local stages = apartCoords[selectedApart]
    if not stages then
        statusLabel.Text = "❌ Data apart tidak ditemukan"
        startBtn.Visible = true
        stopBtn.Visible = false
        nvRunning = false
        return
    end
    
    for stageIdx, stage in ipairs(stages) do
        if nvStopFlag then break end
        
        local targetCF = nil
        if stage.cf then
            targetCF = stage.cf
        elseif stage.kanan and stage.kiri then
            targetCF = (selectedPot == 1) and stage.kanan or stage.kiri
        end
        
        if not targetCF then
            progressLabel.Text = "❌ Koordinat tidak valid"
            break
        end
        
        progressLabel.Text = string.format("Tahap %d/%d: %s", stageIdx, #stages, stage.name)
        
        local success = doCookSequenceForTahap(stageIdx, targetCF)
        if not success or nvStopFlag then break end
        task.wait(0.3)
    end
    
    if nvStopFlag then
        statusLabel.Text = "⏹ Dihentikan"
        statusLabel.TextColor3 = C.orange
    else
        statusLabel.Text = "✅ FULLY NV selesai!"
        statusLabel.TextColor3 = C.green
        progressLabel.Text = "Semua tahap selesai"
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
    statusLabel.Text = "⏹ Dihentikan"
    statusLabel.TextColor3 = C.orange
end)

-- ============================================================
-- SECTION DANGER TP (12 LOKASI LENGKAP)
-- ============================================================
local dtpContent = contents[2]

-- Header
local dtpHeader = Instance.new("Frame", dtpContent)
dtpHeader.Size = UDim2.new(1, 0, 0, 70)
dtpHeader.BackgroundColor3 = Color3.fromRGB(30, 8, 8)
dtpHeader.LayoutOrder = 1
Instance.new("UICorner", dtpHeader).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", dtpHeader).Color = C.red

local dtpTitle = Instance.new("TextLabel", dtpHeader)
dtpTitle.Size = UDim2.new(1, -16, 0, 24)
dtpTitle.Position = UDim2.new(0, 8, 0, 8)
dtpTitle.BackgroundTransparency = 1
dtpTitle.Text = "⚠️ DANGER TELEPORT ⚠️"
dtpTitle.Font = Enum.Font.GothamBold
dtpTitle.TextSize = 14
dtpTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
dtpTitle.TextXAlignment = Enum.TextXAlignment.Center

local dtpDesc = Instance.new("TextLabel", dtpHeader)
dtpDesc.Size = UDim2.new(1, -16, 0, 35)
dtpDesc.Position = UDim2.new(0, 8, 0, 32)
dtpDesc.BackgroundTransparency = 1
dtpDesc.Text = "Lukai diri hingga 1% health (5ms interval) → cooldown 100ms → TP instan"
dtpDesc.Font = Enum.Font.Gotham
dtpDesc.TextSize = 9
dtpDesc.TextColor3 = C.textDim
dtpDesc.TextXAlignment = Enum.TextXAlignment.Center
dtpDesc.TextWrapped = true

-- Status
local dtpStatusFrame = Instance.new("Frame", dtpContent)
dtpStatusFrame.Size = UDim2.new(1, 0, 0, 40)
dtpStatusFrame.BackgroundColor3 = C.card
dtpStatusFrame.LayoutOrder = 2
Instance.new("UICorner", dtpStatusFrame).CornerRadius = UDim.new(0, 10)

local dtpStatusLabel = Instance.new("TextLabel", dtpStatusFrame)
dtpStatusLabel.Size = UDim2.new(1, -16, 1, 0)
dtpStatusLabel.Position = UDim2.new(0, 8, 0, 0)
dtpStatusLabel.BackgroundTransparency = 1
dtpStatusLabel.Text = "✅ SIAP — Pilih lokasi di bawah"
dtpStatusLabel.Font = Enum.Font.GothamBold
dtpStatusLabel.TextSize = 11
dtpStatusLabel.TextColor3 = C.green
dtpStatusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Health bar
local healthBarBg = Instance.new("Frame", dtpStatusFrame)
healthBarBg.Size = UDim2.new(0.7, 0, 0, 6)
healthBarBg.Position = UDim2.new(0.15, 0, 1, -10)
healthBarBg.BackgroundColor3 = C.border
healthBarBg.BorderSizePixel = 0
Instance.new("UICorner", healthBarBg).CornerRadius = UDim.new(1, 0)

local healthBarFill = Instance.new("Frame", healthBarBg)
healthBarFill.Size = UDim2.new(1, 0, 1, 0)
healthBarFill.BackgroundColor3 = C.green
healthBarFill.BorderSizePixel = 0
Instance.new("UICorner", healthBarFill).CornerRadius = UDim.new(1, 0)

-- Label lokasi
local locLabelFrame = Instance.new("Frame", dtpContent)
locLabelFrame.Size = UDim2.new(1, 0, 0, 30)
locLabelFrame.BackgroundTransparency = 1
locLabelFrame.LayoutOrder = 3

local locLabel = Instance.new("TextLabel", locLabelFrame)
locLabel.Size = UDim2.new(1, 0, 1, 0)
locLabel.BackgroundTransparency = 1
locLabel.Text = "📍 PILIH LOKASI TP (12 TUJUAN)"
locLabel.Font = Enum.Font.GothamBold
locLabel.TextSize = 11
locLabel.TextColor3 = C.accent
locLabel.TextXAlignment = Enum.TextXAlignment.Left

-- DAFTAR 12 LOKASI LENGKAP
local dangerLocations = {
    {name = "🏪 01. Dealer NPC",        pos = Vector3.new(510.76, 3.59, 600.79)},
    {name = "🍬 02. MS NPC",            pos = Vector3.new(510.06, 4.48, 600.55)},
    {name = "🏠 03. Apart 1",           pos = Vector3.new(1137.99, 9.93, 449.75)},
    {name = "🏠 04. Apart 2",           pos = Vector3.new(1139.17, 9.93, 420.56)},
    {name = "🏠 05. Apart 3",           pos = Vector3.new(984.86, 9.93, 247.28)},
    {name = "🏠 06. Apart 4",           pos = Vector3.new(988.31, 9.93, 221.66)},
    {name = "🏠 07. Apart 5",           pos = Vector3.new(923.95, 9.93, 42.20)},
    {name = "🏠 08. Apart 6",           pos = Vector3.new(895.72, 9.93, 41.93)},
    {name = "🎰 09. Casino",            pos = Vector3.new(1166.33, 3.36, -29.77)},
    {name = "⛽ 10. GS UJUNG",          pos = Vector3.new(-466.53, 3.86, 357.66)},
    {name = "⛽ 11. GS MID",            pos = Vector3.new(218.43, 3.74, -176.98)},
    {name = "🚔 12. Penjara",           pos = Vector3.new(551.35, 3.66, -564.90)},
}

local isDangerTPBusy = false

local function updateHealthBar()
    pcall(function()
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            local percent = hum.Health / hum.MaxHealth
            healthBarFill.Size = UDim2.new(percent, 0, 1, 0)
            if percent > 0.5 then
                healthBarFill.BackgroundColor3 = C.green
            elseif percent > 0.2 then
                healthBarFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            else
                healthBarFill.BackgroundColor3 = C.red
            end
        end
    end)
end

local function dangerTeleport(targetPos, targetName)
    if isDangerTPBusy then
        dtpStatusLabel.Text = "⏳ Masih proses, tunggu..."
        dtpStatusLabel.TextColor3 = C.orange
        return
    end
    
    isDangerTPBusy = true
    dtpStatusLabel.Text = "💀 Melukai diri (damage 5ms)..."
    dtpStatusLabel.TextColor3 = C.red
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not hum then
        dtpStatusLabel.Text = "❌ Karakter tidak ditemukan!"
        dtpStatusLabel.TextColor3 = C.red
        isDangerTPBusy = false
        return
    end
    
    local maxHealth = hum.MaxHealth
    local targetHealth = maxHealth * 0.01
    
    local damagePerHit = math.max(3, maxHealth * 0.08)
    local startTime = tick()
    
    while hum.Health > targetHealth and tick() - startTime < 0.4 do
        pcall(function() hum:TakeDamage(damagePerHit) end)
        task.wait(0.005)
    end
    
    if hum.Health > targetHealth then
        pcall(function() hum.Health = targetHealth + 1 end)
    end
    
    if hum.Health <= 0 then
        pcall(function() hum.Health = 1 end)
    end
    
    updateHealthBar()
    dtpStatusLabel.Text = string.format("💉 Health: %.1f%% → TP dalam 100ms", (hum.Health / maxHealth) * 100)
    dtpStatusLabel.TextColor3 = C.orange
    
    task.wait(0.1)
    
    dtpStatusLabel.Text = "🌀 Teleport ke " .. targetName .. "..."
    dtpStatusLabel.TextColor3 = C.blue
    
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function() hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0)) end)
    end
    
    task.wait(0.05)
    dtpStatusLabel.Text = "✅ Selesai!"
    dtpStatusLabel.TextColor3 = C.green
    task.wait(0.5)
    dtpStatusLabel.Text = "✅ SIAP — Pilih lokasi di bawah"
    dtpStatusLabel.TextColor3 = C.green
    
    isDangerTPBusy = false
end

-- Buat tombol untuk setiap lokasi
local btnOrder = 4
for _, loc in ipairs(dangerLocations) do
    local btnFrame = Instance.new("Frame", dtpContent)
    btnFrame.Size = UDim2.new(1, 0, 0, 42)
    btnFrame.BackgroundColor3 = C.card
    btnFrame.LayoutOrder = btnOrder
    btnOrder = btnOrder + 1
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)
    
    local nameLbl = Instance.new("TextLabel", btnFrame)
    nameLbl.Size = UDim2.new(0.6, 0, 1, 0)
    nameLbl.Position = UDim2.new(0, 12, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = loc.name
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextSize = 11
    nameLbl.TextColor3 = C.text
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local tpBtn = Instance.new("TextButton", btnFrame)
    tpBtn.Size = UDim2.new(0, 110, 0, 30)
    tpBtn.Position = UDim2.new(1, -122, 0.5, -15)
    tpBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    tpBtn.Text = "💀 DANGER TP"
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 10
    tpBtn.TextColor3 = C.text
    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
    
    local targetPos = loc.pos
    local targetName = loc.name
    
    tpBtn.MouseButton1Click:Connect(function()
        dangerTeleport(targetPos, targetName)
    end)
    
    tpBtn.MouseEnter:Connect(function()
        TweenService:Create(tpBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
    end)
    tpBtn.MouseLeave:Connect(function()
        TweenService:Create(tpBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(180, 40, 40)}):Play()
    end)
end

-- Warning footer
local warnFrame = Instance.new("Frame", dtpContent)
warnFrame.Size = UDim2.new(1, 0, 0, 50)
warnFrame.BackgroundColor3 = Color3.fromRGB(20, 8, 8)
warnFrame.LayoutOrder = btnOrder
Instance.new("UICorner", warnFrame).CornerRadius = UDim.new(0, 8)

local warnText = Instance.new("TextLabel", warnFrame)
warnText.Size = UDim2.new(1, -16, 1, 0)
warnText.Position = UDim2.new(0, 8, 0, 0)
warnText.BackgroundTransparency = 1
warnText.Text = "⚠️ PERINGATAN: Anda akan melukai diri sendiri!\nRisiko mati jika koneksi lag. Gunakan dengan bijak."
warnText.Font = Enum.Font.Gotham
warnText.TextSize = 9
warnText.TextColor3 = Color3.fromRGB(255, 100, 100)
warnText.TextXAlignment = Enum.TextXAlignment.Center
warnText.TextWrapped = true

-- Update health bar periodically
task.spawn(function()
    while gui and gui.Parent do
        updateHealthBar()
        task.wait(0.2)
    end
end)

-- Update canvas size when content changes
local function updateCanvas(content)
    task.wait(0.1)
    local totalH = 0
    for _, child in ipairs(content:GetChildren()) do
        if child:IsA("Frame") and child.Visible then
            totalH = totalH + child.Size.Y.Offset + 8
        end
    end
    content.CanvasSize = UDim2.new(0, 0, 0, totalH + 20)
end

updateCanvas(fullyContent)
updateCanvas(dtpContent)

-- Drag handler
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragStart and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = nil
    end
end)

print("✅ NV SCRIPT LOADED — Fully NV + Danger TP dengan 12 Lokasi")
