-- FULLY NV (GUI SENDIRI - PASTI JALAN)
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

-- ========== VARIABEL ==========
local fullyRunning = false
local selectedApart = nil
local selectedPot = "KANAN"
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

-- Koordinat masak
local apartCoords = {
    ["APART CASINO 1"] = {
        CFrame.new(1196.51, 3.71, -241.13) * CFrame.Angles(-0.00, -0.05, 0.00),
        CFrame.new(1199.75, 3.71, -238.12) * CFrame.Angles(-0.00, -0.05, -0.00),
        CFrame.new(1199.74, 6.59, -233.05) * CFrame.Angles(-0.00, 0.00, -0.00),
        CFrame.new(1199.66, 6.59, -227.75) * CFrame.Angles(0.00, -0.00, 0.00),
        {kiri = CFrame.new(1199.95, 7.07, -177.69) * CFrame.Angles(-0.00, 0.01, 0.00), kanan = CFrame.new(1199.66, 6.59, -227.75) * CFrame.Angles(0.00, -0.00, 0.00)},
        {kiri = CFrame.new(1199.46, 15.96, -177.81) * CFrame.Angles(-0.00, -0.05, -0.00), kanan = CFrame.new(1199.55, 15.96, -181.89) * CFrame.Angles(0.00, -0.09, 0.00)},
        CFrame.new(1199.87, 15.96, -215.33) * CFrame.Angles(0.00, 0.05, 0.00),
    },
    ["APART CASINO 2"] = {
        CFrame.new(1186.34, 3.71, -242.92) * CFrame.Angles(0.00, -0.06, 0.00),
        CFrame.new(1183.00, 6.59, -233.78) * CFrame.Angles(-0.00, 0.00, 0.00),
        CFrame.new(1182.70, 7.32, -229.73) * CFrame.Angles(-0.00, -0.01, 0.00),
        CFrame.new(1182.75, 6.59, -224.78) * CFrame.Angles(-0.00, -0.01, 0.00),
        {kiri = CFrame.new(1183.22, 15.96, -225.63) * CFrame.Angles(0.00, -0.04, -0.00), kanan = CFrame.new(1183.43, 15.96, -229.66) * CFrame.Angles(0.00, 0.02, -0.00)},
    },
    ["APART CASINO 3"] = {
        CFrame.new(1196.17, 3.71, -205.72) * CFrame.Angles(0.00, -0.03, -0.00),
        CFrame.new(1199.76, 3.71, -196.51) * CFrame.Angles(0.00, -0.04, 0.00),
        CFrame.new(1199.69, 6.59, -191.16) * CFrame.Angles(-0.00, -0.06, -0.00),
        CFrame.new(1199.42, 6.59, -185.27) * CFrame.Angles(-0.00, 0.01, 0.00),
        {kiri = CFrame.new(1199.95, 7.07, -177.69) * CFrame.Angles(-0.00, 0.01, 0.00), kanan = CFrame.new(1199.42, 6.59, -185.27) * CFrame.Angles(-0.00, 0.01, 0.00)},
        {kiri = CFrame.new(1199.46, 15.96, -177.81) * CFrame.Angles(-0.00, -0.05, -0.00), kanan = CFrame.new(1199.55, 15.96, -181.89) * CFrame.Angles(0.00, -0.09, 0.00)},
    },
    ["APART CASINO 4"] = {
        CFrame.new(1187.70, 3.71, -209.73) * CFrame.Angles(0.00, -0.03, 0.00),
        CFrame.new(1182.27, 3.71, -204.65) * CFrame.Angles(-0.00, 0.09, -0.00),
        CFrame.new(1182.23, 3.71, -198.77) * CFrame.Angles(0.00, -0.04, -0.00),
        CFrame.new(1183.06, 6.59, -193.92) * CFrame.Angles(0.00, 0.08, -0.00),
        {kiri = CFrame.new(1183.36, 6.72, -187.25) * CFrame.Angles(-0.00, -0.04, -0.00), kanan = CFrame.new(1182.60, 7.56, -191.29) * CFrame.Angles(-0.00, -0.02, -0.00)},
        {kiri = CFrame.new(1183.08, 15.96, -187.36) * CFrame.Angles(-0.00, -0.05, -0.00), kanan = CFrame.new(1183.24, 15.96, -191.25) * CFrame.Angles(-0.00, -0.01, 0.00)},
    },
}

-- ========== FUNGSI DASAR ==========
local function equip(name)
    local char = player.Character
    local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
    if tool then
        char.Humanoid:EquipTool(tool)
        task.wait(.3)
        return true
    end
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

local function teleportWithPlate(targetPos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 5, hrp.Position.Z)
    task.wait(0.5)
    blinkTo(targetPos)
end

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
end

local function cookAtApartment()
    local coords = apartCoords[selectedApart]
    if not coords then return false end
    
    for _, stage in ipairs(coords) do
        if not fullyRunning then return false end
        
        local targetCF = nil
        if type(stage) == "table" then
            targetCF = (selectedPot == "KANAN") and stage.kanan or stage.kiri
        else
            targetCF = stage
        end
        
        if targetCF then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local tween = TweenService:Create(hrp, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = targetCF})
                tween:Play()
                tween.Completed:Wait()
            end
            spamE(10)
            task.wait(0.5)
        end
    end
    
    if statusLabel then statusLabel.Text = "💧 Water 20 detik..." end
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
    
    if statusLabel then statusLabel.Text = "🔥 Cooking 45 detik..." end
    task.wait(45)
    if not fullyRunning then return false end
    
    if statusLabel then statusLabel.Text = "🎒 Take..." end
    equip("Empty Bag")
    spamE(10)
    task.wait(1.5)
    
    totalCooked = totalCooked + 1
    return true
end

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
            if not cookAtApartment() then break end
        end
        
        if statusLabel then statusLabel.Text = "🚀 Ke NPC Jual" end
        teleportWithPlate(NPC_SELL)
        if not sellAll() then break end
        
        if statusLabel then statusLabel.Text = "🔄 Loop selesai" end
        task.wait(1)
    end
    fullyRunning = false
    if statusLabel then statusLabel.Text = "⏹️ STOPPED" end
end

-- ========== GUI SENDIRI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "FullyNV"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 380, 0, 480)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(130, 60, 240)
Instance.new("UIStroke", mainFrame).Thickness = 1

-- Title bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 33, 50)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "FULLY NV - AUTO APART CASINO"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(220, 215, 245)
title.TextXAlignment = Enum.TextXAlignment.Center

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
    fullyRunning = false
    gui:Destroy()
end)

-- Scroll
local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, 0, 1, -40)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3
scroll.CanvasSize = UDim2.new(0, 0, 0, 460)

local pad = Instance.new("UIPadding", scroll)
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingRight = UDim.new(0, 12)
pad.PaddingTop = UDim.new(0, 10)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ===== Pilih Apart =====
local apartFrame = Instance.new("Frame", scroll)
apartFrame.Size = UDim2.new(1, 0, 0, 70)
apartFrame.BackgroundColor3 = Color3.fromRGB(35, 33, 50)
Instance.new("UICorner", apartFrame).CornerRadius = UDim.new(0, 8)

local apartLabel = Instance.new("TextLabel", apartFrame)
apartLabel.Size = UDim2.new(1, 0, 0, 25)
apartLabel.Position = UDim2.new(0, 8, 0, 5)
apartLabel.BackgroundTransparency = 1
apartLabel.Text = "Pilih Apart Casino:"
apartLabel.Font = Enum.Font.GothamBold
apartLabel.TextSize = 12
apartLabel.TextColor3 = Color3.fromRGB(220, 215, 245)
apartLabel.TextXAlignment = Enum.TextXAlignment.Left

local apartValue = Instance.new("TextLabel", apartFrame)
apartValue.Size = UDim2.new(0.8, 0, 0, 30)
apartValue.Position = UDim2.new(0.1, 0, 0, 32)
apartValue.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
apartValue.Text = "Pilih Apart"
apartValue.TextColor3 = Color3.fromRGB(255, 255, 255)
apartValue.Font = Enum.Font.GothamBold
apartValue.TextSize = 12
apartValue.TextXAlignment = Enum.TextXAlignment.Center
Instance.new("UICorner", apartValue).CornerRadius = UDim.new(0, 6)

local apartNames = {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}
local apartMenuVisible = false
local apartMenu = nil

apartValue.MouseButton1Click:Connect(function()
    if apartMenu then apartMenu:Destroy() apartMenu = nil return end
    apartMenu = Instance.new("Frame", scroll)
    apartMenu.Size = UDim2.new(0.8, 0, 0, 120)
    apartMenu.Position = UDim2.new(0.1, 0, 0, 110)
    apartMenu.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
    Instance.new("UICorner", apartMenu).CornerRadius = UDim.new(0, 8)
    for i, name in ipairs(apartNames) do
        local btn = Instance.new("TextButton", apartMenu)
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
        btn.BackgroundTransparency = 1
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(220, 215, 245)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.MouseButton1Click:Connect(function()
            selectedApart = name
            apartValue.Text = name
            apartMenu:Destroy()
            apartMenu = nil
        end)
    end
    task.delay(5, function() if apartMenu then apartMenu:Destroy() apartMenu = nil end end)
end)

-- ===== Pilih Pot =====
local potFrame = Instance.new("Frame", scroll)
potFrame.Size = UDim2.new(1, 0, 0, 70)
potFrame.BackgroundColor3 = Color3.fromRGB(35, 33, 50)
Instance.new("UICorner", potFrame).CornerRadius = UDim.new(0, 8)

local potLabel = Instance.new("TextLabel", potFrame)
potLabel.Size = UDim2.new(1, 0, 0, 25)
potLabel.Position = UDim2.new(0, 8, 0, 5)
potLabel.BackgroundTransparency = 1
potLabel.Text = "Pilih Pot:"
potLabel.Font = Enum.Font.GothamBold
potLabel.TextSize = 12
potLabel.TextColor3 = Color3.fromRGB(220, 215, 245)
potLabel.TextXAlignment = Enum.TextXAlignment.Left

local potKanan = Instance.new("TextButton", potFrame)
potKanan.Size = UDim2.new(0.4, -5, 0, 32)
potKanan.Position = UDim2.new(0.05, 0, 0, 32)
potKanan.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
potKanan.Text = "KANAN"
potKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
potKanan.Font = Enum.Font.GothamBold
potKanan.TextSize = 12
Instance.new("UICorner", potKanan).CornerRadius = UDim.new(0, 6)

local potKiri = Instance.new("TextButton", potFrame)
potKiri.Size = UDim2.new(0.4, -5, 0, 32)
potKiri.Position = UDim2.new(0.55, 0, 0, 32)
potKiri.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
potKiri.Text = "KIRI"
potKiri.TextColor3 = Color3.fromRGB(220, 215, 245)
potKiri.Font = Enum.Font.GothamBold
potKiri.TextSize = 12
Instance.new("UICorner", potKiri).CornerRadius = UDim.new(0, 6)

potKanan.MouseButton1Click:Connect(function()
    selectedPot = "KANAN"
    potKanan.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
    potKiri.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
    potKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
    potKiri.TextColor3 = Color3.fromRGB(220, 215, 245)
end)
potKiri.MouseButton1Click:Connect(function()
    selectedPot = "KIRI"
    potKiri.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
    potKanan.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
    potKiri.TextColor3 = Color3.fromRGB(255, 255, 255)
    potKanan.TextColor3 = Color3.fromRGB(220, 215, 245)
end)

-- ===== Slider Jumlah MS =====
local sliderFrame = Instance.new("Frame", scroll)
sliderFrame.Size = UDim2.new(1, 0, 0, 60)
sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 33, 50)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)

local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(0.7, 0, 0, 25)
sliderLabel.Position = UDim2.new(0, 8, 0, 5)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Target MS per Loop:"
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 11
sliderLabel.TextColor3 = Color3.fromRGB(220, 215, 245)
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

local sliderVal = Instance.new("TextLabel", sliderFrame)
sliderVal.Size = UDim2.new(0, 50, 0, 30)
sliderVal.Position = UDim2.new(0.8, 0, 0, 26)
sliderVal.BackgroundTransparency = 1
sliderVal.Text = "5"
sliderVal.Font = Enum.Font.GothamBold
sliderVal.TextSize = 16
sliderVal.TextColor3 = Color3.fromRGB(100, 190, 255)
sliderVal.TextXAlignment = Enum.TextXAlignment.Center

local minusBtn = Instance.new("TextButton", sliderFrame)
minusBtn.Size = UDim2.new(0, 35, 0, 30)
minusBtn.Position = UDim2.new(0.65, 0, 0, 26)
minusBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 16
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.BorderSizePixel = 0
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)

local plusBtn = Instance.new("TextButton", sliderFrame)
plusBtn.Size = UDim2.new(0, 35, 0, 30)
plusBtn.Position = UDim2.new(0.85, 0, 0, 26)
plusBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 16
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.BorderSizePixel = 0
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)

minusBtn.MouseButton1Click:Connect(function()
    targetMS = math.max(1, targetMS - 1)
    sliderVal.Text = tostring(targetMS)
end)
plusBtn.MouseButton1Click:Connect(function()
    targetMS = math.min(50, targetMS + 1)
    sliderVal.Text = tostring(targetMS)
end)

-- ===== Status =====
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

-- ===== Statistik =====
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

-- ===== Tombol Start/Stop =====
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
    if not selectedApart then
        statusLabel.Text = "❌ Pilih apart casino dulu!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    if not selectedPot then
        statusLabel.Text = "❌ Pilih pot dulu!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    createBasePlate()
    fullyRunning = true
    statusLabel.Text = "✅ RUNNING"
    statusLabel.TextColor3 = Color3.fromRGB(100, 190, 255)
    startBtn.Visible = false
    stopBtn.Visible = true
    task.spawn(mainLoop)
end)

stopBtn.MouseButton1Click:Connect(function()
    fullyRunning = false
    statusLabel.Text = "⏹️ STOPPED"
    statusLabel.TextColor3 = Color3.fromRGB(255, 160, 40)
    startBtn.Visible = true
    stopBtn.Visible = false
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

print("✅ FULLY NV GUI LOADED! Tekan RightShift untuk buka menu (jika perlu drag)")
print("✅ Pilih apart, pilih pot, atur target MS, klik START")
