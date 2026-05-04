-- ELIXIR 3.5 -- FULLY NV + AUTO BASEPLATE 2999x2999
local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local ContextActionService = game:GetService("ContextActionService")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

repeat task.wait() until player.Character

local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- VARIABLES
-- ============================================================
local running = false
local autoSellEnabled = false
local buyAmount = 1
local autoFarmRunning = false
local autoFarmStopping = false
local cookAmount = 5
local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase
local npcPos = CFrame.new(510.762817,3.58721066,600.791504)
local tierPos = CFrame.new(1110.18726,4.28433371,117.139168)
local fullyRunningNV = false
local fullyTargetNV = 5
local selectedApartNV = "APART CASINO 1"
local selectedPotNV = "KANAN"
local baseplateSpawned = false
local currentBaseplate = nil

-- ============================================================
-- ANTI AFK
-- ============================================================
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ============================================================
-- HELPERS
-- ============================================================
local function holdE(t)
    vim:SendKeyEvent(true,"E",false,game)
    task.wait(t)
    vim:SendKeyEvent(false,"E",false,game)
end

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
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v.Name == name then total += 1 end
    end
    for _,v in pairs(player.Character:GetChildren()) do
        if v:IsA("Tool") and v.Name == name then total += 1 end
    end
    return total
end

local function vehicleTeleport(cf)
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    local seat = humanoid.SeatPart
    if not seat then return end
    local vehicle = seat:FindFirstAncestorOfClass("Model")
    if not vehicle then return end
    if not vehicle.PrimaryPart then vehicle.PrimaryPart = seat end
    vehicle:SetPrimaryPartCFrame(cf)
    task.wait(1)
    seat.Throttle = 1
    task.wait(0.5)
    seat.Throttle = 0
end

local function fill(bar, time)
    bar.Size = UDim2.new(0,0,1,0)
    bar:TweenSize(UDim2.new(1,0,1,0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, time, true)
    task.delay(time, function() bar.Size = UDim2.new(0,0,1,0) end)
end

-- ============================================================
-- BASEPLATE SPAWNER (2999x2999, 7 studs below lowest map point)
-- ============================================================
local function spawnBaseplate2999()
    -- Hapus baseplate lama jika ada
    if currentBaseplate and currentBaseplate.Parent then
        currentBaseplate:Destroy()
    end
    
    -- Cari titik terendah map
    local lowestPoint = math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Anchored then
            local bottomY = obj.Position.Y - (obj.Size.Y / 2)
            if bottomY < lowestPoint then
                lowestPoint = bottomY
            end
        end
    end
    
    if lowestPoint == math.huge then
        lowestPoint = 0
    end
    
    -- Posisi 7 studs DI BAWAH titik terendah
    local underMapPosition = Vector3.new(0, lowestPoint - 7, 0)
    
    -- Buat baseplate ukuran 2999x2999
    local newBaseplate = Instance.new("Part")
    newBaseplate.Name = "MegaBaseplate_2999x2999_FullyNV"
    newBaseplate.Size = Vector3.new(2999, 1, 2999)
    newBaseplate.Position = underMapPosition
    newBaseplate.Anchored = true
    newBaseplate.BrickColor = BrickColor.new("Dark grey")
    newBaseplate.Material = Enum.Material.Granite
    newBaseplate.Transparency = 0.3
    newBaseplate.Parent = Workspace
    
    -- Add efek glow
    local glow = Instance.new("SelectionBox", newBaseplate)
    glow.Adornee = newBaseplate
    glow.Color3 = Color3.fromRGB(148, 80, 255)
    glow.Transparency = 0.7
    glow.LineThickness = 0.5
    
    currentBaseplate = newBaseplate
    
    print("[System Dark] Baseplate 2999x2999 spawned di Y = " .. underMapPosition.Y .. " (7 studs di bawah map)")
    return newBaseplate
end

-- ============================================================
-- COLOR PALETTE (LENGKAP DENGAN C.line)
-- ============================================================
local C = {
    bg        = Color3.fromRGB(8,  7,  14),
    surface   = Color3.fromRGB(14, 12, 24),
    panel     = Color3.fromRGB(18, 16, 30),
    card      = Color3.fromRGB(24, 21, 40),
    sidebar   = Color3.fromRGB(11,  9, 20),
    accent    = Color3.fromRGB(130, 60, 240),
    accentDim = Color3.fromRGB(75,  35, 140),
    accentGlow= Color3.fromRGB(175, 120, 255),
    accentSoft= Color3.fromRGB(100, 55, 190),
    text      = Color3.fromRGB(220, 215, 245),
    textMid   = Color3.fromRGB(145, 138, 175),
    textDim   = Color3.fromRGB(75,  68, 100),
    green     = Color3.fromRGB(55,  200, 110),
    red       = Color3.fromRGB(220, 60,  75),
    border    = Color3.fromRGB(38,  32,  62),
    borderAct = Color3.fromRGB(100, 55, 190),
    purple    = Color3.fromRGB(148, 80,  255),
    cyan      = Color3.fromRGB(50,  210, 230),
    orange    = Color3.fromRGB(255, 160, 40),
    line      = Color3.fromRGB(38,  32,  62),  -- FIX: C.line sekarang terdefinisi
    blue      = Color3.fromRGB(82,  130, 255),
    blueD     = Color3.fromRGB(48,  88,  200),
}

-- ============================================================
-- LOADING OVERLAY
-- ============================================================
local showLoading, hideLoading
do
    local loadGui = Instance.new("ScreenGui")
    loadGui.Name = "ELIXIR_LOAD"
    loadGui.IgnoreGuiInset = true
    loadGui.ResetOnSpawn = false
    loadGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadGui.DisplayOrder = 999
    loadGui.Enabled = false
    pcall(function() loadGui.Parent = game:GetService("CoreGui") end)
    if not loadGui.Parent then loadGui.Parent = playerGui end

    local bg = Instance.new("Frame", loadGui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0
    bg.BorderSizePixel = 0
    bg.ZIndex = 10

    local glow = Instance.new("Frame", bg)
    glow.Size = UDim2.new(0, 400, 0, 180)
    glow.Position = UDim2.new(0.5, -200, 0.5, -90)
    glow.BackgroundColor3 = Color3.fromRGB(80, 30, 160)
    glow.BackgroundTransparency = 0.88
    glow.BorderSizePixel = 0
    glow.ZIndex = 11
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(0, 500, 0, 56)
    title.Position = UDim2.new(0.5, -250, 0.5, -50)
    title.BackgroundTransparency = 1
    title.Text = "ELIXIR STORE"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 44
    title.TextColor3 = Color3.fromRGB(220, 215, 245)
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 12
    
    local subLbl = Instance.new("TextLabel", bg)
    subLbl.Size = UDim2.new(0, 400, 0, 22)
    subLbl.Position = UDim2.new(0.5, -200, 0.5, 24)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Teleporting..."
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 13
    subLbl.TextColor3 = Color3.fromRGB(100, 55, 190)
    subLbl.TextXAlignment = Enum.TextXAlignment.Center
    subLbl.ZIndex = 12

    showLoading = function(subText)
        subLbl.Text = subText or "Teleporting"
        loadGui.Enabled = true
    end

    hideLoading = function()
        loadGui.Enabled = false
    end
end

-- ============================================================
-- NOTIFICATION SYSTEM
-- ============================================================
local notifContainer = Instance.new("Frame", gui)
notifContainer.Size = UDim2.new(0, 270, 1, 0)
notifContainer.Position = UDim2.new(1, -280, 0, 0)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 100

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 6)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

local notifPadding = Instance.new("UIPadding", notifContainer)
notifPadding.PaddingBottom = UDim.new(0, 14)
notifPadding.PaddingRight = UDim.new(0, 8)

local notifCount = 0
local function notify(title, msg, ntype)
    notifCount += 1
    local color = ntype == "success" and C.green or ntype == "error" and C.red or C.accent

    local card = Instance.new("Frame", notifContainer)
    card.Size = UDim2.new(1, 0, 0, 58)
    card.BackgroundColor3 = C.card
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.ZIndex = 100
    card.LayoutOrder = notifCount
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = color
    stroke.Thickness = 1
    stroke.Transparency = 0.5

    local t = Instance.new("TextLabel", card)
    t.Position = UDim2.new(0, 14, 0, 7)
    t.Size = UDim2.new(1, -22, 0, 18)
    t.BackgroundTransparency = 1
    t.Text = title
    t.Font = Enum.Font.GothamBold
    t.TextSize = 13
    t.TextColor3 = C.text
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.ZIndex = 101

    local m = Instance.new("TextLabel", card)
    m.Position = UDim2.new(0, 14, 0, 26)
    m.Size = UDim2.new(1, -22, 0, 26)
    m.BackgroundTransparency = 1
    m.Text = msg
    m.Font = Enum.Font.Gotham
    m.TextSize = 11
    m.TextColor3 = C.textMid
    m.TextXAlignment = Enum.TextXAlignment.Left
    m.TextWrapped = true
    m.ZIndex = 101

    local timerBar = Instance.new("Frame", card)
    timerBar.Position = UDim2.new(0, 3, 1, -2)
    timerBar.Size = UDim2.new(1, -3, 0, 2)
    timerBar.BackgroundColor3 = color
    timerBar.BorderSizePixel = 0
    timerBar.ZIndex = 101

    card.Position = UDim2.new(1, 16, 0, 0)
    TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0,0,0,0)}):Play()
    TweenService:Create(timerBar, TweenInfo.new(3.5, Enum.EasingStyle.Linear), {Size = UDim2.new(0,3,0,2)}):Play()

    task.delay(3.5, function()
        TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Position = UDim2.new(1,16,0,0)}):Play()
        task.wait(0.3)
        card:Destroy()
    end)
end

-- ============================================================
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIR_3_5"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ============================================================
-- UI COMPONENT BUILDERS
-- ============================================================
local function mkFrame(p, bg, zi)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or C.card
    f.BorderSizePixel = 0
    f.ZIndex = zi or 2
    if p then f.Parent = p end
    return f
end

local function mkLabel(p, txt, col, font, xa, zi, ts)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = txt or ""
    l.TextColor3 = col or C.text
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.ZIndex = zi or 3
    if ts then l.TextScaled = false l.TextSize = ts
    else l.TextScaled = true end
    if p then l.Parent = p end
    return l
end

local function mkBtn(p, txt, col, font, zi, ts)
    local b = Instance.new("TextButton")
    b.BackgroundTransparency = 1
    b.Text = txt or ""
    b.TextColor3 = col or C.text
    b.Font = font or Enum.Font.Gotham
    b.ZIndex = zi or 3
    if ts then b.TextScaled = false b.TextSize = ts
    else b.TextScaled = true end
    if p then b.Parent = p end
    return b
end

local function corner(p, r)
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, r or 8)
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.line
    s.Thickness = th or 1
    return s
end

local function line(p, y)
    local d = mkFrame(p, C.line, 2)
    d.Size = UDim2.new(1, -24, 0, 1)
    d.Position = UDim2.new(0, 12, 0, y)
end

local function secHdr(p, y, txt)
    local bar = mkFrame(p, C.blue, 3)
    bar.Size = UDim2.new(0, 3, 0, 12)
    bar.Position = UDim2.new(0, 12, 0, y + 3)
    corner(bar, 2)
    local l = mkLabel(p, txt, C.textMid, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 3, 10)
    l.Size = UDim2.new(1, -30, 0, 18)
    l.Position = UDim2.new(0, 20, 0, y)
    return l
end

local function statRow(p, y, icon, lbl, valCol)
    local row = mkFrame(p, C.card, 2)
    row.Size = UDim2.new(1, -24, 0, 34)
    row.Position = UDim2.new(0, 12, 0, y)
    corner(row, 8)
    local ic = mkLabel(row, icon, C.text, Enum.Font.Gotham, Enum.TextXAlignment.Center, 3, 13)
    ic.Size = UDim2.new(0, 28, 1, 0)
    ic.Position = UDim2.new(0, 4, 0, 0)
    local nm = mkLabel(row, lbl, C.textMid, Enum.Font.Gotham, Enum.TextXAlignment.Left, 3, 11)
    nm.Size = UDim2.new(0.55, -32, 1, 0)
    nm.Position = UDim2.new(0, 34, 0, 0)
    local vl = mkLabel(row, "0", valCol or C.blue, Enum.Font.GothamBold, Enum.TextXAlignment.Right, 3, 13)
    vl.Size = UDim2.new(0.45, -10, 1, 0)
    vl.Position = UDim2.new(0.55, 0, 0, 0)
    return vl
end

local function actionBtn(p, y, txt, bg, txtC)
    local w = mkFrame(p, bg or C.blue, 3)
    w.Size = UDim2.new(1, -24, 0, 36)
    w.Position = UDim2.new(0, 12, 0, y)
    corner(w, 8)
    local b = mkBtn(w, txt, txtC or C.text, Enum.Font.GothamBold, 4)
    b.Size = UDim2.new(1, 0, 1, 0)
    b.TextSize = 11
    b.TextScaled = false
    return w, b
end

local function hoverBtn(w, b, nc, hc)
    b.MouseEnter:Connect(function()
        TweenService:Create(w, TweenInfo.new(0.1), {BackgroundColor3=hc}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(w, TweenInfo.new(0.1), {BackgroundColor3=nc}):Play()
    end)
end

local function stepperRow(p, y, lbl, minV, maxV, defV, unit)
    local row = mkFrame(p, C.card, 2)
    row.Size = UDim2.new(1, -24, 0, 44)
    row.Position = UDim2.new(0, 12, 0, y)
    corner(row, 8)

    local nm = mkLabel(row, lbl, C.textMid, Enum.Font.Gotham, Enum.TextXAlignment.Left, 3, 10)
    nm.Size = UDim2.new(0.5, 0, 0, 20)
    nm.Position = UDim2.new(0, 10, 0, 2)

    local curVal = defV
    local valL = mkLabel(row, tostring(curVal) .. (unit or ""), C.text, Enum.Font.GothamBold, Enum.TextXAlignment.Center, 3, 13)
    valL.Size = UDim2.new(0, 50, 0, 24)
    valL.Position = UDim2.new(0.5, -25, 0, 18)

    local minusW = mkFrame(row, C.blueD, 3)
    minusW.Size = UDim2.new(0, 28, 0, 24)
    minusW.Position = UDim2.new(0.5, -25-34, 0, 18)
    corner(minusW, 6)
    local minusB = mkBtn(minusW, "−", C.text, Enum.Font.GothamBold, 4, 14)
    minusB.Size = UDim2.new(1, 0, 1, 0)
    minusB.TextScaled = false

    local plusW = mkFrame(row, C.blueD, 3)
    plusW.Size = UDim2.new(0, 28, 0, 24)
    plusW.Position = UDim2.new(0.5, 25+6, 0, 18)
    corner(plusW, 6)
    local plusB = mkBtn(plusW, "+", C.text, Enum.Font.GothamBold, 4, 14)
    plusB.Size = UDim2.new(1, 0, 1, 0)
    plusB.TextScaled = false

    local function updateVal(v)
        curVal = math.clamp(v, minV, maxV)
        valL.Text = tostring(curVal) .. (unit or "")
    end

    minusB.MouseButton1Click:Connect(function() updateVal(curVal - 1) end)
    plusB.MouseButton1Click:Connect(function() updateVal(curVal + 1) end)
    hoverBtn(minusW, minusB, C.blueD, C.blue)
    hoverBtn(plusW, plusB, C.blueD, C.blue)

    return function() return curVal end
end

local function makeSlider(parent, labelText, minV, maxV, defaultV, order, callback)
    local wrap = mkFrame(parent, C.card, 2)
    wrap.Size = UDim2.new(1, -24, 0, 54)
    wrap.Position = UDim2.new(0, 12, 0, order)
    corner(wrap, 8)

    local lbl = mkLabel(wrap, labelText, C.textMid, Enum.Font.GothamSemibold, Enum.TextXAlignment.Left, 3, 11)
    lbl.Size = UDim2.new(1, -80, 0, 16)
    lbl.Position = UDim2.new(0, 12, 0, 8)

    local valLbl = mkLabel(wrap, tostring(defaultV), C.accentGlow, Enum.Font.GothamBold, Enum.TextXAlignment.Right, 3, 12)
    valLbl.Size = UDim2.new(0, 42, 0, 16)
    valLbl.Position = UDim2.new(1, -52, 0, 8)

    local track = mkFrame(wrap, C.border, 3)
    track.Size = UDim2.new(1, -24, 0, 5)
    track.Position = UDim2.new(0, 12, 0, 34)
    track.Active = true
    corner(track, 2)

    local fill = mkFrame(track, C.accent, 4)
    fill.Size = UDim2.new((defaultV - minV)/(maxV - minV), 0, 1, 0)
    corner(fill, 2)

    local knob = mkFrame(track, Color3.new(1,1,1), 5)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((defaultV - minV)/(maxV - minV), -7, 0.5, -7)
    corner(knob, 7)
    stroke(knob, C.accent, 2)

    local dragging = false
    local function update(x)
        local pos = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.floor(minV + pos * (maxV - minV))
        knob.Position = UDim2.new(pos, -7, 0.5, -7)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valLbl.Text = tostring(val)
        if callback then callback(val) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input.Position.X)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return wrap, valLbl
end

local function makeProgressBar(parent, label, y)
    local f = mkFrame(parent, C.card, 2)
    f.Size = UDim2.new(1, -24, 0, 34)
    f.Position = UDim2.new(0, 12, 0, y)
    corner(f, 8)
    local l = mkLabel(f, label, C.textMid, Enum.Font.Gotham, Enum.TextXAlignment.Left, 3, 10)
    l.Size = UDim2.new(1, -10, 0, 14)
    l.Position = UDim2.new(0, 10, 0, 5)
    local bg = mkFrame(f, C.border, 3)
    bg.Size = UDim2.new(1, -20, 0, 5)
    bg.Position = UDim2.new(0, 10, 0, 22)
    corner(bg, 2)
    local bar = mkFrame(bg, C.accent, 4)
    bar.Size = UDim2.new(0, 0, 1, 0)
    return bar
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 720, 0, 520)
main.Position = UDim2.new(0.5, -360, 0.5, -260)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
main.ClipsDescendants = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
stroke(main, C.border, 1)

local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 46)
topBar.BackgroundColor3 = C.surface
topBar.ZIndex = 2
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local titleLbl = mkLabel(topBar, "ELIXIR 3.5", C.text, Enum.Font.GothamBlack, Enum.TextXAlignment.Left, 4, 15)
titleLbl.Size = UDim2.new(0, 160, 1, 0)
titleLbl.Position = UDim2.new(0, 16, 0, 0)

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 22)
closeBtn.Text = "x"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = C.red
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -72, 0.5, -14)
minBtn.BackgroundColor3 = C.card
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.TextColor3 = C.textMid
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 90, 1, -46)
sidebar.Position = UDim2.new(0, 0, 0, 46)
sidebar.BackgroundColor3 = C.sidebar
sidebar.ZIndex = 2
sidebar.ClipsDescendants = false

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -90, 1, -46)
content.Position = UDim2.new(0, 90, 0, 46)
content.BackgroundColor3 = C.panel
content.ClipsDescendants = true

-- ============================================================
-- MENU SYSTEM (8 MENUS)
-- ============================================================
local pages = {}
local tabBtns = {}
local currentTab = nil

local menuNames = {"FARM", "AUTO", "STATUS", "TP", "ESP", "RESPAWN", "UNDERPOT", "FULLYNV"}

for i, name in ipairs(menuNames) do
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0, 78, 0, 36)
    btn.Position = UDim2.new(0, 6, 0, 8 + (i-1)*42)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.TextColor3 = C.textDim
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 2, 0, 18)
    indicator.Position = UDim2.new(0, 0, 0.5, -9)
    indicator.BackgroundColor3 = C.accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)
    
    local page = Instance.new("ScrollingFrame", content)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.Visible = false
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 600)
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    pages[name] = page
    tabBtns[name] = {btn=btn, ind=indicator}
    
    btn.MouseButton1Click:Connect(function()
        for n, t in pairs(tabBtns) do
            pages[n].Visible = false
            t.ind.Visible = false
            t.btn.TextColor3 = C.textDim
        end
        page.Visible = true
        indicator.Visible = true
        btn.TextColor3 = C.accentGlow
        currentTab = name
    end)
end

-- ============================================================
-- FARM PAGE
-- ============================================================
local fp = pages["FARM"]
local lblStatus = mkLabel(fp, "Siap digunakan", C.cyan, Enum.Font.Gotham, Enum.TextXAlignment.Center, 4, 10)
lblStatus.Size = UDim2.new(1, -24, 0, 26)
lblStatus.Position = UDim2.new(0, 12, 0, 8)
corner(lblStatus, 8)
stroke(lblStatus, C.line, 1)

local waterVal = statRow(fp, 46, "💧", "Water", Color3.fromRGB(100,200,255))
local sugarVal = statRow(fp, 86, "🧂", "Sugar Bag", Color3.fromRGB(255,220,100))
local gelatinVal = statRow(fp, 126, "🟡", "Gelatin", Color3.fromRGB(255,190,60))
local bagVal = statRow(fp, 166, "🎒", "Empty Bag", Color3.fromRGB(100,180,255))

local buySliderWrap, buyValLbl = makeSlider(fp, "BUY AMOUNT", 1, 25, 1, 200, function(v) buyAmount = v end)
local farmToggleBtn = makeActionBtn(fp, "START FARM", C.accentDim, 210)
local sellToggleBtn = makeActionBtn(fp, "AUTO SELL : OFF", C.card, 250)
local buyNowBtn = makeActionBtn(fp, "BUY NOW", C.card, 290)

local waterBar = makeProgressBar(fp, "Water (20s)", 330)
local sugarBar = makeProgressBar(fp, "Sugar (1s)", 370)
local gelatinBar = makeProgressBar(fp, "Gelatin (1s)", 410)
local bagBar = makeProgressBar(fp, "Bag (45s)", 450)

local function cook()
    while running do
        if equip("Water") then
            lblStatus.Text = "Cooking Water..."
            fill(waterBar, 20)
            holdE(.7)
            task.wait(20)
        end
        if equip("Sugar Block Bag") then
            lblStatus.Text = "Cooking Sugar..."
            fill(sugarBar, 1)
            holdE(.7)
            task.wait(1)
        end
        if equip("Gelatin") then
            lblStatus.Text = "Cooking Gelatin..."
            fill(gelatinBar, 1)
            holdE(.7)
            task.wait(1)
        end
        lblStatus.Text = "Waiting..."
        fill(bagBar, 45)
        task.wait(45)
        if equip("Empty Bag") then
            lblStatus.Text = "Collecting..."
            holdE(.7)
            task.wait(1)
        end
    end
    lblStatus.Text = "IDLE"
end

local buying = false
local function autoBuy()
    if buying then return end
    buying = true
    for i = 1, buyAmount do
        buyRemote:FireServer("Water") task.wait(.35)
        buyRemote:FireServer("Sugar Block Bag") task.wait(.35)
        buyRemote:FireServer("Gelatin") task.wait(.35)
        buyRemote:FireServer("Empty Bag") task.wait(.45)
    end
    buying = false
end

local function autoSell()
    local bags = {"Small Marshmallow Bag","Medium Marshmallow Bag","Large Marshmallow Bag"}
    for _,bag in pairs(bags) do
        while countItem(bag) > 0 and autoSellEnabled do
            if equip(bag) then holdE(.7) task.wait(1)
            else break end
        end
    end
end

farmToggleBtn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        farmToggleBtn.Text = "STOP FARM"
        TweenService:Create(farmToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.red}):Play()
        task.spawn(cook)
    else
        farmToggleBtn.Text = "START FARM"
        TweenService:Create(farmToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.accentDim}):Play()
    end
end)

buyNowBtn.MouseButton1Click:Connect(function() task.spawn(autoBuy) end)
sellToggleBtn.MouseButton1Click:Connect(function()
    autoSellEnabled = not autoSellEnabled
    sellToggleBtn.Text = autoSellEnabled and "AUTO SELL : ON" or "AUTO SELL : OFF"
    if autoSellEnabled then task.spawn(autoSell) end
end)

-- ============================================================
-- AUTO PAGE
-- ============================================================
local ap = pages["AUTO"]
secHdr(ap, 8, "AUTO FARM LOOP")
local autoFarmToggle = makeActionBtn(ap, "START AUTO FARM", C.accentDim, 40)
local cookSlider, cookVal = makeSlider(ap, "COOK AMOUNT", 1, 50, 5, 80, function(v) cookAmount = v end)

autoFarmToggle.MouseButton1Click:Connect(function()
    autoFarmRunning = not autoFarmRunning
    autoFarmToggle.Text = autoFarmRunning and "STOP AUTO FARM" or "START AUTO FARM"
    TweenService:Create(autoFarmToggle, TweenInfo.new(0.2), {BackgroundColor3 = autoFarmRunning and C.red or C.accentDim}):Play()
    if autoFarmRunning then
        task.spawn(function()
            while autoFarmRunning do
                autoBuy()
                task.wait(2)
                for i = 1, cookAmount do
                    if equip("Water") then holdE(0.7) task.wait(20) end
                    if equip("Sugar Block Bag") then holdE(0.7) task.wait(1) end
                    if equip("Gelatin") then holdE(0.7) task.wait(1) end
                    task.wait(45)
                    if equip("Empty Bag") then holdE(0.7) task.wait(1) end
                end
                autoSell()
                task.wait(1)
            end
        end)
    end
end)

-- ============================================================
-- STATUS PAGE
-- ============================================================
local sp = pages["STATUS"]
local statWater = statRow(sp, 20, "💧", "Water", C.cyan)
local statSugar = statRow(sp, 60, "🧂", "Sugar", C.cyan)
local statGelatin = statRow(sp, 100, "🟡", "Gelatin", C.cyan)
local statSmall = statRow(sp, 140, "🍬", "Small MS", C.green)
local statMedium = statRow(sp, 180, "🍬", "Medium MS", C.green)
local statLarge = statRow(sp, 220, "🍬", "Large MS", C.green)

-- ============================================================
-- TP PAGE
-- ============================================================
local tp = pages["TP"]
local tpBtns = {
    {"NPC Store", npcPos.Position, 20},
    {"Tier", tierPos.Position, 60},
    {"CSN 1", Vector3.new(1178.83, 3.95, -227.37), 100},
    {"CSN 2", Vector3.new(1205.09, 3.95, -220.54), 140},
}
for _, btn in ipairs(tpBtns) do
    local b = makeActionBtn(tp, btn[1], C.card, btn[3])
    b.MouseButton1Click:Connect(function() vehicleTeleport(CFrame.new(btn[2])) end)
end

-- ============================================================
-- ESP PAGE
-- ============================================================
local ep = pages["ESP"]
local espToggle = makeActionBtn(ep, "ENABLE ESP", C.accentDim, 20)
local espEnabled = false
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = espEnabled and "DISABLE ESP" or "ENABLE ESP"
end)

-- Simple ESP Drawing
local Camera = workspace.CurrentCamera
local ESPLines = {}
local function updateESP()
    if not espEnabled then
        for _, line in pairs(ESPLines) do if line then line.Visible = false end end
        return
    end
    -- Simple ESP implementation
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                if not ESPLines[plr] then
                    ESPLines[plr] = Drawing.new("Text")
                    ESPLines[plr].Size = 12
                    ESPLines[plr].Center = true
                    ESPLines[plr].Color = Color3.fromRGB(148, 80, 255)
                    ESPLines[plr].Outline = true
                end
                ESPLines[plr].Text = plr.Name
                ESPLines[plr].Position = Vector2.new(pos.X, pos.Y - 30)
                ESPLines[plr].Visible = true
            elseif ESPLines[plr] then
                ESPLines[plr].Visible = false
            end
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

-- ============================================================
-- RESPAWN PAGE
-- ============================================================
local rp = pages["RESPAWN"]
local spawnPos = Vector3.new(511, 3, 601)
local respawnBtn = makeActionBtn(rp, "RESPAWN", C.accent, 20)
respawnBtn.MouseButton1Click:Connect(function()
    player.Character.Humanoid.Health = 0
    player.CharacterAdded:Wait()
    player.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPos)
end)

-- ============================================================
-- UNDERPOT PAGE
-- ============================================================
local up = pages["UNDERPOT"]
local lowerBtn = makeActionBtn(up, "LOWER ROAD", C.accentDim, 20)
local lowered = false
lowerBtn.MouseButton1Click:Connect(function()
    lowered = not lowered
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("road") then
            v.CFrame = v.CFrame * CFrame.new(0, lowered and -6 or 6, 0)
        end
    end
end)

-- ============================================================
-- FULLY NV PAGE (BLINK + TWEEN + BASEPLATE SPAWNER)
-- ============================================================
local fullyNVPage = pages["FULLYNV"]
local fullyNVScroll = Instance.new("ScrollingFrame")
fullyNVScroll.Size = UDim2.new(1, 0, 1, 0)
fullyNVScroll.CanvasSize = UDim2.new(0, 0, 0, 580)
fullyNVScroll.BackgroundTransparency = 1
fullyNVScroll.BorderSizePixel = 0
fullyNVScroll.ScrollBarThickness = 3
fullyNVScroll.Parent = fullyNVPage

secHdr(fullyNVScroll, 8, "AUTO FULLY NV — APART CASINO")

local infoBox = mkFrame(fullyNVScroll, Color3.fromRGB(11,16,28), 3)
infoBox.Size = UDim2.new(1, -24, 0, 70)
infoBox.Position = UDim2.new(0, 12, 0, 26)
corner(infoBox, 8)
stroke(infoBox, C.purple, 1)

mkLabel(infoBox, "Blink bawah 6 studs + cooldown 1s sebelum setiap gerakan", C.cyan, Enum.Font.Gotham, Enum.TextXAlignment.Left, 4, 9).Size = UDim2.new(1, -10, 0.33, 0)
mkLabel(infoBox, "Di dalam Apart: Tween (<2s) | Luar: Blink", C.orange, Enum.Font.Gotham, Enum.TextXAlignment.Left, 4, 9).Size = UDim2.new(1, -10, 0.33, 0)
mkLabel(infoBox, "BASEPLATE 2999x2999 otomatis spawn 7 studs di bawah map saat START", C.green, Enum.Font.Gotham, Enum.TextXAlignment.Left, 4, 9).Size = UDim2.new(1, -10, 0.33, 0)

line(fullyNVScroll, 102)
secHdr(fullyNVScroll, 108, "PILIH APART")

local apartCard = mkFrame(fullyNVScroll, C.card, 3)
apartCard.Size = UDim2.new(1, -24, 0, 50)
apartCard.Position = UDim2.new(0, 12, 0, 126)
corner(apartCard, 8)

local apartNames = {"APT 1", "APT 2", "APT 3", "APT 4"}
local apartFull = {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}
for i, name in ipairs(apartNames) do
    local btn = mkBtn(apartCard, name, C.text, Enum.Font.GothamBold, 4, 10)
    btn.Size = UDim2.new(0.23, -4, 0, 30)
    btn.Position = UDim2.new(0.01 + (i-1)*0.245, 0, 0, 12)
    btn.BackgroundColor3 = i == 1 and C.purple or C.blueD
    btn.BackgroundTransparency = 0
    corner(btn, 6)
    btn.MouseButton1Click:Connect(function()
        selectedApartNV = apartFull[i]
        for j=1,4 do
            local b = apartCard:FindFirstChild(apartNames[j])
            if b then TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = (j==i) and C.purple or C.blueD}):Play() end
        end
    end)
end

line(fullyNVScroll, 182)
secHdr(fullyNVScroll, 188, "PILIH POT")

local potCard = mkFrame(fullyNVScroll, C.card, 3)
potCard.Size = UDim2.new(1, -24, 0, 50)
potCard.Position = UDim2.new(0, 12, 0, 206)
corner(potCard, 8)

local potKanan = mkBtn(potCard, "POT KANAN", C.text, Enum.Font.GothamBold, 4, 10)
potKanan.Size = UDim2.new(0.45, -4, 0, 30)
potKanan.Position = UDim2.new(0.03, 0, 0, 12)
potKanan.BackgroundColor3 = C.purple
potKanan.BackgroundTransparency = 0
corner(potKanan, 6)

local potKiri = mkBtn(potCard, "POT KIRI", C.text, Enum.Font.GothamBold, 4, 10)
potKiri.Size = UDim2.new(0.45, -4, 0, 30)
potKiri.Position = UDim2.new(0.52, 0, 0, 12)
potKiri.BackgroundColor3 = C.blueD
potKiri.BackgroundTransparency = 0
corner(potKiri, 6)

potKanan.MouseButton1Click:Connect(function()
    selectedPotNV = "KANAN"
    TweenService:Create(potKanan, TweenInfo.new(0.1), {BackgroundColor3 = C.purple}):Play()
    TweenService:Create(potKiri, TweenInfo.new(0.1), {BackgroundColor3 = C.blueD}):Play()
end)
potKiri.MouseButton1Click:Connect(function()
    selectedPotNV = "KIRI"
    TweenService:Create(potKanan, TweenInfo.new(0.1), {BackgroundColor3 = C.blueD}):Play()
    TweenService:Create(potKiri, TweenInfo.new(0.1), {BackgroundColor3 = C.purple}):Play()
end)

line(fullyNVScroll, 262)
secHdr(fullyNVScroll, 268, "SETTING")
local getTarget = stepperRow(fullyNVScroll, 284, "Target MS per loop", 1, 50, 5, "x")

line(fullyNVScroll, 334)
secHdr(fullyNVScroll, 340, "STATUS")
local statusBox = mkFrame(fullyNVScroll, C.bg, 3)
statusBox.Size = UDim2.new(1, -24, 0, 28)
statusBox.Position = UDim2.new(0, 12, 0, 358)
corner(statusBox, 8)
stroke(statusBox, C.line, 1)
local statusLbl = mkLabel(statusBox, "Belum dimulai", C.textMid, Enum.Font.Gotham, Enum.TextXAlignment.Center, 4, 10)
statusLbl.Size = UDim2.new(1, -8, 1, 0)

local msStat = statRow(fullyNVScroll, 398, "🍬", "Total MS Dibuat", C.cyan)

local startW, startB = actionBtn(fullyNVScroll, 438, "⚡ START FULLY NV", C.purple, C.text)
local stopW, stopB = actionBtn(fullyNVScroll, 438, "■ STOP FULLY NV", C.red, C.text)
stopW.Visible = false

local function setNVStatus(msg, col)
    statusLbl.Text = msg
    statusLbl.TextColor3 = col or C.textMid
    lblStatus.Text = msg
    lblStatus.TextColor3 = col or C.cyan
end

-- KOORDINAT APART CASINO
local apartCoords = {
    ["APART CASINO 1"] = {
        {CFrame.new(1196.51, 3.71, -241.13)},
        {CFrame.new(1199.75, 3.71, -238.12)},
        {CFrame.new(1199.74, 6.59, -233.05)},
        {CFrame.new(1199.66, 6.59, -227.75)},
        {kanan = CFrame.new(1199.66, 6.59, -227.75), kiri = CFrame.new(1199.66, 6.59, -227.75)},
        {kanan = CFrame.new(1199.91, 7.56, -219.75), kiri = CFrame.new(1199.75, 7.45, -217.66)},
        {kanan = CFrame.new(1199.87, 15.96, -215.33), kiri = CFrame.new(1199.38, 15.96, -220.53)},
    },
    ["APART CASINO 2"] = {
        {CFrame.new(1186.34, 3.71, -242.92)},
        {CFrame.new(1183.00, 6.59, -233.78)},
        {CFrame.new(1182.70, 7.32, -229.73)},
        {CFrame.new(1182.75, 6.59, -224.78)},
        {kanan = CFrame.new(1183.43, 15.96, -229.66), kiri = CFrame.new(1183.22, 15.96, -225.63)},
    },
    ["APART CASINO 3"] = {
        {CFrame.new(1196.17, 3.71, -205.72)},
        {CFrame.new(1199.76, 3.71, -196.51)},
        {CFrame.new(1199.69, 6.59, -191.16)},
        {CFrame.new(1199.42, 6.59, -185.27)},
        {kanan = CFrame.new(1199.42, 6.59, -185.27), kiri = CFrame.new(1199.95, 7.07, -177.69)},
        {kanan = CFrame.new(1199.55, 15.96, -181.89), kiri = CFrame.new(1199.46, 15.96, -177.81)},
    },
    ["APART CASINO 4"] = {
        {CFrame.new(1187.70, 3.71, -209.73)},
        {CFrame.new(1182.27, 3.71, -204.65)},
        {CFrame.new(1182.23, 3.71, -198.77)},
        {CFrame.new(1183.06, 6.59, -193.92)},
        {kanan = CFrame.new(1182.60, 7.56, -191.29), kiri = CFrame.new(1183.36, 6.72, -187.25)},
        {kanan = CFrame.new(1183.24, 15.96, -191.25), kiri = CFrame.new(1183.08, 15.96, -187.36)},
    },
}

-- BLINK + TWEEN FUNCTIONS
local function blinkDown()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, -6, 0) end
end

local function blinkTo(pos)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(pos) end
end

local function tweenTo(cf, dur)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local tween = TweenService:Create(hrp, TweenInfo.new(math.min(dur, 1.9), Enum.EasingStyle.Linear), {CFrame = cf})
        tween:Play()
        tween.Completed:Wait()
    end
end

local function moveTo(target, useTween)
    blinkDown()
    task.wait(1)
    if useTween then tweenTo(target, 1.2) else blinkTo(target.Position) end
end

local function spamE()
    for i = 1, 3 do
        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        task.wait(0.1)
    end
end

-- MAIN LOOP DENGAN BASEPLATE SPAWN
local function doFullyNV()
    fullyRunningNV = true
    
    -- SPAWN BASEPLATE 2999x2999 otomatis saat start
    setNVStatus("📦 Spawning baseplate 2999x2999...", C.purple)
    spawnBaseplate2999()
    task.wait(1)
    notify("Baseplate", "Baseplate 2999x2999 spawned 7 studs di bawah map!", "success")
    
    local npcPos = Vector3.new(510.061, 4.476, 600.548)
    
    while fullyRunningNV do
        setNVStatus("🏪 Ke NPC...", C.cyan)
        moveTo(CFrame.new(npcPos), false)
        task.wait(0.5)
        
        setNVStatus("🛒 Beli " .. fullyTargetNV .. "x...", C.cyan)
        for i = 1, fullyTargetNV do
            buyRemote:FireServer("Water") task.wait(0.3)
            buyRemote:FireServer("Sugar Block Bag") task.wait(0.3)
            buyRemote:FireServer("Gelatin") task.wait(0.3)
            buyRemote:FireServer("Empty Bag") task.wait(0.3)
        end
        if not fullyRunningNV then break end
        
        local apartEntry = {["APART CASINO 1"]=Vector3.new(1196,3.7,-241), ["APART CASINO 2"]=Vector3.new(1186,3.7,-242), ["APART CASINO 3"]=Vector3.new(1196,3.7,-205), ["APART CASINO 4"]=Vector3.new(1187,3.7,-209)}
        setNVStatus("🏠 Ke " .. selectedApartNV .. "...", C.purple)
        moveTo(CFrame.new(apartEntry[selectedApartNV]), false)
        task.wait(1)
        
        local coords = apartCoords[selectedApartNV]
        for i, coord in ipairs(coords) do
            if not fullyRunningNV then break end
            local target
            if coord.kanan then
                target = (selectedPotNV == "KANAN" and coord.kanan or coord.kiri)
            else
                target = coord[1]
            end
            setNVStatus("📦 Tahap " .. i .. "...", C.cyan)
            moveTo(target, true)
            task.wait(0.3)
            spamE()
            task.wait(0.5)
        end
        
        setNVStatus("🔥 Memasak...", C.orange)
        if equip("Water") then spamE() task.wait(20) end
        if equip("Sugar Block Bag") then spamE() task.wait(1) end
        if equip("Gelatin") then spamE() task.wait(1) end
        task.wait(45)
        if equip("Empty Bag") then spamE() task.wait(1) end
        
        setNVStatus("💰 Kembali & Jual...", C.green)
        moveTo(CFrame.new(npcPos), false)
        local bags = {"Small Marshmallow Bag","Medium Marshmallow Bag","Large Marshmallow Bag"}
        for _, bag in pairs(bags) do
            while countItem(bag) > 0 do
                if equip(bag) then spamE() task.wait(0.8) else break end
            end
        end
        task.wait(1)
    end
    fullyRunningNV = false
end

startB.MouseButton1Click:Connect(function()
    if fullyRunningNV then return end
    fullyTargetNV = getTarget()
    startW.Visible = false
    stopW.Visible = true
    setNVStatus("FULLY NV BERJALAN + BASEPLATE 2999x2999", C.green)
    task.spawn(doFullyNV)
end)

stopB.MouseButton1Click:Connect(function()
    fullyRunningNV = false
    startW.Visible = true
    stopW.Visible = false
    setNVStatus("DIHENTIKAN", C.orange)
end)

hoverBtn(startW, startB, C.purple, Color3.fromRGB(120,70,220))
hoverBtn(stopW, stopB, C.red, Color3.fromRGB(240,65,65))

-- ============================================================
-- UPDATE LOOP
-- ============================================================
task.spawn(function()
    while gui and gui.Parent do
        pcall(function()
            if waterVal then waterVal.Text = tostring(countItem("Water")) end
            if sugarVal then sugarVal.Text = tostring(countItem("Sugar Block Bag")) end
            if gelatinVal then gelatinVal.Text = tostring(countItem("Gelatin")) end
            if bagVal then bagVal.Text = tostring(countItem("Empty Bag")) end
            if statWater then statWater.Text = tostring(countItem("Water")) end
            if statSugar then statSugar.Text = tostring(countItem("Sugar Block Bag")) end
            if statGelatin then statGelatin.Text = tostring(countItem("Gelatin")) end
            if msStat then msStat.Text = tostring(countItem("Small Marshmallow Bag") + countItem("Medium Marshmallow Bag") + countItem("Large Marshmallow Bag")) end
        end)
        task.wait(0.5)
    end
end)

-- ============================================================
-- HIDE BUTTON
-- ============================================================
local hideBtn = Instance.new("TextButton", gui)
hideBtn.Size = UDim2.new(0, 42, 0, 42)
hideBtn.Position = UDim2.new(1, -52, 0.5, -21)
hideBtn.Text = "E"
hideBtn.Font = Enum.Font.GothamBlack
hideBtn.TextSize = 15
hideBtn.BackgroundColor3 = C.accent
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.BorderSizePixel = 0
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 10)
hideBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

ContextActionService:BindAction("toggleUI", function(_, state)
    if state == Enum.UserInputState.Begin then main.Visible = not main.Visible end
end, false, Enum.KeyCode.Z)

-- ============================================================
-- STARTUP
-- ============================================================
pages["FARM"].Visible = true
tabBtns["FARM"].ind.Visible = true
tabBtns["FARM"].btn.TextColor3 = C.accentGlow
notify("ELIXIR 3.5", "FULLY NV READY! Baseplate 2999x2999 auto spawn saat Start", "success")
