-- FULLY NV FINAL (DETECT RAGDOLL → TP → TUNGGU 10 DETIK → INTERACT)
local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

-- ========== UTILITY ==========
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

-- ========== RAGDOLL TELEPORT (turunkan health, detect ragdoll, langsung TP, lalu tunggu 10 detik) ==========
local function ragdollTeleport(targetPos)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    -- Turunkan health ke 3% (biarkan game yang membuat ragdoll)
    hum.Health = 3
    task.wait(0.2)

    -- Tunggu sampai karakter benar-benar dalam state Ragdoll
    local ragdollDetected = false
    for _ = 1, 50 do -- max 5 detik
        char = player.Character
        hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState() == Enum.HumanoidStateType.Ragdoll then
            ragdollDetected = true
            break
        end
        task.wait(0.1)
    end

    if not ragdollDetected then
        if statusLabel then statusLabel.Text = "⚠️ Gagal detect ragdoll, tetap lanjut..." end
    end

    -- Segera teleport setelah ragdoll terdeteksi
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
    end

    -- Tunggu 10 detik setelah ragdoll (recovery time)
    for i = 10, 1, -1 do
        if not fullyRunning then return false end
        if statusLabel then statusLabel.Text = "Tunggu " .. i .. " detik setelah ragdoll..." end
        task.wait(1)
    end

    return true
end

-- ========== TWEEN + BLINK ==========
local function tweenTo(targetCFrame, duration)
    duration = duration or 2.0
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
    return true
end

local function moveWithBlink(targetCFrame)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    tweenTo(targetCFrame, 2.0)
    task.wait(0.3)
    if hrp and (hrp.Position - targetCFrame.Position).Magnitude > 3 then
        hrp.CFrame = targetCFrame
        task.wait(0.2)
    end
    return true
end

-- ========== KOORDINAT LENGKAP (DENGAN PILIHAN KANAN/KIRI) ==========
local apartCoords = {
    ["APART CASINO 1"] = {
        tahap1 = CFrame.new(1196.51, 3.71, -241.13) * CFrame.Angles(-0.00, -0.05, 0.00),
        tahap2 = CFrame.new(1199.75, 3.71, -238.12) * CFrame.Angles(-0.00, -0.05, -0.00),
        tahap3 = CFrame.new(1199.74, 6.59, -233.05) * CFrame.Angles(-0.00, 0.00, -0.00),
        tahap4 = CFrame.new(1199.66, 6.59, -227.75) * CFrame.Angles(0.00, -0.00, 0.00),
        tahap5_kanan = CFrame.new(1199.66, 6.59, -227.75) * CFrame.Angles(0.00, -0.00, 0.00),
        tahap5_kiri  = CFrame.new(1199.95, 7.07, -177.69) * CFrame.Angles(-0.00, 0.01, 0.00),
        tahap6_kanan = CFrame.new(1199.55, 15.96, -181.89) * CFrame.Angles(0.00, -0.09, 0.00),
        tahap6_kiri  = CFrame.new(1199.46, 15.96, -177.81) * CFrame.Angles(-0.00, -0.05, -0.00),
        tahap7 = CFrame.new(1199.87, 15.96, -215.33) * CFrame.Angles(0.00, 0.05, 0.00),
    },
    ["APART CASINO 2"] = {
        tahap1 = CFrame.new(1186.34, 3.71, -242.92) * CFrame.Angles(0.00, -0.06, 0.00),
        tahap2 = CFrame.new(1183.00, 6.59, -233.78) * CFrame.Angles(-0.00, 0.00, 0.00),
        tahap3 = CFrame.new(1182.70, 7.32, -229.73) * CFrame.Angles(-0.00, -0.01, 0.00),
        tahap4 = CFrame.new(1182.75, 6.59, -224.78) * CFrame.Angles(-0.00, -0.01, 0.00),
        tahap5_kanan = CFrame.new(1183.43, 15.96, -229.66) * CFrame.Angles(0.00, 0.02, -0.00),
        tahap5_kiri  = CFrame.new(1183.22, 15.96, -225.63) * CFrame.Angles(0.00, -0.04, -0.00),
    },
    ["APART CASINO 3"] = {
        tahap1 = CFrame.new(1196.17, 3.71, -205.72) * CFrame.Angles(0.00, -0.03, -0.00),
        tahap2 = CFrame.new(1199.76, 3.71, -196.51) * CFrame.Angles(0.00, -0.04, 0.00),
        tahap3 = CFrame.new(1199.69, 6.59, -191.16) * CFrame.Angles(-0.00, -0.06, -0.00),
        tahap4 = CFrame.new(1199.42, 6.59, -185.27) * CFrame.Angles(-0.00, 0.01, 0.00),
        tahap5_kanan = CFrame.new(1199.42, 6.59, -185.27) * CFrame.Angles(-0.00, 0.01, 0.00),
        tahap5_kiri  = CFrame.new(1199.95, 7.07, -177.69) * CFrame.Angles(-0.00, 0.01, 0.00),
        tahap6_kanan = CFrame.new(1199.55, 15.96, -181.89) * CFrame.Angles(0.00, -0.09, 0.00),
        tahap6_kiri  = CFrame.new(1199.46, 15.96, -177.81) * CFrame.Angles(-0.00, -0.05, -0.00),
    },
    ["APART CASINO 4"] = {
        tahap1 = CFrame.new(1187.70, 3.71, -209.73) * CFrame.Angles(0.00, -0.03, 0.00),
        tahap2 = CFrame.new(1182.27, 3.71, -204.65) * CFrame.Angles(-0.00, 0.09, -0.00),
        tahap3 = CFrame.new(1182.23, 3.71, -198.77) * CFrame.Angles(0.00, -0.04, -0.00),
        tahap4 = CFrame.new(1183.06, 6.59, -193.92) * CFrame.Angles(0.00, 0.08, -0.00),
        tahap5_kanan = CFrame.new(1182.60, 7.56, -191.29) * CFrame.Angles(-0.00, -0.02, -0.00),
        tahap5_kiri  = CFrame.new(1183.36, 6.72, -187.25) * CFrame.Angles(-0.00, -0.04, -0.00),
        tahap6_kanan = CFrame.new(1183.24, 15.96, -191.25) * CFrame.Angles(-0.00, -0.01, 0.00),
        tahap6_kiri  = CFrame.new(1183.08, 15.96, -187.36) * CFrame.Angles(-0.00, -0.05, -0.00),
    },
}

-- ========== POSISI NPC DAN APART ==========
local NPC_BUY_POS = Vector3.new(510.061, 4.476, 600.548)
local NPC_SELL_POS = Vector3.new(510.061, 4.476, 600.548)
local APART_ENTRY_POS = {
    ["APART CASINO 1"] = Vector3.new(1137.992, 9.932, 449.753),
    ["APART CASINO 2"] = Vector3.new(1139.174, 9.932, 420.556),
    ["APART CASINO 3"] = Vector3.new(984.856, 9.932, 247.280),
    ["APART CASINO 4"] = Vector3.new(988.311, 9.932, 221.664),
}

-- ========== PROSES MASAK DI APART ==========
local function cookAtApartment(selectedApart, selectedPot)
    local coords = apartCoords[selectedApart]
    if not coords then return false end

    local tahap5 = (selectedPot == "KANAN") and coords.tahap5_kanan or coords.tahap5_kiri
    local tahap6 = (selectedPot == "KANAN") and coords.tahap6_kanan or coords.tahap6_kiri

    local stages = {
        {name = "Tahap 1", cf = coords.tahap1},
        {name = "Tahap 2", cf = coords.tahap2},
        {name = "Tahap 3", cf = coords.tahap3},
        {name = "Tahap 4", cf = coords.tahap4},
        {name = "Tahap 5", cf = tahap5},
        {name = "Tahap 6", cf = tahap6},
    }
    if coords.tahap7 then
        table.insert(stages, {name = "Tahap 7", cf = coords.tahap7})
    end

    -- Gerak ke setiap tahap pakai TWEEN + BLINK
    for _, stage in ipairs(stages) do
        if not fullyRunning then return false end
        if statusLabel then statusLabel.Text = "→ " .. stage.name end
        moveWithBlink(stage.cf)
        spamE(10) -- spam 10 kali agar pasti interact
        task.wait(0.5)
    end

    -- Proses memasak
    if statusLabel then statusLabel.Text = "💧 Memasak Water (20 detik)..." end
    equip("Water")
    spamE(10)
    task.wait(20)
    if not fullyRunning then return false end

    if statusLabel then statusLabel.Text = "🧂 Memasak Sugar (1 detik)..." end
    equip("Sugar Block Bag")
    spamE(10)
    task.wait(1)

    if statusLabel then statusLabel.Text = "🟡 Memasak Gelatin (1 detik)..." end
    equip("Gelatin")
    spamE(10)
    task.wait(1)

    if statusLabel then statusLabel.Text = "🔥 Memasak (45 detik)..." end
    task.wait(45)
    if not fullyRunning then return false end

    if statusLabel then statusLabel.Text = "🎒 Mengambil Marshmallow..." end
    equip("Empty Bag")
    spamE(10)
    task.wait(1.5)

    return true
end

-- ========== BELI BAHAN ==========
local function buyIngredients(amount)
    if statusLabel then statusLabel.Text = "🛒 Membeli " .. amount .. " set bahan..." end
    for i = 1, amount do
        if not fullyRunning then return false end
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
    if statusLabel then statusLabel.Text = "✅ Selesai beli " .. amount .. " set" end
    return true
end

-- ========== JUAL SEMUA MARSHMALLOW ==========
local function sellAllMS()
    if statusLabel then statusLabel.Text = "💰 Menjual Marshmallow..." end
    local sold = 0
    local bags = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
    for _, bag in pairs(bags) do
        while fullyRunning and countItem(bag) > 0 do
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
    if statusLabel then statusLabel.Text = "✅ Terjual " .. sold .. " Marshmallow" end
    return true
end

-- ========== LOOP UTAMA ==========
local fullyRunning = false
local selectedApart = nil
local selectedPot = nil
local buyAmount = 5
local totalCooked = 0
local totalSold = 0
local statusLabel = nil
local startBtn = nil
local stopBtn = nil

local function fullyNVLoop()
    while fullyRunning do
        -- 1. Ragdoll teleport ke NPC beli
        if statusLabel then statusLabel.Text = "🚀 Teleport ke NPC Beli (ragdoll)..." end
        if not ragdollTeleport(NPC_BUY_POS) then break end

        -- 2. Beli bahan sesuai jumlah
        if not buyIngredients(buyAmount) then break end

        -- 3. Ragdoll teleport ke apart casino
        local apartPos = APART_ENTRY_POS[selectedApart]
        if statusLabel then statusLabel.Text = "🚀 Teleport ke " .. selectedApart .. " (ragdoll)..." end
        if not ragdollTeleport(apartPos) then break end

        -- 4. Masak sebanyak buyAmount kali
        for i = 1, buyAmount do
            if not fullyRunning then break end
            if statusLabel then statusLabel.Text = "🔥 Memasak batch " .. i .. "/" .. buyAmount end
            if cookAtApartment(selectedApart, selectedPot) then
                totalCooked = totalCooked + 1
            else
                break
            end
        end

        -- 5. Ragdoll teleport ke NPC jual
        if statusLabel then statusLabel.Text = "🚀 Teleport ke NPC Jual (ragdoll)..." end
        if not ragdollTeleport(NPC_SELL_POS) then break end

        -- 6. Jual semua Marshmallow
        if not sellAllMS() then break end

        if statusLabel then statusLabel.Text = "🔄 Loop selesai, mengulang..." end
        task.wait(1)
    end
    fullyRunning = false
    if statusLabel then statusLabel.Text = "⏹️ FULLY NV STOP" end
    if startBtn and stopBtn then
        startBtn.Visible = true
        stopBtn.Visible = false
    end
end

-- ========== GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "FULLY_NV"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 480)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 16, 30)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(100, 55, 190)
Instance.new("UIStroke", mainFrame).Thickness = 1

-- Title bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
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
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Pilih Apart
local apartFrame = Instance.new("Frame", scroll)
apartFrame.Size = UDim2.new(1, 0, 0, 90)
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

local apartDropdown = Instance.new("TextButton", apartFrame)
apartDropdown.Size = UDim2.new(0.9, 0, 0, 35)
apartDropdown.Position = UDim2.new(0.05, 0, 0, 40)
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
    menu.Position = UDim2.new(0.1, 0, 0, 130)
    menu.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
    Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
    for i, name in ipairs(apartList) do
        local btn = Instance.new("TextButton", menu)
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
        btn.BackgroundTransparency = 1
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(220, 215, 245)
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

-- Pilih Pot
local potFrame = Instance.new("Frame", scroll)
potFrame.Size = UDim2.new(1, 0, 0, 90)
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
potKanan.Size = UDim2.new(0.4, -5, 0, 35)
potKanan.Position = UDim2.new(0.05, 0, 0, 40)
potKanan.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
potKanan.Text = "POT KANAN"
potKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
potKanan.Font = Enum.Font.GothamBold
potKanan.TextSize = 12
Instance.new("UICorner", potKanan).CornerRadius = UDim.new(0, 6)

local potKiri = Instance.new("TextButton", potFrame)
potKiri.Size = UDim2.new(0.4, -5, 0, 35)
potKiri.Position = UDim2.new(0.55, 0, 0, 40)
potKiri.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
potKiri.Text = "POT KIRI"
potKiri.TextColor3 = Color3.fromRGB(220, 215, 245)
potKiri.Font = Enum.Font.GothamBold
potKiri.TextSize = 12
Instance.new("UICorner", potKiri).CornerRadius = UDim.new(0, 6)

potKanan.MouseButton1Click:Connect(function()
    selectedPot = "KANAN"
    TweenService:Create(potKanan, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(48, 88, 200)}):Play()
    TweenService:Create(potKiri, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 23, 40)}):Play()
    potKanan.TextColor3 = Color3.fromRGB(255, 255, 255)
    potKiri.TextColor3 = Color3.fromRGB(220, 215, 245)
end)

potKiri.MouseButton1Click:Connect(function()
    selectedPot = "KIRI"
    TweenService:Create(potKiri, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(48, 88, 200)}):Play()
    TweenService:Create(potKanan, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 23, 40)}):Play()
    potKiri.TextColor3 = Color3.fromRGB(255, 255, 255)
    potKanan.TextColor3 = Color3.fromRGB(220, 215, 245)
end)

-- Slider Jumlah Beli
local sliderFrame = Instance.new("Frame", scroll)
sliderFrame.Size = UDim2.new(1, 0, 0, 60)
sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 33, 50)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)

local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(1, 0, 0, 25)
sliderLabel.Position = UDim2.new(0, 8, 0, 5)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Jumlah Set Bahan per Loop:"
sliderLabel.Font = Enum.Font.GothamBold
sliderLabel.TextSize = 12
sliderLabel.TextColor3 = Color3.fromRGB(220, 215, 245)
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

local sliderValue = Instance.new("TextLabel", sliderFrame)
sliderValue.Size = UDim2.new(0, 50, 0, 30)
sliderValue.Position = UDim2.new(0.5, -25, 0, 30)
sliderValue.BackgroundTransparency = 1
sliderValue.Text = "5"
sliderValue.Font = Enum.Font.GothamBold
sliderValue.TextSize = 16
sliderValue.TextColor3 = Color3.fromRGB(100, 190, 255)
sliderValue.TextXAlignment = Enum.TextXAlignment.Center

local minusBtn = Instance.new("TextButton", sliderFrame)
minusBtn.Size = UDim2.new(0, 35, 0, 35)
minusBtn.Position = UDim2.new(0.5, -95, 0, 27)
minusBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.BorderSizePixel = 0
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)

local plusBtn = Instance.new("TextButton", sliderFrame)
plusBtn.Size = UDim2.new(0, 35, 0, 35)
plusBtn.Position = UDim2.new(0.5, 60, 0, 27)
plusBtn.BackgroundColor3 = Color3.fromRGB(48, 88, 200)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.BorderSizePixel = 0
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)

local currentBuy = 5
minusBtn.MouseButton1Click:Connect(function()
    currentBuy = math.max(1, currentBuy - 1)
    sliderValue.Text = tostring(currentBuy)
    buyAmount = currentBuy
end)
plusBtn.MouseButton1Click:Connect(function()
    currentBuy = math.min(50, currentBuy + 1)
    sliderValue.Text = tostring(currentBuy)
    buyAmount = currentBuy
end)

-- Status
local statusFrame = Instance.new("Frame", scroll)
statusFrame.Size = UDim2.new(1, 0, 0, 50)
statusFrame.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 8)

statusLabel = Instance.new("TextLabel", statusFrame)
statusLabel.Size = UDim2.new(1, -16, 1, 0)
statusLabel.Position = UDim2.new(0, 8, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Belum dimulai"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextColor3 = Color3.fromRGB(145, 138, 175)
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.TextWrapped = true

-- Statistik
local statFrame = Instance.new("Frame", scroll)
statFrame.Size = UDim2.new(1, 0, 0, 60)
statFrame.BackgroundColor3 = Color3.fromRGB(35, 33, 50)
Instance.new("UICorner", statFrame).CornerRadius = UDim.new(0, 8)

local cookedLabel = Instance.new("TextLabel", statFrame)
cookedLabel.Size = UDim2.new(0.5, 0, 0, 25)
cookedLabel.Position = UDim2.new(0, 8, 0, 5)
cookedLabel.BackgroundTransparency = 1
cookedLabel.Text = "Total MS Dimasak:"
cookedLabel.Font = Enum.Font.Gotham
cookedLabel.TextSize = 11
cookedLabel.TextColor3 = Color3.fromRGB(145, 138, 175)
cookedLabel.TextXAlignment = Enum.TextXAlignment.Left

local cookedValue = Instance.new("TextLabel", statFrame)
cookedValue.Size = UDim2.new(0.4, 0, 0, 25)
cookedValue.Position = UDim2.new(0.6, 0, 0, 5)
cookedValue.BackgroundTransparency = 1
cookedValue.Text = "0"
cookedValue.Font = Enum.Font.GothamBold
cookedValue.TextSize = 14
cookedValue.TextColor3 = Color3.fromRGB(100, 190, 255)
cookedValue.TextXAlignment = Enum.TextXAlignment.Right

local soldLabel = Instance.new("TextLabel", statFrame)
soldLabel.Size = UDim2.new(0.5, 0, 0, 25)
soldLabel.Position = UDim2.new(0, 8, 0, 30)
soldLabel.BackgroundTransparency = 1
soldLabel.Text = "Total MS Terjual:"
soldLabel.Font = Enum.Font.Gotham
soldLabel.TextSize = 11
soldLabel.TextColor3 = Color3.fromRGB(145, 138, 175)
soldLabel.TextXAlignment = Enum.TextXAlignment.Left

local soldValue = Instance.new("TextLabel", statFrame)
soldValue.Size = UDim2.new(0.4, 0, 0, 25)
soldValue.Position = UDim2.new(0.6, 0, 0, 30)
soldValue.BackgroundTransparency = 1
soldValue.Text = "0"
soldValue.Font = Enum.Font.GothamBold
soldValue.TextSize = 14
soldValue.TextColor3 = Color3.fromRGB(52, 210, 110)
soldValue.TextXAlignment = Enum.TextXAlignment.Right

-- Tombol Start/Stop
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
    if fullyRunning then return end
    if not selectedApart then
        statusLabel.Text = "❌ Pilih apart casino dulu!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    if not selectedPot then
        statusLabel.Text = "❌ Pilih pot kanan/kiri dulu!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    fullyRunning = true
    buyAmount = currentBuy
    statusLabel.TextColor3 = Color3.fromRGB(100, 190, 255)
    startBtn.Visible = false
    stopBtn.Visible = true
    task.spawn(fullyNVLoop)
end)

stopBtn.MouseButton1Click:Connect(function()
    fullyRunning = false
    startBtn.Visible = true
    stopBtn.Visible = false
    statusLabel.Text = "⏹️ Dihentikan"
    statusLabel.TextColor3 = Color3.fromRGB(255, 160, 40)
end)

-- Update statistik
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            cookedValue.Text = tostring(totalCooked)
            soldValue.Text = tostring(totalSold)
        end)
    end
end)

print("[FULLY NV] GUI siap! Pilih apart dan pot, lalu klik START.")
print("[INFO] Ragdoll: health 3% → detect ragdoll → langsung TP → tunggu 10 detik → baru interaksi")
