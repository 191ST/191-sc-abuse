-- FULLY NV STANDALONE (FINAL) - PASTI JALAN, GUI MUNCUL
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

-- ========== FUNGSI DASAR ==========
local function equip(name)
    local char = player.Character
    local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
    if tool then
        char.Humanoid:EquipTool(tool)
        task.wait(0.3)
        return true
    end
    return false
end

local function countItem(name)
    local total = 0
    for _, v in pairs(player.Backpack:GetChildren()) do
        if v.Name == name then total = total + 1 end
    end
    for _, v in pairs(player.Character:GetChildren()) do
        if v:IsA("Tool") and v.Name == name then total = total + 1 end
    end
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
    task.wait(0.3)
end

-- ========== KOORDINAT ==========
local NPC_BUY = Vector3.new(510.061, 4.476, 600.548)
local NPC_SELL = Vector3.new(510.061, 4.476, 600.548)
local APART_POS = {
    ["APART CASINO 1"] = Vector3.new(1137.992, 9.932, 449.753),
    ["APART CASINO 2"] = Vector3.new(1139.174, 9.932, 420.556),
    ["APART CASINO 3"] = Vector3.new(984.856, 9.932, 247.280),
    ["APART CASINO 4"] = Vector3.new(988.311, 9.932, 221.664),
}

local apartCoords = {
    ["APART CASINO 1"] = {
        CFrame.new(1196.51, 3.71, -241.13) * CFrame.Angles(-0.00, -0.05, 0.00),
        CFrame.new(1199.75, 3.71, -238.12) * CFrame.Angles(-0.00, -0.05, -0.00),
        CFrame.new(1199.74, 6.59, -233.05) * CFrame.Angles(-0.00, 0.00, -0.00),
        CFrame.new(1199.66, 6.59, -227.75) * CFrame.Angles(0.00, -0.00, 0.00),
        {kanan = CFrame.new(1199.66, 6.59, -227.75) * CFrame.Angles(0.00, -0.00, 0.00), kiri = CFrame.new(1199.95, 7.07, -177.69) * CFrame.Angles(-0.00, 0.01, 0.00)},
        {kanan = CFrame.new(1199.55, 15.96, -181.89) * CFrame.Angles(0.00, -0.09, 0.00), kiri = CFrame.new(1199.46, 15.96, -177.81) * CFrame.Angles(-0.00, -0.05, -0.00)},
        CFrame.new(1199.87, 15.96, -215.33) * CFrame.Angles(0.00, 0.05, 0.00),
    },
    ["APART CASINO 2"] = {
        CFrame.new(1186.34, 3.71, -242.92) * CFrame.Angles(0.00, -0.06, 0.00),
        CFrame.new(1183.00, 6.59, -233.78) * CFrame.Angles(-0.00, 0.00, 0.00),
        CFrame.new(1182.70, 7.32, -229.73) * CFrame.Angles(-0.00, -0.01, 0.00),
        CFrame.new(1182.75, 6.59, -224.78) * CFrame.Angles(-0.00, -0.01, 0.00),
        {kanan = CFrame.new(1183.43, 15.96, -229.66) * CFrame.Angles(0.00, 0.02, -0.00), kiri = CFrame.new(1183.22, 15.96, -225.63) * CFrame.Angles(0.00, -0.04, -0.00)},
    },
    ["APART CASINO 3"] = {
        CFrame.new(1196.17, 3.71, -205.72) * CFrame.Angles(0.00, -0.03, -0.00),
        CFrame.new(1199.76, 3.71, -196.51) * CFrame.Angles(0.00, -0.04, 0.00),
        CFrame.new(1199.69, 6.59, -191.16) * CFrame.Angles(-0.00, -0.06, -0.00),
        CFrame.new(1199.42, 6.59, -185.27) * CFrame.Angles(-0.00, 0.01, 0.00),
        {kanan = CFrame.new(1199.42, 6.59, -185.27) * CFrame.Angles(-0.00, 0.01, 0.00), kiri = CFrame.new(1199.95, 7.07, -177.69) * CFrame.Angles(-0.00, 0.01, 0.00)},
        {kanan = CFrame.new(1199.55, 15.96, -181.89) * CFrame.Angles(0.00, -0.09, 0.00), kiri = CFrame.new(1199.46, 15.96, -177.81) * CFrame.Angles(-0.00, -0.05, -0.00)},
    },
    ["APART CASINO 4"] = {
        CFrame.new(1187.70, 3.71, -209.73) * CFrame.Angles(0.00, -0.03, 0.00),
        CFrame.new(1182.27, 3.71, -204.65) * CFrame.Angles(-0.00, 0.09, -0.00),
        CFrame.new(1182.23, 3.71, -198.77) * CFrame.Angles(0.00, -0.04, -0.00),
        CFrame.new(1183.06, 6.59, -193.92) * CFrame.Angles(0.00, 0.08, -0.00),
        {kanan = CFrame.new(1182.60, 7.56, -191.29) * CFrame.Angles(-0.00, -0.02, -0.00), kiri = CFrame.new(1183.36, 6.72, -187.25) * CFrame.Angles(-0.00, -0.04, -0.00)},
        {kanan = CFrame.new(1183.24, 15.96, -191.25) * CFrame.Angles(-0.00, -0.01, 0.00), kiri = CFrame.new(1183.08, 15.96, -187.36) * CFrame.Angles(-0.00, -0.05, -0.00)},
    },
}

-- ========== TELEPORT BLINK (5 studs, cooldown 1 detik) ==========
local function blinkTo(targetPos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    while running and (hrp.Position - targetPos).Magnitude > 5 do
        local dir = (targetPos - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position + dir * 5)
        task.wait(1)
        char = player.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then break end
    end
    if hrp then hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0)) end
    return true
end

-- ========== TWEEN UNTUK APART (slow tween 2 detik) ==========
local function tweenTo(targetCFrame)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tween = TweenService:Create(hrp, TweenInfo.new(2.0, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
    if hrp and (hrp.Position - targetCFrame.Position).Magnitude > 3 then
        hrp.CFrame = targetCFrame
    end
end

-- ========== PROSES MASAK DI APART ==========
local function cookAtApartment()
    local coords = apartCoords[selectedApart]
    if not coords then return false end
    for i, stage in ipairs(coords) do
        if not running then return false end
        if statusLabel then statusLabel.Text = "→ Tahap " .. i end
        if type(stage) == "table" then
            tweenTo(selectedPot == "KANAN" and stage.kanan or stage.kiri)
        else
            tweenTo(stage)
        end
        spamE(10)
        task.wait(0.5)
    end
    if statusLabel then statusLabel.Text = "💧 Water (20 detik)..." end
    equip("Water")
    spamE(10)
    task.wait(20)
    if not running then return false end
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
    if not running then return false end
    if statusLabel then statusLabel.Text = "🎒 Take Marshmallow..." end
    equip("Empty Bag")
    spamE(10)
    task.wait(1.5)
    totalCooked = totalCooked + 1
    return true
end

-- ========== BELI BAHAN ==========
local function buyIngredients(amount)
    if statusLabel then statusLabel.Text = "🛒 Membeli " .. amount .. " set..." end
    for i = 1, amount do
        if not running then return false end
        pcall(function()
            buyRemote:FireServer("Water", 1)
            task.wait(0.4)
            buyRemote:FireServer("Sugar Block Bag", 1)
            task.wait(0.4)
            buyRemote:FireServer("Gelatin", 1)
            task.wait(0.4)
            buyRemote:FireServer("Empty Bag", 1)
            task.wait(0.5)
        end)
    end
    return true
end

-- ========== JUAL SEMUA MASSHROM ==========
local function sellAllMS()
    if statusLabel then statusLabel.Text = "💰 Menjual..." end
    local sold = 0
    local bags = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
    for _, bag in pairs(bags) do
        while running and countItem(bag) > 0 do
            if equip(bag) then
                spamE(10)
                task.wait(0.8)
                sold = sold + 1
                totalSold = totalSold + 1
            else
                break
            end
        end
    end
    return true
end

-- ========== LOOP UTAMA ==========
local running = false
local selectedApart = nil
local selectedPot = nil
local targetMS = 5
local totalCooked = 0
local totalSold = 0
local statusLabel = nil
local startBtn = nil
local stopBtn = nil

local function mainLoop()
    while running do
        if statusLabel then statusLabel.Text = "🚀 Ke NPC Beli..." end
        if not blinkTo(NPC_BUY) then break end
        if not buyIngredients(targetMS) then break end
        
        if statusLabel then statusLabel.Text = "🚀 Ke " .. selectedApart .. "..." end
        if not blinkTo(APART_POS[selectedApart]) then break end
        
        for i = 1, targetMS do
            if not running then break end
            if statusLabel then statusLabel.Text = "🔥 Masak " .. i .. "/" .. targetMS end
            if not cookAtApartment() then break end
        end
        
        if statusLabel then statusLabel.Text = "🚀 Ke NPC Jual..." end
        if not blinkTo(NPC_SELL) then break end
        if not sellAllMS() then break end
        
        if statusLabel then statusLabel.Text = "🔄 Loop selesai, ulang..." end
        task.wait(1)
    end
    running = false
    if statusLabel then statusLabel.Text = "⏹️ FULLY NV STOP" end
    if startBtn then startBtn.Visible = true end
    if stopBtn then stopBtn.Visible = false end
end

-- ========== GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "FULLY_NV"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 420, 0, 500)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "FULLY NV - AUTO APART CASINO"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    running = false
    gui:Destroy()
end)

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, 0, 1, -40)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3
scroll.CanvasSize = UDim2.new(0, 0, 0, 520)

local pad = Instance.new("UIPadding", scroll)
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingRight = UDim.new(0, 12)
pad.PaddingTop = UDim.new(0, 12)
pad.PaddingBottom = UDim.new(0, 12)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ========== PILIH APART ==========
local apartFrame = Instance.new("Frame", scroll)
apartFrame.Size = UDim2.new(1, 0, 0, 80)
apartFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
Instance.new("UICorner", apartFrame).CornerRadius = UDim.new(0, 8)

local apartLabel = Instance.new("TextLabel", apartFrame)
apartLabel.Size = UDim2.new(1, 0, 0, 25)
apartLabel.Position = UDim2.new(0, 8, 0, 5)
apartLabel.BackgroundTransparency = 1
apartLabel.Text = "Pilih Apart Casino:"
apartLabel.Font = Enum.Font.GothamBold
apartLabel.TextSize = 12
apartLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local apartDropdown = Instance.new("TextButton", apartFrame)
apartDropdown.Size = UDim2.new(0.8, 0, 0, 35)
apartDropdown.Position = UDim2.new(0.1, 0, 0, 35)
apartDropdown.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
apartDropdown.Text = "Pilih Apart"
apartDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
apartDropdown.Font = Enum.Font.GothamBold
apartDropdown.TextSize = 12
Instance.new("UICorner", apartDropdown).CornerRadius = UDim.new(0, 6)

local apartList = {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}
apartDropdown.MouseButton1Click:Connect(function()
    local menu = Instance.new("Frame", scroll)
    menu.Size = UDim2.new(0.8, 0, 0, 120)
    menu.Position = UDim2.new(0.1, 0, 0, 120)
    menu.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
    for i, name in ipairs(apartList) do
        local btn = Instance.new("TextButton", menu)
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
        btn.BackgroundTransparency = 1
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.MouseButton1Click:Connect(function()
            selectedApart = name
            apartDropdown.Text = name
            menu:Destroy()
        end)
    end
    task.delay(5, function() pcall(function() menu:Destroy() end) end)
end)

-- ========== PILIH POT ==========
local potFrame = Instance.new("Frame", scroll)
potFrame.Size = UDim2.new(1, 0, 0, 80)
potFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
Instance.new("UICorner", potFrame).CornerRadius = UDim.new(0, 8)

local potLabel = Instance.new("TextLabel", potFrame)
potLabel.Size = UDim2.new(1, 0, 0, 25)
potLabel.Position = UDim2.new(0, 8, 0, 5)
potLabel.BackgroundTransparency = 1
potLabel.Text = "Pilih Pot:"
potLabel.Font = Enum.Font.GothamBold
potLabel.TextSize = 12
potLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local potKanan = Instance.new("TextButton", potFrame)
potKanan.Size = UDim2.new(0.4, -5, 0, 35)
potKanan.Position = UDim2.new(0.05, 0, 0, 35)
potKanan.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
potKanan.Text = "KANAN"
potKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
potKanan.Font = Enum.Font.GothamBold
potKanan.TextSize = 12
Instance.new("UICorner", potKanan).CornerRadius = UDim.new(0, 6)

local potKiri = Instance.new("TextButton", potFrame)
potKiri.Size = UDim2.new(0.4, -5, 0, 35)
potKiri.Position = UDim2.new(0.55, 0, 0, 35)
potKiri.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
potKiri.Text = "KIRI"
potKiri.TextColor3 = Color3.fromRGB(255, 255, 255)
potKiri.Font = Enum.Font.GothamBold
potKiri.TextSize = 12
Instance.new("UICorner", potKiri).CornerRadius = UDim.new(0, 6)

potKanan.MouseButton1Click:Connect(function()
    selectedPot = "KANAN"
    TweenService:Create(potKanan, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(48, 88, 200)}):Play()
    TweenService:Create(potKiri, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 45)}):Play()
    potKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
    potKiri.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

potKiri.MouseButton1Click:Connect(function()
    selectedPot = "KIRI"
    TweenService:Create(potKiri, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(48, 88, 200)}):Play()
    TweenService:Create(potKanan, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 45)}):Play()
    potKiri.TextColor3 = Color3.fromRGB(255, 255, 255)
    potKanan.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- ========== SLIDER JUMLAH MS ==========
local sliderFrame = Instance.new("Frame", scroll)
sliderFrame.Size = UDim2.new(1, 0, 0, 60)
sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)

local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(1, 0, 0, 25)
sliderLabel.Position = UDim2.new(0, 8, 0, 5)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Target MS per Loop:"
sliderLabel.Font = Enum.Font.GothamBold
sliderLabel.TextSize = 12
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local targetVal = Instance.new("TextLabel", sliderFrame)
targetVal.Size = UDim2.new(0, 50, 0, 30)
targetVal.Position = UDim2.new(0.5, -25, 0.5, 0)
targetVal.BackgroundTransparency = 1
targetVal.Text = "5"
targetVal.Font = Enum.Font.GothamBold
targetVal.TextSize = 16
targetVal.TextColor3 = Color3.fromRGB(100, 190, 255)

local minusBtn = Instance.new("TextButton", sliderFrame)
minusBtn.Size = UDim2.new(0, 35, 0, 35)
minusBtn.Position = UDim2.new(0.5, -95, 0.5, 0)
minusBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)

local plusBtn = Instance.new("TextButton", sliderFrame)
plusBtn.Size = UDim2.new(0, 35, 0, 35)
plusBtn.Position = UDim2.new(0.5, 60, 0.5, 0)
plusBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)

local currentTarget = 5
minusBtn.MouseButton1Click:Connect(function()
    currentTarget = math.max(1, currentTarget - 1)
    targetVal.Text = tostring(currentTarget)
    targetMS = currentTarget
end)
plusBtn.MouseButton1Click:Connect(function()
    currentTarget = math.min(50, currentTarget + 1)
    targetVal.Text = tostring(currentTarget)
    targetMS = currentTarget
end)

-- ========== STATUS ==========
local statusFrame = Instance.new("Frame", scroll)
statusFrame.Size = UDim2.new(1, 0, 0, 50)
statusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 8)

statusLabel = Instance.new("TextLabel", statusFrame)
statusLabel.Size = UDim2.new(1, -16, 1, 0)
statusLabel.Position = UDim2.new(0, 8, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Belum dimulai"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ========== STATISTIK ==========
local statFrame = Instance.new("Frame", scroll)
statFrame.Size = UDim2.new(1, 0, 0, 60)
statFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
Instance.new("UICorner", statFrame).CornerRadius = UDim.new(0, 8)

local cookedLabel = Instance.new("TextLabel", statFrame)
cookedLabel.Size = UDim2.new(0.5, 0, 0, 25)
cookedLabel.Position = UDim2.new(0, 12, 0, 5)
cookedLabel.BackgroundTransparency = 1
cookedLabel.Text = "Total Dimasak:"
cookedLabel.Font = Enum.Font.GothamBold
cookedLabel.TextSize = 12
cookedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

local cookedValue = Instance.new("TextLabel", statFrame)
cookedValue.Size = UDim2.new(0.4, 0, 0, 25)
cookedValue.Position = UDim2.new(0.6, 0, 0, 5)
cookedValue.BackgroundTransparency = 1
cookedValue.Text = "0"
cookedValue.Font = Enum.Font.GothamBold
cookedValue.TextSize = 16
cookedValue.TextColor3 = Color3.fromRGB(100, 190, 255)

local soldLabel = Instance.new("TextLabel", statFrame)
soldLabel.Size = UDim2.new(0.5, 0, 0, 25)
soldLabel.Position = UDim2.new(0, 12, 0, 30)
soldLabel.BackgroundTransparency = 1
soldLabel.Text = "Total Terjual:"
soldLabel.Font = Enum.Font.GothamBold
soldLabel.TextSize = 12
soldLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

local soldValue = Instance.new("TextLabel", statFrame)
soldValue.Size = UDim2.new(0.4, 0, 0, 25)
soldValue.Position = UDim2.new(0.6, 0, 0, 30)
soldValue.BackgroundTransparency = 1
soldValue.Text = "0"
soldValue.Font = Enum.Font.GothamBold
soldValue.TextSize = 16
soldValue.TextColor3 = Color3.fromRGB(100, 190, 255)

-- ========== TOMBOL START/STOP ==========
local btnFrame = Instance.new("Frame", scroll)
btnFrame.Size = UDim2.new(1, 0, 0, 50)
btnFrame.BackgroundTransparency = 1

startBtn = Instance.new("TextButton", btnFrame)
startBtn.Size = UDim2.new(0.8, 0, 0, 36)
startBtn.Position = UDim2.new(0.1, 0, 0, 5)
startBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
startBtn.Text = "▶ START FULLY NV"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

stopBtn = Instance.new("TextButton", btnFrame)
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
    if running then return end
    if not selectedApart then
        statusLabel.Text = "❌ Pilih apart casino dulu!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    if not selectedPot then
        statusLabel.Text = "❌ Pilih pot (KANAN/KIRI) dulu!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    running = true
    startBtn.Visible = false
    stopBtn.Visible = true
    statusLabel.Text = "✅ FULLY NV START"
    statusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
    task.spawn(mainLoop)
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    startBtn.Visible = true
    stopBtn.Visible = false
    statusLabel.Text = "⏹️ FULLY NV STOP"
    statusLabel.TextColor3 = Color3.fromRGB(255, 160, 40)
end)

-- Update statistik loop
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            cookedValue.Text = tostring(totalCooked)
            soldValue.Text = tostring(totalSold)
        end)
    end
end)

-- Drag system
do
    local drag = false
    local startPos = nil
    local startMouse = nil
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            startPos = mainFrame.Position
            startMouse = i.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - startMouse
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
end

print("[FULLY NV] GUI LOADED! Pilih apart dan pot, lalu klik START.")
