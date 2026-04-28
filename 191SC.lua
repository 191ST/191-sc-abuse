-- FULLY NV STANDALONE (COASTIFIED UI) - FIXED START/STOP
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

-- ========== VARIABEL ==========
local fullyRunning = false
local selectedApart = nil
local selectedPot = "KANAN"  -- default
local targetMS = 5
local totalCooked = 0
local totalSold = 0
local basePlate = nil

-- Koordinat NPC
local NPC_BUY = Vector3.new(510.061, 4.476, 600.548)
local NPC_SELL = Vector3.new(510.061, 4.476, 600.548)

-- Koordinat masuk apart
local APART_POS = {
    ["APART CASINO 1"] = Vector3.new(1137.992, 9.932, 449.753),
    ["APART CASINO 2"] = Vector3.new(1139.174, 9.932, 420.556),
    ["APART CASINO 3"] = Vector3.new(984.856, 9.932, 247.280),
    ["APART CASINO 4"] = Vector3.new(988.311, 9.932, 221.664),
}

-- Koordinat masak (lengkap semua apart)
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
end

-- ========== MASAK DI APART ==========
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
    
    -- Proses masak
    if statusLabel then statusLabel:SetText("💧 Water 20 detik...") end
    equip("Water")
    spamE(10)
    task.wait(20)
    if not fullyRunning then return false end
    
    if statusLabel then statusLabel:SetText("🧂 Sugar...") end
    equip("Sugar Block Bag")
    spamE(10)
    task.wait(1)
    
    if statusLabel then statusLabel:SetText("🟡 Gelatin...") end
    equip("Gelatin")
    spamE(10)
    task.wait(1)
    
    if statusLabel then statusLabel:SetText("🔥 Cooking 45 detik...") end
    task.wait(45)
    if not fullyRunning then return false end
    
    if statusLabel then statusLabel:SetText("🎒 Take...") end
    equip("Empty Bag")
    spamE(10)
    task.wait(1.5)
    
    totalCooked = totalCooked + 1
    return true
end

-- ========== BELI & JUAL ==========
local function buyIngredients(amount)
    if statusLabel then statusLabel:SetText("🛒 Beli " .. amount .. " set") end
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
    if statusLabel then statusLabel:SetText("💰 Menjual...") end
    local sold = 0
    local bags = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
    for _, bag in pairs(bags) do
        while fullyRunning and countItem(bag) > 0 do
            if equip(bag) then spamE(10) task.wait(0.8) sold = sold + 1 totalSold = totalSold + 1 else break end
        end
    end
    return true
end

-- ========== LOOP UTAMA ==========
local function mainLoop()
    while fullyRunning do
        if statusLabel then statusLabel:SetText("🚀 Ke NPC Beli") end
        teleportWithPlate(NPC_BUY)
        if not buyIngredients(targetMS) then break end
        
        if statusLabel then statusLabel:SetText("🚀 Ke " .. selectedApart) end
        teleportWithPlate(APART_POS[selectedApart])
        
        for i = 1, targetMS do
            if not fullyRunning then break end
            if statusLabel then statusLabel:SetText("🔥 Masak " .. i .. "/" .. targetMS) end
            if not cookAtApartment() then break end
        end
        
        if statusLabel then statusLabel:SetText("🚀 Ke NPC Jual") end
        teleportWithPlate(NPC_SELL)
        if not sellAll() then break end
        
        if statusLabel then statusLabel:SetText("🔄 Loop selesai") end
        task.wait(1)
    end
    fullyRunning = false
    if statusLabel then statusLabel:SetText("⏹️ STOPPED") end
    startBtn.Visible = true
    stopBtn.Visible = false
end

-- ========== LOAD UI COASTIFIED ==========
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/coastified/src.lua"))()
local Window = Lib:Window("FULLY NV", "Auto Apart Casino", Enum.KeyCode.RightShift)
local Tab = Window:Tab("FULLY NV")

-- Variabel UI
local statusLabel = nil
local startBtn = nil
local stopBtn = nil

-- Dropdown Pilih Apart
Tab:Dropdown("Pilih Apart", {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}, function(value)
    selectedApart = value
end)

-- Pilih Pot (KANAN / KIRI)
Tab:Dropdown("Pilih Pot", {"KANAN", "KIRI"}, function(value)
    selectedPot = value
end)

-- Slider Jumlah MS
Tab:Slider("Target MS per Loop", 1, 50, 5, function(value)
    targetMS = value
end)

-- Status label
statusLabel = Tab:Label("Belum dimulai")

-- Statistik
local cookedStat = Tab:Label("Total Dimasak: 0")
local soldStat = Tab:Label("Total Terjual: 0")
local bahanStat = Tab:Label("Bahan: -")

-- Tombol Start/Stop (menggunakan Button biasa, status disimpan di variabel terpisah)
local startButton
local stopButton

startButton = Tab:Button("▶ START FULLY NV", function()
    if fullyRunning then return end
    if not selectedApart then
        statusLabel:SetText("❌ Pilih apart casino dulu!")
        return
    end
    if not selectedPot then
        statusLabel:SetText("❌ Pilih pot dulu!")
        return
    end
    
    createBasePlate()
    fullyRunning = true
    statusLabel:SetText("✅ RUNNING")
    startButton.Visible = false
    if stopButton then stopButton.Visible = true end
    task.spawn(mainLoop)
end)

stopButton = Tab:Button("■ STOP FULLY NV", function()
    fullyRunning = false
    statusLabel:SetText("⏹️ STOPPED")
    startButton.Visible = true
    stopButton.Visible = false
end)
stopButton.Visible = false

-- Update statistik setiap detik
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            cookedStat:SetText("Total Dimasak: " .. totalCooked)
            soldStat:SetText("Total Terjual: " .. totalSold)
            local w = countItem("Water")
            local s = countItem("Sugar Block Bag")
            local g = countItem("Gelatin")
            local e = countItem("Empty Bag")
            bahanStat:SetText(string.format("Bahan: 💧%d 🧂%d 🟡%d 🎒%d", w, s, g, e))
        end)
    end
end)

print("✅ FULLY NV READY. Tekan RightShift untuk buka menu.")
print("✅ Pilih apart, pilih pot, atur target MS, lalu klik START.")
