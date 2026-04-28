-- FULLY NV STANDALONE (PASTI JALAN, GUI SEDERHANA)
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

-- ========== VARIABEL ==========
local fullyRunning = false
local selectedApart = nil
local selectedPot = nil
local targetMS = 5
local totalCooked = 0
local totalSold = 0
local basePlate = nil

-- Koordinat
local NPC_BUY = Vector3.new(510.061, 4.476, 600.548)
local NPC_SELL = Vector3.new(510.061, 4.476, 600.548)
local APART_POS = {
    ["APART CASINO 1"] = Vector3.new(1137.992, 9.932, 449.753),
    ["APART CASINO 2"] = Vector3.new(1139.174, 9.932, 420.556),
    ["APART CASINO 3"] = Vector3.new(984.856, 9.932, 247.280),
    ["APART CASINO 4"] = Vector3.new(988.311, 9.932, 221.664),
}

-- Koordinat masak (hanya contoh untuk Apart 1, lengkap nanti)
local coords = {
    ["APART CASINO 1"] = {
        CFrame.new(1196.51, 3.71, -241.13),
        CFrame.new(1199.75, 3.71, -238.12),
        CFrame.new(1199.74, 6.59, -233.05),
        CFrame.new(1199.66, 6.59, -227.75),
    },
}

-- ========== FUNGSI DASAR ==========
local function equip(name)
    local char = player.Character
    local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
    if tool then char.Humanoid:EquipTool(tool) task.wait(.3) return true end
end

local function countItem(name)
    local total = 0
    for _, v in pairs(player.Backpack:GetChildren()) do if v.Name == name then total = total + 1 end end
    for _, v in pairs(player.Character:GetChildren()) do if v:IsA("Tool") and v.Name == name then total = total + 1 end end
    return total
end

local function spamE(times)
    times = times or 10
    for i = 1, times do
        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        task.wait(0.05)
    end
end

-- ========== TELEPORT BLINK ==========
local function blinkTo(targetPos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local maxDist = 5
    while fullyRunning and (hrp.Position - targetPos).Magnitude > maxDist do
        local dir = (targetPos - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position + dir * maxDist)
        task.wait(1)
        char = player.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then break end
    end
    if hrp then hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0)) end
end

-- ========== TELEPORT DENGAN BASEPLATE ==========
local function teleportWithPlate(targetPos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Turun 5 studs
    hrp.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 5, hrp.Position.Z)
    task.wait(0.5)
    blinkTo(targetPos)
end

-- ========== BASEPLATE ==========
local function createBasePlate()
    if basePlate then basePlate:Destroy() end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local plate = Instance.new("Part")
    plate.Size = Vector3.new(1000, 1, 1000)
    plate.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 5, hrp.Position.Z)
    plate.Anchored = true
    plate.CanCollide = true
    plate.Material = Enum.Material.Neon
    plate.Color = Color3.fromRGB(255, 0, 0)
    plate.Name = "FullyNV_BasePlate"
    plate.Parent = workspace
    basePlate = plate
    print("✅ Baseplate dibuat")
end

-- ========== MASAK DI APART ==========
local function cookAtApart()
    local c = coords[selectedApart]
    if not c then return false end
    
    for _, cf in ipairs(c) do
        if not fullyRunning then return false end
        if statusLabel then statusLabel.Text = "→ Tahap" end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tween = TweenService:Create(hrp, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = cf})
            tween:Play()
            tween.Completed:Wait()
        end
        spamE(10)
        task.wait(0.5)
    end
    
    if statusLabel then statusLabel.Text = "💧 Water 20s..." end
    equip("Water")
    spamE(10)
    task.wait(20)
    if not fullyRunning then return false end
    
    if statusLabel then statusLabel.Text = "🧂 Sugar..." end
    equip("Sugar Block Bag")
    spamE(10)
    task.wait(1)
    
    if statusLabel then statusLabel.Text = "🟡 Gelatin..." end
    equip("Gelatin")
    spamE(10)
    task.wait(1)
    
    if statusLabel then statusLabel.Text = "🔥 Cooking 45s..." end
    task.wait(45)
    if not fullyRunning then return false end
    
    if statusLabel then statusLabel.Text = "🎒 Take..." end
    equip("Empty Bag")
    spamE(10)
    task.wait(1.5)
    
    totalCooked = totalCooked + 1
    return true
end

-- ========== BELI & JUAL ==========
local function buyIngredients(amount)
    if statusLabel then statusLabel.Text = "🛒 Beli " .. amount .. " set" end
    for i = 1, amount do
        if not fullyRunning then return false end
        pcall(function()
            buyRemote:FireServer("Water", 1) task.wait(0.4)
            buyRemote:FireServer("Sugar Block Bag", 1) task.wait(0.4)
            buyRemote:FireServer("Gelatin", 1) task.wait(0.4)
            buyRemote:FireServer("Empty Bag", 1) task.wait(0.5)
        end)
    end
    return true
end

local function sellAll()
    if statusLabel then statusLabel.Text = "💰 Menjual..." end
    local bags = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
    for _, bag in pairs(bags) do
        while fullyRunning and countItem(bag) > 0 do
            if equip(bag) then spamE(10) task.wait(0.8) totalSold = totalSold + 1 else break end
        end
    end
    return true
end

-- ========== LOOP UTAMA ==========
local function mainLoop()
    while fullyRunning do
        if statusLabel then statusLabel.Text = "🚀 Ke NPC Beli" end
        teleportWithPlate(NPC_BUY)
        if not buyIngredients(targetMS) then break end
        
        if statusLabel then statusLabel.Text = "🚀 Ke " .. selectedApart end
        teleportWithPlate(APART_POS[selectedApart])
        
        for i = 1, targetMS do
            if not fullyRunning then break end
            if statusLabel then statusLabel.Text = "🔥 Masak " .. i .. "/" .. targetMS end
            if not cookAtApart() then break end
        end
        
        if statusLabel then statusLabel.Text = "🚀 Ke NPC Jual" end
        teleportWithPlate(NPC_SELL)
        if not sellAll() then break end
        
        if statusLabel then statusLabel.Text = "🔄 Loop selesai" end
        task.wait(1)
    end
    fullyRunning = false
    if statusLabel then statusLabel.Text = "⏹️ STOP" end
    if startBtn then startBtn.Visible = true end
    if stopBtn then stopBtn.Visible = false end
end

-- ========== GUI SEDERHANA (PASTI MUNCUL) ==========
local gui = Instance.new("ScreenGui")
gui.Name = "FullyNV"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 380, 0, 450)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(130, 60, 240)
Instance.new("UIStroke", mainFrame).Thickness = 1

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "FULLY NV"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(220, 215, 245)
title.TextXAlignment = Enum.TextXAlignment.Center

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -33, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
    fullyRunning = false
    gui:Destroy()
end)

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, 0, 1, -35)
scroll.Position = UDim2.new(0, 0, 0, 35)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3
scroll.CanvasSize = UDim2.new(0, 0, 0, 400)

local pad = Instance.new("UIPadding", scroll)
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingRight = UDim.new(0, 12)
pad.PaddingTop = UDim.new(0, 10)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Pilih Apart
local apartFrame = Instance.new("Frame", scroll)
apartFrame.Size = UDim2.new(1, 0, 0, 70)
apartFrame.BackgroundColor3 = Color3.fromRGB(35, 33, 50)
Instance.new("UICorner", apartFrame).CornerRadius = UDim.new(0, 8)

local apartL = Instance.new("TextLabel", apartFrame)
apartL.Size = UDim2.new(1, 0, 0, 22)
apartL.Position = UDim2.new(0, 8, 0, 5)
apartL.BackgroundTransparency = 1
apartL.Text = "Pilih Apart:"
apartL.Font = Enum.Font.GothamBold
apartL.TextSize = 12
apartL.TextColor3 = Color3.fromRGB(220, 215, 245)
apartL.TextXAlignment = Enum.TextXAlignment.Left

local apartDrop = Instance.new("TextButton", apartFrame)
apartDrop.Size = UDim2.new(0.9, 0, 0, 30)
apartDrop.Position = UDim2.new(0.05, 0, 0, 32)
apartDrop.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
apartDrop.Text = "Pilih Apart"
apartDrop.TextColor3 = Color3.fromRGB(255, 255, 255)
apartDrop.Font = Enum.Font.GothamBold
apartDrop.TextSize = 12
Instance.new("UICorner", apartDrop).CornerRadius = UDim.new(0, 6)

local apartNames = {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}
apartDrop.MouseButton1Click:Connect(function()
    local menu = Instance.new("Frame", scroll)
    menu.Size = UDim2.new(0.8, 0, 0, 120)
    menu.Position = UDim2.new(0.1, 0, 0, 100)
    menu.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
    Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
    for i, name in ipairs(apartNames) do
        local btn = Instance.new("TextButton", menu)
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
        btn.BackgroundTransparency = 1
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(220, 215, 245)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.MouseButton1Click:Connect(function()
            selectedApart = name
            apartDrop.Text = name
            menu:Destroy()
        end)
    end
    task.delay(5, function() pcall(function() menu:Destroy() end) end)
end)

-- Pilih Pot
local potFrame = Instance.new("Frame", scroll)
potFrame.Size = UDim2.new(1, 0, 0, 70)
potFrame.BackgroundColor3 = Color3.fromRGB(35, 33, 50)
Instance.new("UICorner", potFrame).CornerRadius = UDim.new(0, 8)

local potL = Instance.new("TextLabel", potFrame)
potL.Size = UDim2.new(1, 0, 0, 22)
potL.Position = UDim2.new(0, 8, 0, 5)
potL.BackgroundTransparency = 1
potL.Text = "Pilih Pot:"
potL.Font = Enum.Font.GothamBold
potL.TextSize = 12
potL.TextColor3 = Color3.fromRGB(220, 215, 245)
potL.TextXAlignment = Enum.TextXAlignment.Left

local kananBtn = Instance.new("TextButton", potFrame)
kananBtn.Size = UDim2.new(0.4, -5, 0, 30)
kananBtn.Position = UDim2.new(0.05, 0, 0, 32)
kananBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
kananBtn.Text = "KANAN"
kananBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
kananBtn.Font = Enum.Font.GothamBold
kananBtn.TextSize = 12
Instance.new("UICorner", kananBtn).CornerRadius = UDim.new(0, 6)

local kiriBtn = Instance.new("TextButton", potFrame)
kiriBtn.Size = UDim2.new(0.4, -5, 0, 30)
kiriBtn.Position = UDim2.new(0.55, 0, 0, 32)
kiriBtn.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
kiriBtn.Text = "KIRI"
kiriBtn.TextColor3 = Color3.fromRGB(220, 215, 245)
kiriBtn.Font = Enum.Font.GothamBold
kiriBtn.TextSize = 12
Instance.new("UICorner", kiriBtn).CornerRadius = UDim.new(0, 6)

kananBtn.MouseButton1Click:Connect(function()
    selectedPot = "KANAN"
    kananBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
    kiriBtn.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
    kananBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    kiriBtn.TextColor3 = Color3.fromRGB(220, 215, 245)
end)
kiriBtn.MouseButton1Click:Connect(function()
    selectedPot = "KIRI"
    kiriBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
    kananBtn.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
    kiriBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    kananBtn.TextColor3 = Color3.fromRGB(220, 215, 245)
end)

-- Slider Jumlah
local sliderFrame = Instance.new("Frame", scroll)
sliderFrame.Size = UDim2.new(1, 0, 0, 50)
sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 33, 50)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)

local sliderL = Instance.new("TextLabel", sliderFrame)
sliderL.Size = UDim2.new(0.7, 0, 0, 20)
sliderL.Position = UDim2.new(0, 8, 0, 5)
sliderL.BackgroundTransparency = 1
sliderL.Text = "Target MS per Loop:"
sliderL.Font = Enum.Font.Gotham
sliderL.TextSize = 11
sliderL.TextColor3 = Color3.fromRGB(220, 215, 245)
sliderL.TextXAlignment = Enum.TextXAlignment.Left

local sliderVal = Instance.new("TextLabel", sliderFrame)
sliderVal.Size = UDim2.new(0, 50, 0, 25)
sliderVal.Position = UDim2.new(0.8, 0, 0, 22)
sliderVal.BackgroundTransparency = 1
sliderVal.Text = "5"
sliderVal.Font = Enum.Font.GothamBold
sliderVal.TextSize = 14
sliderVal.TextColor3 = Color3.fromRGB(100, 190, 255)
sliderVal.TextXAlignment = Enum.TextXAlignment.Right

local minusBtn = Instance.new("TextButton", sliderFrame)
minusBtn.Size = UDim2.new(0, 30, 0, 30)
minusBtn.Position = UDim2.new(0.65, 0, 0, 18)
minusBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 16
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.BorderSizePixel = 0
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)

local plusBtn = Instance.new("TextButton", sliderFrame)
plusBtn.Size = UDim2.new(0, 30, 0, 30)
plusBtn.Position = UDim2.new(0.85, 0, 0, 18)
plusBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 16
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.BorderSizePixel = 0
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)

local currentVal = 5
minusBtn.MouseButton1Click:Connect(function()
    currentVal = math.max(1, currentVal - 1)
    sliderVal.Text = tostring(currentVal)
    targetMS = currentVal
end)
plusBtn.MouseButton1Click:Connect(function()
    currentVal = math.min(50, currentVal + 1)
    sliderVal.Text = tostring(currentVal)
    targetMS = currentVal
end)

-- Status
local statusFrame = Instance.new("Frame", scroll)
statusFrame.Size = UDim2.new(1, 0, 0, 45)
statusFrame.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 8)

local statusLabel = Instance.new("TextLabel", statusFrame)
statusLabel.Size = UDim2.new(1, -10, 1, 0)
statusLabel.Position = UDim2.new(0, 5, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Belum dimulai"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextColor3 = Color3.fromRGB(150, 140, 180)
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Statistik
local statFrame = Instance.new("Frame", scroll)
statFrame.Size = UDim2.new(1, 0, 0, 65)
statFrame.BackgroundColor3 = Color3.fromRGB(35, 33, 50)
Instance.new("UICorner", statFrame).CornerRadius = UDim.new(0, 8)

local cookedL = Instance.new("TextLabel", statFrame)
cookedL.Size = UDim2.new(0.6, 0, 0, 25)
cookedL.Position = UDim2.new(0, 8, 0, 5)
cookedL.BackgroundTransparency = 1
cookedL.Text = "Total Dimasak:"
cookedL.Font = Enum.Font.Gotham
cookedL.TextSize = 11
cookedL.TextColor3 = Color3.fromRGB(150, 140, 180)
cookedL.TextXAlignment = Enum.TextXAlignment.Left

local cookedV = Instance.new("TextLabel", statFrame)
cookedV.Size = UDim2.new(0.4, 0, 0, 25)
cookedV.Position = UDim2.new(0.6, 0, 0, 5)
cookedV.BackgroundTransparency = 1
cookedV.Text = "0"
cookedV.Font = Enum.Font.GothamBold
cookedV.TextSize = 14
cookedV.TextColor3 = Color3.fromRGB(100, 190, 255)
cookedV.TextXAlignment = Enum.TextXAlignment.Right

local soldL = Instance.new("TextLabel", statFrame)
soldL.Size = UDim2.new(0.6, 0, 0, 25)
soldL.Position = UDim2.new(0, 8, 0, 35)
soldL.BackgroundTransparency = 1
soldL.Text = "Total Terjual:"
soldL.Font = Enum.Font.Gotham
soldL.TextSize = 11
soldL.TextColor3 = Color3.fromRGB(150, 140, 180)
soldL.TextXAlignment = Enum.TextXAlignment.Left

local soldV = Instance.new("TextLabel", statFrame)
soldV.Size = UDim2.new(0.4, 0, 0, 25)
soldV.Position = UDim2.new(0.6, 0, 0, 35)
soldV.BackgroundTransparency = 1
soldV.Text = "0"
soldV.Font = Enum.Font.GothamBold
soldV.TextSize = 14
soldV.TextColor3 = Color3.fromRGB(52, 210, 110)
soldV.TextXAlignment = Enum.TextXAlignment.Right

-- Tombol Start/Stop
local btnFrame = Instance.new("Frame", scroll)
btnFrame.Size = UDim2.new(1, 0, 0, 45)
btnFrame.BackgroundTransparency = 1

local startBtn = Instance.new("TextButton", btnFrame)
startBtn.Size = UDim2.new(0.8, 0, 0, 36)
startBtn.Position = UDim2.new(0.1, 0, 0, 5)
startBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
startBtn.Text = "▶ START FULLY NV"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", btnFrame)
stopBtn.Size = UDim2.new(0.8, 0, 0, 36)
stopBtn.Position = UDim2.new(0.1, 0, 0, 5)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 50)
stopBtn.Text = "■ STOP FULLY NV"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)
stopBtn.Visible = false

startBtn.MouseButton1Click:Connect(function()
    if fullyRunning then return end
    if not selectedApart then statusLabel.Text = "❌ Pilih apart!" statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80) return end
    if not selectedPot then statusLabel.Text = "❌ Pilih pot!" statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80) return end
    
    createBasePlate()
    fullyRunning = true
    startBtn.Visible = false
    stopBtn.Visible = true
    statusLabel.Text = "✅ START"
    statusLabel.TextColor3 = Color3.fromRGB(100, 190, 255)
    task.spawn(mainLoop)
end)

stopBtn.MouseButton1Click:Connect(function()
    fullyRunning = false
    startBtn.Visible = true
    stopBtn.Visible = false
    statusLabel.Text = "⏹️ STOP"
    statusLabel.TextColor3 = Color3.fromRGB(255, 160, 40)
end)

-- Update statistik
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            cookedV.Text = tostring(totalCooked)
            soldV.Text = tostring(totalSold)
        end)
    end
end)

print("✅ FULLY NV READY. Pilih apart & pot, lalu START.")
