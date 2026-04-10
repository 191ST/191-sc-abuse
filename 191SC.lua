local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local VirtualUser = game:GetService("VirtualUser")

-- ========== CUSTOM RESPAWN ==========
local RESPAWN_POINT = CFrame.new(729.86, 3.71, 444.46) * CFrame.Angles(-3.14, 0.01, -3.14)

local function setupCustomRespawn()
    player.CharacterAdded:Connect(function(character)
        task.wait(0.1)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
            hrp.CFrame = RESPAWN_POINT
            task.wait(0.05)
            hrp.Anchored = false
        end
    end)
end

setupCustomRespawn()

-- ========== AMBIL REMOTE EVENTS ==========
local remotes = ReplicatedStorage:FindFirstChild("RemoteEvents")
local storePurchaseRE = remotes and remotes:FindFirstChild("StorePurchase")

repeat task.wait() until player.Character

local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local buyAmount = 10
local blinkEnabled = true
local fullyTarget = 5

-- ========== BLINK FUNCTIONS ==========
local function blinkMaju()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 8
    end
end

local function blinkMundur()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame - hrp.CFrame.LookVector * 8
    end
end

local function blinkAtas()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 5, 0)
    end
end

local function blinkBawah()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, -5, 0)
    end
end

ContextActionService:BindAction("blink_forward", function(_, state)
    if state == Enum.UserInputState.Begin and blinkEnabled then
        blinkMaju()
    end
end, false, Enum.KeyCode.T)

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
    VirtualInputManager:SendKeyEvent(true,"E",false,game)
    task.wait(t or 0.7)
    VirtualInputManager:SendKeyEvent(false,"E",false,game)
end

local function equip(name)
    local char = player.Character
    local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
    if tool then
        char.Humanoid:EquipTool(tool)
        task.wait(.3)
        return true
    end
    return false
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

local function stepTeleport(targetPos)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return end
    local seatPart = hum.SeatPart
    if seatPart then
        local vehicle = seatPart:FindFirstAncestorOfClass("Model")
        if vehicle and vehicle.PrimaryPart then
            vehicle:SetPrimaryPartCFrame(CFrame.new(targetPos + Vector3.new(0, 2, 0)))
        end
    else
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
            hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            task.wait(0.05)
            hrp.Anchored = false
        end
    end
end

-- ============================================================
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "191_STORE"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ============================================================
-- COLOR PALETTE
-- ============================================================
local C = {
    bg        = Color3.fromRGB(8,  8,  16),
    surface   = Color3.fromRGB(13, 13, 22),
    panel     = Color3.fromRGB(18, 18, 28),
    card      = Color3.fromRGB(22, 22, 36),
    sidebar   = Color3.fromRGB(10, 10, 20),
    accent    = Color3.fromRGB(0, 110, 220),
    accentDim = Color3.fromRGB(0, 70, 150),
    accentGlow= Color3.fromRGB(50, 150, 255),
    accentSoft= Color3.fromRGB(0, 90, 190),
    text      = Color3.fromRGB(230, 235, 255),
    textMid   = Color3.fromRGB(150, 160, 200),
    textDim   = Color3.fromRGB(80, 85, 120),
    green     = Color3.fromRGB(40, 200, 100),
    red       = Color3.fromRGB(220, 60, 70),
    border    = Color3.fromRGB(40, 45, 65),
}

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 660, 0, 500)
main.Position = UDim2.new(0.5, -330, 0.5, -250)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
main.ClipsDescendants = false

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = C.border
mainStroke.Thickness = 1

-- ============================================================
-- TOP BAR
-- ============================================================
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 46)
topBar.BackgroundColor3 = C.surface
topBar.ZIndex = 2
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

do
    local fix = Instance.new("Frame", topBar)
    fix.Size = UDim2.new(1, 0, 0, 12)
    fix.Position = UDim2.new(0, 0, 1, -12)
    fix.BackgroundColor3 = C.surface
    fix.BorderSizePixel = 0

    local sq = Instance.new("Frame", topBar)
    sq.Size = UDim2.new(0, 4, 0, 20)
    sq.Position = UDim2.new(0, 16, 0.5, -10)
    sq.BackgroundColor3 = C.accent
    sq.BorderSizePixel = 0
    Instance.new("UICorner", sq).CornerRadius = UDim.new(0, 2)

    local titleLbl = Instance.new("TextLabel", topBar)
    titleLbl.Position = UDim2.new(0, 28, 0, 0)
    titleLbl.Size = UDim2.new(0, 160, 1, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "191 STORE"
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 15
    titleLbl.TextColor3 = C.text
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextStrokeTransparency = 1
end

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 22)
closeBtn.Text = "x"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = C.red
closeBtn.BorderSizePixel = 0
closeBtn.TextStrokeTransparency = 1
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -72, 0.5, -14)
minBtn.BackgroundColor3 = C.card
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.TextColor3 = C.textMid
minBtn.BorderSizePixel = 0
minBtn.TextStrokeTransparency = 1
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- ============================================================
-- SIDEBAR
-- ============================================================
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 80, 1, -46)
sidebar.Position = UDim2.new(0, 0, 0, 46)
sidebar.BackgroundColor3 = C.sidebar
sidebar.ZIndex = 2
sidebar.ClipsDescendants = false

local sidebarLine = Instance.new("Frame", main)
sidebarLine.Size = UDim2.new(0, 1, 1, -46)
sidebarLine.Position = UDim2.new(0, 79, 0, 46)
sidebarLine.BackgroundColor3 = C.border
sidebarLine.BorderSizePixel = 0
sidebarLine.ZIndex = 3

local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Top
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local sidebarPad = Instance.new("UIPadding", sidebar)
sidebarPad.PaddingTop = UDim.new(0, 10)

-- ============================================================
-- CONTENT AREA
-- ============================================================
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -80, 1, -46)
content.Position = UDim2.new(0, 80, 0, 46)
content.BackgroundColor3 = C.panel
content.ClipsDescendants = true
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 0)

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local pages = {}
local tabBtns = {}
local currentTab = nil

local tabDefs = {
    {label = "AUTO",     order = 1},
    {label = "FULLY",    order = 2},
    {label = "TP",       order = 3},
    {label = "MS POT",   order = 4},
    {label = "BUY",      order = 5},
    {label = "SELL",     order = 6},
    {label = "SETTINGS", order = 7},
}

local function switchTab(name)
    for n, p in pairs(pages) do
        p.Visible = (n == name)
    end
    for n, b in pairs(tabBtns) do
        if n == name then
            b.BackgroundColor3 = C.accentDim
            b.BackgroundTransparency = 0
            b.TextColor3 = C.accentGlow
        else
            b.BackgroundTransparency = 1
            b.TextColor3 = C.textDim
        end
    end
    currentTab = name
end

for i, def in ipairs(tabDefs) do
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0, 68, 0, 36)
    btn.BackgroundTransparency = 1
    btn.Text = def.label
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = C.textDim
    btn.BorderSizePixel = 0
    btn.LayoutOrder = def.order
    btn.TextStrokeTransparency = 1
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
    page.ScrollBarImageColor3 = C.accentSoft
    page.Visible = false
    page.BorderSizePixel = 0

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 14)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 14)

    pages[def.label] = page
    tabBtns[def.label] = btn

    btn.MouseButton1Click:Connect(function()
        switchTab(def.label)
        for _, b2 in pairs(tabBtns) do
            local ind = b2:FindFirstChild("Frame")
            if ind then ind.Visible = (b2 == btn) end
        end
    end)
end

-- ============================================================
-- UI COMPONENT BUILDERS
-- ============================================================
local function sectionLabel(parent, text, order)
    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1, 0, 0, 22)
    wrap.BackgroundTransparency = 1
    wrap.LayoutOrder = order or 0

    local lbl = Instance.new("TextLabel", wrap)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextColor3 = C.textDim
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.TextStrokeTransparency = 1

    local line = Instance.new("Frame", wrap)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = C.border
    line.BorderSizePixel = 0

    return wrap
end

local function card(parent, h, order)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, h or 46)
    f.BackgroundColor3 = C.card
    f.BorderSizePixel = 0
    f.LayoutOrder = order or 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    return f
end

local function makeActionBtn(parent, text, color, order)
    local f = Instance.new("TextButton", parent)
    f.Size = UDim2.new(1, 0, 0, 36)
    f.BackgroundColor3 = color or C.accentDim
    f.Font = Enum.Font.GothamBold
    f.TextSize = 12
    f.TextColor3 = C.text
    f.Text = text
    f.BorderSizePixel = 0
    f.LayoutOrder = order or 0
    f.TextStrokeTransparency = 1
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    f.MouseEnter:Connect(function()
        TweenService:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = C.accent}):Play()
    end)
    f.MouseLeave:Connect(function()
        TweenService:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = color or C.accentDim}):Play()
    end)
    return f
end

local function makeSlider(parent, labelText, minV, maxV, defaultV, order, callback)
    local wrap = card(parent, 54, order)

    local lbl = Instance.new("TextLabel", wrap)
    lbl.Position = UDim2.new(0, 12, 0, 8)
    lbl.Size = UDim2.new(1, -80, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 11
    lbl.TextColor3 = C.textMid
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeTransparency = 1

    local valLbl = Instance.new("TextLabel", wrap)
    valLbl.Position = UDim2.new(1, -52, 0, 8)
    valLbl.Size = UDim2.new(0, 42, 0, 16)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defaultV)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 12
    valLbl.TextColor3 = C.accentGlow
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.TextStrokeTransparency = 1

    local track = Instance.new("Frame", wrap)
    track.Position = UDim2.new(0, 12, 0, 34)
    track.Size = UDim2.new(1, -24, 0, 5)
    track.BackgroundColor3 = C.border
    track.BorderSizePixel = 0
    track.Active = true
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill2 = Instance.new("Frame", track)
    fill2.Size = UDim2.new((defaultV - minV)/(maxV - minV), 0, 1, 0)
    fill2.BackgroundColor3 = C.accent
    fill2.BorderSizePixel = 0
    Instance.new("UICorner", fill2).CornerRadius = UDim.new(1, 0)

    local knob2 = Instance.new("Frame", track)
    local kp = (defaultV - minV)/(maxV - minV)
    knob2.Size = UDim2.new(0, 14, 0, 14)
    knob2.Position = UDim2.new(kp, -7, 0.5, -7)
    knob2.BackgroundColor3 = Color3.new(1,1,1)
    knob2.BorderSizePixel = 0
    Instance.new("UICorner", knob2).CornerRadius = UDim.new(1, 0)

    local ks = Instance.new("UIStroke", knob2)
    ks.Color = C.accent
    ks.Thickness = 2

    local dragging = false

    local function update(x)
        local pos = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.floor(minV + pos * (maxV - minV))
        knob2.Position = UDim2.new(pos, -7, 0.5, -7)
        fill2.Size = UDim2.new(pos, 0, 1, 0)
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

local function makeStatusRow(parent, label, order)
    local f = card(parent, 30, order)

    local lbl2 = Instance.new("TextLabel", f)
    lbl2.Position = UDim2.new(0, 12, 0, 0)
    lbl2.Size = UDim2.new(0.6, 0, 1, 0)
    lbl2.BackgroundTransparency = 1
    lbl2.Text = label
    lbl2.Font = Enum.Font.GothamSemibold
    lbl2.TextSize = 11
    lbl2.TextColor3 = C.textMid
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.TextStrokeTransparency = 1

    local val2 = Instance.new("TextLabel", f)
    val2.Position = UDim2.new(0.6, 0, 0, 0)
    val2.Size = UDim2.new(0.4, -10, 1, 0)
    val2.BackgroundTransparency = 1
    val2.Text = "0"
    val2.Font = Enum.Font.GothamBold
    val2.TextSize = 12
    val2.TextColor3 = C.accentGlow
    val2.TextXAlignment = Enum.TextXAlignment.Right
    val2.TextStrokeTransparency = 1

    return val2
end

-- ============================================================
-- AUTO PAGE (MS LOOP)
-- ============================================================
local ap = pages["AUTO"]

sectionLabel(ap, "MS LOOP AUTO COOK", 1)

local waterValAuto = makeStatusRow(ap, "Water", 2)
local sugarValAuto = makeStatusRow(ap, "Sugar Block Bag", 3)
local gelatinValAuto = makeStatusRow(ap, "Gelatin", 4)
local emptyValAuto = makeStatusRow(ap, "Empty Bag", 5)

sectionLabel(ap, "CONTROL", 6)

local msStatusCard = card(ap, 40, 7)
local msStatusLbl = Instance.new("TextLabel", msStatusCard)
msStatusLbl.Size = UDim2.new(1, -20, 1, 0)
msStatusLbl.Position = UDim2.new(0, 12, 0, 0)
msStatusLbl.BackgroundTransparency = 1
msStatusLbl.Text = "STOPPED"
msStatusLbl.Font = Enum.Font.GothamBold
msStatusLbl.TextSize = 13
msStatusLbl.TextColor3 = C.red
msStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
msStatusLbl.TextStrokeTransparency = 1

local msStartBtn = makeActionBtn(ap, "START MS LOOP", C.green, 8)
local msStopBtn = makeActionBtn(ap, "STOP MS LOOP", C.red, 9)

local msRunning = false

local function updateAutoInventory()
    waterValAuto.Text = tostring(countItem("Water"))
    sugarValAuto.Text = tostring(countItem("Sugar Block Bag"))
    gelatinValAuto.Text = tostring(countItem("Gelatin"))
    emptyValAuto.Text = tostring(countItem("Empty Bag"))
end

-- FUNGSI MASAK SEDERHANA
local function cookProcess()
    pcall(function()
        equip("Water")
        holdE(0.7)
        for i = 20, 1, -1 do
            if not msRunning and not fullyRunning then return end
            task.wait(1)
        end
        
        equip("Sugar Block Bag")
        holdE(0.7)
        task.wait(1)
        
        equip("Gelatin")
        holdE(0.7)
        task.wait(1)
        
        for i = 45, 1, -1 do
            if not msRunning and not fullyRunning then return end
            task.wait(1)
        end
        
        equip("Empty Bag")
        holdE(0.7)
        task.wait(1)
    end)
end

local function msLoop()
    while msRunning do
        updateAutoInventory()
        msStatusLbl.Text = "COOKING..."
        cookProcess()
        updateAutoInventory()
        task.wait(2)
    end
    msStatusLbl.Text = "STOPPED"
end

msStartBtn.MouseButton1Click:Connect(function()
    if not msRunning then
        msRunning = true
        msStartBtn.Text = "STOP MS LOOP"
        TweenService:Create(msStartBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.red}):Play()
        msStatusLbl.Text = "RUNNING"
        msStatusLbl.TextColor3 = C.green
        task.spawn(msLoop)
    end
end)

msStopBtn.MouseButton1Click:Connect(function()
    msRunning = false
    msStartBtn.Text = "START MS LOOP"
    TweenService:Create(msStartBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.green}):Play()
    msStatusLbl.Text = "STOPPED"
    msStatusLbl.TextColor3 = C.red
end)

-- ============================================================
-- FULLY PAGE (FIXED STOP)
-- ============================================================
local fullyPage = pages["FULLY"]

sectionLabel(fullyPage, "AUTO FULLY", 1)

local waterValFully = makeStatusRow(fullyPage, "Water", 2)
local sugarValFully = makeStatusRow(fullyPage, "Sugar Block Bag", 3)
local gelatinValFully = makeStatusRow(fullyPage, "Gelatin", 4)
local emptyValFully = makeStatusRow(fullyPage, "Empty Bag", 5)

sectionLabel(fullyPage, "SETTING", 6)

local targetSliderWrap, targetValLbl = makeSlider(fullyPage, "TARGET FULLY", 1, 50, 5, 7, function(v)
    fullyTarget = v
end)

local fullyStatusCard = card(fullyPage, 40, 8)
local fullyStatusLbl = Instance.new("TextLabel", fullyStatusCard)
fullyStatusLbl.Size = UDim2.new(1, -20, 1, 0)
fullyStatusLbl.Position = UDim2.new(0, 12, 0, 0)
fullyStatusLbl.BackgroundTransparency = 1
fullyStatusLbl.Text = "STOPPED"
fullyStatusLbl.Font = Enum.Font.GothamBold
fullyStatusLbl.TextSize = 13
fullyStatusLbl.TextColor3 = C.red
fullyStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
fullyStatusLbl.TextStrokeTransparency = 1

local fullyStartBtn = makeActionBtn(fullyPage, "START FULLY", C.green, 9)
local fullyStopBtn = makeActionBtn(fullyPage, "STOP FULLY", C.red, 10)

-- FULLY LOGIC
local fullyRunning = false
local fullySavedPos = nil
local NPC_MS_POS = Vector3.new(510.061, 4.476, 600.548)
local fullyLoopThread = nil

local function updateFullyInventory()
    waterValFully.Text = tostring(countItem("Water"))
    sugarValFully.Text = tostring(countItem("Sugar Block Bag"))
    gelatinValFully.Text = tostring(countItem("Gelatin"))
    emptyValFully.Text = tostring(countItem("Empty Bag"))
end

local function setFullyStatus(msg, color)
    fullyStatusLbl.Text = msg
    fullyStatusLbl.TextColor3 = color or C.textMid
end

local function fullyBuy(qty)
    if not storePurchaseRE then return false end
    if not fullyRunning then return false end
    
    local items = {"Water", "Sugar Block Bag", "Gelatin", "Empty Bag"}
    
    for _, item in ipairs(items) do
        if not fullyRunning then return false end
        setFullyStatus("BUYING " .. item .. " x" .. qty, Color3.fromRGB(100, 180, 255))
        for i = 1, qty do
            if not fullyRunning then return false end
            pcall(function() storePurchaseRE:FireServer(item, 1) end)
            task.wait(0.4)
        end
        task.wait(0.5)
    end
    setFullyStatus("PURCHASE COMPLETE!", Color3.fromRGB(80, 220, 130))
    task.wait(1)
    return true
end

local function fullySell()
    if not fullyRunning then return false end
    
    local sellItems = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
    
    for _, item in ipairs(sellItems) do
        if not fullyRunning then return false end
        while countItem(item) > 0 and fullyRunning do
            setFullyStatus("SELLING " .. item, Color3.fromRGB(52, 210, 110))
            pcall(function()
                equip(item)
                holdE(0.7)
                task.wait(1)
            end)
            if not fullyRunning then return false end
            task.wait(0.1)
        end
    end
    setFullyStatus("SELLING COMPLETE!", Color3.fromRGB(52, 210, 110))
    task.wait(1)
    return true
end

local function fullyCook()
    if not fullyRunning then return false end
    
    pcall(function()
        equip("Water")
        holdE(0.7)
        for i = 20, 1, -1 do
            if not fullyRunning then return end
            task.wait(1)
        end
        
        if not fullyRunning then return end
        equip("Sugar Block Bag")
        holdE(0.7)
        task.wait(1)
        
        if not fullyRunning then return end
        equip("Gelatin")
        holdE(0.7)
        task.wait(1)
        
        if not fullyRunning then return end
        for i = 45, 1, -1 do
            if not fullyRunning then return end
            task.wait(1)
        end
        
        if not fullyRunning then return end
        equip("Empty Bag")
        holdE(0.7)
        task.wait(1)
    end)
    
    return true
end

local function fullyLoop()
    setFullyStatus("TARGET: " .. fullyTarget .. " MS PER LOOP", Color3.fromRGB(100, 180, 255))
    
    while fullyRunning do
        if not fullyRunning then break end
        
        -- BELI
        setFullyStatus("TELEPORT TO NPC", Color3.fromRGB(100, 180, 255))
        stepTeleport(NPC_MS_POS)
        task.wait(1)
        
        if not fullyRunning then break end
        fullyBuy(fullyTarget)
        if not fullyRunning then break end
        
        -- KEMBALI
        if fullySavedPos then
            setFullyStatus("RETURN TO APARTMENT", Color3.fromRGB(148, 80, 255))
            stepTeleport(fullySavedPos)
            task.wait(1)
        end
        
        if not fullyRunning then break end
        updateFullyInventory()
        
        -- MASAK
        local cooked = 0
        while fullyRunning and cooked < fullyTarget do
            setFullyStatus("COOKING MS " .. (cooked + 1) .. "/" .. fullyTarget, Color3.fromRGB(82, 130, 255))
            fullyCook()
            cooked = cooked + 1
            updateFullyInventory()
            task.wait(0.5)
            if not fullyRunning then break end
        end
        
        if not fullyRunning then break end
        
        -- JUAL
        setFullyStatus("TELEPORT TO NPC FOR SELLING", Color3.fromRGB(52, 210, 110))
        stepTeleport(NPC_MS_POS)
        task.wait(1)
        
        if not fullyRunning then break end
        fullySell()
        if not fullyRunning then break end
        
        setFullyStatus("LOOP COMPLETE, RESTARTING...", Color3.fromRGB(100, 180, 255))
        task.wait(2)
    end
    
    -- TAMAT
    fullyRunning = false
    fullyStartBtn.Text = "START FULLY"
    TweenService:Create(fullyStartBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.green}):Play()
    setFullyStatus("STOPPED", C.red)
    fullyLoopThread = nil
end

fullyStartBtn.MouseButton1Click:Connect(function()
    if fullyRunning then return end
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        setFullyStatus("CANNOT GET POSITION!", C.red)
        return
    end
    
    fullySavedPos = hrp.Position
    fullyRunning = true
    
    fullyStartBtn.Text = "RUNNING..."
    TweenService:Create(fullyStartBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.accentDim}):Play()
    setFullyStatus("RUNNING", C.green)
    
    if fullyLoopThread then task.cancel(fullyLoopThread) end
    fullyLoopThread = task.spawn(fullyLoop)
end)

fullyStopBtn.MouseButton1Click:Connect(function()
    if not fullyRunning then return
    fullyRunning = false
    setFullyStatus("STOPPING...", C.orange)
end)

-- ============================================================
-- TP PAGE
-- ============================================================
local tp = pages["TP"]

local LOCATIONS = {
    {name = "Dealer NPC",      pos = Vector3.new(770.992, 3.71, 433.75)},
    {name = "NPC Marshmallow", pos = Vector3.new(510.061, 4.476, 600.548)},
    {name = "Apart 1",         pos = Vector3.new(1137.992, 9.932, 449.753)},
    {name = "Apart 2",         pos = Vector3.new(1139.174, 9.932, 420.556)},
    {name = "Apart 3",         pos = Vector3.new(984.856, 9.932, 247.280)},
    {name = "Apart 4",         pos = Vector3.new(988.311, 9.932, 221.664)},
    {name = "Apart 5",         pos = Vector3.new(923.954, 9.932, 42.202)},
    {name = "Apart 6",         pos = Vector3.new(895.721, 9.932, 41.928)},
    {name = "Casino",          pos = Vector3.new(1166.33, 3.36, -29.77)},
    {name = "Hospital",        pos = Vector3.new(1065.19, 28.47, 420.76)},
    {name = "Apt Casino 1",    pos = Vector3.new(1202.30, 3.71, -220.91)},
    {name = "Apt Casino 2",    pos = Vector3.new(1179.72, 3.71, -230.21)},
    {name = "Apt Casino 3",    pos = Vector3.new(1202.31, 3.71, -182.55)},
}

for i, loc in ipairs(LOCATIONS) do
    local btn = makeActionBtn(tp, loc.name, C.card, i)
    btn.MouseButton1Click:Connect(function()
        stepTeleport(loc.pos)
    end)
end

-- ============================================================
-- MS POT PAGE
-- ============================================================
local mspot = pages["MS POT"]

sectionLabel(mspot, "DELETE PART BELOW", 1)

local deleteFloorBtn = makeActionBtn(mspot, "DELETE PART BELOW", Color3.fromRGB(120, 20, 50), 2)
local undoBtn = makeActionBtn(mspot, "UNDO", C.card, 3)

sectionLabel(mspot, "FIND COOK (PROMPT SCANNER)", 4)

local findCookBtn = makeActionBtn(mspot, "FIND COOK", Color3.fromRGB(0, 100, 80), 5)

local deletedStack = {}
local scannedPrompts = {}
local SCAN_RADIUS = 50
local isDeleting = false

local function getPromptPosition(prompt)
    local p = prompt.Parent
    if not p then return nil end
    if p:IsA("BasePart") then return p.Position end
    if p:IsA("Attachment") then return p.WorldPosition end
    if p:IsA("Model") then
        if p.PrimaryPart then return p.PrimaryPart.Position end
        for _, child in ipairs(p:GetDescendants()) do
            if child:IsA("BasePart") then return child.Position end
        end
    end
    local gp = p.Parent
    if gp then
        if gp:IsA("BasePart") then return gp.Position end
        if gp:IsA("Model") then
            if gp.PrimaryPart then return gp.PrimaryPart.Position end
            for _, child in ipairs(gp:GetDescendants()) do
                if child:IsA("BasePart") then return child.Position end
            end
        end
    end
    return nil
end

local function doPromptScan()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for prompt, data in pairs(scannedPrompts) do
        if prompt and prompt.Parent then
            prompt.MaxActivationDistance = data.maxDist
            prompt.RequiresLineOfSight   = data.lineOfSight
            prompt.Enabled               = data.enabled
            prompt.HoldDuration          = data.holdDuration
        end
    end
    scannedPrompts = {}

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local pos = getPromptPosition(v)
            if pos then
                local dist = (hrp.Position - pos).Magnitude
                if dist <= SCAN_RADIUS then
                    scannedPrompts[v] = {
                        maxDist      = v.MaxActivationDistance,
                        lineOfSight  = v.RequiresLineOfSight,
                        enabled      = v.Enabled,
                        holdDuration = v.HoldDuration,
                    }
                    v.Enabled               = true
                    v.MaxActivationDistance = 20
                    v.RequiresLineOfSight   = false
                    v.HoldDuration          = 0
                end
            end
        end
    end
end

findCookBtn.MouseButton1Click:Connect(function()
    findCookBtn.Text = "SCANNING..."
    TweenService:Create(findCookBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 60, 50)}):Play()
    task.spawn(function()
        doPromptScan()
        task.wait(0.3)
        findCookBtn.Text = "FIND COOK"
        TweenService:Create(findCookBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 100, 80)}):Play()
    end)
end)

deleteFloorBtn.MouseButton1Click:Connect(function()
    if isDeleting then return end
    isDeleting = true
    deleteFloorBtn.Text = "PROCESSING..."
    TweenService:Create(deleteFloorBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 0, 30)}):Play()

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        isDeleting = false
        deleteFloorBtn.Text = "DELETE PART BELOW"
        TweenService:Create(deleteFloorBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(120, 20, 50)}):Play()
        return
    end

    local rayOrigin = hrp.Position
    local rayDir = Vector3.new(0, -15, 0)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local result = workspace:Raycast(rayOrigin, rayDir, rayParams)
    if result and result.Instance then
        local hit = result.Instance
        if hit and hit.Parent then
            table.insert(deletedStack, {object = hit:Clone(), parent = hit.Parent})
            hit:Destroy()
        end
    end

    task.wait(0.3)
    isDeleting = false
    deleteFloorBtn.Text = "DELETE PART BELOW"
    TweenService:Create(deleteFloorBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(120, 20, 50)}):Play()
end)

undoBtn.MouseButton1Click:Connect(function()
    local last = table.remove(deletedStack)
    if last and last.object then
        last.object.Parent = last.parent
    end
end)

-- ============================================================
-- BUY PAGE
-- ============================================================
local buyp = pages["BUY"]

sectionLabel(buyp, "AUTO BUY INGREDIENTS", 1)

local buyStatusCard = card(buyp, 40, 2)
local buyStatusLbl = Instance.new("TextLabel", buyStatusCard)
buyStatusLbl.Size = UDim2.new(1, -20, 1, 0)
buyStatusLbl.Position = UDim2.new(0, 12, 0, 0)
buyStatusLbl.BackgroundTransparency = 1
buyStatusLbl.Text = "STOPPED"
buyStatusLbl.Font = Enum.Font.GothamBold
buyStatusLbl.TextSize = 13
buyStatusLbl.TextColor3 = C.red
buyStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
buyStatusLbl.TextStrokeTransparency = 1

local buyTotalCard = card(buyp, 30, 3)
local buyTotalLbl = Instance.new("TextLabel", buyTotalCard)
buyTotalLbl.Size = UDim2.new(1, -20, 1, 0)
buyTotalLbl.Position = UDim2.new(0, 12, 0, 0)
buyTotalLbl.BackgroundTransparency = 1
buyTotalLbl.Text = "Total: 0 items"
buyTotalLbl.Font = Enum.Font.Gotham
buyTotalLbl.TextSize = 11
buyTotalLbl.TextColor3 = C.textMid
buyTotalLbl.TextXAlignment = Enum.TextXAlignment.Left
buyTotalLbl.TextStrokeTransparency = 1

local buySliderWrap, buyValLbl = makeSlider(buyp, "BUY AMOUNT PER ITEM", 1, 50, 10, 4, function(v)
    buyAmount = v
end)

local buyStartBtn = makeActionBtn(buyp, "START BUY", C.green, 5)
local buyStopBtn = makeActionBtn(buyp, "STOP BUY", C.red, 6)

local autoBuyRunning = false
local autoBuyTotalBought = 0

local function startAutoBuy()
    if autoBuyRunning then return end
    if not storePurchaseRE then
        buyStatusLbl.Text = "ERROR!"
        buyStatusLbl.TextColor3 = C.red
        task.wait(2)
        buyStatusLbl.Text = "STOPPED"
        return
    end
    
    autoBuyRunning = true
    autoBuyTotalBought = 0
    buyStatusLbl.Text = "RUNNING"
    buyStatusLbl.TextColor3 = C.green
    buyTotalLbl.Text = "Total: 0 items"
    
    local BUY_ITEMS = {"Water", "Sugar Block Bag", "Gelatin"}
    
    task.spawn(function()
        local amount = buyAmount
        
        for _, itemName in ipairs(BUY_ITEMS) do
            if not autoBuyRunning then break end
            
            buyStatusLbl.Text = "Buying " .. itemName .. " x" .. amount
            buyStatusLbl.TextColor3 = Color3.fromRGB(255,255,100)
            
            for i = 1, amount do
                if not autoBuyRunning then break end
                pcall(function() storePurchaseRE:FireServer(itemName, 1) end)
                autoBuyTotalBought = autoBuyTotalBought + 1
                buyTotalLbl.Text = "Total: " .. autoBuyTotalBought .. " items"
                task.wait(0.5)
            end
            task.wait(0.8)
        end
        
        if autoBuyRunning then
            buyStatusLbl.Text = "Complete! " .. autoBuyTotalBought .. " items"
            buyStatusLbl.TextColor3 = C.green
            task.wait(2)
            if autoBuyRunning then
                buyStatusLbl.Text = "STOPPED"
                buyStatusLbl.TextColor3 = C.red
                autoBuyRunning = false
            end
        end
    end)
end

local function stopAutoBuy()
    autoBuyRunning = false
    buyStatusLbl.Text = "STOPPED"
    buyStatusLbl.TextColor3 = C.red
end

buyStartBtn.MouseButton1Click:Connect(startAutoBuy)
buyStopBtn.MouseButton1Click:Connect(stopAutoBuy)

-- ============================================================
-- SELL PAGE
-- ============================================================
local sellp = pages["SELL"]

sectionLabel(sellp, "AUTO SELL MARSHMALLOW BAGS", 1)

local sellStatusCard = card(sellp, 40, 2)
local sellStatusLbl = Instance.new("TextLabel", sellStatusCard)
sellStatusLbl.Size = UDim2.new(1, -20, 1, 0)
sellStatusLbl.Position = UDim2.new(0, 12, 0, 0)
sellStatusLbl.BackgroundTransparency = 1
sellStatusLbl.Text = "STOPPED"
sellStatusLbl.Font = Enum.Font.GothamBold
sellStatusLbl.TextSize = 13
sellStatusLbl.TextColor3 = C.red
sellStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
sellStatusLbl.TextStrokeTransparency = 1

local sellCounterCard = card(sellp, 30, 3)
local sellCounterLbl = Instance.new("TextLabel", sellCounterCard)
sellCounterLbl.Size = UDim2.new(1, -20, 1, 0)
sellCounterLbl.Position = UDim2.new(0, 12, 0, 0)
sellCounterLbl.BackgroundTransparency = 1
sellCounterLbl.Text = "Sold: 0"
sellCounterLbl.Font = Enum.Font.GothamBold
sellCounterLbl.TextSize = 12
sellCounterLbl.TextColor3 = C.accentGlow
sellCounterLbl.TextXAlignment = Enum.TextXAlignment.Left
sellCounterLbl.TextStrokeTransparency = 1

local sellStartBtn = makeActionBtn(sellp, "START SELL", C.green, 4)
local sellStopBtn = makeActionBtn(sellp, "STOP SELL", C.red, 5)

local autoSellRunning = false
local autoSellCount = 0
local SELL_TOOLS = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}

local function getSellTools()
    local tools = {}
    if player.Character then
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("Tool") then
                for _, toolName in ipairs(SELL_TOOLS) do
                    if child.Name == toolName then table.insert(tools, child) break end
                end
            end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                for _, toolName in ipairs(SELL_TOOLS) do
                    if child.Name == toolName then table.insert(tools, child) break end
                end
            end
        end
    end
    return tools
end

local function startAutoSell()
    if autoSellRunning then return end
    autoSellRunning = true
    autoSellCount = 0
    sellStatusLbl.Text = "RUNNING"
    sellStatusLbl.TextColor3 = C.green
    
    task.spawn(function()
        while autoSellRunning do
            local tools = getSellTools()
            
            if #tools > 0 then
                for _, tool in ipairs(tools) do
                    if not autoSellRunning then break end
                    if tool and tool.Parent then
                        if tool.Parent == player:FindFirstChild("Backpack") then
                            local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                            if humanoid then humanoid:EquipTool(tool) task.wait(0.3) end
                        end
                        sellStatusLbl.Text = "SELLING..."
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        local holdStart = tick()
                        while autoSellRunning and (tick() - holdStart) < 2 do task.wait(0.1) end
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        autoSellCount = autoSellCount + 1
                        sellCounterLbl.Text = "Sold: " .. autoSellCount
                        sellStatusLbl.Text = "RUNNING"
                        task.wait(1)
                    end
                end
            else
                task.wait(2)
            end
            task.wait(0.5)
        end
    end)
end

local function stopAutoSell()
    autoSellRunning = false
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    sellStatusLbl.Text = "STOPPED"
    sellStatusLbl.TextColor3 = C.red
end

sellStartBtn.MouseButton1Click:Connect(startAutoSell)
sellStopBtn.MouseButton1Click:Connect(stopAutoSell)

-- ============================================================
-- SETTINGS PAGE
-- ============================================================
local settingsp = pages["SETTINGS"]

sectionLabel(settingsp, "SHORTCUT SETTINGS", 1)

local blinkToggleCard = card(settingsp, 50, 2)
local blinkToggleTitle = Instance.new("TextLabel", blinkToggleCard)
blinkToggleTitle.Size = UDim2.new(0.6, 0, 1, 0)
blinkToggleTitle.Position = UDim2.new(0, 12, 0, 0)
blinkToggleTitle.BackgroundTransparency = 1
blinkToggleTitle.Text = "Shortcut T (Blink Forward)"
blinkToggleTitle.Font = Enum.Font.GothamSemibold
blinkToggleTitle.TextSize = 12
blinkToggleTitle.TextColor3 = C.text
blinkToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
blinkToggleTitle.TextStrokeTransparency = 1

local blinkToggleBtn = Instance.new("TextButton", blinkToggleCard)
blinkToggleBtn.Size = UDim2.new(0, 80, 0, 32)
blinkToggleBtn.Position = UDim2.new(1, -92, 0.5, -16)
blinkToggleBtn.BackgroundColor3 = C.green
blinkToggleBtn.Text = "ON"
blinkToggleBtn.Font = Enum.Font.GothamBold
blinkToggleBtn.TextSize = 12
blinkToggleBtn.TextColor3 = C.text
blinkToggleBtn.BorderSizePixel = 0
blinkToggleBtn.TextStrokeTransparency = 1
Instance.new("UICorner", blinkToggleBtn).CornerRadius = UDim.new(0, 6)

blinkToggleBtn.MouseButton1Click:Connect(function()
    blinkEnabled = not blinkEnabled
    if blinkEnabled then
        blinkToggleBtn.Text = "ON"
        blinkToggleBtn.BackgroundColor3 = C.green
    else
        blinkToggleBtn.Text = "OFF"
        blinkToggleBtn.BackgroundColor3 = C.red
    end
end)

sectionLabel(settingsp, "BLINK BUTTONS FOR MOBILE", 3)

local blinkMajuBtn = makeActionBtn(settingsp, "BLINK FORWARD", C.accentDim, 4)
local blinkMundurBtn = makeActionBtn(settingsp, "BLINK BACKWARD", C.accentDim, 5)
local blinkAtasBtn = makeActionBtn(settingsp, "BLINK UP", C.accentDim, 6)
local blinkBawahBtn = makeActionBtn(settingsp, "BLINK DOWN", C.accentDim, 7)

blinkMajuBtn.MouseButton1Click:Connect(blinkMaju)
blinkMundurBtn.MouseButton1Click:Connect(blinkMundur)
blinkAtasBtn.MouseButton1Click:Connect(blinkAtas)
blinkBawahBtn.MouseButton1Click:Connect(blinkBawah)

-- ============================================================
-- INVENTORY UPDATE LOOP
-- ============================================================
task.spawn(function()
    while gui and gui.Parent do
        if pages["AUTO"] and pages["AUTO"].Visible then
            updateAutoInventory()
        end
        if pages["FULLY"] and pages["FULLY"].Visible then
            updateFullyInventory()
        end
        task.wait(1)
    end
end)

-- ============================================================
-- MINIMIZE BUTTON
-- ============================================================
local bodyVisible = true

minBtn.MouseButton1Click:Connect(function()
    bodyVisible = not bodyVisible
    sidebar.Visible = bodyVisible
    content.Visible = bodyVisible
    if bodyVisible then
        TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 660, 0, 500)}):Play()
    else
        TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 660, 0, 46)}):Play()
    end
end)

-- ============================================================
-- HIDE BUTTON + KEYBIND Z
-- ============================================================
local hideBtn = Instance.new("TextButton", gui)
hideBtn.Size = UDim2.new(0, 42, 0, 42)
hideBtn.Position = UDim2.new(1, -52, 0.5, -21)
hideBtn.Text = "191"
hideBtn.Font = Enum.Font.GothamBlack
hideBtn.TextSize = 12
hideBtn.BackgroundColor3 = C.accent
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Active = true
hideBtn.Draggable = true
hideBtn.BorderSizePixel = 0
hideBtn.TextStrokeTransparency = 1
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 10)

hideBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

ContextActionService:BindAction("toggleUI_191", function(_, state)
    if state == Enum.UserInputState.Begin then
        main.Visible = not main.Visible
    end
end, false, Enum.KeyCode.Z)

-- ============================================================
-- STARTUP
-- ============================================================
switchTab("AUTO")
