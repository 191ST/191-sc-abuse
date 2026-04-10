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
local running = false
local buyAmount = 1

local buyRemote = ReplicatedStorage:FindFirstChild("RemoteEvents") and ReplicatedStorage.RemoteEvents:FindFirstChild("StorePurchase")

-- ========== BLINK SHORTCUT (KEY T) ==========
local function blinkMajuShortcut()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 8
    end
end

ContextActionService:BindAction("blink_forward", function(_, state)
    if state == Enum.UserInputState.Begin then
        blinkMajuShortcut()
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

local function findTool(toolName)
    if player.Character then
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("Tool") and string.find(string.lower(child.Name), string.lower(toolName)) then
                return child
            end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") and string.find(string.lower(child.Name), string.lower(toolName)) then
                return child
            end
        end
    end
    return nil
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
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "191_STORE"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ============================================================
-- COLOR PALETTE (BIRU & HITAM)
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
    borderAct = Color3.fromRGB(0, 110, 220),
}

-- ============================================================
-- SIMPLE LOADING OVERLAY
-- ============================================================
local showLoading, hideLoading
do
    local loadGui = Instance.new("ScreenGui")
    loadGui.Name = "191_LOAD"
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
    glow.BackgroundColor3 = Color3.fromRGB(0, 70, 150)
    glow.BackgroundTransparency = 0.88
    glow.BorderSizePixel = 0
    glow.ZIndex = 11
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(0, 500, 0, 56)
    title.Position = UDim2.new(0.5, -250, 0.5, -50)
    title.BackgroundTransparency = 1
    title.Text = "191 STORE"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 44
    title.TextColor3 = Color3.fromRGB(50, 150, 255)
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 12

    local line = Instance.new("Frame", bg)
    line.Size = UDim2.new(0, 200, 0, 1)
    line.Position = UDim2.new(0.5, -100, 0.5, 14)
    line.BackgroundColor3 = Color3.fromRGB(0, 110, 220)
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0
    line.ZIndex = 12
    Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)

    local subLbl = Instance.new("TextLabel", bg)
    subLbl.Size = UDim2.new(0, 400, 0, 22)
    subLbl.Position = UDim2.new(0.5, -200, 0.5, 24)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Teleporting..."
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 13
    subLbl.TextColor3 = Color3.fromRGB(0, 90, 190)
    subLbl.TextXAlignment = Enum.TextXAlignment.Center
    subLbl.ZIndex = 12

    local ver = Instance.new("TextLabel", bg)
    ver.Size = UDim2.new(1, 0, 0, 18)
    ver.Position = UDim2.new(0, 0, 1, -22)
    ver.BackgroundTransparency = 1
    ver.Text = "191 STORE v191  •  Blue Edition"
    ver.Font = Enum.Font.Gotham
    ver.TextSize = 11
    ver.TextColor3 = Color3.fromRGB(60, 65, 90)
    ver.TextXAlignment = Enum.TextXAlignment.Center
    ver.ZIndex = 12

    task.spawn(function()
        local pats = {"Teleporting", "Teleporting.", "Teleporting..", "Teleporting..."}
        local idx = 1
        while loadGui and loadGui.Parent do
            if loadGui.Enabled then
                subLbl.Text = pats[idx]
                idx = (idx % #pats) + 1
            end
            task.wait(0.3)
        end
    end)

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

    local bar_left = Instance.new("Frame", card)
    bar_left.Size = UDim2.new(0, 3, 1, 0)
    bar_left.BackgroundColor3 = color
    bar_left.BorderSizePixel = 0
    bar_left.ZIndex = 101

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
-- MAIN WINDOW
-- ============================================================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 660, 0, 430)
main.Position = UDim2.new(0.5, -330, 0.5, -215)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
main.ClipsDescendants = false

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = C.border
mainStroke.Thickness = 1

local topGlow = Instance.new("Frame", main)
topGlow.Size = UDim2.new(1, 0, 0, 1)
topGlow.BackgroundColor3 = C.accentSoft
topGlow.BorderSizePixel = 0
topGlow.ZIndex = 5
topGlow.BackgroundTransparency = 0.3

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

    local accentLine = Instance.new("Frame", topBar)
    accentLine.Size = UDim2.new(1, 0, 0, 1)
    accentLine.Position = UDim2.new(0, 0, 1, -1)
    accentLine.BackgroundColor3 = C.border
    accentLine.BorderSizePixel = 0

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

    local badge = Instance.new("Frame", topBar)
    badge.Size = UDim2.new(0, 38, 0, 18)
    badge.Position = UDim2.new(0, 190, 0.5, -9)
    badge.BackgroundColor3 = C.accentDim
    badge.BorderSizePixel = 0
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)
    local badgeTxt = Instance.new("TextLabel", badge)
    badgeTxt.Size = UDim2.new(1,0,1,0)
    badgeTxt.BackgroundTransparency = 1
    badgeTxt.Text = "v191"
    badgeTxt.Font = Enum.Font.GothamBold
    badgeTxt.TextSize = 10
    badgeTxt.TextColor3 = C.accentGlow
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
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    running = false
    notify("191 Store", "Script dihentikan.", "error")
    task.wait(0.4)
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
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- ============================================================
-- TEXT SIDEBAR
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

local contentFix = Instance.new("Frame", content)
contentFix.Size = UDim2.new(0, 12, 1, 0)
contentFix.BackgroundColor3 = C.panel
contentFix.BorderSizePixel = 0

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local pages = {}
local tabBtns = {}
local currentTab = nil

local tabDefs = {
    {label = "FARM",     order = 1},
    {label = "AUTO",     order = 2},
    {label = "STATUS",   order = 3},
    {label = "TP",       order = 4},
    {label = "MS POT",   order = 5},
    {label = "BUY",      order = 6},
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
    local s = Instance.new("UIStroke", f)
    s.Color = C.border
    s.Thickness = 1
    return f
end

local function makeToggleBtn(parent, text, order)
    local f = card(parent, 38, order)
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.TextColor3 = C.text
    btn.Text = text
    btn.BorderSizePixel = 0

    local pill = Instance.new("Frame", f)
    pill.Size = UDim2.new(0, 28, 0, 14)
    pill.Position = UDim2.new(1, -40, 0.5, -7)
    pill.BackgroundColor3 = C.textDim
    pill.BorderSizePixel = 0
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", pill)
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new(0, 2, 0.5, -5)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = false
    local function setToggle(on)
        state = on
        if on then
            TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = C.accent}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(1, -12, 0.5, -5)}):Play()
            btn.TextColor3 = C.accentGlow
        else
            TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = C.textDim}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(0, 2, 0.5, -5)}):Play()
            btn.TextColor3 = C.text
        end
    end

    btn.MouseButton1Click:Connect(function()
        setToggle(not state)
    end)

    return btn, f, setToggle
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
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local s = Instance.new("UIStroke", f)
    s.Color = C.border
    s.Thickness = 1

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

    local valLbl = Instance.new("TextLabel", wrap)
    valLbl.Position = UDim2.new(1, -52, 0, 8)
    valLbl.Size = UDim2.new(0, 42, 0, 16)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defaultV)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 12
    valLbl.TextColor3 = C.accentGlow
    valLbl.TextXAlignment = Enum.TextXAlignment.Right

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

    local val2 = Instance.new("TextLabel", f)
    val2.Position = UDim2.new(0.6, 0, 0, 0)
    val2.Size = UDim2.new(0.4, -10, 1, 0)
    val2.BackgroundTransparency = 1
    val2.Text = "0"
    val2.Font = Enum.Font.GothamBold
    val2.TextSize = 12
    val2.TextColor3 = C.accentGlow
    val2.TextXAlignment = Enum.TextXAlignment.Right

    return val2, f
end

-- ============================================================
-- FARM PAGE
-- ============================================================
local fp = pages["FARM"]

sectionLabel(fp, "Status", 1)

local statusCard = card(fp, 36, 2)
local statusLabel = Instance.new("TextLabel", statusCard)
statusLabel.Size = UDim2.new(1, -20, 1, 0)
statusLabel.Position = UDim2.new(0, 12, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "IDLE"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 12
statusLabel.TextColor3 = C.textMid
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

sectionLabel(fp, "Inventory", 3)

local waterVal, _  = makeStatusRow(fp, "Water",            4)
local sugarVal, _  = makeStatusRow(fp, "Sugar Block Bag",  5)
local gelatinVal,_ = makeStatusRow(fp, "Gelatin",          6)
local bagVal, _    = makeStatusRow(fp, "Empty Bag",        7)

sectionLabel(fp, "Controls", 8)

local buySliderWrap, buyValLbl = makeSlider(fp, "BUY AMOUNT", 1, 25, 1, 9, function(v)
    buyAmount = v
end)

local farmToggleBtn = makeActionBtn(fp, "START FARM", C.accentDim, 10)
local buyNowBtn     = makeActionBtn(fp, "BUY NOW", C.card, 11)

sectionLabel(fp, "Cook Progress", 12)

local function makeProgressCard(label, order)
    local f = card(fp, 34, order)
    local lbl3 = Instance.new("TextLabel", f)
    lbl3.Position = UDim2.new(0, 10, 0, 5)
    lbl3.Size = UDim2.new(0.6, 0, 0, 13)
    lbl3.BackgroundTransparency = 1
    lbl3.Text = label
    lbl3.Font = Enum.Font.GothamSemibold
    lbl3.TextSize = 10
    lbl3.TextColor3 = C.textMid
    lbl3.TextXAlignment = Enum.TextXAlignment.Left
    local bg2 = Instance.new("Frame", f)
    bg2.Position = UDim2.new(0, 10, 0, 22)
    bg2.Size = UDim2.new(1, -20, 0, 5)
    bg2.BackgroundColor3 = C.border
    bg2.BorderSizePixel = 0
    Instance.new("UICorner", bg2).CornerRadius = UDim.new(1, 0)
    local bar2 = Instance.new("Frame", bg2)
    bar2.Size = UDim2.new(0, 0, 1, 0)
    bar2.BackgroundColor3 = C.accent
    bar2.BorderSizePixel = 0
    Instance.new("UICorner", bar2).CornerRadius = UDim.new(1, 0)
    return bar2
end

local waterBar   = makeProgressCard("Water (20s)",   13)
local sugarBar   = makeProgressCard("Sugar (1s)",    14)
local gelatinBar = makeProgressCard("Gelatin (1s)",  15)
local bagBar     = makeProgressCard("Bag (45s)",     16)

-- ============================================================
-- AUTO PAGE (MS Loop dengan HP Safe)
-- ============================================================
local ap = pages["AUTO"]

sectionLabel(ap, "MS Loop (Auto Cook)", 1)

local msStatusCard = card(ap, 40, 2)
local msStatusLbl = Instance.new("TextLabel", msStatusCard)
msStatusLbl.Size = UDim2.new(1, -20, 1, 0)
msStatusLbl.Position = UDim2.new(0, 12, 0, 0)
msStatusLbl.BackgroundTransparency = 1
msStatusLbl.Text = "⏹️ STOPPED"
msStatusLbl.Font = Enum.Font.GothamBold
msStatusLbl.TextSize = 13
msStatusLbl.TextColor3 = C.red
msStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local stepCard = card(ap, 30, 3)
local stepLbl = Instance.new("TextLabel", stepCard)
stepLbl.Size = UDim2.new(1, -20, 1, 0)
stepLbl.Position = UDim2.new(0, 12, 0, 0)
stepLbl.BackgroundTransparency = 1
stepLbl.Text = "Step: Waiting..."
stepLbl.Font = Enum.Font.Gotham
stepLbl.TextSize = 11
stepLbl.TextColor3 = C.textMid
stepLbl.TextXAlignment = Enum.TextXAlignment.Left

local timerCard = card(ap, 30, 4)
local timerLbl = Instance.new("TextLabel", timerCard)
timerLbl.Size = UDim2.new(1, -20, 1, 0)
timerLbl.Position = UDim2.new(0, 12, 0, 0)
timerLbl.BackgroundTransparency = 1
timerLbl.Text = "Timer: 0s"
timerLbl.Font = Enum.Font.Gotham
timerLbl.TextSize = 11
timerLbl.TextColor3 = C.textMid
timerLbl.TextXAlignment = Enum.TextXAlignment.Left

local toolCard = card(ap, 30, 5)
local toolLbl = Instance.new("TextLabel", toolCard)
toolLbl.Size = UDim2.new(1, -20, 1, 0)
toolLbl.Position = UDim2.new(0, 12, 0, 0)
toolLbl.BackgroundTransparency = 1
toolLbl.Text = "Tool: -"
toolLbl.Font = Enum.Font.GothamBold
toolLbl.TextSize = 11
toolLbl.TextColor3 = C.accentGlow
toolLbl.TextXAlignment = Enum.TextXAlignment.Left

local msStartBtn = makeActionBtn(ap, "▶️ START MS LOOP", C.green, 6)
local msStopBtn = makeActionBtn(ap, "⏹️ STOP MS LOOP", C.red, 7)

-- ============================================================
-- STATUS PAGE
-- ============================================================
local sp = pages["STATUS"]

local avatarCard = card(sp, 70, 1)
local avatarImg2 = Instance.new("ImageLabel", avatarCard)
avatarImg2.Position = UDim2.new(0, 10, 0.5, -26)
avatarImg2.Size = UDim2.new(0, 52, 0, 52)
avatarImg2.BackgroundColor3 = C.border
avatarImg2.BorderSizePixel = 0
Instance.new("UICorner", avatarImg2).CornerRadius = UDim.new(0, 8)

local usernameLbl = Instance.new("TextLabel", avatarCard)
usernameLbl.Position = UDim2.new(0, 72, 0, 14)
usernameLbl.Size = UDim2.new(1, -82, 0, 20)
usernameLbl.BackgroundTransparency = 1
usernameLbl.Text = player.Name
usernameLbl.Font = Enum.Font.GothamBlack
usernameLbl.TextSize = 15
usernameLbl.TextColor3 = C.text
usernameLbl.TextXAlignment = Enum.TextXAlignment.Left

local displayLbl = Instance.new("TextLabel", avatarCard)
displayLbl.Position = UDim2.new(0, 72, 0, 36)
displayLbl.Size = UDim2.new(1, -82, 0, 14)
displayLbl.BackgroundTransparency = 1
displayLbl.Text = "@" .. player.DisplayName
displayLbl.Font = Enum.Font.Gotham
displayLbl.TextSize = 11
displayLbl.TextColor3 = C.textDim
displayLbl.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    local img, _ = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    avatarImg2.Image = img
end)

sectionLabel(sp, "Inventory", 2)
local statWaterVal   = makeStatusRow(sp, "Water",           3)
local statSugarVal   = makeStatusRow(sp, "Sugar Block Bag", 4)
local statGelatinVal = makeStatusRow(sp, "Gelatin",         5)
local statBagVal     = makeStatusRow(sp, "Empty Bag",       6)

sectionLabel(sp, "Marshmallow Bags", 7)
local statSmallVal  = makeStatusRow(sp, "Small Bag",  8)
local statMedVal    = makeStatusRow(sp, "Medium Bag", 9)
local statLargeVal  = makeStatusRow(sp, "Large Bag",  10)

local totalCard2 = card(sp, 36, 11)
local totalLblLeft = Instance.new("TextLabel", totalCard2)
totalLblLeft.Position = UDim2.new(0,12,0,0)
totalLblLeft.Size = UDim2.new(0.5,0,1,0)
totalLblLeft.BackgroundTransparency = 1
totalLblLeft.Text = "Total Bags"
totalLblLeft.Font = Enum.Font.GothamBold
totalLblLeft.TextSize = 12
totalLblLeft.TextColor3 = C.text
totalLblLeft.TextXAlignment = Enum.TextXAlignment.Left

local totalVal = Instance.new("TextLabel", totalCard2)
totalVal.Position = UDim2.new(0.5,0,0,0)
totalVal.Size = UDim2.new(0.5,-12,1,0)
totalVal.BackgroundTransparency = 1
totalVal.Text = "0"
totalVal.Font = Enum.Font.GothamBlack
totalVal.TextSize = 15
totalVal.TextColor3 = C.accentGlow
totalVal.TextXAlignment = Enum.TextXAlignment.Right

-- ============================================================
-- TELEPORT PAGE
-- ============================================================
local tp = pages["TP"]

local LOCATIONS = {
    {name = "🏪 Dealer NPC",      pos = Vector3.new(770.992, 3.71, 433.75)},
    {name = "🍬 NPC Marshmallow", pos = Vector3.new(510.061, 4.476, 600.548)},
    {name = "🏠 Apart 1",         pos = Vector3.new(1137.992, 9.932, 449.753)},
    {name = "🏠 Apart 2",         pos = Vector3.new(1139.174, 9.932, 420.556)},
    {name = "🏠 Apart 3",         pos = Vector3.new(984.856, 9.932, 247.280)},
    {name = "🏠 Apart 4",         pos = Vector3.new(988.311, 9.932, 221.664)},
    {name = "🏠 Apart 5",         pos = Vector3.new(923.954, 9.932, 42.202)},
    {name = "🏠 Apart 6",         pos = Vector3.new(895.721, 9.932, 41.928)},
    {name = "🎰 Casino",          pos = Vector3.new(1166.33, 3.36, -29.77)},
    {name = "🏥 Hospital",        pos = Vector3.new(1065.19, 28.47, 420.76)},
    {name = "⚒️ Material Storage", pos = Vector3.new(521.32, 47.79, 617.25)},
}

for i, loc in ipairs(LOCATIONS) do
    local btn = makeActionBtn(tp, loc.name, C.card, i)
    btn.MouseButton1Click:Connect(function()
        notify("Teleport", "Menuju "..loc.name.."...", "info")
        showLoading("Menuju " .. loc.name)
        vehicleTeleport(CFrame.new(loc.pos))
        hideLoading()
        notify("Teleport", "Tiba di "..loc.name, "success")
    end)
end

-- ============================================================
-- MS POT PAGE (UNDERPOT)
-- ============================================================
local mspot = pages["MS POT"]

sectionLabel(mspot, "Delete Part di Bawah", 1)

local mspotStatusCard = card(mspot, 40, 2)
local mspotStatusLbl = Instance.new("TextLabel", mspotStatusCard)
mspotStatusLbl.Size = UDim2.new(1, -20, 1, 0)
mspotStatusLbl.Position = UDim2.new(0, 12, 0, 0)
mspotStatusLbl.BackgroundTransparency = 1
mspotStatusLbl.Text = "Idle"
mspotStatusLbl.Font = Enum.Font.GothamSemibold
mspotStatusLbl.TextSize = 12
mspotStatusLbl.TextColor3 = C.textMid
mspotStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local undoCard2 = card(mspot, 30, 3)
local undoCountLbl = Instance.new("TextLabel", undoCard2)
undoCountLbl.Size = UDim2.new(1, -20, 1, 0)
undoCountLbl.Position = UDim2.new(0, 12, 0, 0)
undoCountLbl.BackgroundTransparency = 1
undoCountLbl.Text = "Undo Stack: 0 object"
undoCountLbl.Font = Enum.Font.Gotham
undoCountLbl.TextSize = 11
undoCountLbl.TextColor3 = C.textDim
undoCountLbl.TextXAlignment = Enum.TextXAlignment.Left

local deleteFloorBtn = makeActionBtn(mspot, "DELETE PART DI BAWAH", Color3.fromRGB(120, 20, 50), 4)
local undoBtn = makeActionBtn(mspot, "UNDO", C.card, 5)

sectionLabel(mspot, "Find Cook (Prompt Scanner)", 6)

local promptCountCard = card(mspot, 30, 7)
local promptCountLbl = Instance.new("TextLabel", promptCountCard)
promptCountLbl.Size = UDim2.new(1, -20, 1, 0)
promptCountLbl.Position = UDim2.new(0, 12, 0, 0)
promptCountLbl.BackgroundTransparency = 1
promptCountLbl.Text = "0 prompt ditemukan"
promptCountLbl.Font = Enum.Font.Gotham
promptCountLbl.TextSize = 11
promptCountLbl.TextColor3 = C.textDim
promptCountLbl.TextXAlignment = Enum.TextXAlignment.Left

local findCookBtn = makeActionBtn(mspot, "FIND COOK", Color3.fromRGB(0, 100, 80), 8)
local restoreCookBtn = makeActionBtn(mspot, "RESTORE COOK", C.card, 9)

-- ============================================================
-- BUY PAGE (Auto Buy dengan Slider)
-- ============================================================
local buyp = pages["BUY"]

sectionLabel(buyp, "Auto Buy Bahan", 1)

local buyStatusCard2 = card(buyp, 50, 2)
local buyStatusLbl2 = Instance.new("TextLabel", buyStatusCard2)
buyStatusLbl2.Size = UDim2.new(1, -20, 1, 0)
buyStatusLbl2.Position = UDim2.new(0, 12, 0, 0)
buyStatusLbl2.BackgroundTransparency = 1
buyStatusLbl2.Text = "⏹️ STOPPED"
buyStatusLbl2.Font = Enum.Font.GothamBold
buyStatusLbl2.TextSize = 13
buyStatusLbl2.TextColor3 = C.red
buyStatusLbl2.TextXAlignment = Enum.TextXAlignment.Left

local buyTotalCard2 = card(buyp, 30, 3)
local buyTotalLbl2 = Instance.new("TextLabel", buyTotalCard2)
buyTotalLbl2.Size = UDim2.new(1, -20, 1, 0)
buyTotalLbl2.Position = UDim2.new(0, 12, 0, 0)
buyTotalLbl2.BackgroundTransparency = 1
buyTotalLbl2.Text = "Total: 0 item"
buyTotalLbl2.Font = Enum.Font.Gotham
buyTotalLbl2.TextSize = 11
buyTotalLbl2.TextColor3 = C.textMid
buyTotalLbl2.TextXAlignment = Enum.TextXAlignment.Left

local buySliderWrap2, buyValLbl2 = makeSlider(buyp, "JUMLAH BELI PER ITEM", 1, 50, 10, 4, function(v)
    buyAmount = v
end)

local buyStartBtn2 = makeActionBtn(buyp, "▶️ START BUY", C.green, 5)
local buyStopBtn2 = makeActionBtn(buyp, "⏹️ STOP BUY", C.red, 6)

-- ============================================================
-- HP SAFE LOGIC (otomatis saat MS start/stop)
-- ============================================================
local hpMonitoringActive = false
local isInSafeZone = false
local originalPosition = nil
local safeZoneTimerThread = nil
local currentHumanoid = nil
local lastHealthPercent = 100

local SAFE_ZONE_CFRAME = CFrame.new(537.71, 4.59, -537.09) * CFrame.Angles(-1.20, -1.56, -1.20)

local function teleportToSafeZone()
    local character = player.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not hum then return false end
    
    local seatPart = hum.SeatPart
    if seatPart then
        local vehicle = seatPart:FindFirstAncestorOfClass("Model")
        if vehicle then
            if vehicle.PrimaryPart then
                vehicle:SetPrimaryPartCFrame(SAFE_ZONE_CFRAME)
            end
            return true
        end
    else
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
            hrp.CFrame = SAFE_ZONE_CFRAME
            task.wait(0.05)
            hrp.Anchored = false
            return true
        end
    end
    return false
end

local function teleportBackToOriginal()
    if originalPosition then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
            hrp.CFrame = originalPosition
            task.wait(0.05)
            hrp.Anchored = false
        end
        originalPosition = nil
    end
    isInSafeZone = false
end

local function saveOriginalPosition()
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp then
        originalPosition = hrp.CFrame
        return true
    end
    return false
end

local function startSafeZoneTimer()
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
    end
    
    safeZoneTimerThread = task.spawn(function()
        task.wait(8)
        if isInSafeZone and hpMonitoringActive then
            teleportBackToOriginal()
        end
        safeZoneTimerThread = nil
    end)
end

local function onCharacterAdded(character)
    currentHumanoid = character:WaitForChild("Humanoid")
    lastHealthPercent = (currentHumanoid.Health / currentHumanoid.MaxHealth) * 100
    isInSafeZone = false
    originalPosition = nil
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
        safeZoneTimerThread = nil
    end
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

local function checkHealthAndTeleport()
    if not hpMonitoringActive then return end
    if not currentHumanoid or currentHumanoid.Parent == nil then
        local character = player.Character
        if character then
            currentHumanoid = character:FindFirstChildOfClass("Humanoid")
        end
        if not currentHumanoid then return end
    end
    
    local currentHealth = currentHumanoid.Health
    local maxHealth = currentHumanoid.MaxHealth
    
    if maxHealth > 0 then
        local currentPercent = (currentHealth / maxHealth) * 100
        local percentDropped = lastHealthPercent - currentPercent
        
        if percentDropped >= 1 and not isInSafeZone then
            saveOriginalPosition()
            
            if teleportToSafeZone() then
                isInSafeZone = true
                startSafeZoneTimer()
            end
        end
        
        lastHealthPercent = currentPercent
    end
end

local hpMonitorThread = nil
local function startHPMonitoring()
    if hpMonitoringActive then return end
    hpMonitoringActive = true
    isInSafeZone = false
    originalPosition = nil
    
    if currentHumanoid then
        lastHealthPercent = (currentHumanoid.Health / currentHumanoid.MaxHealth) * 100
    else
        lastHealthPercent = 100
    end
    
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
        safeZoneTimerThread = nil
    end
    
    hpMonitorThread = task.spawn(function()
        while hpMonitoringActive do
            checkHealthAndTeleport()
            task.wait(0.3)
        end
    end)
end

local function stopHPMonitoring()
    hpMonitoringActive = false
    
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
        safeZoneTimerThread = nil
    end
    
    if hpMonitorThread then
        task.cancel(hpMonitorThread)
        hpMonitorThread = nil
    end
    
    if isInSafeZone then
        teleportBackToOriginal()
    end
    
    isInSafeZone = false
    originalPosition = nil
end

-- ============================================================
-- FARM LOGIC
-- ============================================================
local function cook()
    while running do
        if equip("Water") then
            statusLabel.Text = "Cooking Water..."
            statusLabel.TextColor3 = C.accentGlow
            if waterBar then fill(waterBar, 20) end
            holdE(0.7)
            task.wait(20)
        end
        if equip("Sugar Block Bag") then
            statusLabel.Text = "Cooking Sugar..."
            if sugarBar then fill(sugarBar, 1) end
            holdE(0.7)
            task.wait(1)
        end
        if equip("Gelatin") then
            statusLabel.Text = "Cooking Gelatin..."
            if gelatinBar then fill(gelatinBar, 1) end
            holdE(0.7)
            task.wait(1)
        end
        statusLabel.Text = "Waiting..."
        if bagBar then fill(bagBar, 45) end
        task.wait(45)
        if equip("Empty Bag") then
            statusLabel.Text = "Collecting..."
            holdE(0.7)
            task.wait(1)
        end
    end
    statusLabel.Text = "IDLE"
    statusLabel.TextColor3 = C.textMid
end

local buying = false
local function autoBuyFarm()
    if buying then return end
    buying = true
    notify("Buy", "Membeli x" .. buyAmount, "info")
    for i = 1, buyAmount do
        if buyRemote then
            buyRemote:FireServer("Water") task.wait(.35)
            buyRemote:FireServer("Sugar Block Bag") task.wait(.35)
            buyRemote:FireServer("Gelatin") task.wait(.35)
            buyRemote:FireServer("Empty Bag") task.wait(.45)
        end
    end
    notify("Buy", "Selesai beli x" .. buyAmount, "success")
    buying = false
end

farmToggleBtn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        farmToggleBtn.Text = "STOP FARM"
        TweenService:Create(farmToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.red}):Play()
        notify("Farm", "Auto farm dimulai!", "success")
        task.spawn(cook)
    else
        farmToggleBtn.Text = "START FARM"
        TweenService:Create(farmToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.accentDim}):Play()
        notify("Farm", "Auto farm dihentikan.", "error")
    end
end)

buyNowBtn.MouseButton1Click:Connect(function()
    task.spawn(autoBuyFarm)
end)

-- ============================================================
-- MS LOOP LOGIC (dengan HP Safe otomatis)
-- ============================================================
local loopRunning = false

local function pressE2()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function startMSLoop()
    if loopRunning then return end
    loopRunning = true
    msStatusLbl.Text = "▶️ RUNNING"
    msStatusLbl.TextColor3 = C.green
    
    -- Aktifkan HP Safe otomatis
    startHPMonitoring()
    
    task.spawn(function()
        while loopRunning do
            -- Update inventory display di status page
            local w = countItem("Water")
            local sg = countItem("Sugar Block Bag")
            local ge = countItem("Gelatin")
            if waterVal then waterVal.Text = tostring(w) end
            if sugarVal then sugarVal.Text = tostring(sg) end
            if gelatinVal then gelatinVal.Text = tostring(ge) end
            if bagVal then bagVal.Text = tostring(countItem("Empty Bag")) end
            
            -- Masak Water (20 detik)
            local waterTool = findTool("water")
            if waterTool and equip(waterTool.Name) then
                toolLbl.Text = "Tool: WATER"
                stepLbl.Text = "Step: Cooking Water..."
                pressE2()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 20 do
                    local remaining = 20 - (tick() - startTime)
                    timerLbl.Text = string.format("Timer: %d/20s", math.floor(remaining))
                    task.wait(0.1)
                end
            else
                stepLbl.Text = "No Water tool! Waiting..."
                task.wait(5)
            end
            
            if not loopRunning then break end
            
            -- Masak Sugar (1 detik)
            local sugarTool = findTool("sugar")
            if sugarTool and equip(sugarTool.Name) then
                toolLbl.Text = "Tool: SUGAR"
                stepLbl.Text = "Step: Cooking Sugar..."
                pressE2()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 1 do
                    task.wait(0.1)
                end
                timerLbl.Text = "Timer: 0s"
            else
                stepLbl.Text = "No Sugar tool! Waiting..."
                task.wait(5)
            end
            
            task.wait(0.5)
            if not loopRunning then break end
            
            -- Masak Gelatin (45 detik)
            local gelatinTool = findTool("gelatin")
            if gelatinTool and equip(gelatinTool.Name) then
                toolLbl.Text = "Tool: GELATIN"
                stepLbl.Text = "Step: Cooking Gelatin..."
                pressE2()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 45 do
                    local remaining = 45 - (tick() - startTime)
                    timerLbl.Text = string.format("Timer: %d/45s", math.floor(remaining))
                    task.wait(0.1)
                end
            else
                stepLbl.Text = "No Gelatin tool! Waiting..."
                task.wait(5)
            end
            
            task.wait(3)
            if not loopRunning then break end
            
            -- Ambil hasil (Empty Bag)
            local emptyTool = findTool("empty") or findTool("bag")
            if emptyTool and equip(emptyTool.Name) then
                toolLbl.Text = "Tool: EMPTY BAG"
                stepLbl.Text = "Step: Collecting Result..."
                pressE2()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 2 do
                    local remaining = 2 - (tick() - startTime)
                    timerLbl.Text = string.format("Timer: %d/2s", math.floor(remaining))
                    task.wait(0.1)
                end
            else
                stepLbl.Text = "No Empty Bag! Waiting..."
                task.wait(5)
            end
            
            stepLbl.Text = "Loop complete! Restarting..."
            task.wait(2)
        end
        
        loopRunning = false
        msStatusLbl.Text = "⏹️ STOPPED"
        msStatusLbl.TextColor3 = C.red
        stepLbl.Text = "Step: Stopped"
        timerLbl.Text = "Timer: 0s"
        toolLbl.Text = "Tool: -"
        
        -- Matikan HP Safe otomatis saat MS stop
        stopHPMonitoring()
    end)
end

local function stopMSLoop()
    loopRunning = false
    stopHPMonitoring()
end

msStartBtn.MouseButton1Click:Connect(function()
    if not loopRunning then task.spawn(startMSLoop) end
end)

msStopBtn.MouseButton1Click:Connect(function()
    loopRunning = false
end)

-- ============================================================
-- MS POT LOGIC (DELETE PART DI BAWAH, UNDO, FIND COOK)
-- ============================================================
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
    if not hrp then 
        mspotStatusLbl.Text = "HumanoidRootPart tidak ada" 
        return 
    end

    for prompt, data in pairs(scannedPrompts) do
        if prompt and prompt.Parent then
            prompt.MaxActivationDistance = data.maxDist
            prompt.RequiresLineOfSight   = data.lineOfSight
            prompt.Enabled               = data.enabled
            prompt.HoldDuration          = data.holdDuration
        end
    end
    scannedPrompts = {}

    mspotStatusLbl.Text = "Scanning prompt..."
    local found = 0

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
                    found += 1
                end
            end
        end
    end

    promptCountLbl.Text = found .. " prompt ditemukan"
    mspotStatusLbl.Text = "Scan: " .. found .. " prompt dimodifikasi"
end

local function doRestorePrompts()
    local count = 0
    for prompt, data in pairs(scannedPrompts) do
        if prompt and prompt.Parent then
            prompt.MaxActivationDistance = data.maxDist
            prompt.RequiresLineOfSight   = data.lineOfSight
            prompt.Enabled               = data.enabled
            prompt.HoldDuration          = data.holdDuration
            count += 1
        end
    end
    scannedPrompts = {}
    promptCountLbl.Text = "0 prompt ditemukan"
    mspotStatusLbl.Text = count .. " prompt di-restore"
end

findCookBtn.MouseButton1Click:Connect(function()
    findCookBtn.Text = "Scanning..."
    TweenService:Create(findCookBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 60, 50)}):Play()
    task.spawn(function()
        doPromptScan()
        notify("MS POT", promptCountLbl.Text, "success")
        task.wait(0.3)
        findCookBtn.Text = "FIND COOK"
        TweenService:Create(findCookBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 100, 80)}):Play()
    end)
end)

restoreCookBtn.MouseButton1Click:Connect(function()
    doRestorePrompts()
    notify("MS POT", "Prompt di-restore.", "info")
end)

deleteFloorBtn.MouseButton1Click:Connect(function()
    if isDeleting then return end
    isDeleting = true
    deleteFloorBtn.Text = "Memproses..."
    TweenService:Create(deleteFloorBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 0, 30)}):Play()

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        mspotStatusLbl.Text = "HumanoidRootPart tidak ada"
        isDeleting = false
        deleteFloorBtn.Text = "DELETE PART DI BAWAH"
        TweenService:Create(deleteFloorBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(120, 20, 50)}):Play()
        return
    end

    mspotStatusLbl.Text = "Mencari object di bawah..."

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
            undoCountLbl.Text = "Undo Stack: " .. #deletedStack .. " object"
            mspotStatusLbl.Text = "Deleted: " .. hit.Name
            notify("MS POT", "Part dihapus!", "success")
        end
    else
        mspotStatusLbl.Text = "Tidak ada object di bawah"
        notify("MS POT", "Tidak ada object terdeteksi.", "error")
    end

    task.wait(0.3)
    isDeleting = false
    deleteFloorBtn.Text = "DELETE PART DI BAWAH"
    TweenService:Create(deleteFloorBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(120, 20, 50)}):Play()
end)

undoBtn.MouseButton1Click:Connect(function()
    local last = table.remove(deletedStack)
    if last and last.object then
        last.object.Parent = last.parent
        undoCountLbl.Text = "Undo Stack: " .. #deletedStack .. " object"
        mspotStatusLbl.Text = "Undo berhasil"
        notify("MS POT", "Undo berhasil!", "success")
    else
        mspotStatusLbl.Text = "Tidak ada yang bisa di-undo"
        notify("MS POT", "Tidak ada yang bisa di-undo.", "error")
    end
end)

-- ============================================================
-- AUTO BUY LOGIC (BUY PAGE)
-- ============================================================
local autoBuyRunning = false
local autoBuyTotalBought = 0

local function startAutoBuy()
    if autoBuyRunning then return end
    if not storePurchaseRE then
        buyStatusLbl2.Text = "❌ RemoteEvent Error!"
        buyStatusLbl2.TextColor3 = C.red
        task.wait(2)
        buyStatusLbl2.Text = "⏹️ STOPPED"
        return
    end
    
    autoBuyRunning = true
    autoBuyTotalBought = 0
    buyStatusLbl2.Text = "▶️ RUNNING"
    buyStatusLbl2.TextColor3 = C.green
    buyTotalLbl2.Text = "Total: 0 item"
    
    local BUY_ITEMS = {"Water", "Sugar Block Bag", "Gelatin"}
    
    task.spawn(function()
        local amount = buyAmount
        
        for _, itemName in ipairs(BUY_ITEMS) do
            if not autoBuyRunning then break end
            
            buyStatusLbl2.Text = "🛒 Buying " .. itemName .. " x" .. amount
            buyStatusLbl2.TextColor3 = Color3.fromRGB(255,255,100)
            
            for i = 1, amount do
                if not autoBuyRunning then break end
                
                pcall(function()
                    storePurchaseRE:FireServer(itemName, 1)
                end)
                
                autoBuyTotalBought = autoBuyTotalBought + 1
                buyTotalLbl2.Text = "Total: " .. autoBuyTotalBought .. " items"
                task.wait(0.5)
            end
            
            task.wait(0.8)
        end
        
        if autoBuyRunning then
            buyStatusLbl2.Text = "✅ Complete! " .. autoBuyTotalBought .. " items"
            buyStatusLbl2.TextColor3 = C.green
            task.wait(2)
            if autoBuyRunning then
                buyStatusLbl2.Text = "⏹️ STOPPED"
                buyStatusLbl2.TextColor3 = C.red
                autoBuyRunning = false
            end
        end
    end)
end

local function stopAutoBuy()
    autoBuyRunning = false
    buyStatusLbl2.Text = "⏹️ STOPPED"
    buyStatusLbl2.TextColor3 = C.red
end

buyStartBtn2.MouseButton1Click:Connect(startAutoBuy)
buyStopBtn2.MouseButton1Click:Connect(stopAutoBuy)

-- ============================================================
-- STATUS LOOP
-- ============================================================
task.spawn(function()
    while gui and gui.Parent do
        local w  = countItem("Water")
        local sg = countItem("Sugar Block Bag")
        local ge = countItem("Gelatin")
        local bg = countItem("Empty Bag")
        local sm = countItem("Small Marshmallow Bag")
        local md = countItem("Medium Marshmallow Bag")
        local lg = countItem("Large Marshmallow Bag")

        if waterVal    then waterVal.Text    = tostring(w)  end
        if sugarVal    then sugarVal.Text    = tostring(sg) end
        if gelatinVal  then gelatinVal.Text  = tostring(ge) end
        if bagVal      then bagVal.Text      = tostring(bg) end
        if statWaterVal   then statWaterVal.Text   = tostring(w)  end
        if statSugarVal   then statSugarVal.Text   = tostring(sg) end
        if statGelatinVal then statGelatinVal.Text = tostring(ge) end
        if statBagVal     then statBagVal.Text     = tostring(bg) end
        if statSmallVal   then statSmallVal.Text   = tostring(sm) end
        if statMedVal     then statMedVal.Text     = tostring(md) end
        if statLargeVal   then statLargeVal.Text   = tostring(lg) end
        if totalVal       then totalVal.Text        = tostring(sm+md+lg) end

        task.wait(0.5)
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
        TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 660, 0, 430)}):Play()
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
switchTab("FARM")
task.wait(0.3)
notify("191 STORE", "Script berhasil diload! v191", "success")
notify("Shortcut", "Tekan T untuk blink maju 8 studs", "info")
