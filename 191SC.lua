-- ============================================================
-- FULLY NV - TWEEN MURNI + TURUN/NAIK INSTAN
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

local apartData = {
    [1] = {
        name = "Apart Casino 1",
        stages = {
            Vector3.new(1196.51, 3.71, -241.13),
            Vector3.new(1199.75, 3.71, -238.12),
            Vector3.new(1199.74, 6.59, -233.05),
            Vector3.new(1199.66, 6.59, -227.75),
            Vector3.new(1199.66, 6.59, -227.75),
            Vector3.new(1199.91, 7.56, -219.75),
            Vector3.new(1199.87, 15.96, -215.33),
        }
    },
    [2] = {
        name = "Apart Casino 2",
        stages = {
            Vector3.new(1186.34, 3.71, -242.92),
            Vector3.new(1183.00, 6.59, -233.78),
            Vector3.new(1182.70, 7.32, -229.73),
            Vector3.new(1182.75, 6.59, -224.78),
            Vector3.new(1183.43, 15.96, -229.66),
        }
    },
    [3] = {
        name = "Apart Casino 3",
        stages = {
            Vector3.new(1196.17, 3.71, -205.72),
            Vector3.new(1199.76, 3.71, -196.51),
            Vector3.new(1199.69, 6.59, -191.16),
            Vector3.new(1199.42, 6.59, -185.27),
            Vector3.new(1199.42, 6.59, -185.27),
            Vector3.new(1199.55, 15.96, -181.89),
        }
    },
    [4] = {
        name = "Apart Casino 4",
        stages = {
            Vector3.new(1187.70, 3.71, -209.73),
            Vector3.new(1182.27, 3.71, -204.65),
            Vector3.new(1182.23, 3.71, -198.77),
            Vector3.new(1183.06, 6.59, -193.92),
            Vector3.new(1182.60, 7.56, -191.29),
            Vector3.new(1183.24, 15.96, -191.25),
        }
    }
}

local fullyRunning = false
local selectedApart = 1
local targetMS = 5
local basePlate = nil
local SPEED = 0.5

-- ============================================================
-- KETARIK: TURUN 6 → TWEEN → NAIK 6
-- ============================================================
local function ketarikKeTarget(targetPos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- TURUN 6 STUDS (INSTAN)
    local startPos = hrp.Position
    hrp.CFrame = CFrame.new(startPos.X, startPos.Y - 6, startPos.Z)
    task.wait(0.05)

    local distance = (targetPos - hrp.Position).Magnitude
    if distance < 2 then
        hrp.CFrame = CFrame.new(targetPos)
        return true
    end

    -- TWEEN KE TARGET (TURUN 1 DETIK = 0.5 STUD)
    local duration = distance / SPEED
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        CFrame = CFrame.new(targetPos.X, targetPos.Y - 6, targetPos.Z)
    })
    tween:Play()
    tween.Completed:Wait()

    -- NAIK 6 STUDS (INSTAN)
    hrp.CFrame = CFrame.new(targetPos)
    return true
end

-- ============================================================
-- TURUN/NAIK UNTUK COOK TIMING
-- ============================================================
local function blinkTurun()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, -6, 0)
        task.wait(0.05)
    end
end

local function blinkNaik()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 6, 0)
        task.wait(0.05)
    end
end

-- ============================================================
-- COOK TIMING
-- ============================================================
local function cookWithTiming()
    if not fullyRunning then return false end
    
    -- WATER (20 DETIK)
    if equip("Water") then
        blinkNaik()
        holdE(0.7)
        local startTime = tick()
        local remaining = 20
        while remaining > 0 and fullyRunning do
            remaining = 20 - (tick() - startTime)
            if remaining <= 2 and remaining > 0 then
                blinkTurun()
                break
            end
            task.wait(0.1)
        end
        task.wait(math.max(0, remaining))
    else
        return false
    end
    
    -- SUGAR
    if equip("Sugar Block Bag") then
        holdE(0.7)
        task.wait(0.5)
    else
        return false
    end
    
    -- GELATIN
    if equip("Gelatin") then
        holdE(0.7)
        task.wait(0.5)
    else
        return false
    end
    
    -- NAIK SETELAH GELATIN
    blinkNaik()
    
    -- TUNGGU 45 DETIK
    local cookStart = tick()
    local remaining = 45
    while remaining > 0 and fullyRunning do
        remaining = 45 - (tick() - cookStart)
        if remaining <= 2 and remaining > 0 then
            blinkTurun()
            break
        end
        task.wait(0.1)
    end
    task.wait(math.max(0, remaining))
    
    -- EMPTY BAG
    if equip("Empty Bag") then
        holdE(0.7)
        task.wait(1)
    else
        return false
    end
    
    return true
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
        while fullyRunning and countItem(bag) > 0 do
            if equip(bag) then
                holdE(0.7)
                task.wait(0.5)
            else
                break
            end
        end
    end
end

-- ============================================================
-- BASE PLATE
-- ============================================================
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

-- ============================================================
-- MAIN LOOP
-- ============================================================
local function jalankanFully(statusFunc)
    fullyRunning = true
    local stages = apartData[selectedApart]
    if not stages then
        statusFunc("❌ Apart tidak ditemukan!")
        fullyRunning = false
        return
    end
    
    local apartPos = stages[1]
    
    while fullyRunning do
        statusFunc("🏃 Beli bahan...")
        ketarikKeTarget(npcPos)
        
        if not beliBahan(targetMS) then break end
        
        statusFunc("🏃 Ke apart...")
        ketarikKeTarget(apartPos)
        
        for i, stagePos in ipairs(stages) do
            if not fullyRunning then break end
            
            statusFunc("📍 Stage " .. i)
            ketarikKeTarget(stagePos)
            spamE(3)
            task.wait(0.3)
            
            if i == 5 or i == 6 then
                statusFunc("🍳 Memasak...")
                if not cookWithTiming() then break end
                statusFunc("✅ Selesai masak")
                task.wait(1)
            end
        end
        
        statusFunc("💰 Jual MS...")
        ketarikKeTarget(npcPos)
        jualSemua()
        
        statusFunc("🔄 Ulang loop...")
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
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "FULLY NV - TWEEN + TURUN"
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
scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function addCard(parent, h)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1, 0, 0, h or 40)
    c.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)
    return c
end

local function addLabel(parent, text, color, size)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1, -10, 1, 0)
    l.Position = UDim2.new(0, 5, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(220, 215, 245)
    l.Font = Enum.Font.Gotham
    l.TextSize = size or 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

-- Target MS
local targetCard = addCard(scroll, 70)
addLabel(targetCard, "Target MS per loop")
local targetVal = Instance.new("TextLabel", targetCard)
targetVal.Size = UDim2.new(0, 50, 0, 35)
targetVal.Position = UDim2.new(0.5, -25, 0, 30)
targetVal.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
targetVal.Text = "5"
targetVal.TextColor3 = Color3.new(1,1,1)
targetVal.Font = Enum.Font.GothamBold
targetVal.TextSize = 14
Instance.new("UICorner", targetVal).CornerRadius = UDim.new(0, 6)

local minusBtn = Instance.new("TextButton", targetCard)
minusBtn.Size = UDim2.new(0, 35, 0, 35)
minusBtn.Position = UDim2.new(0, 10, 0, 30)
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
plusBtn.Position = UDim2.new(1, -45, 0, 30)
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

-- Apart
local apartCard = addCard(scroll, 60)
addLabel(apartCard, "Pilih Apart")
local apartBtns = {}
for i = 1, 4 do
    local btn = Instance.new("TextButton", apartCard)
    btn.Size = UDim2.new(0.22, -5, 0, 35)
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

-- Status
local statusCard = addCard(scroll, 50)
local statusTextUI = addLabel(statusCard, "Belum dimulai", Color3.fromRGB(145, 138, 175), 11)
statusTextUI.TextXAlignment = Enum.TextXAlignment.Center

-- Start/Stop
local btnCard = addCard(scroll, 60)
local startBtn = Instance.new("TextButton", btnCard)
startBtn.Size = UDim2.new(0.45, -5, 0, 40)
startBtn.Position = UDim2.new(0.03, 0, 0.5, -20)
startBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
startBtn.Text = "▶ START"
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", btnCard)
stopBtn.Size = UDim2.new(0.45, -5, 0, 40)
stopBtn.Position = UDim2.new(0.52, 0, 0.5, -20)
stopBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 75)
stopBtn.Text = "■ STOP"
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

local function setStatus(msg)
    statusTextUI.Text = msg
    print(msg)
end

startBtn.MouseButton1Click:Connect(function()
    if fullyRunning then return end
    setStatus("🚀 START (turun 6 → tween → naik 6)")
    task.spawn(function() jalankanFully(setStatus) end)
end)

stopBtn.MouseButton1Click:Connect(function()
    fullyRunning = false
    setStatus("⏹ STOP")
end)

-- Base Plate
local baseCard = addCard(scroll, 60)
local createBaseBtn = Instance.new("TextButton", baseCard)
createBaseBtn.Size = UDim2.new(0.3, -5, 0, 35)
createBaseBtn.Position = UDim2.new(0.02, 0, 0.5, -17.5)
createBaseBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
createBaseBtn.Text = "CREATE BASE"
createBaseBtn.TextColor3 = Color3.new(1,1,1)
createBaseBtn.Font = Enum.Font.GothamBold
createBaseBtn.TextSize = 11
Instance.new("UICorner", createBaseBtn).CornerRadius = UDim.new(0, 6)
createBaseBtn.MouseButton1Click:Connect(createBasePlate)

local raksasaBtn = Instance.new("TextButton", baseCard)
raksasaBtn.Size = UDim2.new(0.3, -5, 0, 35)
raksasaBtn.Position = UDim2.new(0.35, 0, 0.5, -17.5)
raksasaBtn.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
raksasaBtn.Text = "RAKSASA"
raksasaBtn.TextColor3 = Color3.new(1,1,1)
raksasaBtn.Font = Enum.Font.GothamBold
raksasaBtn.TextSize = 11
Instance.new("UICorner", raksasaBtn).CornerRadius = UDim.new(0, 6)
raksasaBtn.MouseButton1Click:Connect(createBasePlateRaksasa)

local removeBaseBtn = Instance.new("TextButton", baseCard)
removeBaseBtn.Size = UDim2.new(0.3, -5, 0, 35)
removeBaseBtn.Position = UDim2.new(0.68, 0, 0.5, -17.5)
removeBaseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 75)
removeBaseBtn.Text = "REMOVE"
removeBaseBtn.TextColor3 = Color3.new(1,1,1)
removeBaseBtn.Font = Enum.Font.GothamBold
removeBaseBtn.TextSize = 11
Instance.new("UICorner", removeBaseBtn).CornerRadius = UDim.new(0, 6)
removeBaseBtn.MouseButton1Click:Connect(removeBasePlate)

print("✅ FULLY NV TWEEN + TURUN SIAP! Speed 0.5")
