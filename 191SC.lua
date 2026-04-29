-- ============================================================
-- FULLY NV PAGE (MENGGANTIKAN STATUS)
-- ============================================================
local fullyPage = pages["FULLY NV"]

-- Hapus isi lama
for _, v in pairs(fullyPage:GetChildren()) do
    if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("ScrollingFrame") then
        v:Destroy()
    end
end

-- Scroll
local fscroll = Instance.new("ScrollingFrame", fullyPage)
fscroll.Size = UDim2.new(1, 0, 1, 0)
fscroll.CanvasSize = UDim2.new(0, 0, 0, 560)
fscroll.BackgroundTransparency = 1
fscroll.ScrollBarThickness = 3

local function card(parent, h, y)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -24, 0, h)
    f.Position = UDim2.new(0, 12, 0, y)
    f.BackgroundColor3 = C.card
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", f)
    s.Color = C.border
    s.Thickness = 1
    return f
end

local function btn(parent, text, color, y, w)
    local f = Instance.new("TextButton", parent)
    f.Size = UDim2.new(w or 0.8, 0, 0, 36)
    f.Position = UDim2.new(0.1, 0, 0, y)
    f.BackgroundColor3 = color or C.blueD
    f.Font = Enum.Font.GothamBold
    f.TextSize = 12
    f.TextColor3 = C.text
    f.Text = text
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    return f
end

-- Judul
local title = Instance.new("TextLabel", fscroll)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.Text = "FULLY NV - AUTO APART CASINO"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = C.text

-- Pilih Apart
local apartFrame = card(fscroll, 80, 45)
local apartL = Instance.new("TextLabel", apartFrame)
apartL.Size = UDim2.new(1, 0, 0, 25)
apartL.Position = UDim2.new(0, 10, 0, 5)
apartL.BackgroundTransparency = 1
apartL.Text = "Pilih Apart Casino:"
apartL.Font = Enum.Font.GothamBold
apartL.TextSize = 12
apartL.TextColor3 = C.text

local apartDropdown = Instance.new("TextButton", apartFrame)
apartDropdown.Size = UDim2.new(0.8, 0, 0, 32)
apartDropdown.Position = UDim2.new(0.1, 0, 0, 35)
apartDropdown.BackgroundColor3 = C.blueD
apartDropdown.Text = "Pilih Apart"
apartDropdown.TextColor3 = C.text
apartDropdown.Font = Enum.Font.GothamBold
apartDropdown.TextSize = 12
Instance.new("UICorner", apartDropdown).CornerRadius = UDim.new(0, 6)

local apartList = {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}
local selectedApart = nil
apartDropdown.MouseButton1Click:Connect(function()
    local menu = Instance.new("Frame", fscroll)
    menu.Size = UDim2.new(0.8, 0, 0, 120)
    menu.Position = UDim2.new(0.1, 0, 0, 130)
    menu.BackgroundColor3 = C.surface
    Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
    for i, name in ipairs(apartList) do
        local mbtn = Instance.new("TextButton", menu)
        mbtn.Size = UDim2.new(1, 0, 0, 28)
        mbtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
        mbtn.BackgroundTransparency = 1
        mbtn.Text = name
        mbtn.TextColor3 = C.text
        mbtn.Font = Enum.Font.Gotham
        mbtn.TextSize = 11
        mbtn.MouseButton1Click:Connect(function()
            selectedApart = name
            apartDropdown.Text = name
            menu:Destroy()
        end)
    end
    task.delay(5, function() pcall(function() menu:Destroy() end) end)
end)

-- Pilih Pot
local potFrame = card(fscroll, 80, 130)
local potL = Instance.new("TextLabel", potFrame)
potL.Size = UDim2.new(1, 0, 0, 25)
potL.Position = UDim2.new(0, 10, 0, 5)
potL.BackgroundTransparency = 1
potL.Text = "Pilih Pot:"
potL.Font = Enum.Font.GothamBold
potL.TextSize = 12
potL.TextColor3 = C.text

local selectedPot = nil
local potKanan = Instance.new("TextButton", potFrame)
potKanan.Size = UDim2.new(0.4, -5, 0, 32)
potKanan.Position = UDim2.new(0.05, 0, 0, 35)
potKanan.BackgroundColor3 = C.blueD
potKanan.Text = "KANAN"
potKanan.TextColor3 = C.text
potKanan.Font = Enum.Font.GothamBold
potKanan.TextSize = 12
Instance.new("UICorner", potKanan).CornerRadius = UDim.new(0, 6)

local potKiri = Instance.new("TextButton", potFrame)
potKiri.Size = UDim2.new(0.4, -5, 0, 32)
potKiri.Position = UDim2.new(0.55, 0, 0, 35)
potKiri.BackgroundColor3 = C.card
potKiri.Text = "KIRI"
potKiri.TextColor3 = C.text
potKiri.Font = Enum.Font.GothamBold
potKiri.TextSize = 12
Instance.new("UICorner", potKiri).CornerRadius = UDim.new(0, 6)

potKanan.MouseButton1Click:Connect(function() selectedPot = "KANAN" end)
potKiri.MouseButton1Click:Connect(function() selectedPot = "KIRI" end)

-- Slider
local sliderFrame = card(fscroll, 60, 215)
local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(1, 0, 0, 25)
sliderLabel.Position = UDim2.new(0, 10, 0, 5)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Target MS per Loop:"
sliderLabel.Font = Enum.Font.GothamBold
sliderLabel.TextSize = 12
sliderLabel.TextColor3 = C.text

local targetMS = 5
local targetVal = Instance.new("TextLabel", sliderFrame)
targetVal.Size = UDim2.new(0, 50, 0, 30)
targetVal.Position = UDim2.new(0.5, -25, 0.5, 0)
targetVal.BackgroundTransparency = 1
targetVal.Text = "5"
targetVal.Font = Enum.Font.GothamBold
targetVal.TextSize = 16
targetVal.TextColor3 = C.blue

local minus = Instance.new("TextButton", sliderFrame)
minus.Size = UDim2.new(0, 35, 0, 35)
minus.Position = UDim2.new(0.5, -95, 0.5, 0)
minus.BackgroundColor3 = C.blueD
minus.Text = "-"
minus.Font = Enum.Font.GothamBold
minus.TextSize = 18
minus.TextColor3 = C.text
Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 6)

local plus = Instance.new("TextButton", sliderFrame)
plus.Size = UDim2.new(0, 35, 0, 35)
plus.Position = UDim2.new(0.5, 60, 0.5, 0)
plus.BackgroundColor3 = C.blueD
plus.Text = "+"
plus.Font = Enum.Font.GothamBold
plus.TextSize = 18
plus.TextColor3 = C.text
Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 6)

minus.MouseButton1Click:Connect(function() targetMS = math.max(1, targetMS-1) targetVal.Text = tostring(targetMS) end)
plus.MouseButton1Click:Connect(function() targetMS = math.min(50, targetMS+1) targetVal.Text = tostring(targetMS) end)

-- Status
local statusFrame = card(fscroll, 50, 280)
local fullyStatus = Instance.new("TextLabel", statusFrame)
fullyStatus.Size = UDim2.new(1, -16, 1, 0)
fullyStatus.Position = UDim2.new(0, 8, 0, 0)
fullyStatus.BackgroundTransparency = 1
fullyStatus.Text = "Belum dimulai"
fullyStatus.Font = Enum.Font.Gotham
fullyStatus.TextSize = 11
fullyStatus.TextColor3 = C.textMid
fullyStatus.TextXAlignment = Enum.TextXAlignment.Center

-- Statistik dari page STATUS lama
local statFrame = card(fscroll, 80, 335)
local totCookL = Instance.new("TextLabel", statFrame)
totCookL.Size = UDim2.new(0.5, 0, 0, 20)
totCookL.Position = UDim2.new(0, 12, 0, 5)
totCookL.BackgroundTransparency = 1
totCookL.Text = "Total MS Dimasak:"
totCookL.Font = Enum.Font.GothamSemibold
totCookL.TextSize = 11
totCookL.TextColor3 = C.textMid

local totCookV = Instance.new("TextLabel", statFrame)
totCookV.Size = UDim2.new(0.4, 0, 0, 20)
totCookV.Position = UDim2.new(0.6, 0, 0, 5)
totCookV.BackgroundTransparency = 1
totCookV.Text = "0"
totCookV.Font = Enum.Font.GothamBold
totCookV.TextSize = 14
totCookV.TextColor3 = C.blue

local totSoldL = Instance.new("TextLabel", statFrame)
totSoldL.Size = UDim2.new(0.5, 0, 0, 20)
totSoldL.Position = UDim2.new(0, 12, 0, 30)
totSoldL.BackgroundTransparency = 1
totSoldL.Text = "Total MS Terjual:"
totSoldL.Font = Enum.Font.GothamSemibold
totSoldL.TextSize = 11
totSoldL.TextColor3 = C.textMid

local totSoldV = Instance.new("TextLabel", statFrame)
totSoldV.Size = UDim2.new(0.4, 0, 0, 20)
totSoldV.Position = UDim2.new(0.6, 0, 0, 30)
totSoldV.BackgroundTransparency = 1
totSoldV.Text = "0"
totSoldV.Font = Enum.Font.GothamBold
totSoldV.TextSize = 14
totSoldV.TextColor3 = C.blue

local bahanL = Instance.new("TextLabel", fscroll)
bahanL.Size = UDim2.new(1, 0, 0, 22)
bahanL.Position = UDim2.new(0, 12, 0, 425)
bahanL.BackgroundTransparency = 1
bahanL.Text = "SISA BAHAN:"
bahanL.Font = Enum.Font.GothamBold
bahanL.TextSize = 10
bahanL.TextColor3 = C.textDim

local waterF = card(fscroll, 25, 450)
local waterFL = Instance.new("TextLabel", waterF)
waterFL.Size = UDim2.new(0.5, 0, 1, 0)
waterFL.Position = UDim2.new(0, 12, 0, 0)
waterFL.BackgroundTransparency = 1
waterFL.Text = "Water:"
waterFL.Font = Enum.Font.GothamSemibold
waterFL.TextSize = 11
waterFL.TextColor3 = C.textMid

local waterFV = Instance.new("TextLabel", waterF)
waterFV.Size = UDim2.new(0.4, 0, 1, 0)
waterFV.Position = UDim2.new(0.6, 0, 0, 0)
waterFV.BackgroundTransparency = 1
waterFV.Text = "0"
waterFV.Font = Enum.Font.GothamBold
waterFV.TextSize = 12
waterFV.TextColor3 = C.blue

local sugarF = card(fscroll, 25, 480)
local sugarFL = Instance.new("TextLabel", sugarF)
sugarFL.Size = UDim2.new(0.5, 0, 1, 0)
sugarFL.Position = UDim2.new(0, 12, 0, 0)
sugarFL.BackgroundTransparency = 1
sugarFL.Text = "Sugar Block Bag:"
sugarFL.Font = Enum.Font.GothamSemibold
sugarFL.TextSize = 11
sugarFL.TextColor3 = C.textMid

local sugarFV = Instance.new("TextLabel", sugarF)
sugarFV.Size = UDim2.new(0.4, 0, 1, 0)
sugarFV.Position = UDim2.new(0.6, 0, 0, 0)
sugarFV.BackgroundTransparency = 1
sugarFV.Text = "0"
sugarFV.Font = Enum.Font.GothamBold
sugarFV.TextSize = 12
sugarFV.TextColor3 = C.blue

local gelF = card(fscroll, 25, 510)
local gelFL = Instance.new("TextLabel", gelF)
gelFL.Size = UDim2.new(0.5, 0, 1, 0)
gelFL.Position = UDim2.new(0, 12, 0, 0)
gelFL.BackgroundTransparency = 1
gelFL.Text = "Gelatin:"
gelFL.Font = Enum.Font.GothamSemibold
gelFL.TextSize = 11
gelFL.TextColor3 = C.textMid

local gelFV = Instance.new("TextLabel", gelF)
gelFV.Size = UDim2.new(0.4, 0, 1, 0)
gelFV.Position = UDim2.new(0.6, 0, 0, 0)
gelFV.BackgroundTransparency = 1
gelFV.Text = "0"
gelFV.Font = Enum.Font.GothamBold
gelFV.TextSize = 12
gelFV.TextColor3 = C.blue

local emptyF = card(fscroll, 25, 540)
local emptyFL = Instance.new("TextLabel", emptyF)
emptyFL.Size = UDim2.new(0.5, 0, 1, 0)
emptyFL.Position = UDim2.new(0, 12, 0, 0)
emptyFL.BackgroundTransparency = 1
emptyFL.Text = "Empty Bag:"
emptyFL.Font = Enum.Font.GothamSemibold
emptyFL.TextSize = 11
emptyFL.TextColor3 = C.textMid

local emptyFV = Instance.new("TextLabel", emptyF)
emptyFV.Size = UDim2.new(0.4, 0, 1, 0)
emptyFV.Position = UDim2.new(0.6, 0, 0, 0)
emptyFV.BackgroundTransparency = 1
emptyFV.Text = "0"
emptyFV.Font = Enum.Font.GothamBold
emptyFV.TextSize = 12
emptyFV.TextColor3 = C.blue

-- Tombol
local startBtn = btn(fscroll, "▶ START FULLY NV", C.blueD, 575, 0.8)
local stopBtn = btn(fscroll, "■ STOP FULLY NV", C.red, 575, 0.8)
stopBtn.Visible = false

-- Variabel Fully NV
local fullyActive = false
local totalCook = 0
local totalSell = 0

-- Koordinat
local NPC_BUY = Vector3.new(510.061, 4.476, 600.548)
local NPC_SELL = Vector3.new(510.061, 4.476, 600.548)
local APART_POS = {
    ["APART CASINO 1"] = Vector3.new(1137.992, 9.932, 449.753),
    ["APART CASINO 2"] = Vector3.new(1139.174, 9.932, 420.556),
    ["APART CASINO 3"] = Vector3.new(984.856, 9.932, 247.280),
    ["APART CASINO 4"] = Vector3.new(988.311, 9.932, 221.664),
}

local APART_COORDS = {
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

local function blink(pos)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    while fullyActive and (hrp.Position - pos).Magnitude > 5 do
        local dir = (pos - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position + dir * 5)
        task.wait(1)
        hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then break end
    end
    if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) end
    return true
end

local function tweenTo(cf)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tw = TweenService:Create(hrp, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = cf})
    tw:Play()
    tw.Completed:Wait()
    if hrp and (hrp.Position - cf.Position).Magnitude > 3 then hrp.CFrame = cf end
end

local function eSpam(t)
    for _ = 1, (t or 10) do
        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        task.wait(0.05)
    end
    task.wait(0.3)
end

local function masakApart()
    local c = APART_COORDS[selectedApart]
    if not c then return false end
    for i, s in ipairs(c) do
        if not fullyActive then return false end
        fullyStatus.Text = "→ Tahap " .. i
        if type(s) == "table" then
            tweenTo(selectedPot == "KANAN" and s.kanan or s.kiri)
        else
            tweenTo(s)
        end
        eSpam(10)
        task.wait(0.5)
    end
    fullyStatus.Text = "💧 Water..."
    equip("Water"); eSpam(10); task.wait(20)
    if not fullyActive then return false end
    fullyStatus.Text = "🧂 Sugar..."
    equip("Sugar Block Bag"); eSpam(10); task.wait(1)
    fullyStatus.Text = "🟡 Gelatin..."
    equip("Gelatin"); eSpam(10); task.wait(1)
    fullyStatus.Text = "🔥 Cooking..."
    task.wait(45)
    if not fullyActive then return false end
    fullyStatus.Text = "🎒 Take..."
    equip("Empty Bag"); eSpam(10); task.wait(1.5)
    totalCook = totalCook + 1
    return true
end

local function beli(jumlah)
    fullyStatus.Text = "🛒 Buying " .. jumlah .. " sets"
    for i = 1, jumlah do
        if not fullyActive then return false end
        pcall(function()
            buyRemote:FireServer("Water", 1); task.wait(0.4)
            buyRemote:FireServer("Sugar Block Bag", 1); task.wait(0.4)
            buyRemote:FireServer("Gelatin", 1); task.wait(0.4)
            buyRemote:FireServer("Empty Bag", 1); task.wait(0.5)
        end)
    end
    return true
end

local function jual()
    fullyStatus.Text = "💰 Selling..."
    local s = 0
    for _, bag in pairs({"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}) do
        while fullyActive and countItem(bag) > 0 do
            if equip(bag) then eSpam(10); task.wait(0.8); s = s + 1; totalSell = totalSell + 1 else break end
        end
    end
    return true
end

local function loopFull()
    while fullyActive do
        fullyStatus.Text = "🚀 To NPC Buy"
        if not blink(NPC_BUY) then break end
        if not beli(targetMS) then break end
        fullyStatus.Text = "🚀 To " .. selectedApart
        if not blink(APART_POS[selectedApart]) then break end
        for i = 1, targetMS do
            if not fullyActive then break end
            fullyStatus.Text = "🔥 Cook " .. i .. "/" .. targetMS
            if not masakApart() then break end
        end
        fullyStatus.Text = "🚀 To NPC Sell"
        if not blink(NPC_SELL) then break end
        if not jual() then break end
        fullyStatus.Text = "🔄 Loop done"
        task.wait(1)
    end
    fullyActive = false
    fullyStatus.Text = "⏹️ STOPPED"
    startBtn.Visible = true
    stopBtn.Visible = false
end

startBtn.MouseButton1Click:Connect(function()
    if fullyActive then return end
    if not selectedApart then fullyStatus.Text = "❌ Pilih apart!" fullyStatus.TextColor3 = C.red return end
    if not selectedPot then fullyStatus.Text = "❌ Pilih pot!" fullyStatus.TextColor3 = C.red return end
    fullyActive = true
    startBtn.Visible = false
    stopBtn.Visible = true
    fullyStatus.Text = "✅ STARTED"
    fullyStatus.TextColor3 = C.green
    task.spawn(loopFull)
end)

stopBtn.MouseButton1Click:Connect(function()
    fullyActive = false
    startBtn.Visible = true
    stopBtn.Visible = false
    fullyStatus.Text = "⏹️ STOPPED"
    fullyStatus.TextColor3 = C.orange
end)

task.spawn(function()
    while wait(0.5) do
        pcall(function()
            totCookV.Text = tostring(totalCook)
            totSoldV.Text = tostring(totalSell)
            waterFV.Text = tostring(countItem("Water"))
            sugarFV.Text = tostring(countItem("Sugar Block Bag"))
            gelFV.Text = tostring(countItem("Gelatin"))
            emptyFV.Text = tostring(countItem("Empty Bag"))
        end)
    end
end)
