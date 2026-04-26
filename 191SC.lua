-- ============================================================
-- FULLY NV - TWEEN STABIL (TURUN 7 → GERAK → NAIK 7)
-- TANPA NOCLIP, TANPA MOVETO, TANPA JATUH
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

-- KORDINAT APART CASINO
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

local fullyRunning = false
local selectedApart = 1
local selectedPot = "kanan"
local targetMS = 5
local basePlate = nil

-- BASE PLATE
local function getGroundLevel(pos)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {player.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local rayOrigin = Vector3.new(pos.X, pos.Y + 20, pos.Z)
    local rayDir = Vector3.new(0, -50, 0)
    local result = workspace:Raycast(rayOrigin, rayDir, params)
    if result then return result.Position.Y end
    return pos.Y - 5
end

local function createBasePlate()
    if basePlate and basePlate.Parent then basePlate:Destroy() end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local groundY = getGroundLevel(hrp.Position)
    local baseY = groundY - 5
    basePlate = Instance.new("Part")
    basePlate.Name = "FullyNV_BasePlate"
    basePlate.Size = Vector3.new(1000, 1, 1000)
    basePlate.Position = Vector3.new(hrp.Position.X, baseY, hrp.Position.Z)
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
    if basePlate and basePlate.Parent then basePlate:Destroy() end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local groundY = getGroundLevel(hrp.Position)
    local baseY = groundY - 5
    basePlate = Instance.new("Part")
    basePlate.Name = "FullyNV_BasePlate_Raksasa"
    basePlate.Size = Vector3.new(5000, 1, 5000)
    basePlate.Position = Vector3.new(hrp.Position.X, baseY, hrp.Position.Z)
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

-- HELPER
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
-- KETARIK TWEEN STABIL (TANPA NOCLIP, TANPA MOVETO)
-- ============================================================
local function ketarikKeTarget(targetPos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- MATIKAN ANIMASI BERJALAN (Optional)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = false
        hum.PlatformStand = true -- biar gak jatuh
    end

    -- 1. TURUN 7 STUDS
    local downPos = CFrame.new(hrp.Position.X, hrp.Position.Y - 7, hrp.Position.Z)
    local downTween = TweenService:Create(hrp, TweenInfo.new(0.2, Enum.EasingStyle.Linear), { CFrame = downPos })
    downTween:Play()
    downTween.Completed:Wait()
    task.wait(0.05)

    -- 2. TWEEN KE TARGET (SPEED 0.3)
    local distance = (targetPos - hrp.Position).Magnitude
    local duration = distance / 0.3
    duration = math.max(duration, 3)

    local targetCF = CFrame.new(targetPos.X, targetPos.Y - 7, targetPos.Z)
    local moveTween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = targetCF })
    moveTween:Play()
    moveTween.Completed:Wait()
    task.wait(0.05)

    -- 3. NAIK 7 STUDS
    local upPos = CFrame.new(targetPos)
    local upTween = TweenService:Create(hrp, TweenInfo.new(0.2, Enum.EasingStyle.Linear), { CFrame = upPos })
    upTween:Play()
    upTween.Completed:Wait()

    -- KEMBALIKAN SETTING HUMANOD
    if hum then
        hum.AutoRotate = true
        hum.PlatformStand = false
    end

    return true
end

local function getStagePos(stage, pot)
    if stage.pos then return stage.pos
    elseif stage[pot] then return stage[pot]
    end
    return nil
end

-- MAIN LOOP
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
        statusFunc("🏃 Ketarik ke NPC Buy...")
        ketarikKeTarget(npcPos)

        statusFunc("🛒 Beli bahan x" .. target)
        if not beliBahan(target) then break end

        statusFunc("🏃 Ketarik ke apart...")
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

        statusFunc("🏃 Ketarik ke NPC Jual...")
        ketarikKeTarget(npcPos)

        statusFunc("💰 Menjual MS")
        jualSemua()

        statusFunc("🔄 Loop selesai, ulang...")
        task.wait(1)
    end

    fullyRunning = false
    statusFunc("⏹ Dihentikan")
end

-- GUI
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
titleText.Text = "FULLY NV - TWEEN STABIL"
titleText.TextColor3 = Color3.new(1,1,1)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14

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
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- INFO
local infoCard = Instance.new("Frame", scroll)
infoCard.Size = UDim2.new(1, 0, 0, 60)
infoCard.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 8)
local infoLbl = Instance.new("TextLabel", infoCard)
infoLbl.Size = UDim2.new(1, -10, 1, 0)
infoLbl.Position = UDim2.new(0, 5, 0, 0)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "TWEEN SPEED 0.3\nTURUN 7 → GERAK → NAIK 7"
infoLbl.TextColor3 = Color3.fromRGB(200, 200, 255)
infoLbl.Font = Enum.Font.GothamBold
infoLbl.TextSize = 11
infoLbl.TextWrapped = true
infoLbl.TextXAlignment = Enum.TextXAlignment.Center

-- BASE PLATE
local baseCard = Instance.new("Frame", scroll)
baseCard.Size = UDim2.new(1, 0, 0, 80)
baseCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
Instance.new("UICorner", baseCard).CornerRadius = UDim.new(0, 8)

local createBtn = Instance.new("TextButton", baseCard)
createBtn.Size = UDim2.new(0.3, -5, 0, 35)
createBtn.Position = UDim2.new(0.02, 0, 0.5, -17.5)
createBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
createBtn.Text = "CREATE"
createBtn.TextColor3 = Color3.new(1,1,1)
createBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", createBtn).CornerRadius = UDim.new(0, 6)
createBtn.MouseButton1Click:Connect(createBasePlate)

local raksasaBtn = Instance.new("TextButton", baseCard)
raksasaBtn.Size = UDim2.new(0.3, -5, 0, 35)
raksasaBtn.Position = UDim2.new(0.35, 0, 0.5, -17.5)
raksasaBtn.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
raksasaBtn.Text = "RAKSASA"
raksasaBtn.TextColor3 = Color3.new(1,1,1)
raksasaBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", raksasaBtn).CornerRadius = UDim.new(0, 6)
raksasaBtn.MouseButton1Click:Connect(createBasePlateRaksasa)

local removeBtn = Instance.new("TextButton", baseCard)
removeBtn.Size = UDim2.new(0.3, -5, 0, 35)
removeBtn.Position = UDim2.new(0.68, 0, 0.5, -17.5)
removeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 75)
removeBtn.Text = "REMOVE"
removeBtn.TextColor3 = Color3.new(1,1,1)
removeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", removeBtn).CornerRadius = UDim.new(0, 6)
removeBtn.MouseButton1Click:Connect(removeBasePlate)

-- TARGET MS
local targetCard = Instance.new("Frame", scroll)
targetCard.Size = UDim2.new(1, 0, 0, 70)
targetCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
Instance.new("UICorner", targetCard).CornerRadius = UDim.new(0, 8)

local targetLabel = Instance.new("TextLabel", targetCard)
targetLabel.Size = UDim2.new(1, -10, 0, 20)
targetLabel.Position = UDim2.new(0, 5, 0, 5)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Target MS per loop"
targetLabel.TextColor3 = Color3.fromRGB(220, 215, 245)
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 12

local targetVal = Instance.new("TextLabel", targetCard)
targetVal.Size = UDim2.new(0, 50, 0, 35)
targetVal.Position = UDim2.new(0.5, -25, 0, 28)
targetVal.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
targetVal.Text = "5"
targetVal.TextColor3 = Color3.new(1,1,1)
targetVal.Font = Enum.Font.GothamBold
targetVal.TextSize = 14
Instance.new("UICorner", targetVal).CornerRadius = UDim.new(0, 6)

local minusBtn = Instance.new("TextButton", targetCard)
minusBtn.Size = UDim2.new(0, 35, 0, 35)
minusBtn.Position = UDim2.new(0, 10, 0, 28)
minusBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.new(1,1,1)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)
minusBtn.MouseButton1Click:Connect(function()
    targetMS = math.max(1, targetMS - 1)
    targetVal.Text = tostring(targetMS)
end)

local plusBtn = Instance.new("TextButton", targetCard)
plusBtn.Size = UDim2.new(0, 35, 0, 35)
plusBtn.Position = UDim2.new(1, -45, 0, 28)
plusBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)
plusBtn.MouseButton1Click:Connect(function()
    targetMS = math.min(50, targetMS + 1)
    targetVal.Text = tostring(targetMS)
end)

-- APART
local apartLabel = Instance.new("TextLabel", scroll)
apartLabel.Size = UDim2.new(1, 0, 0, 20)
apartLabel.BackgroundTransparency = 1
apartLabel.Text = "PILIH APART"
apartLabel.TextColor3 = Color3.fromRGB(145, 138, 175)
apartLabel.Font = Enum.Font.GothamBold
apartLabel.TextSize = 11

local apartCard = Instance.new("Frame", scroll)
apartCard.Size = UDim2.new(1, 0, 0, 50)
apartCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
Instance.new("UICorner", apartCard).CornerRadius = UDim.new(0, 8)

local apartBtns = {}
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
        for _, b in pairs(apartBtns) do b.BackgroundColor3 = Color3.fromRGB(24, 21, 40) end
        btn.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
    end)
    apartBtns[i] = btn
end

-- POT
local potLabel = Instance.new("TextLabel", scroll)
potLabel.Size = UDim2.new(1, 0, 0, 20)
potLabel.BackgroundTransparency = 1
potLabel.Text = "PILIH POT"
potLabel.TextColor3 = Color3.fromRGB(145, 138, 175)
potLabel.Font = Enum.Font.GothamBold
potLabel.TextSize = 11

local potCard = Instance.new("Frame", scroll)
potCard.Size = UDim2.new(1, 0, 0, 50)
potCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
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

-- STATUS
local statusCard2 = Instance.new("Frame", scroll)
statusCard2.Size = UDim2.new(1, 0, 0, 50)
statusCard2.BackgroundColor3 = Color3.fromRGB(18, 16, 30)
Instance.new("UICorner", statusCard2).CornerRadius = UDim.new(0, 8)

local statusText = Instance.new("TextLabel", statusCard2)
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Belum dimulai"
statusText.TextColor3 = Color3.fromRGB(145, 138, 175)
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 11
statusText.TextWrapped = true
statusText.TextXAlignment = Enum.TextXAlignment.Center

-- BUTTONS
local btnCard2 = Instance.new("Frame", scroll)
btnCard2.Size = UDim2.new(1, 0, 0, 50)
btnCard2.BackgroundTransparency = 1

local startBtn = Instance.new("TextButton", btnCard2)
startBtn.Size = UDim2.new(0.45, -5, 0, 40)
startBtn.Position = UDim2.new(0.03, 0, 0.5, -20)
startBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
startBtn.Text = "▶ START"
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", btnCard2)
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
    setStatus("🚀 Memulai Fully NV (Tween stabil)...")
    task.spawn(function()
        jalankanFully(setStatus)
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    fullyRunning = false
    setStatus("⏹ Dihentikan")
end)

print("✅ FULLY NV TWEEN STABIL SIAP! Gerak mulus, tidak jatuh, tidak noclip.")
