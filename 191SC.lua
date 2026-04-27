-- FULLY NV ADDER (JALANKAN SETELAH ELIXIR 3.5 LOAD)
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

local function equip(name)
    local char = player.Character
    local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
    if tool then char.Humanoid:EquipTool(tool) task.wait(.3) return true end
end

local function countItem(name)
    local t = 0
    for _,v in pairs(player.Backpack:GetChildren()) do if v.Name == name then t = t + 1 end end
    for _,v in pairs(player.Character:GetChildren()) do if v:IsA("Tool") and v.Name == name then t = t + 1 end end
    return t
end

-- CARI GUI ELIXIR YANG SUDAH ADA
local elixirGui = nil
for _, v in pairs(game.CoreGui:GetChildren()) do if v.Name == "ELIXIR_3_5" then elixirGui = v end end
if not elixirGui then for _, v in pairs(player.PlayerGui:GetChildren()) do if v.Name == "ELIXIR_3_5" then elixirGui = v end end end
if not elixirGui then warn("ELIXIR GUI tidak ditemukan! Jalankan Elixir dulu.") return end

-- CARI SIDEBAR DAN CONTENT
local sidebar = nil
local content = nil
local pages = nil
local tabBtns = nil
local tabDefs = nil
local C = nil

for _, v in pairs(elixirGui:GetDescendants()) do
    if v.Name == "sidebar" and v:IsA("Frame") then sidebar = v end
    if v.Name == "content" and v:IsA("Frame") then content = v end
    if v:IsA("Frame") and v:FindFirstChildWhichIsA("UIListLayout") then
        for _, child in pairs(v:GetChildren()) do
            if child:IsA("ScrollingFrame") and child.Name ~= "sidebar" then
                if not pages then pages = {} end
                if not tabBtns then tabBtns = {} end
            end
        end
    end
end

if not sidebar or not content then warn("Tidak bisa menemukan sidebar/content") return end

-- BUAT WARNA (ambil dari GUI)
local C = {bg=Color3.fromRGB(8,7,14),surface=Color3.fromRGB(14,12,24),panel=Color3.fromRGB(18,16,30),card=Color3.fromRGB(24,21,40),sidebar=Color3.fromRGB(11,9,20),accent=Color3.fromRGB(130,60,240),accentDim=Color3.fromRGB(75,35,140),accentGlow=Color3.fromRGB(175,120,255),accentSoft=Color3.fromRGB(100,55,190),text=Color3.fromRGB(220,215,245),textMid=Color3.fromRGB(145,138,175),textDim=Color3.fromRGB(75,68,100),green=Color3.fromRGB(55,200,110),red=Color3.fromRGB(220,60,75),border=Color3.fromRGB(38,32,62),blueD=Color3.fromRGB(48,88,200),blue=Color3.fromRGB(82,130,255),orange=Color3.fromRGB(255,160,40),purple=Color3.fromRGB(148,80,255),cyan=Color3.fromRGB(50,210,230),txt=Color3.fromRGB(230,232,240)}

-- BUAT HALAMAN FULLY NV
local fullyPage = Instance.new("ScrollingFrame", content)
fullyPage.Size = UDim2.new(1,0,1,0)
fullyPage.BackgroundTransparency = 1
fullyPage.ScrollBarThickness = 3
fullyPage.Visible = false
fullyPage.BorderSizePixel = 0
local layout = Instance.new("UIListLayout", fullyPage)
layout.Padding = UDim.new(0,7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
local pad = Instance.new("UIPadding", fullyPage)
pad.PaddingTop = UDim.new(0,14)
pad.PaddingLeft = UDim.new(0,12)
pad.PaddingRight = UDim.new(0,12)
pad.PaddingBottom = UDim.new(0,14)

-- SAVE KE GLOBAL
_G.fullyPage = fullyPage

-- BUAT TOMBOL SIDEBAR
local btn = Instance.new("TextButton", sidebar)
btn.Size = UDim2.new(0,68,0,36)
btn.BackgroundTransparency = 1
btn.Text = "FULLY NV"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 10
btn.TextColor3 = C.textDim
btn.BorderSizePixel = 0
btn.LayoutOrder = 8
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
local indicator = Instance.new("Frame", btn)
indicator.Size = UDim2.new(0,2,0,18)
indicator.Position = UDim2.new(0,0,0.5,-9)
indicator.BackgroundColor3 = C.accent
indicator.BorderSizePixel = 0
indicator.Visible = false
Instance.new("UICorner", indicator).CornerRadius = UDim.new(0,2)

-- UPDATE FUNCTION UNTUK PAGE
local oldSwitch = nil
for _, v in pairs(getfenv().script:GetDescendants()) do
    if type(v) == "function" and string.find(tostring(v), "switchTab") then
        oldSwitch = v
        break
    end
end

btn.MouseButton1Click:Connect(function()
    -- HIDE ALL PAGES
    for _, p in pairs(content:GetChildren()) do
        if p:IsA("ScrollingFrame") then p.Visible = false end
    end
    fullyPage.Visible = true
    for _, b in pairs(sidebar:GetChildren()) do
        if b:IsA("TextButton") then
            if b == btn then
                b.BackgroundColor3 = C.accentDim
                b.BackgroundTransparency = 0
                b.TextColor3 = C.accentGlow
            else
                b.BackgroundTransparency = 1
                b.TextColor3 = C.textDim
            end
        end
    end
end)

-- ============================================================
-- ISI HALAMAN FULLY NV
-- ============================================================
local NPC_BUY = Vector3.new(510.061, 4.476, 600.548)
local NPC_SELL = Vector3.new(510.061, 4.476, 600.548)
local APART_POS = {
    ["APART CASINO 1"] = Vector3.new(1137.992, 9.932, 449.753),
    ["APART CASINO 2"] = Vector3.new(1139.174, 9.932, 420.556),
    ["APART CASINO 3"] = Vector3.new(984.856, 9.932, 247.280),
    ["APART CASINO 4"] = Vector3.new(988.311, 9.932, 221.664),
}

local fullyRun = false
local fullyApart = nil
local fullyPot = nil
local fullyQty = 5
local fullyCooked = 0
local fullySold = 0
local fullyStatusLabel = nil

local function setFStat(msg, col) if fullyStatusLabel then fullyStatusLabel.Text = msg fullyStatusLabel.TextColor3 = col or C.textMid end end

local function ragdollTP(pos)
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not h then return false end
    h.Health = 1
    task.wait(0.2)
    local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if r then r.CFrame = CFrame.new(pos + Vector3.new(0,2,0)) end
    for i = 6,1,-1 do if not fullyRun then return false end setFStat("Tunggu "..i.." detik", C.orange) task.wait(1) end
    return true
end

local function tweenTo(cf, dur)
    local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local t = TweenService:Create(r, TweenInfo.new(dur or 2, Enum.EasingStyle.Linear), {CFrame = cf})
    t:Play()
    t.Completed:Wait()
end

local function blinkTo(cf)
    tweenTo(cf, 2)
    task.wait(0.3)
    local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if r and (r.Position - cf.Position).Magnitude > 3 then r.CFrame = cf end
end

local function spamE(t) for _ = 1, (t or 3) do vim:SendKeyEvent(true, Enum.KeyCode.E, false, game) task.wait(0.1) vim:SendKeyEvent(false, Enum.KeyCode.E, false, game) task.wait(0.05) end end

local coords = {
    ["APART CASINO 1"] = {
        CFrame.new(1196.51,3.71,-241.13)*CFrame.Angles(-0,-0.05,0),
        CFrame.new(1199.75,3.71,-238.12)*CFrame.Angles(-0,-0.05,-0),
        CFrame.new(1199.74,6.59,-233.05)*CFrame.Angles(-0,0,-0),
        CFrame.new(1199.66,6.59,-227.75)*CFrame.Angles(0,-0,0),
        {kiri=CFrame.new(1199.95,7.07,-177.69)*CFrame.Angles(-0,0.01,0), kanan=CFrame.new(1199.66,6.59,-227.75)*CFrame.Angles(0,-0,0)},
        {kiri=CFrame.new(1199.46,15.96,-177.81)*CFrame.Angles(-0,-0.05,-0), kanan=CFrame.new(1199.55,15.96,-181.89)*CFrame.Angles(0,-0.09,0)},
        CFrame.new(1199.87,15.96,-215.33)*CFrame.Angles(0,0.05,0),
    },
    ["APART CASINO 2"] = {
        CFrame.new(1186.34,3.71,-242.92)*CFrame.Angles(0,-0.06,0),
        CFrame.new(1183,6.59,-233.78)*CFrame.Angles(-0,0,0),
        CFrame.new(1182.7,7.32,-229.73)*CFrame.Angles(-0,-0.01,0),
        CFrame.new(1182.75,6.59,-224.78)*CFrame.Angles(-0,-0.01,0),
        {kiri=CFrame.new(1183.22,15.96,-225.63)*CFrame.Angles(0,-0.04,-0), kanan=CFrame.new(1183.43,15.96,-229.66)*CFrame.Angles(0,0.02,-0)},
    },
    ["APART CASINO 3"] = {
        CFrame.new(1196.17,3.71,-205.72)*CFrame.Angles(0,-0.03,-0),
        CFrame.new(1199.76,3.71,-196.51)*CFrame.Angles(0,-0.04,0),
        CFrame.new(1199.69,6.59,-191.16)*CFrame.Angles(-0,-0.06,-0),
        CFrame.new(1199.42,6.59,-185.27)*CFrame.Angles(-0,0.01,0),
        {kiri=CFrame.new(1199.95,7.07,-177.69)*CFrame.Angles(-0,0.01,0), kanan=CFrame.new(1199.42,6.59,-185.27)*CFrame.Angles(-0,0.01,0)},
        {kiri=CFrame.new(1199.46,15.96,-177.81)*CFrame.Angles(-0,-0.05,-0), kanan=CFrame.new(1199.55,15.96,-181.89)*CFrame.Angles(0,-0.09,0)},
    },
    ["APART CASINO 4"] = {
        CFrame.new(1187.7,3.71,-209.73)*CFrame.Angles(0,-0.03,0),
        CFrame.new(1182.27,3.71,-204.65)*CFrame.Angles(-0,0.09,-0),
        CFrame.new(1182.23,3.71,-198.77)*CFrame.Angles(0,-0.04,-0),
        CFrame.new(1183.06,6.59,-193.92)*CFrame.Angles(0,0.08,-0),
        {kiri=CFrame.new(1183.36,6.72,-187.25)*CFrame.Angles(-0,-0.04,-0), kanan=CFrame.new(1182.6,7.56,-191.29)*CFrame.Angles(-0,-0.02,-0)},
        {kiri=CFrame.new(1183.08,15.96,-187.36)*CFrame.Angles(-0,-0.05,-0), kanan=CFrame.new(1183.24,15.96,-191.25)*CFrame.Angles(-0,-0.01,0)},
    },
}

local function cookAtApart()
    local c = coords[fullyApart]
    if not c then return false end
    for i, stage in ipairs(c) do
        if not fullyRun then return false end
        if type(stage) == "table" then
            blinkTo(fullyPot == "KANAN" and stage.kanan or stage.kiri)
        else
            blinkTo(stage)
        end
        spamE(3)
        task.wait(0.5)
    end
    setFStat("💧 Water...", C.blue)
    spamE(3)
    task.wait(20)
    if not fullyRun then return false end
    setFStat("🧂 Sugar...", C.orange)
    spamE(3)
    task.wait(1)
    setFStat("🟡 Gelatin...", C.purple)
    spamE(3)
    task.wait(1)
    setFStat("🔥 Cooking 45s...", C.red)
    task.wait(45)
    if not fullyRun then return false end
    setFStat("🎒 Take...", C.green)
    spamE(3)
    task.wait(1.5)
    fullyCooked = fullyCooked + 1
    return true
end

local function buyStuff(amt)
    setFStat("🛒 Buying "..amt.." sets", C.blue)
    for i = 1, amt do
        if not fullyRun then return false end
        pcall(function()
            buyRemote:FireServer("Water",1) task.wait(0.4)
            buyRemote:FireServer("Sugar Block Bag",1) task.wait(0.4)
            buyRemote:FireServer("Gelatin",1) task.wait(0.4)
            buyRemote:FireServer("Empty Bag",1) task.wait(0.5)
        end)
    end
    setFStat("✅ Bought "..amt.." sets", C.green)
    return true
end

local function sellAll()
    setFStat("💰 Selling...", C.green)
    local s = 0
    for _, bag in pairs({"Small Marshmallow Bag","Medium Marshmallow Bag","Large Marshmallow Bag"}) do
        while fullyRun and countItem(bag) > 0 do
            if equip(bag) then spamE(2) task.wait(0.8) s = s + 1 fullySold = fullySold + 1 else break end
        end
    end
    setFStat("✅ Sold "..s.." MS", C.green)
    return true
end

local function fullyLoop()
    while fullyRun do
        setFStat("🚀 Ragdoll to NPC Buy", C.orange)
        if not ragdollTP(NPC_BUY) then break end
        if not buyStuff(fullyQty) then break end
        setFStat("🚀 Ragdoll to "..fullyApart, C.orange)
        if not ragdollTP(APART_POS[fullyApart]) then break end
        for i = 1, fullyQty do
            if not fullyRun then break end
            setFStat("🔥 Cook "..i.."/"..fullyQty, C.cyan)
            if not cookAtApart() then break end
        end
        setFStat("🚀 Ragdoll to NPC Sell", C.orange)
        if not ragdollTP(NPC_SELL) then break end
        if not sellAll() then break end
        setFStat("🔄 Loop done", C.green)
        task.wait(1)
    end
    fullyRun = false
    setFStat("⏹️ STOPPED", C.red)
end

-- BUILD UI
local function makeActionBtn(parent, text, color)
    local f = Instance.new("TextButton", parent)
    f.Size = UDim2.new(1,-24,0,36)
    f.Position = UDim2.new(0,12,0,0)
    f.BackgroundColor3 = color or C.accentDim
    f.Font = Enum.Font.GothamBold
    f.TextSize = 12
    f.TextColor3 = C.text
    f.Text = text
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke", f)
    s.Color = C.border
    s.Thickness = 1
    return f
end

local scr = Instance.new("ScrollingFrame", fullyPage)
scr.Size = UDim2.new(1,0,1,0)
scr.CanvasSize = UDim2.new(0,0,0,450)
scr.BackgroundTransparency = 1
scr.ScrollBarThickness = 3

local function sec(txt, y) local l = Instance.new("TextLabel", scr) l.Size = UDim2.new(1,0,0,22) l.Position = UDim2.new(0,0,0,y) l.BackgroundTransparency = 1 l.Text = txt:upper() l.Font = Enum.Font.GothamBold l.TextSize = 9 l.TextColor3 = C.textDim l.TextXAlignment = Enum.TextXAlignment.Left end

sec("FULLY NV - AUTO APART CASINO", 8)

local apartCard = Instance.new("Frame", scr)
apartCard.Size = UDim2.new(1,-24,0,80)
apartCard.Position = UDim2.new(0,12,0,30)
apartCard.BackgroundColor3 = C.card
Instance.new("UICorner", apartCard).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", apartCard).Color = C.border

local apartL = Instance.new("TextLabel", apartCard)
apartL.Size = UDim2.new(1,0,0,20)
apartL.Position = UDim2.new(0,10,0,5)
apartL.BackgroundTransparency = 1
apartL.Text = "Pilih Apart:"
apartL.Font = Enum.Font.GothamBold
apartL.TextSize = 11
apartL.TextColor3 = C.text

local apartDrop = Instance.new("TextButton", apartCard)
apartDrop.Size = UDim2.new(0.8,0,0,32)
apartDrop.Position = UDim2.new(0.1,0,0,30)
apartDrop.BackgroundColor3 = C.blueD
apartDrop.Text = "Pilih Apart"
apartDrop.TextColor3 = C.text
apartDrop.Font = Enum.Font.GothamBold
Instance.new("UICorner", apartDrop).CornerRadius = UDim.new(0,6)
apartDrop.MouseButton1Click:Connect(function()
    local m = Instance.new("Frame", scr)
    m.Size = UDim2.new(0.8,0,0,120)
    m.Position = UDim2.new(0.1,0,0,110)
    m.BackgroundColor3 = C.surface
    Instance.new("UICorner", m).CornerRadius = UDim.new(0,8)
    for i, n in ipairs({"APART CASINO 1","APART CASINO 2","APART CASINO 3","APART CASINO 4"}) do
        local b = Instance.new("TextButton", m)
        b.Size = UDim2.new(1,0,0,28)
        b.Position = UDim2.new(0,0,0,(i-1)*30)
        b.BackgroundTransparency = 1
        b.Text = n
        b.TextColor3 = C.text
        b.Font = Enum.Font.Gotham
        b.TextSize = 11
        b.MouseButton1Click:Connect(function()
            fullyApart = n
            apartDrop.Text = n
            m:Destroy()
        end)
    end
    task.delay(5, function() pcall(function() m:Destroy() end) end)
end)

local potCard = Instance.new("Frame", scr)
potCard.Size = UDim2.new(1,-24,0,80)
potCard.Position = UDim2.new(0,12,0,115)
potCard.BackgroundColor3 = C.card
Instance.new("UICorner", potCard).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", potCard).Color = C.border

local potL = Instance.new("TextLabel", potCard)
potL.Size = UDim2.new(1,0,0,20)
potL.Position = UDim2.new(0,10,0,5)
potL.BackgroundTransparency = 1
potL.Text = "Pilih Pot:"
potL.Font = Enum.Font.GothamBold
potL.TextSize = 11
potL.TextColor3 = C.text

local kanan = Instance.new("TextButton", potCard)
kanan.Size = UDim2.new(0.4,-10,0,32)
kanan.Position = UDim2.new(0.05,0,0,30)
kanan.BackgroundColor3 = C.blueD
kanan.Text = "POT KANAN"
kanan.TextColor3 = C.text
kanan.Font = Enum.Font.GothamBold
Instance.new("UICorner", kanan).CornerRadius = UDim.new(0,6)

local kiri = Instance.new("TextButton", potCard)
kiri.Size = UDim2.new(0.4,-10,0,32)
kiri.Position = UDim2.new(0.55,0,0,30)
kiri.BackgroundColor3 = C.card
kiri.Text = "POT KIRI"
kiri.TextColor3 = C.text
kiri.Font = Enum.Font.GothamBold
Instance.new("UICorner", kiri).CornerRadius = UDim.new(0,6)

kanan.MouseButton1Click:Connect(function() fullyPot = "KANAN" TweenService:Create(kanan, TweenInfo.new(0.1), {BackgroundColor3 = C.blueD}):Play() TweenService:Create(kiri, TweenInfo.new(0.1), {BackgroundColor3 = C.card}):Play() end)
kiri.MouseButton1Click:Connect(function() fullyPot = "KIRI" TweenService:Create(kiri, TweenInfo.new(0.1), {BackgroundColor3 = C.blueD}):Play() TweenService:Create(kanan, TweenInfo.new(0.1), {BackgroundColor3 = C.card}):Play() end)

local qtyRow = Instance.new("Frame", scr)
qtyRow.Size = UDim2.new(1,-24,0,44)
qtyRow.Position = UDim2.new(0,12,0,200)
qtyRow.BackgroundColor3 = C.card
Instance.new("UICorner", qtyRow).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", qtyRow).Color = C.border

local qtyL = Instance.new("TextLabel", qtyRow)
qtyL.Size = UDim2.new(0.5,0,0,20)
qtyL.Position = UDim2.new(0,10,0,2)
qtyL.BackgroundTransparency = 1
qtyL.Text = "Jumlah Set per Loop"
qtyL.Font = Enum.Font.Gotham
qtyL.TextSize = 10
qtyL.TextColor3 = C.textMid
qtyL.TextXAlignment = Enum.TextXAlignment.Left

local qtyVal = 5
local qtyVall = Instance.new("TextLabel", qtyRow)
qtyVall.Size = UDim2.new(0,50,0,24)
qtyVall.Position = UDim2.new(0.5,-25,0,18)
qtyVall.BackgroundTransparency = 1
qtyVall.Text = "5 x"
qtyVall.Font = Enum.Font.GothamBold
qtyVall.TextSize = 13
qtyVall.TextColor3 = C.text
qtyVall.TextXAlignment = Enum.TextXAlignment.Center

local minusW = Instance.new("Frame", qtyRow)
minusW.Size = UDim2.new(0,28,0,24)
minusW.Position = UDim2.new(0.5,-25-34,0,18)
minusW.BackgroundColor3 = C.blueD
Instance.new("UICorner", minusW).CornerRadius = UDim.new(0,6)
local minusB = Instance.new("TextButton", minusW)
minusB.Size = UDim2.new(1,0,1,0)
minusB.BackgroundTransparency = 1
minusB.Text = "−"
minusB.Font = Enum.Font.GothamBold
minusB.TextSize = 14
minusB.TextColor3 = C.txt

local plusW = Instance.new("Frame", qtyRow)
plusW.Size = UDim2.new(0,28,0,24)
plusW.Position = UDim2.new(0.5,25+6,0,18)
plusW.BackgroundColor3 = C.blueD
Instance.new("UICorner", plusW).CornerRadius = UDim.new(0,6)
local plusB = Instance.new("TextButton", plusW)
plusB.Size = UDim2.new(1,0,1,0)
plusB.BackgroundTransparency = 1
plusB.Text = "+"
plusB.Font = Enum.Font.GothamBold
plusB.TextSize = 14
plusB.TextColor3 = C.txt

minusB.MouseButton1Click:Connect(function() qtyVal = math.max(1, qtyVal-1) qtyVall.Text = qtyVal.." x" end)
plusB.MouseButton1Click:Connect(function() qtyVal = math.min(50, qtyVal+1) qtyVall.Text = qtyVal.." x" end)

local statCard = Instance.new("Frame", scr)
statCard.Size = UDim2.new(1,-24,0,50)
statCard.Position = UDim2.new(0,12,0,250)
statCard.BackgroundColor3 = C.card
Instance.new("UICorner", statCard).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", statCard).Color = C.border

fullyStatusLabel = Instance.new("TextLabel", statCard)
fullyStatusLabel.Size = UDim2.new(1,-16,1,0)
fullyStatusLabel.Position = UDim2.new(0,8,0,0)
fullyStatusLabel.BackgroundTransparency = 1
fullyStatusLabel.Text = "Belum dimulai"
fullyStatusLabel.Font = Enum.Font.Gotham
fullyStatusLabel.TextSize = 11
fullyStatusLabel.TextColor3 = C.textMid
fullyStatusLabel.TextXAlignment = Enum.TextXAlignment.Center

local cookedRow = Instance.new("Frame", scr)
cookedRow.Size = UDim2.new(1,-24,0,30)
cookedRow.Position = UDim2.new(0,12,0,306)
cookedRow.BackgroundColor3 = C.card
Instance.new("UICorner", cookedRow).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", cookedRow).Color = C.border
local cookedL = Instance.new("TextLabel", cookedRow)
cookedL.Size = UDim2.new(0.6,0,1,0)
cookedL.Position = UDim2.new(0,12,0,0)
cookedL.BackgroundTransparency = 1
cookedL.Text = "Total MS Dimasak"
cookedL.Font = Enum.Font.GothamSemibold
cookedL.TextSize = 11
cookedL.TextColor3 = C.textMid
cookedL.TextXAlignment = Enum.TextXAlignment.Left
local cookedV = Instance.new("TextLabel", cookedRow)
cookedV.Size = UDim2.new(0.4,-10,1,0)
cookedV.Position = UDim2.new(0.6,0,0,0)
cookedV.BackgroundTransparency = 1
cookedV.Text = "0"
cookedV.Font = Enum.Font.GothamBold
cookedV.TextSize = 12
cookedV.TextColor3 = C.accentGlow
cookedV.TextXAlignment = Enum.TextXAlignment.Right

local soldRow = Instance.new("Frame", scr)
soldRow.Size = UDim2.new(1,-24,0,30)
soldRow.Position = UDim2.new(0,12,0,342)
soldRow.BackgroundColor3 = C.card
Instance.new("UICorner", soldRow).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", soldRow).Color = C.border
local soldL = Instance.new("TextLabel", soldRow)
soldL.Size = UDim2.new(0.6,0,1,0)
soldL.Position = UDim2.new(0,12,0,0)
soldL.BackgroundTransparency = 1
soldL.Text = "Total MS Terjual"
soldL.Font = Enum.Font.GothamSemibold
soldL.TextSize = 11
soldL.TextColor3 = C.textMid
soldL.TextXAlignment = Enum.TextXAlignment.Left
local soldV = Instance.new("TextLabel", soldRow)
soldV.Size = UDim2.new(0.4,-10,1,0)
soldV.Position = UDim2.new(0.6,0,0,0)
soldV.BackgroundTransparency = 1
soldV.Text = "0"
soldV.Font = Enum.Font.GothamBold
soldV.TextSize = 12
soldV.TextColor3 = C.accentGlow
soldV.TextXAlignment = Enum.TextXAlignment.Right

local startB = makeActionBtn(scr, "▶ START FULLY NV", C.blueD)
startB.Position = UDim2.new(0,12,0,380)
local stopB = makeActionBtn(scr, "■ STOP FULLY NV", C.red)
stopB.Position = UDim2.new(0,12,0,380)
stopB.Visible = false

startB.MouseButton1Click:Connect(function()
    if fullyRun then return end
    if not fullyApart then setFStat("❌ Pilih apart!", C.red) return end
    if not fullyPot then setFStat("❌ Pilih pot!", C.red) return end
    fullyRun = true
    fullyQty = qtyVal
    startB.Visible = false
    stopB.Visible = true
    setFStat("✅ START", C.green)
    task.spawn(fullyLoop)
end)
stopB.MouseButton1Click:Connect(function()
    fullyRun = false
    startB.Visible = true
    stopB.Visible = false
    setFStat("⏹️ STOP", C.orange)
end)

task.spawn(function()
    while wait(0.5) do
        pcall(function()
            cookedV.Text = tostring(fullyCooked)
            soldV.Text = tostring(fullySold)
        end)
    end
end)

print("[FULLY NV] Berhasil ditambahkan! Klik tab FULLY NV di sidebar.")
