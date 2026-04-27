-- ELIXIR 3.5 - FULLY NV ONLY (FIX KOSONG)
local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TS = TweenService

repeat task.wait() until player.Character
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIR_FULLY_NV"
gui.ResetOnSpawn = false

local success = false
local coreGui = game:GetService("CoreGui")
if coreGui then pcall(function() gui.Parent = coreGui end) end
if not gui.Parent then pcall(function() gui.Parent = playerGui end) end
if not gui.Parent then return warn("GUI gagal dipasang") end

task.wait(0.2)

-- ============================================================
-- WARNA
-- ============================================================
local C = {
    bg = Color3.fromRGB(15, 15, 25),
    card = Color3.fromRGB(25, 25, 40),
    accent = Color3.fromRGB(100, 80, 255),
    accentDark = Color3.fromRGB(60, 40, 200),
    text = Color3.fromRGB(230, 230, 250),
    textDim = Color3.fromRGB(150, 150, 180),
    green = Color3.fromRGB(50, 200, 100),
    red = Color3.fromRGB(220, 60, 70),
    border = Color3.fromRGB(45, 45, 65),
}

-- ============================================================
-- HELPER UI
-- ============================================================
local function corner(p, r) Instance.new("UICorner", p).CornerRadius = UDim.new(0, r or 8) end
local function mkFrame(p, bg, zi) local f = Instance.new("Frame") f.BackgroundColor3 = bg or C.card f.BorderSizePixel = 0 f.ZIndex = zi or 2 if p then f.Parent = p end return f end
local function mkLabel(p, txt, col, font, xa, ts) local l = Instance.new("TextLabel") l.BackgroundTransparency = 1 l.Text = txt or "" l.TextColor3 = col or C.text l.Font = font or Enum.Font.GothamSemibold l.TextXAlignment = xa or Enum.TextXAlignment.Center l.TextSize = ts or 12 if p then l.Parent = p end return l end
local function mkBtn(p, txt, bg, col, ts) local b = Instance.new("TextButton") b.BackgroundColor3 = bg or C.accentDark b.Text = txt or "" b.TextColor3 = col or C.text b.Font = Enum.Font.GothamBold b.TextSize = ts or 12 b.BorderSizePixel = 0 if p then b.Parent = p end corner(b, 6) return b end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local main = mkFrame(gui, C.bg, 1)
main.Size = UDim2.new(0, 420, 0, 500)
main.Position = UDim2.new(0.5, -210, 0.5, -250)
main.Active = true
main.Draggable = true
corner(main, 12)

-- Title bar
local titleBar = mkFrame(main, C.card, 2)
titleBar.Size = UDim2.new(1, 0, 0, 40)
corner(titleBar, 12)
local titleLbl = mkLabel(titleBar, "FULLY NV - APART CASINO", C.text, Enum.Font.GothamBold, Enum.TextXAlignment.Center, 14)
titleLbl.Size = UDim2.new(1, 0, 1, 0)

local closeBtn = mkBtn(titleBar, "X", C.red, C.text, 12)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0.5, -15)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Content scroll
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, 0, 1, -40)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 550)
scroll.ScrollBarThickness = 4

local pad = Instance.new("UIPadding", scroll)
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingRight = UDim.new(0, 12)
pad.PaddingTop = UDim.new(0, 12)
pad.PaddingBottom = UDim.new(0, 12)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================================
-- DROPDOWN APART
-- ============================================================
local apartCard = mkFrame(scroll, C.card, 3)
apartCard.Size = UDim2.new(1, 0, 0, 60)
corner(apartCard, 10)

local apartLbl = mkLabel(apartCard, "Pilih Apartemen", C.textDim, Enum.Font.Gotham, Enum.TextXAlignment.Left, 11)
apartLbl.Size = UDim2.new(1, -20, 0, 20)
apartLbl.Position = UDim2.new(0, 10, 0, 5)

local apartValue = "APART CASINO 1"
local apartBtn = mkBtn(apartCard, apartValue, C.accentDark, C.text, 11)
apartBtn.Size = UDim2.new(1, -20, 0, 32)
apartBtn.Position = UDim2.new(0, 10, 0, 28)

local apartOptions = {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}
local apartMenu = nil
apartBtn.MouseButton1Click:Connect(function()
    if apartMenu then apartMenu:Destroy() end
    apartMenu = mkFrame(scroll, C.card, 10)
    apartMenu.Size = UDim2.new(0.8, 0, 0, 120)
    apartMenu.Position = UDim2.new(0, apartBtn.AbsolutePosition.X + 10, apartBtn.AbsolutePosition.Y + 40)
    corner(apartMenu, 8)
    for i, opt in ipairs(apartOptions) do
        local optBtn = mkBtn(apartMenu, opt, C.accentDark, C.text, 10)
        optBtn.Size = UDim2.new(1, -10, 0, 30)
        optBtn.Position = UDim2.new(0, 5, 0, (i-1)*32)
        optBtn.MouseButton1Click:Connect(function()
            apartValue = opt
            apartBtn.Text = apartValue
            apartMenu:Destroy()
            apartMenu = nil
        end)
    end
    task.delay(5, function() if apartMenu then apartMenu:Destroy() apartMenu = nil end end)
end)

-- ============================================================
-- DROPDOWN POT
-- ============================================================
local potCard = mkFrame(scroll, C.card, 3)
potCard.Size = UDim2.new(1, 0, 0, 60)
corner(potCard, 10)

local potLbl = mkLabel(potCard, "Pilih Pot (KANAN/KIRI)", C.textDim, Enum.Font.Gotham, Enum.TextXAlignment.Left, 11)
potLbl.Size = UDim2.new(1, -20, 0, 20)
potLbl.Position = UDim2.new(0, 10, 0, 5)

local potValue = "KANAN"
local potBtn = mkBtn(potCard, potValue, C.accentDark, C.text, 11)
potBtn.Size = UDim2.new(1, -20, 0, 32)
potBtn.Position = UDim2.new(0, 10, 0, 28)

local potOptions = {"KANAN", "KIRI"}
local potMenu = nil
potBtn.MouseButton1Click:Connect(function()
    if potMenu then potMenu:Destroy() end
    potMenu = mkFrame(scroll, C.card, 10)
    potMenu.Size = UDim2.new(0.5, 0, 0, 70)
    potMenu.Position = UDim2.new(0, potBtn.AbsolutePosition.X + 10, potBtn.AbsolutePosition.Y + 40)
    corner(potMenu, 8)
    for i, opt in ipairs(potOptions) do
        local optBtn = mkBtn(potMenu, opt, C.accentDark, C.text, 10)
        optBtn.Size = UDim2.new(1, -10, 0, 30)
        optBtn.Position = UDim2.new(0, 5, 0, (i-1)*32)
        optBtn.MouseButton1Click:Connect(function()
            potValue = opt
            potBtn.Text = potValue
            potMenu:Destroy()
            potMenu = nil
        end)
    end
    task.delay(5, function() if potMenu then potMenu:Destroy() potMenu = nil end end)
end)

-- ============================================================
-- BUTTON START / STOP
-- ============================================================
local btnCard = mkFrame(scroll, C.card, 3)
btnCard.Size = UDim2.new(1, 0, 0, 80)
corner(btnCard, 10)

local startBtn = mkBtn(btnCard, "▶ START FULLY", C.green, C.text, 14)
startBtn.Size = UDim2.new(0.45, -5, 0, 40)
startBtn.Position = UDim2.new(0, 10, 0.5, -20)

local stopBtn = mkBtn(btnCard, "■ STOP FULLY", C.red, C.text, 14)
stopBtn.Size = UDim2.new(0.45, -5, 0, 40)
stopBtn.Position = UDim2.new(0.55, 5, 0.5, -20)

-- ============================================================
-- STATUS
-- ============================================================
local statusCard = mkFrame(scroll, C.card, 3)
statusCard.Size = UDim2.new(1, 0, 0, 50)
corner(statusCard, 10)

local statusLbl = mkLabel(statusCard, "Status: Siap", C.text, Enum.Font.Gotham, Enum.TextXAlignment.Center, 12)
statusLbl.Size = UDim2.new(1, -20, 1, 0)

-- ============================================================
-- KOORDINAT (SEMUA APART)
-- ============================================================
local a1t1 = CFrame.new(1196.51,3.71,-241.13) * CFrame.Angles(-0,-0.05,0)
local a1t2 = CFrame.new(1199.75,3.71,-238.12) * CFrame.Angles(-0,-0.05,-0)
local a1t3 = CFrame.new(1199.74,6.59,-233.05) * CFrame.Angles(-0,0,-0)
local a1t4 = CFrame.new(1199.66,6.59,-227.75) * CFrame.Angles(0,-0,0)
local a1t5 = CFrame.new(1199.66,6.59,-227.75) * CFrame.Angles(0,-0,0)
local a1t6kiri = CFrame.new(1199.75,7.45,-217.66) * CFrame.Angles(0,-0.12,-0)
local a1t6kanan = CFrame.new(1199.91,7.56,-219.75) * CFrame.Angles(-0,0.05,0)
local a1t7kiri = CFrame.new(1199.38,15.96,-220.53) * CFrame.Angles(0,0.06,0)
local a1t7kanan = CFrame.new(1199.87,15.96,-215.33) * CFrame.Angles(0,0.05,0)

local a2t1 = CFrame.new(1186.34,3.71,-242.92) * CFrame.Angles(0,-0.06,0)
local a2t2 = CFrame.new(1183.00,6.59,-233.78) * CFrame.Angles(-0,0,0)
local a2t3 = CFrame.new(1182.70,7.32,-229.73) * CFrame.Angles(-0,-0.01,0)
local a2t4 = CFrame.new(1182.75,6.59,-224.78) * CFrame.Angles(-0,-0.01,0)
local a2t5kanan = CFrame.new(1183.43,15.96,-229.66) * CFrame.Angles(0,0.02,-0)
local a2t5kiri = CFrame.new(1183.22,15.96,-225.63) * CFrame.Angles(0,-0.04,-0)

local a3t1 = CFrame.new(1196.17,3.71,-205.72) * CFrame.Angles(0,-0.03,-0)
local a3t2 = CFrame.new(1199.76,3.71,-196.51) * CFrame.Angles(0,-0.04,0)
local a3t3 = CFrame.new(1199.69,6.59,-191.16) * CFrame.Angles(-0,-0.06,-0)
local a3t4 = CFrame.new(1199.42,6.59,-185.27) * CFrame.Angles(-0,0.01,0)
local a3t5 = CFrame.new(1199.42,6.59,-185.27) * CFrame.Angles(-0,0.01,0)
local a3t6kanan = CFrame.new(1199.95,7.07,-177.69) * CFrame.Angles(-0,0.01,0)
local a3t6kiri = CFrame.new(1199.95,7.07,-177.69) * CFrame.Angles(-0,0.01,0)
local a3t7kanan = CFrame.new(1199.55,15.96,-181.89) * CFrame.Angles(0,-0.09,0)
local a3t7kiri = CFrame.new(1199.46,15.96,-177.81) * CFrame.Angles(-0,-0.05,-0)

local a4t1 = CFrame.new(1187.70,3.71,-209.73) * CFrame.Angles(0,-0.03,0)
local a4t2 = CFrame.new(1182.27,3.71,-204.65) * CFrame.Angles(-0,0.09,-0)
local a4t3 = CFrame.new(1182.23,3.71,-198.77) * CFrame.Angles(0,-0.04,-0)
local a4t4 = CFrame.new(1183.06,6.59,-193.92) * CFrame.Angles(0,0.08,-0)
local a4t5kanan = CFrame.new(1182.60,7.56,-191.29) * CFrame.Angles(-0,-0.02,-0)
local a4t5kiri = CFrame.new(1183.36,6.72,-187.25) * CFrame.Angles(-0,-0.04,-0)
local a4t6kanan = CFrame.new(1183.24,15.96,-191.25) * CFrame.Angles(-0,-0.01,0)
local a4t6kiri = CFrame.new(1183.08,15.96,-187.36) * CFrame.Angles(-0,-0.05,-0)

-- ============================================================
-- FUNGSI GERAK
-- ============================================================
local function spamE()
    for i = 1, 3 do
        vim:SendKeyEvent(true, "E", false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, "E", false, game)
        task.wait(0.1)
    end
end

local function slowTween(cf, dur)
    dur = dur or 1.8
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local tw = TS:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Linear), {CFrame = cf})
        tw:Play()
        tw.Completed:Wait()
    end
end

local function blink(cf)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cf end
end

-- ============================================================
-- LOGIKA FULLY NV
-- ============================================================
local running = false

local function runFully()
    running = true
    startBtn.BackgroundColor3 = C.red
    startBtn.Text = "RUNNING..."
    stopBtn.BackgroundColor3 = C.accentDark
    statusLbl.Text = "Status: Running - " .. apartValue .. " - " .. potValue
    statusLbl.TextColor3 = C.green
    
    local stages = {}
    if apartValue == "APART CASINO 1" then
        if potValue == "KANAN" then stages = {a1t1,a1t2,a1t3,a1t4,a1t5,a1t6kanan,a1t7kanan}
        else stages = {a1t1,a1t2,a1t3,a1t4,a1t5,a1t6kiri,a1t7kiri} end
    elseif apartValue == "APART CASINO 2" then
        if potValue == "KANAN" then stages = {a2t1,a2t2,a2t3,a2t4,a2t5kanan}
        else stages = {a2t1,a2t2,a2t3,a2t4,a2t5kiri} end
    elseif apartValue == "APART CASINO 3" then
        if potValue == "KANAN" then stages = {a3t1,a3t2,a3t3,a3t4,a3t5,a3t6kanan,a3t7kanan}
        else stages = {a3t1,a3t2,a3t3,a3t4,a3t5,a3t6kiri,a3t7kiri} end
    elseif apartValue == "APART CASINO 4" then
        if potValue == "KANAN" then stages = {a4t1,a4t2,a4t3,a4t4,a4t5kanan,a4t6kanan}
        else stages = {a4t1,a4t2,a4t3,a4t4,a4t5kiri,a4t6kiri} end
    end
    
    for idx, cf in ipairs(stages) do
        if not running then break end
        local oldPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local oldVec = oldPos and oldPos.Position or Vector3.zero
        slowTween(cf, 1.8)
        task.wait(0.1)
        local newPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if newPos and (newPos.Position - oldVec).Magnitude < 1 then
            blink(cf)
        end
        spamE()
        statusLbl.Text = "Status: Tahap " .. idx .. "/" .. #stages
        task.wait(0.2)
    end
    
    running = false
    startBtn.BackgroundColor3 = C.green
    startBtn.Text = "▶ START FULLY"
    statusLbl.Text = "Status: Selesai"
    statusLbl.TextColor3 = C.text
end

-- ============================================================
-- EVENT BUTTON
-- ============================================================
startBtn.MouseButton1Click:Connect(function()
    if running then return end
    task.spawn(runFully)
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    startBtn.BackgroundColor3 = C.green
    startBtn.Text = "▶ START FULLY"
    statusLbl.Text = "Status: Dihentikan"
    statusLbl.TextColor3 = C.red
end)

-- ============================================================
-- DRAG
-- ============================================================
local dragStart, startPos, dragging = nil, nil, false
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function() dragging = false end)

print("[FULLY NV] LOADED - GUI LENGKAP")
