-- FULLY NV INJECTOR (JALANKAN SETELAH ELIXIR 3.5 ASLI LOAD)
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

-- Cari GUI Elixir yang sudah berjalan
local elixirGui = nil
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "ELIXIR_3_5" then
        elixirGui = v
        break
    end
end
if not elixirGui then
    for _, v in pairs(player.PlayerGui:GetChildren()) do
        if v.Name == "ELIXIR_3_5" then
            elixirGui = v
            break
        end
    end
end

if not elixirGui then
    warn("Elixir GUI tidak ditemukan! Jalankan Elixir 3.5 dulu.")
    return
end

-- Cari komponen Elixir
local sidebar = nil
local content = nil
local pages = {}
local tabBtns = {}
local C = nil

for _, v in pairs(elixirGui:GetDescendants()) do
    if v.Name == "sidebar" and v:IsA("Frame") then sidebar = v end
    if v.Name == "content" and v:IsA("Frame") then content = v end
    if v:IsA("ScrollingFrame") and v.Parent == content then
        pages[v.Name] = v
    end
    if v:IsA("TextButton") and v.Parent == sidebar then
        tabBtns[v.Text] = v
    end
end

-- Ambil warna dari Elixir (cari frame dengan BackgroundColor3)
for _, v in pairs(elixirGui:GetDescendants()) do
    if v:IsA("Frame") and v.BackgroundColor3 ~= Color3.new(0,0,0) then
        C = {
            bg = v.BackgroundColor3,
            card = v.BackgroundColor3,
            text = Color3.fromRGB(255,255,255),
            textMid = Color3.fromRGB(200,200,200),
            textDim = Color3.fromRGB(150,150,150),
            blueD = Color3.fromRGB(48,88,200),
            red = Color3.fromRGB(255,80,80),
            green = Color3.fromRGB(80,255,80),
            orange = Color3.fromRGB(255,160,40),
            border = Color3.fromRGB(80,80,80),
        }
        break
    end
end
if not C then
    C = {
        bg = Color3.fromRGB(18,16,30),
        card = Color3.fromRGB(30,28,45),
        text = Color3.fromRGB(255,255,255),
        textMid = Color3.fromRGB(200,200,200),
        textDim = Color3.fromRGB(150,150,150),
        blueD = Color3.fromRGB(48,88,200),
        red = Color3.fromRGB(255,80,80),
        green = Color3.fromRGB(80,255,80),
        orange = Color3.fromRGB(255,160,40),
        border = Color3.fromRGB(80,80,80),
    }
end

-- Fungsi helper UI
local function card(parent, h)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -24, 0, h or 46)
    f.BackgroundColor3 = C.card
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    return f
end

local function makeActionBtn(parent, text, color)
    local f = Instance.new("TextButton", parent)
    f.Size = UDim2.new(1, -24, 0, 36)
    f.BackgroundColor3 = color or C.blueD
    f.Font = Enum.Font.GothamBold
    f.TextSize = 12
    f.TextColor3 = C.text
    f.Text = text
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    return f
end

local function stepperRow(parent, y, lbl, minV, maxV, defV, unit)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -24, 0, 44)
    row.Position = UDim2.new(0, 12, 0, y)
    row.BackgroundColor3 = C.card
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local nm = Instance.new("TextLabel", row)
    nm.Size = UDim2.new(0.5, 0, 0, 20)
    nm.Position = UDim2.new(0, 10, 0, 2)
    nm.BackgroundTransparency = 1
    nm.Text = lbl
    nm.Font = Enum.Font.Gotham
    nm.TextSize = 10
    nm.TextColor3 = C.textDim
    nm.TextXAlignment = Enum.TextXAlignment.Left

    local curVal = defV
    local valL = Instance.new("TextLabel", row)
    valL.Size = UDim2.new(0, 50, 0, 24)
    valL.Position = UDim2.new(0.5, -25, 0, 18)
    valL.BackgroundTransparency = 1
    valL.Text = tostring(curVal) .. (unit or "")
    valL.Font = Enum.Font.GothamBold
    valL.TextSize = 13
    valL.TextColor3 = C.text
    valL.TextXAlignment = Enum.TextXAlignment.Center

    local minusW = Instance.new("Frame", row)
    minusW.Size = UDim2.new(0, 28, 0, 24)
    minusW.Position = UDim2.new(0.5, -25-34, 0, 18)
    minusW.BackgroundColor3 = C.blueD
    minusW.BorderSizePixel = 0
    Instance.new("UICorner", minusW).CornerRadius = UDim.new(0, 6)
    local minusB = Instance.new("TextButton", minusW)
    minusB.Size = UDim2.new(1, 0, 1, 0)
    minusB.BackgroundTransparency = 1
    minusB.Text = "−"
    minusB.Font = Enum.Font.GothamBold
    minusB.TextSize = 14
    minusB.TextColor3 = C.text

    local plusW = Instance.new("Frame", row)
    plusW.Size = UDim2.new(0, 28, 0, 24)
    plusW.Position = UDim2.new(0.5, 25+6, 0, 18)
    plusW.BackgroundColor3 = C.blueD
    plusW.BorderSizePixel = 0
    Instance.new("UICorner", plusW).CornerRadius = UDim.new(0, 6)
    local plusB = Instance.new("TextButton", plusW)
    plusB.Size = UDim2.new(1, 0, 1, 0)
    plusB.BackgroundTransparency = 1
    plusB.Text = "+"
    plusB.Font = Enum.Font.GothamBold
    plusB.TextSize = 14
    plusB.TextColor3 = C.text

    local function updateVal(v)
        curVal = math.clamp(v, minV, maxV)
        valL.Text = tostring(curVal) .. (unit or "")
    end

    minusB.MouseButton1Click:Connect(function() updateVal(curVal - 1) end)
    plusB.MouseButton1Click:Connect(function() updateVal(curVal + 1) end)

    return function() return curVal end
end

-- ========== VARIABLES FULLY NV ==========
local fullyRunning = false
local fullySelectedApart = nil
local fullySelectedPot = nil
local fullyTargetMS = 5
local fullyTotalCooked = 0
local fullyTotalSold = 0
local fullyStatusLabel = nil

-- Koordinat
local NPC_BUY_POS = Vector3.new(510.061, 4.476, 600.548)
local NPC_SELL_POS = Vector3.new(510.061, 4.476, 600.548)
local APART_ENTRY_POS = {
    ["APART CASINO 1"] = Vector3.new(1137.992, 9.932, 449.753),
    ["APART CASINO 2"] = Vector3.new(1139.174, 9.932, 420.556),
    ["APART CASINO 3"] = Vector3.new(984.856, 9.932, 247.280),
    ["APART CASINO 4"] = Vector3.new(988.311, 9.932, 221.664),
}

-- Koordinat masak apart
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

-- Fungsi helper Elixir (ambil dari Elixir yang sudah jalan)
local function equipItem(name)
    local char = player.Character
    local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
    if tool then
        char.Humanoid:EquipTool(tool)
        task.wait(0.3)
        return true
    end
end

local function countItemElixir(name)
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
    task.wait(0.3)
end

-- Blink system
local function blinkToTarget(targetPos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local maxDistance = 5
    local cooldown = 1
    while fullyRunning and (hrp.Position - targetPos).Magnitude > maxDistance do
        local direction = (targetPos - hrp.Position).Unit
        local newPos = hrp.Position + direction * maxDistance
        hrp.CFrame = CFrame.new(newPos)
        task.wait(cooldown)
        char = player.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then break end
    end
    if hrp then hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0)) end
    return true
end

-- Slow tween untuk apart
local function tweenToApart(targetCFrame)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tween = TweenService:Create(hrp, TweenInfo.new(2.0, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
    if hrp and (hrp.Position - targetCFrame.Position).Magnitude > 3 then
        hrp.CFrame = targetCFrame
    end
end

-- Proses masak di apart
local function cookAtApartment()
    local coords = apartCoords[fullySelectedApart]
    if not coords then return false end
    for i, stage in ipairs(coords) do
        if not fullyRunning then return false end
        if fullyStatusLabel then fullyStatusLabel.Text = "→ Tahap " .. i end
        if type(stage) == "table" then
            tweenToApart(fullySelectedPot == "KANAN" and stage.kanan or stage.kiri)
        else
            tweenToApart(stage)
        end
        spamE(10)
        task.wait(0.5)
    end
    if fullyStatusLabel then fullyStatusLabel.Text = "💧 Water (20 detik)..." end
    equipItem("Water"); spamE(10); task.wait(20)
    if not fullyRunning then return false end
    if fullyStatusLabel then fullyStatusLabel.Text = "🧂 Sugar..." end
    equipItem("Sugar Block Bag"); spamE(10); task.wait(1)
    if fullyStatusLabel then fullyStatusLabel.Text = "🟡 Gelatin..." end
    equipItem("Gelatin"); spamE(10); task.wait(1)
    if fullyStatusLabel then fullyStatusLabel.Text = "🔥 Cooking 45 detik..." end
    task.wait(45)
    if not fullyRunning then return false end
    if fullyStatusLabel then fullyStatusLabel.Text = "🎒 Take Marshmallow..." end
    equipItem("Empty Bag"); spamE(10); task.wait(1.5)
    fullyTotalCooked = fullyTotalCooked + 1
    return true
end

-- Beli bahan
local function buyIngredients(amount)
    if fullyStatusLabel then fullyStatusLabel.Text = "🛒 Membeli " .. amount .. " set..." end
    for i = 1, amount do
        if not fullyRunning then return false end
        pcall(function()
            buyRemote:FireServer("Water", 1); task.wait(0.4)
            buyRemote:FireServer("Sugar Block Bag", 1); task.wait(0.4)
            buyRemote:FireServer("Gelatin", 1); task.wait(0.4)
            buyRemote:FireServer("Empty Bag", 1); task.wait(0.5)
        end)
    end
    return true
end

-- Jual semua MS
local function sellAllMS()
    if fullyStatusLabel then fullyStatusLabel.Text = "💰 Menjual..." end
    local sold = 0
    local bags = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
    for _, bag in pairs(bags) do
        while fullyRunning and countItemElixir(bag) > 0 do
            if equipItem(bag) then spamE(10); task.wait(0.8); sold = sold + 1; fullyTotalSold = fullyTotalSold + 1 else break end
        end
    end
    return true
end

-- Loop utama
local function fullyNVLoop()
    while fullyRunning do
        if fullyStatusLabel then fullyStatusLabel.Text = "🚀 Ke NPC Beli..." end
        if not blinkToTarget(NPC_BUY_POS) then break end
        if not buyIngredients(fullyTargetMS) then break end
        local apartPos = APART_ENTRY_POS[fullySelectedApart]
        if fullyStatusLabel then fullyStatusLabel.Text = "🚀 Ke " .. fullySelectedApart .. "..." end
        if not blinkToTarget(apartPos) then break end
        for i = 1, fullyTargetMS do
            if not fullyRunning then break end
            if fullyStatusLabel then fullyStatusLabel.Text = "🔥 Masak " .. i .. "/" .. fullyTargetMS end
            if not cookAtApartment() then break end
        end
        if fullyStatusLabel then fullyStatusLabel.Text = "🚀 Ke NPC Jual..." end
        if not blinkToTarget(NPC_SELL_POS) then break end
        if not sellAllMS() then break end
        if fullyStatusLabel then fullyStatusLabel.Text = "🔄 Loop selesai, ulang..." end
        task.wait(1)
    end
    fullyRunning = false
    if fullyStatusLabel then fullyStatusLabel.Text = "⏹️ FULLY NV STOP" end
    if startBtn then startBtn.Visible = true end
    if stopBtn then stopBtn.Visible = false end
end

-- ========== BUAT HALAMAN FULLY NV ==========
if not pages["FULLY NV"] then
    local newPage = Instance.new("ScrollingFrame", content)
    newPage.Size = UDim2.new(1, 0, 1, 0)
    newPage.BackgroundTransparency = 1
    newPage.ScrollBarThickness = 3
    newPage.Visible = false
    newPage.BorderSizePixel = 0
    pages["FULLY NV"] = newPage
end

-- Buat tombol sidebar jika belum ada
if not tabBtns["FULLY NV"] then
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0, 68, 0, 36)
    btn.BackgroundTransparency = 1
    btn.Text = "FULLY NV"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = C.textDim
    btn.BorderSizePixel = 0
    btn.LayoutOrder = 8
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    tabBtns["FULLY NV"] = btn
    btn.MouseButton1Click:Connect(function()
        for n, p in pairs(pages) do p.Visible = (n == "FULLY NV") end
        for n, b in pairs(tabBtns) do
            if n == "FULLY NV" then
                b.BackgroundColor3 = C.blueD
                b.BackgroundTransparency = 0
                b.TextColor3 = C.text
            else
                b.BackgroundTransparency = 1
                b.TextColor3 = C.textDim
            end
        end
    end)
end

-- Hapus isi halaman FULLY NV yang lama
local fullyPage = pages["FULLY NV"]
for _, v in pairs(fullyPage:GetChildren()) do
    if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("TextButton") then
        v:Destroy()
    end
end

-- Scroll untuk konten
local scroll = Instance.new("ScrollingFrame", fullyPage)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 520)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3

-- Judul
local titleLabel = Instance.new("TextLabel", scroll)
titleLabel.Size = UDim2.new(1, 0, 0, 22)
titleLabel.Position = UDim2.new(0, 12, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "FULLY NV - AUTO APART CASINO"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 11
titleLabel.TextColor3 = C.text

-- Pilih Apart
local apartCard = card(scroll, 80)
apartCard.Position = UDim2.new(0, 12, 0, 35)
local apartLabel = Instance.new("TextLabel", apartCard)
apartLabel.Size = UDim2.new(1, 0, 0, 20)
apartLabel.Position = UDim2.new(0, 10, 0, 5)
apartLabel.BackgroundTransparency = 1
apartLabel.Text = "Pilih Apart Casino:"
apartLabel.Font = Enum.Font.GothamBold
apartLabel.TextSize = 12
apartLabel.TextColor3 = C.text

local apartDropdown = Instance.new("TextButton", apartCard)
apartDropdown.Size = UDim2.new(0.8, 0, 0, 32)
apartDropdown.Position = UDim2.new(0.1, 0, 0, 35)
apartDropdown.BackgroundColor3 = C.blueD
apartDropdown.Text = "Pilih Apart"
apartDropdown.TextColor3 = C.text
apartDropdown.Font = Enum.Font.GothamBold
apartDropdown.TextSize = 12
Instance.new("UICorner", apartDropdown).CornerRadius = UDim.new(0, 6)

local apartList = {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}
apartDropdown.MouseButton1Click:Connect(function()
    local menu = Instance.new("Frame", scroll)
    menu.Size = UDim2.new(0.8, 0, 0, 120)
    menu.Position = UDim2.new(0.1, 0, 0, 120)
    menu.BackgroundColor3 = C.card
    Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
    for i, name in ipairs(apartList) do
        local btn = Instance.new("TextButton", menu)
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
        btn.BackgroundTransparency = 1
        btn.Text = name
        btn.TextColor3 = C.text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.MouseButton1Click:Connect(function()
            fullySelectedApart = name
            apartDropdown.Text = name
            menu:Destroy()
        end)
    end
    task.delay(5, function() pcall(function() menu:Destroy() end) end)
end)

-- Pilih Pot
local potCard = card(scroll, 80)
potCard.Position = UDim2.new(0, 12, 0, 120)
local potLabel = Instance.new("TextLabel", potCard)
potLabel.Size = UDim2.new(1, 0, 0, 20)
potLabel.Position = UDim2.new(0, 10, 0, 5)
potLabel.BackgroundTransparency = 1
potLabel.Text = "Pilih Pot:"
potLabel.Font = Enum.Font.GothamBold
potLabel.TextSize = 12
potLabel.TextColor3 = C.text

local potKanan = Instance.new("TextButton", potCard)
potKanan.Size = UDim2.new(0.4, -5, 0, 32)
potKanan.Position = UDim2.new(0.05, 0, 0, 35)
potKanan.BackgroundColor3 = C.blueD
potKanan.Text = "KANAN"
potKanan.TextColor3 = C.text
potKanan.Font = Enum.Font.GothamBold
potKanan.TextSize = 12
Instance.new("UICorner", potKanan).CornerRadius = UDim.new(0, 6)

local potKiri = Instance.new("TextButton", potCard)
potKiri.Size = UDim2.new(0.4, -5, 0, 32)
potKiri.Position = UDim2.new(0.55, 0, 0, 35)
potKiri.BackgroundColor3 = C.card
potKiri.Text = "KIRI"
potKiri.TextColor3 = C.text
potKiri.Font = Enum.Font.GothamBold
potKiri.TextSize = 12
Instance.new("UICorner", potKiri).CornerRadius = UDim.new(0, 6)

potKanan.MouseButton1Click:Connect(function() fullySelectedPot = "KANAN" end)
potKiri.MouseButton1Click:Connect(function() fullySelectedPot = "KIRI" end)

-- Slider Jumlah MS
local getTargetMS = stepperRow(scroll, 210, "Target MS per Loop", 1, 50, 5, " MS")

-- Status
local statusCard = card(scroll, 50)
statusCard.Position = UDim2.new(0, 12, 0, 260)
fullyStatusLabel = Instance.new("TextLabel", statusCard)
fullyStatusLabel.Size = UDim2.new(1, -16, 1, 0)
fullyStatusLabel.Position = UDim2.new(0, 8, 0, 0)
fullyStatusLabel.BackgroundTransparency = 1
fullyStatusLabel.Text = "Belum dimulai"
fullyStatusLabel.Font = Enum.Font.Gotham
fullyStatusLabel.TextSize = 11
fullyStatusLabel.TextColor3 = C.textMid
fullyStatusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Statistik
local statCard = card(scroll, 80)
statCard.Position = UDim2.new(0, 12, 0, 315)
local totalCookedLabel = Instance.new("TextLabel", statCard)
totalCookedLabel.Size = UDim2.new(0.5, 0, 0, 20)
totalCookedLabel.Position = UDim2.new(0, 12, 0, 5)
totalCookedLabel.BackgroundTransparency = 1
totalCookedLabel.Text = "Total MS Dimasak:"
totalCookedLabel.Font = Enum.Font.GothamSemibold
totalCookedLabel.TextSize = 11
totalCookedLabel.TextColor3 = C.textMid

local totalCookedValue = Instance.new("TextLabel", statCard)
totalCookedValue.Size = UDim2.new(0.4, 0, 0, 20)
totalCookedValue.Position = UDim2.new(0.6, 0, 0, 5)
totalCookedValue.BackgroundTransparency = 1
totalCookedValue.Text = "0"
totalCookedValue.Font = Enum.Font.GothamBold
totalCookedValue.TextSize = 14
totalCookedValue.TextColor3 = C.text

local totalSoldLabel = Instance.new("TextLabel", statCard)
totalSoldLabel.Size = UDim2.new(0.5, 0, 0, 20)
totalSoldLabel.Position = UDim2.new(0, 12, 0, 30)
totalSoldLabel.BackgroundTransparency = 1
totalSoldLabel.Text = "Total MS Terjual:"
totalSoldLabel.Font = Enum.Font.GothamSemibold
totalSoldLabel.TextSize = 11
totalSoldLabel.TextColor3 = C.textMid

local totalSoldValue = Instance.new("TextLabel", statCard)
totalSoldValue.Size = UDim2.new(0.4, 0, 0, 20)
totalSoldValue.Position = UDim2.new(0.6, 0, 0, 30)
totalSoldValue.BackgroundTransparency = 1
totalSoldValue.Text = "0"
totalSoldValue.Font = Enum.Font.GothamBold
totalSoldValue.TextSize = 14
totalSoldValue.TextColor3 = C.text

-- Sisa Bahan
local bahanLabel = Instance.new("TextLabel", scroll)
bahanLabel.Size = UDim2.new(1, 0, 0, 22)
bahanLabel.Position = UDim2.new(0, 12, 0, 405)
bahanLabel.BackgroundTransparency = 1
bahanLabel.Text = "SISA BAHAN:"
bahanLabel.Font = Enum.Font.GothamBold
bahanLabel.TextSize = 10
bahanLabel.TextColor3 = C.textDim

local waterRow = card(scroll, 25)
waterRow.Position = UDim2.new(0, 12, 0, 430)
local waterLabel = Instance.new("TextLabel", waterRow)
waterLabel.Size = UDim2.new(0.5, 0, 1, 0)
waterLabel.Position = UDim2.new(0, 12, 0, 0)
waterLabel.BackgroundTransparency = 1
waterLabel.Text = "Water:"
waterLabel.Font = Enum.Font.GothamSemibold
waterLabel.TextSize = 11
waterLabel.TextColor3 = C.textMid

local waterValue = Instance.new("TextLabel", waterRow)
waterValue.Size = UDim2.new(0.4, 0, 1, 0)
waterValue.Position = UDim2.new(0.6, 0, 0, 0)
waterValue.BackgroundTransparency = 1
waterValue.Text = "0"
waterValue.Font = Enum.Font.GothamBold
waterValue.TextSize = 12
waterValue.TextColor3 = C.text

local sugarRow = card(scroll, 25)
sugarRow.Position = UDim2.new(0, 12, 0, 460)
local sugarLabel = Instance.new("TextLabel", sugarRow)
sugarLabel.Size = UDim2.new(0.5, 0, 1, 0)
sugarLabel.Position = UDim2.new(0, 12, 0, 0)
sugarLabel.BackgroundTransparency = 1
sugarLabel.Text = "Sugar Block Bag:"
sugarLabel.Font = Enum.Font.GothamSemibold
sugarLabel.TextSize = 11
sugarLabel.TextColor3 = C.textMid

local sugarValue = Instance.new("TextLabel", sugarRow)
sugarValue.Size = UDim2.new(0.4, 0, 1, 0)
sugarValue.Position = UDim2.new(0.6, 0, 0, 0)
sugarValue.BackgroundTransparency = 1
sugarValue.Text = "0"
sugarValue.Font = Enum.Font.GothamBold
sugarValue.TextSize = 12
sugarValue.TextColor3 = C.text

local gelatinRow = card(scroll, 25)
gelatinRow.Position = UDim2.new(0, 12, 0, 490)
local gelatinLabel = Instance.new("TextLabel", gelatinRow)
gelatinLabel.Size = UDim2.new(0.5, 0, 1, 0)
gelatinLabel.Position = UDim2.new(0, 12, 0, 0)
gelatinLabel.BackgroundTransparency = 1
gelatinLabel.Text = "Gelatin:"
gelatinLabel.Font = Enum.Font.GothamSemibold
gelatinLabel.TextSize = 11
gelatinLabel.TextColor3 = C.textMid

local gelatinValue = Instance.new("TextLabel", gelatinRow)
gelatinValue.Size = UDim2.new(0.4, 0, 1, 0)
gelatinValue.Position = UDim2.new(0.6, 0, 0, 0)
gelatinValue.BackgroundTransparency = 1
gelatinValue.Text = "0"
gelatinValue.Font = Enum.Font.GothamBold
gelatinValue.TextSize = 12
gelatinValue.TextColor3 = C.text

local emptyRow = card(scroll, 25)
emptyRow.Position = UDim2.new(0, 12, 0, 520)
local emptyLabel = Instance.new("TextLabel", emptyRow)
emptyLabel.Size = UDim2.new(0.5, 0, 1, 0)
emptyLabel.Position = UDim2.new(0, 12, 0, 0)
emptyLabel.BackgroundTransparency = 1
emptyLabel.Text = "Empty Bag:"
emptyLabel.Font = Enum.Font.GothamSemibold
emptyLabel.TextSize = 11
emptyLabel.TextColor3 = C.textMid

local emptyValue = Instance.new("TextLabel", emptyRow)
emptyValue.Size = UDim2.new(0.4, 0, 1, 0)
emptyValue.Position = UDim2.new(0.6, 0, 0, 0)
emptyValue.BackgroundTransparency = 1
emptyValue.Text = "0"
emptyValue.Font = Enum.Font.GothamBold
emptyValue.TextSize = 12
emptyValue.TextColor3 = C.text

-- Tombol Start/Stop
local btnFrame = Instance.new("Frame", scroll)
btnFrame.Size = UDim2.new(1, 0, 0, 50)
btnFrame.Position = UDim2.new(0, 0, 0, 555)
btnFrame.BackgroundTransparency = 1

local startBtn = makeActionBtn(btnFrame, "▶ START FULLY NV", C.blueD)
startBtn.Position = UDim2.new(0, 12, 0, 5)
startBtn.Size = UDim2.new(1, -24, 0, 36)

local stopBtn = makeActionBtn(btnFrame, "■ STOP FULLY NV", C.red)
stopBtn.Position = UDim2.new(0, 12, 0, 5)
stopBtn.Size = UDim2.new(1, -24, 0, 36)
stopBtn.Visible = false

startBtn.MouseButton1Click:Connect(function()
    if fullyRunning then return end
    if not fullySelectedApart then
        fullyStatusLabel.Text = "❌ Pilih apart casino dulu!"
        fullyStatusLabel.TextColor3 = C.red
        return
    end
    if not fullySelectedPot then
        fullyStatusLabel.Text = "❌ Pilih pot (KANAN/KIRI) dulu!"
        fullyStatusLabel.TextColor3 = C.red
        return
    end
    fullyTargetMS = getTargetMS()
    fullyRunning = true
    startBtn.Visible = false
    stopBtn.Visible = true
    fullyStatusLabel.Text = "✅ FULLY NV START"
    fullyStatusLabel.TextColor3 = C.green
    task.spawn(fullyNVLoop)
end)

stopBtn.MouseButton1Click:Connect(function()
    fullyRunning = false
    startBtn.Visible = true
    stopBtn.Visible = false
    fullyStatusLabel.Text = "⏹️ FULLY NV STOP"
    fullyStatusLabel.TextColor3 = C.orange
end)

-- Update statistik
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            totalCookedValue.Text = tostring(fullyTotalCooked)
            totalSoldValue.Text = tostring(fullyTotalSold)
            waterValue.Text = tostring(countItemElixir("Water"))
            sugarValue.Text = tostring(countItemElixir("Sugar Block Bag"))
            gelatinValue.Text = tostring(countItemElixir("Gelatin"))
            emptyValue.Text = tostring(countItemElixir("Empty Bag"))
        end)
    end
end)

print("[FULLY NV] Berhasil ditambahkan ke Elixir 3.5!")
print("Fitur Elixir lain tetap berfungsi. UNDERPOT tetap ada.")
