-- ============================================================
-- FULLY NV - SPEED 0.3 + BASE PLATE 5 STUDS DI BAWAH TANAH
-- ============================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

repeat task.wait() until player.Character

local playerGui = player:WaitForChild("PlayerGui")
local buyRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
local npcPos = Vector3.new(510.762817, 3.58721066, 600.791504)

-- ============================================================
-- KORDINAT APART CASINO
-- ============================================================
local apartData = {
    [1] = {
        name = "Apart Casino 1",
        stages = {
            { pos = Vector3.new(1196.51, 3.71, -241.13), isCook = false },
            { pos = Vector3.new(1199.75, 3.71, -238.12), isCook = false },
            { pos = Vector3.new(1199.74, 6.59, -233.05), isCook = false },
            { pos = Vector3.new(1199.66, 6.59, -227.75), isCook = false },
            { pos = Vector3.new(1199.66, 6.59, -227.75), isCook = false },
            { kanan = Vector3.new(1199.91, 7.56, -219.75), kiri = Vector3.new(1199.75, 7.45, -217.66), isCook = true },
            { kanan = Vector3.new(1199.87, 15.96, -215.33), kiri = Vector3.new(1199.38, 15.96, -220.53), isCook = false },
        }
    },
    [2] = {
        name = "Apart Casino 2",
        stages = {
            { pos = Vector3.new(1186.34, 3.71, -242.92), isCook = false },
            { pos = Vector3.new(1183.00, 6.59, -233.78), isCook = false },
            { pos = Vector3.new(1182.70, 7.32, -229.73), isCook = false },
            { pos = Vector3.new(1182.75, 6.59, -224.78), isCook = false },
            { kanan = Vector3.new(1183.43, 15.96, -229.66), kiri = Vector3.new(1183.22, 15.96, -225.63), isCook = false },
        }
    },
    [3] = {
        name = "Apart Casino 3",
        stages = {
            { pos = Vector3.new(1196.17, 3.71, -205.72), isCook = false },
            { pos = Vector3.new(1199.76, 3.71, -196.51), isCook = false },
            { pos = Vector3.new(1199.69, 6.59, -191.16), isCook = false },
            { pos = Vector3.new(1199.42, 6.59, -185.27), isCook = false },
            { kanan = Vector3.new(1199.42, 6.59, -185.27), kiri = Vector3.new(1199.95, 7.07, -177.69), isCook = true },
            { kanan = Vector3.new(1199.55, 15.96, -181.89), kiri = Vector3.new(1199.46, 15.96, -177.81), isCook = false },
        }
    },
    [4] = {
        name = "Apart Casino 4",
        stages = {
            { pos = Vector3.new(1187.70, 3.71, -209.73), isCook = false },
            { pos = Vector3.new(1182.27, 3.71, -204.65), isCook = false },
            { pos = Vector3.new(1182.23, 3.71, -198.77), isCook = false },
            { pos = Vector3.new(1183.06, 6.59, -193.92), isCook = false },
            { kanan = Vector3.new(1182.60, 7.56, -191.29), kiri = Vector3.new(1183.36, 6.72, -187.25), isCook = false },
            { kanan = Vector3.new(1183.24, 15.96, -191.25), kiri = Vector3.new(1183.08, 15.96, -187.36), isCook = false },
        }
    }
}

-- ============================================================
-- VARIABEL
-- ============================================================
local fullyRunning = false
local selectedApart = 1
local selectedPot = "kanan"
local targetMS = 5
local tarikSpeed = 0.3 -- SPEED 0.3 (SUPER PELAN)
local basePlate = nil

-- ============================================================
-- FUNGSI BASE PLATE - 5 STUDS DI BAWAH PERMUKAAN TANAH
-- ============================================================
local function getGroundLevel(pos)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {player.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    
    local rayOrigin = Vector3.new(pos.X, pos.Y + 20, pos.Z)
    local rayDir = Vector3.new(0, -50, 0)
    local result = workspace:Raycast(rayOrigin, rayDir, params)
    
    if result then
        return result.Position.Y
    end
    return pos.Y - 5
end

local function createBasePlate()
    if basePlate and basePlate.Parent then
        basePlate:Destroy()
    end
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local playerPos = hrp.Position
    local groundY = getGroundLevel(playerPos)
    local baseY = groundY - 5
    
    basePlate = Instance.new("Part")
    basePlate.Name = "FullyNV_BasePlate"
    basePlate.Size = Vector3.new(1000, 1, 1000)
    basePlate.Position = Vector3.new(playerPos.X, baseY, playerPos.Z)
    basePlate.Anchored = true
    basePlate.BrickColor = BrickColor.new("Really black")
    basePlate.Material = Enum.Material.SmoothPlastic
    basePlate.Transparency = 0.3
    
    local selection = Instance.new("SelectionBox")
    selection.Adornee = basePlate
    selection.Color3 = Color3.fromRGB(130, 60, 240)
    selection.LineThickness = 0.1
    selection.Transparency = 0.5
    selection.Parent = basePlate
    
    basePlate.Parent = workspace
    return basePlate
end

local function createBasePlateRaksasa()
    if basePlate and basePlate.Parent then
        basePlate:Destroy()
    end
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local playerPos = hrp.Position
    local groundY = getGroundLevel(playerPos)
    local baseY = groundY - 5
    
    basePlate = Instance.new("Part")
    basePlate.Name = "FullyNV_BasePlate_Raksasa"
    basePlate.Size = Vector3.new(5000, 1, 5000)
    basePlate.Position = Vector3.new(playerPos.X, baseY, playerPos.Z)
    basePlate.Anchored = true
    basePlate.BrickColor = BrickColor.new("Really black")
    basePlate.Material = Enum.Material.SmoothPlastic
    basePlate.Transparency = 0.2
    
    local selection = Instance.new("SelectionBox")
    selection.Adornee = basePlate
    selection.Color3 = Color3.fromRGB(130, 60, 240)
    selection.LineThickness = 0.05
    selection.Transparency = 0.7
    selection.Parent = basePlate
    
    basePlate.Parent = workspace
    return basePlate
end

local function removeBasePlate()
    if basePlate and basePlate.Parent then
        basePlate:Destroy()
        basePlate = nil
    end
end

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================
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

local function holdE(duration)
    vim:SendKeyEvent(true, "E", false, game)
    task.wait(duration or 0.7)
    vim:SendKeyEvent(false, "E", false, game)
end

local function spamE(times)
    for i = 1, times do
        vim:SendKeyEvent(true, "E", false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, "E", false, game)
        task.wait(0.05)
    end
end

local function cook()
    local steps = {
        { name = "Water", time = 20 },
        { name = "Sugar Block Bag", time = 1 },
        { name = "Gelatin", time = 1 },
        { name = "Empty Bag", time = 45 }
    }
    for _, step in ipairs(steps) do
        if not fullyRunning then return false end
        if equip(step.name) then
            holdE(0.7)
            if step.time then task.wait(step.time) end
        end
    end
    return true
end

local function beliBahan(jumlah)
    for i = 1, jumlah do
        if not fullyRunning then return false end
        buyRemote:FireServer("Water") task.wait(0.35)
        buyRemote:FireServer("Sugar Block Bag") task.wait(0.35)
        buyRemote:FireServer("Gelatin") task.wait(0.35)
        buyRemote:FireServer("Empty Bag") task.wait(0.45)
    end
    return true
end

local function jualSemua()
    local bags = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
    for _, bag in pairs(bags) do
        while countItem(bag) > 0 and fullyRunning do
            if equip(bag) then holdE(0.7) task.wait(0.5) else break end
        end
    end
end

-- ============================================================
-- BLINK TURUN & NAIK
-- ============================================================
local function blinkTurun(studs)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, -studs, 0)
        task.wait(0.1)
    end
end

local function blinkNaik(studs)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, studs, 0)
        task.wait(0.1)
    end
end

-- ============================================================
-- KETARIK SPEED 0.3
-- ============================================================
local function ketarikKeTarget(targetPos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.SeatPart then hum.Sit = false end
    
    blinkTurun(4)
    
    local distance = (targetPos - hrp.Position).Magnitude
    local duration = distance / tarikSpeed
    duration = math.clamp(duration, 2.5, 20)
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
    tween:Play()
    
    while tween.PlaybackState == Enum.PlaybackState.Playing and fullyRunning do
        task.wait(0.05)
    end
    
    if tween.PlaybackState == Enum.PlaybackState.Playing then tween:Cancel() end
    hrp.CFrame = CFrame.new(targetPos)
    
    blinkNaik(4)
    
    task.wait(0.1)
    return true
end

local function getStagePos(stage, pot)
    if stage.pos then return stage.pos
    elseif stage[pot] then return stage[pot]
    end
    return nil
end

-- ============================================================
-- MAIN LOOP
-- ============================================================
local function jalankanFully(statusFunc)
    fullyRunning = true
    local apartId = selectedApart
    local pot = selectedPot
    local stages = apartData[apartId].stages
    local target = targetMS
    
    local apartPos = getStagePos(stages[1], pot)
    if not apartPos then
        statusFunc("❌ Gagal dapat posisi apart!")
        fullyRunning = false
        return
    end
    
    while fullyRunning do
        statusFunc("🏃 Ketarik ke NPC Buy (speed 0.3)...")
        ketarikKeTarget(npcPos)
        
        statusFunc("🛒 Beli bahan x" .. target)
        if not beliBahan(target) then break end
        
        statusFunc("🏃 Ketarik ke apart (speed 0.3)...")
        ketarikKeTarget(apartPos)
        
        for i, stage in ipairs(stages) do
            if not fullyRunning then break end
            local targetPos = getStagePos(stage, pot)
            if not targetPos then
                statusFunc("❌ Stage " .. i .. " tidak ditemukan")
                break
            end
            
            statusFunc("📍 Stage " .. i .. " - Ketarik...")
            ketarikKeTarget(targetPos)
            
            statusFunc("🎯 Stage " .. i .. " - Spam E")
            spamE(3)
            task.wait(0.3)
            
            if stage.isCook then
                statusFunc("🍳 Memasak di stage " .. i)
                local success = cook()
                if not success then break end
                statusFunc("✅ Masak selesai")
                task.wait(1)
            end
        end
        
        statusFunc("🏃 Ketarik ke NPC Jual (speed 0.3)...")
        ketarikKeTarget(npcPos)
        
        statusFunc("💰 Menjual MS")
        jualSemua()
        
        statusFunc("🔄 Loop selesai, ulang...")
        task.wait(1)
    end
    
    fullyRunning = false
    statusFunc("⏹ Dihentikan")
end

-- ============================================================
-- GUI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FullyNV_GUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 550)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 16, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "FULLY NV - SPEED 0.3 + BASE PLATE"
titleText.TextColor3 = Color3.new(1,1,1)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 13

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 75)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() fullyRunning = false end)

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 620)
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- INFO SPEED
local infoCard = Instance.new("Frame", scroll)
infoCard.Size = UDim2.new(1, 0, 0, 50)
infoCard.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 8)

local infoText = Instance.new("TextLabel", infoCard)
infoText.Size = UDim2.new(1, -10, 1, 0)
infoText.Position = UDim2.new(0, 5, 0, 0)
infoText.BackgroundTransparency = 1
infoText.Text = "⚡ KECEPATAN: 0.3 (SUPER PELAN)\n⬇️ BLINK TURUN 4 STUDS SEBELUM KETARIK"
infoText.TextColor3 = Color3.new(1,1,1)
infoText.Font = Enum.Font.GothamBold
infoText.TextSize = 11
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Center

-- BASE PLATE
local basePlateCard = Instance.new("Frame", scroll)
basePlateCard.Size = UDim2.new(1, 0, 0, 100)
basePlateCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", basePlateCard).CornerRadius = UDim.new(0, 8)

local basePlateLabel = Instance.new("TextLabel", basePlateCard)
basePlateLabel.Size = UDim2.new(1, -10, 0, 20)
basePlateLabel.Position = UDim2.new(0, 5, 0, 5)
basePlateLabel.BackgroundTransparency = 1
basePlateLabel.Text = "🏗️ BASE PLATE (5 STUDS DI BAWAH TANAH)"
basePlateLabel.TextColor3 = Color3.fromRGB(220, 215, 245)
basePlateLabel.Font = Enum.Font.GothamBold
basePlateLabel.TextSize = 11

local basePlateDesc = Instance.new("TextLabel", basePlateCard)
basePlateDesc.Size = UDim2.new(1, -10, 0, 20)
basePlateDesc.Position = UDim2.new(0, 5, 0, 22)
basePlateDesc.BackgroundTransparency = 1
basePlateDesc.Text = "Membuat base plate 5 studs DI BAWAH permukaan tanah"
basePlateDesc.TextColor3 = Color3.fromRGB(145, 138, 175)
basePlateDesc.Font = Enum.Font.Gotham
basePlateDesc.TextSize = 10

local createBaseBtn = Instance.new("TextButton", basePlateCard)
createBaseBtn.Size = UDim2.new(0.3, -5, 0, 40)
createBaseBtn.Position = UDim2.new(0.02, 0, 0.55, 0)
createBaseBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
createBaseBtn.Text = "➕ CREATE"
createBaseBtn.TextColor3 = Color3.new(1,1,1)
createBaseBtn.Font = Enum.Font.GothamBold
createBaseBtn.TextSize = 12
Instance.new("UICorner", createBaseBtn).CornerRadius = UDim.new(0, 6)

local createRaksasaBtn = Instance.new("TextButton", basePlateCard)
createRaksasaBtn.Size = UDim2.new(0.3, -5, 0, 40)
createRaksasaBtn.Position = UDim2.new(0.35, 0, 0.55, 0)
createRaksasaBtn.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
createRaksasaBtn.Text = "🌍 RAKSASA"
createRaksasaBtn.TextColor3 = Color3.new(1,1,1)
createRaksasaBtn.Font = Enum.Font.GothamBold
createRaksasaBtn.TextSize = 11
Instance.new("UICorner", createRaksasaBtn).CornerRadius = UDim.new(0, 6)

local removeBaseBtn = Instance.new("TextButton", basePlateCard)
removeBaseBtn.Size = UDim2.new(0.3, -5, 0, 40)
removeBaseBtn.Position = UDim2.new(0.68, 0, 0.55, 0)
removeBaseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 75)
removeBaseBtn.Text = "❌ REMOVE"
removeBaseBtn.TextColor3 = Color3.new(1,1,1)
removeBaseBtn.Font = Enum.Font.GothamBold
removeBaseBtn.TextSize = 12
Instance.new("UICorner", removeBaseBtn).CornerRadius = UDim.new(0, 6)

createBaseBtn.MouseButton1Click:Connect(function()
    local plate = createBasePlate()
    if plate then
        createBaseBtn.Text = "✅ DONE!"
        task.wait(1)
        createBaseBtn.Text = "➕ CREATE"
    end
end)

createRaksasaBtn.MouseButton1Click:Connect(function()
    local plate = createBasePlateRaksasa()
    if plate then
        createRaksasaBtn.Text = "✅ RAKSASA!"
        task.wait(1)
        createRaksasaBtn.Text = "🌍 RAKSASA"
    end
end)

removeBaseBtn.MouseButton1Click:Connect(function()
    removeBasePlate()
    removeBaseBtn.Text = "✅ REMOVED!"
    task.wait(1)
    removeBaseBtn.Text = "❌ REMOVE"
end)

-- Target MS
local targetCard = Instance.new("Frame", scroll)
targetCard.Size = UDim2.new(1, 0, 0, 60)
targetCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", targetCard).CornerRadius = UDim.new(0, 8)

local targetLabel = Instance.new("TextLabel", targetCard)
targetLabel.Size = UDim2.new(1, -10, 0, 20)
targetLabel.Position = UDim2.new(0, 5, 0, 5)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Target MS per loop"
targetLabel.TextColor3 = Color3.fromRGB(220, 215, 245)
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 12

local targetValue = Instance.new("TextLabel", targetCard)
targetValue.Size = UDim2.new(0, 50, 0, 30)
targetValue.Position = UDim2.new(0.5, -25, 0, 25)
targetValue.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
targetValue.Text = "5"
targetValue.TextColor3 = Color3.new(1,1,1)
targetValue.Font = Enum.Font.GothamBold
targetValue.TextSize = 14
Instance.new("UICorner", targetValue).CornerRadius = UDim.new(0, 6)

local minusBtn = Instance.new("TextButton", targetCard)
minusBtn.Size = UDim2.new(0, 35, 0, 30)
minusBtn.Position = UDim2.new(0, 10, 0, 25)
minusBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.new(1,1,1)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)

local plusBtn = Instance.new("TextButton", targetCard)
plusBtn.Size = UDim2.new(0, 35, 0, 30)
plusBtn.Position = UDim2.new(1, -45, 0, 25)
plusBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)

minusBtn.MouseButton1Click:Connect(function()
    targetMS = math.max(1, targetMS - 1)
    targetValue.Text = tostring(targetMS)
end)
plusBtn.MouseButton1Click:Connect(function()
    targetMS = math.min(50, targetMS + 1)
    targetValue.Text = tostring(targetMS)
end)

-- Pilih Apart
local apartLabel = Instance.new("TextLabel", scroll)
apartLabel.Size = UDim2.new(1, 0, 0, 20)
apartLabel.BackgroundTransparency = 1
apartLabel.Text = "PILIH APART"
apartLabel.TextColor3 = Color3.fromRGB(145, 138, 175)
apartLabel.Font = Enum.Font.GothamBold
apartLabel.TextSize = 11
apartLabel.TextXAlignment = Enum.TextXAlignment.Left

local apartCard = Instance.new("Frame", scroll)
apartCard.Size = UDim2.new(1, 0, 0, 50)
apartCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", apartCard).CornerRadius = UDim.new(0, 8)

local apartButtons = {}
for i = 1, 4 do
    local btn = Instance.new("TextButton", apartCard)
    btn.Size = UDim2.new(0.23, -5, 0, 35)
    btn.Position = UDim2.new(0.01 + (i-1)*0.245, 0, 0.5, -17.5)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(130, 60, 240) or Color3.fromRGB(24, 21, 40)
    btn.Text = "Apart " .. i
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        selectedApart = i
        for _, b in pairs(apartButtons) do
            b.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
        end
        btn.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
    end)
    apartButtons[i] = btn
end

-- Pilih Pot
local potLabel = Instance.new("TextLabel", scroll)
potLabel.Size = UDim2.new(1, 0, 0, 20)
potLabel.BackgroundTransparency = 1
potLabel.Text = "PILIH POT"
potLabel.TextColor3 = Color3.fromRGB(145, 138, 175)
potLabel.Font = Enum.Font.GothamBold
potLabel.TextSize = 11
potLabel.TextXAlignment = Enum.TextXAlignment.Left

local potCard = Instance.new("Frame", scroll)
potCard.Size = UDim2.new(1, 0, 0, 50)
potCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", potCard).CornerRadius = UDim.new(0, 8)

local potKanan = Instance.new("TextButton", potCard)
potKanan.Size = UDim2.new(0.45, -5, 0, 35)
potKanan.Position = UDim2.new(0.03, 0, 0.5, -17.5)
potKanan.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
potKanan.Text = "POT KANAN"
potKanan.TextColor3 = Color3.new(1,1,1)
potKanan.Font = Enum.Font.GothamBold
potKanan.TextSize = 12
Instance.new("UICorner", potKanan).CornerRadius = UDim.new(0, 6)

local potKiri = Instance.new("TextButton", potCard)
potKiri.Size = UDim2.new(0.45, -5, 0, 35)
potKiri.Position = UDim2.new(0.52, 0, 0.5, -17.5)
potKiri.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
potKiri.Text = "POT KIRI"
potKiri.TextColor3 = Color3.new(1,1,1)
potKiri.Font = Enum.Font.GothamBold
potKiri.TextSize = 12
Instance.new("UICorner", potKiri).CornerRadius = UDim.new(0, 6)

potKanan.MouseButton1Click:Connect(function()
    selectedPot = "kanan"
    potKanan.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
    potKiri.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
end)
potKiri.MouseButton1Click:Connect(function()
    selectedPot = "kiri"
    potKiri.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
    potKanan.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
end)

-- Status
local statusCardFrame = Instance.new("Frame", scroll)
statusCardFrame.Size = UDim2.new(1, 0, 0, 50)
statusCardFrame.BackgroundColor3 = Color3.fromRGB(18, 16, 30)
Instance.new("UICorner", statusCardFrame).CornerRadius = UDim.new(0, 8)

local statusText = Instance.new("TextLabel", statusCardFrame)
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Belum dimulai"
statusText.TextColor3 = Color3.fromRGB(145, 138, 175)
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 11
statusText.TextWrapped = true
statusText.TextXAlignment = Enum.TextXAlignment.Center

-- Buttons
local btnCardFrame = Instance.new("Frame", scroll)
btnCardFrame.Size = UDim2.new(1, 0, 0, 50)
btnCardFrame.BackgroundTransparency = 1

local startBtn = Instance.new("TextButton", btnCardFrame)
startBtn.Size = UDim2.new(0.45, -5, 0, 40)
startBtn.Position = UDim2.new(0.03, 0, 0.5, -20)
startBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
startBtn.Text = "▶ START"
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", btnCardFrame)
stopBtn.Size = UDim2.new(0.45, -5, 0, 40)
stopBtn.Position = UDim2.new(0.52, 0, 0.5, -20)
stopBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 75)
stopBtn.Text = "■ STOP"
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

local function setStatus(msg)
    statusText.Text = msg
    print("[FullyNV] " .. msg)
end

startBtn.MouseButton1Click:Connect(function()
    if fullyRunning then return end
    setStatus("🚀 Memulai Fully NV (speed 0.3)...")
    task.spawn(function()
        jalankanFully(setStatus)
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    fullyRunning = false
    setStatus("⏹ Dihentikan")
end)

print("✅ FULLY NV SIAP! Speed 0.3 (SUPER PELAN)")
print("✅ Base Plate: 5 studs DI BAWAH PERMUKAAN TANAH")
