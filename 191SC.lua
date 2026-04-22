-- ======================================================
--   191 STORE + MACRO F (FULL VERSION)
-- ======================================================

local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local VirtualUser = game:GetService("VirtualUser")

repeat task.wait() until player.Character
local playerGui = player:WaitForChild("PlayerGui")

-- ========== VARIABLES ==========
local remotes = ReplicatedStorage:FindFirstChild("RemoteEvents")
local storePurchaseRE = remotes and remotes:FindFirstChild("StorePurchase")
local blinkEnabled = true

-- ========== MACRO F (TEKAN & TAHAN KLIK KIRI) ==========
local macroFEnabled = false
local macroFHeld = false
local macroFInterval = 0.3

local function pressF()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end)
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and macroFEnabled then
        macroFHeld = true
        task.spawn(function()
            while macroFHeld and macroFEnabled do
                pressF()
                task.wait(macroFInterval)
            end
        end)
    end
end)

UIS.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        macroFHeld = false
    end
end)

-- ========== ANTI AFK ==========
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ========== FUNGSI HELPERS ==========
local function holdE(t)
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(t or 0.7)
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

local function equip(name)
    local char = player.Character
    local tool = player.Backpack:FindFirstChild(name) or (char and char:FindFirstChild(name))
    if tool and char and char.Humanoid then
        char.Humanoid:EquipTool(tool)
        task.wait(0.3)
        return true
    end
    return false
end

local function countItem(name)
    local total = 0
    if player.Backpack then
        for _, v in pairs(player.Backpack:GetChildren()) do
            if v.Name == name then total = total + 1 end
        end
    end
    local char = player.Character
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") and v.Name == name then total = total + 1 end
        end
    end
    return total
end

local function stepTeleport(pos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Anchored = true
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        task.wait(0.05)
        hrp.Anchored = false
    end
end

local function blinkMaju()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 8
    end
end

-- ========== COOK PROCESS ==========
local function cookProcess()
    pcall(function()
        equip("Water")
        holdE(0.7)
        for i = 1, 20 do task.wait(1) end
        
        equip("Sugar Block Bag")
        holdE(0.7)
        task.wait(1)
        
        equip("Gelatin")
        holdE(0.7)
        task.wait(1)
        
        for i = 1, 45 do task.wait(1) end
        
        equip("Empty Bag")
        holdE(0.7)
        task.wait(1)
    end)
end

-- ============================================================
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "191_STORE"
gui.Parent = playerGui
gui.ResetOnSpawn = false

local C = {
    bg = Color3.fromRGB(8, 8, 16),
    surface = Color3.fromRGB(13, 13, 22),
    panel = Color3.fromRGB(18, 18, 28),
    card = Color3.fromRGB(22, 22, 36),
    sidebar = Color3.fromRGB(10, 10, 20),
    accent = Color3.fromRGB(0, 110, 220),
    accentDim = Color3.fromRGB(0, 70, 150),
    text = Color3.fromRGB(230, 235, 255),
    textMid = Color3.fromRGB(150, 160, 200),
    textDim = Color3.fromRGB(80, 85, 120),
    green = Color3.fromRGB(40, 200, 100),
    red = Color3.fromRGB(220, 60, 70),
    border = Color3.fromRGB(40, 45, 65),
}

-- MAIN WINDOW
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 660, 0, 500)
main.Position = UDim2.new(0.5, -330, 0.5, -250)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- TOP BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 46)
topBar.BackgroundColor3 = C.surface
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Position = UDim2.new(0, 28, 0, 0)
titleLbl.Size = UDim2.new(0, 160, 1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "191 STORE"
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextColor3 = C.text
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

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
    gui:Destroy()
end)

-- SIDEBAR
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 80, 1, -46)
sidebar.Position = UDim2.new(0, 0, 0, 46)
sidebar.BackgroundColor3 = C.sidebar

local sidebarLine = Instance.new("Frame", main)
sidebarLine.Size = UDim2.new(0, 1, 1, -46)
sidebarLine.Position = UDim2.new(0, 79, 0, 46)
sidebarLine.BackgroundColor3 = C.border

-- CONTENT AREA
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -80, 1, -46)
content.Position = UDim2.new(0, 80, 0, 46)
content.BackgroundColor3 = C.panel

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local pages = {}
local tabBtns = {}

local tabDefs = {
    {label = "AUTO", order = 1},
    {label = "FULLY", order = 2},
    {label = "TP", order = 3},
    {label = "MS POT", order = 4},
    {label = "BUY", order = 5},
    {label = "SELL", order = 6},
    {label = "SETTINGS", order = 7},
}

local function switchTab(name)
    for n, p in pairs(pages) do
        p.Visible = (n == name)
    end
    for n, b in pairs(tabBtns) do
        if n == name then
            b.BackgroundColor3 = C.accentDim
            b.TextColor3 = C.accent
        else
            b.BackgroundColor3 = C.sidebar
            b.TextColor3 = C.textDim
        end
    end
end

for i, def in ipairs(tabDefs) do
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0, 68, 0, 36)
    btn.Position = UDim2.new(0, 6, 0, 8 + (i - 1) * 40)
    btn.BackgroundColor3 = C.sidebar
    btn.Text = def.label
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = C.textDim
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local page = Instance.new("ScrollingFrame", content)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.Visible = false
    page.BorderSizePixel = 0

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 14)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)

    pages[def.label] = page
    tabBtns[def.label] = btn

    btn.MouseButton1Click:Connect(function()
        switchTab(def.label)
    end)
end

-- ============================================================
-- UI COMPONENTS
-- ============================================================
local function card(parent, h, order)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, h or 46)
    f.BackgroundColor3 = C.card
    f.LayoutOrder = order or 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    return f
end

local function makeActionBtn(parent, text, color, order)
    local f = Instance.new("TextButton", parent)
    f.Size = UDim2.new(1, 0, 0, 36)
    f.BackgroundColor3 = color or C.accentDim
    f.Text = text
    f.Font = Enum.Font.GothamBold
    f.TextSize = 12
    f.TextColor3 = C.text
    f.BorderSizePixel = 0
    f.LayoutOrder = order or 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    return f
end

local function makeStatusRow(parent, label, order)
    local f = card(parent, 30, order)
    local lbl = Instance.new("TextLabel", f)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 11
    lbl.TextColor3 = C.textMid
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local val = Instance.new("TextLabel", f)
    val.Position = UDim2.new(0.6, 0, 0, 0)
    val.Size = UDim2.new(0.4, -10, 1, 0)
    val.BackgroundTransparency = 1
    val.Text = "0"
    val.Font = Enum.Font.GothamBold
    val.TextSize = 12
    val.TextColor3 = C.accent
    val.TextXAlignment = Enum.TextXAlignment.Right
    return val
end

local function makeSlider(parent, label, minV, maxV, defaultV, order, callback)
    local wrap = card(parent, 54, order)
    
    local lbl = Instance.new("TextLabel", wrap)
    lbl.Position = UDim2.new(0, 12, 0, 8)
    lbl.Size = UDim2.new(1, -80, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
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
    valLbl.TextColor3 = C.accent
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    
    local track = Instance.new("Frame", wrap)
    track.Position = UDim2.new(0, 12, 0, 34)
    track.Size = UDim2.new(1, -24, 0, 5)
    track.BackgroundColor3 = C.border
    track.Active = true
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((defaultV - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = C.accent
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((defaultV - minV) / (maxV - minV), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local x = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = math.floor(minV + x * (maxV - minV))
            knob.Position = UDim2.new(x, -7, 0.5, -7)
            fill.Size = UDim2.new(x, 0, 1, 0)
            valLbl.Text = tostring(val)
            if callback then callback(val) end
        end
    end)
    
    UIS.InputEnded:Connect(function()
        dragging = false
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = math.floor(minV + x * (maxV - minV))
            knob.Position = UDim2.new(x, -7, 0.5, -7)
            fill.Size = UDim2.new(x, 0, 1, 0)
            valLbl.Text = tostring(val)
            if callback then callback(val) end
        end
    end)
    
    return wrap
end

-- ============================================================
-- AUTO PAGE
-- ============================================================
local autoPage = pages["AUTO"]

local waterVal = makeStatusRow(autoPage, "Water", 1)
local sugarVal = makeStatusRow(autoPage, "Sugar Block Bag", 2)
local gelatinVal = makeStatusRow(autoPage, "Gelatin", 3)
local emptyVal = makeStatusRow(autoPage, "Empty Bag", 4)

local statusCard = card(autoPage, 40, 5)
local statusLbl = Instance.new("TextLabel", statusCard)
statusLbl.Size = UDim2.new(1, -20, 1, 0)
statusLbl.Position = UDim2.new(0, 12, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "STOPPED"
statusLbl.Font = Enum.Font.GothamBold
statusLbl.TextSize = 13
statusLbl.TextColor3 = C.red
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

local startBtn = makeActionBtn(autoPage, "START MS LOOP", C.green, 6)
local stopBtn = makeActionBtn(autoPage, "STOP MS LOOP", C.red, 7)
stopBtn.Visible = false

local msRunning = false

local function updateInventory()
    waterVal.Text = countItem("Water")
    sugarVal.Text = countItem("Sugar Block Bag")
    gelatinVal.Text = countItem("Gelatin")
    emptyVal.Text = countItem("Empty Bag")
end

local function msLoop()
    while msRunning do
        updateInventory()
        statusLbl.Text = "COOKING..."
        statusLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
        cookProcess()
        updateInventory()
        task.wait(2)
    end
    statusLbl.Text = "STOPPED"
    statusLbl.TextColor3 = C.red
end

startBtn.MouseButton1Click:Connect(function()
    if not msRunning then
        msRunning = true
        startBtn.Visible = false
        stopBtn.Visible = true
        statusLbl.Text = "RUNNING"
        statusLbl.TextColor3 = C.green
        task.spawn(msLoop)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    msRunning = false
    startBtn.Visible = true
    stopBtn.Visible = false
end)

-- ============================================================
-- FULLY PAGE
-- ============================================================
local fullyPage = pages["FULLY"]
local fullyRunning = false
local fullySavedPos = nil
local fullyTarget = 5
local NPC_MS_POS = Vector3.new(510.061, 4.476, 600.548)

local waterValF = makeStatusRow(fullyPage, "Water", 1)
local sugarValF = makeStatusRow(fullyPage, "Sugar Block Bag", 2)
local gelatinValF = makeStatusRow(fullyPage, "Gelatin", 3)
local emptyValF = makeStatusRow(fullyPage, "Empty Bag", 4)

makeSlider(fullyPage, "TARGET FULLY", 1, 50, 5, 5, function(v)
    fullyTarget = v
end)

local fullyStatusCard = card(fullyPage, 40, 6)
local fullyStatusLbl = Instance.new("TextLabel", fullyStatusCard)
fullyStatusLbl.Size = UDim2.new(1, -20, 1, 0)
fullyStatusLbl.Position = UDim2.new(0, 12, 0, 0)
fullyStatusLbl.BackgroundTransparency = 1
fullyStatusLbl.Text = "STOPPED"
fullyStatusLbl.Font = Enum.Font.GothamBold
fullyStatusLbl.TextSize = 13
fullyStatusLbl.TextColor3 = C.red
fullyStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local fullyStartBtn = makeActionBtn(fullyPage, "START FULLY", C.green, 7)
local fullyStopBtn = makeActionBtn(fullyPage, "STOP FULLY", C.red, 8)
fullyStopBtn.Visible = false

local function updateFullyInventory()
    waterValF.Text = countItem("Water")
    sugarValF.Text = countItem("Sugar Block Bag")
    gelatinValF.Text = countItem("Gelatin")
    emptyValF.Text = countItem("Empty Bag")
end

local function fullyBuy(qty)
    if not storePurchaseRE then return end
    local items = {"Water", "Sugar Block Bag", "Gelatin", "Empty Bag"}
    for _, item in ipairs(items) do
        if not fullyRunning then break end
        for i = 1, qty do
            if not fullyRunning then break end
            pcall(function() storePurchaseRE:FireServer(item, 1) end)
            task.wait(0.4)
        end
        task.wait(0.5)
    end
end

local function fullySell()
    local sellItems = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
    for _, item in ipairs(sellItems) do
        if not fullyRunning then break end
        while countItem(item) > 0 and fullyRunning do
            pcall(function()
                equip(item)
                holdE(0.7)
                task.wait(1)
            end)
        end
    end
end

local function fullyLoop()
    while fullyRunning do
        fullyStatusLbl.Text = "TELEPORT TO NPC"
        stepTeleport(NPC_MS_POS)
        task.wait(1)
        
        fullyStatusLbl.Text = "BUYING..."
        fullyBuy(fullyTarget)
        if not fullyRunning then break end
        
        if fullySavedPos then
            fullyStatusLbl.Text = "RETURN TO APARTMENT"
            stepTeleport(fullySavedPos)
            task.wait(1)
        end
        
        updateFullyInventory()
        
        local cooked = 0
        while fullyRunning and cooked < fullyTarget do
            fullyStatusLbl.Text = "COOKING " .. (cooked + 1) .. "/" .. fullyTarget
            cookProcess()
            cooked = cooked + 1
            updateFullyInventory()
            task.wait(0.5)
        end
        
        if not fullyRunning then break end
        
        fullyStatusLbl.Text = "TELEPORT TO SELL"
        stepTeleport(NPC_MS_POS)
        task.wait(1)
        
        fullyStatusLbl.Text = "SELLING..."
        fullySell()
        if not fullyRunning then break end
        
        task.wait(2)
    end
    fullyRunning = false
    fullyStartBtn.Visible = true
    fullyStopBtn.Visible = false
    fullyStatusLbl.Text = "STOPPED"
    fullyStatusLbl.TextColor3 = C.red
end

fullyStartBtn.MouseButton1Click:Connect(function()
    if fullyRunning then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    fullySavedPos = hrp.Position
    fullyRunning = true
    fullyStartBtn.Visible = false
    fullyStopBtn.Visible = true
    fullyStatusLbl.Text = "RUNNING"
    fullyStatusLbl.TextColor3 = C.green
    task.spawn(fullyLoop)
end)

fullyStopBtn.MouseButton1Click:Connect(function()
    fullyRunning = false
end)

-- ============================================================
-- TP PAGE
-- ============================================================
local tpPage = pages["TP"]

local LOCATIONS = {
    {name = "Dealer NPC", pos = Vector3.new(770.992, 3.71, 433.75)},
    {name = "NPC Marshmallow", pos = Vector3.new(510.061, 4.476, 600.548)},
    {name = "Apart 1", pos = Vector3.new(1137.992, 9.932, 449.753)},
    {name = "Apart 2", pos = Vector3.new(1139.174, 9.932, 420.556)},
    {name = "Apart 3", pos = Vector3.new(984.856, 9.932, 247.280)},
    {name = "Apart 4", pos = Vector3.new(988.311, 9.932, 221.664)},
    {name = "Apart 5", pos = Vector3.new(923.954, 9.932, 42.202)},
    {name = "Apart 6", pos = Vector3.new(895.721, 9.932, 41.928)},
    {name = "Casino", pos = Vector3.new(1166.33, 3.36, -29.77)},
}

for i, loc in ipairs(LOCATIONS) do
    local btn = makeActionBtn(tpPage, loc.name, C.card, i)
    btn.MouseButton1Click:Connect(function()
        stepTeleport(loc.pos)
    end)
end

-- ============================================================
-- MS POT PAGE
-- ============================================================
local mspotPage = pages["MS POT"]

local deleteBtn = makeActionBtn(mspotPage, "HAPUS PART DI BAWAH", Color3.fromRGB(120, 20, 50), 1)
local undoBtn = makeActionBtn(mspotPage, "UNDO", C.card, 2)
local scanBtn = makeActionBtn(mspotPage, "CARI TOMBOL", Color3.fromRGB(0, 100, 80), 3)

local deletedParts = {}

deleteBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(hrp.Position, Vector3.new(0, -15, 0), rayParams)
    if result and result.Instance then
        table.insert(deletedParts, {obj = result.Instance:Clone(), parent = result.Instance.Parent})
        result.Instance:Destroy()
    end
end)

undoBtn.MouseButton1Click:Connect(function()
    local last = table.remove(deletedParts)
    if last and last.obj then
        last.obj.Parent = last.parent
    end
end)

scanBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local pos = v.Parent and v.Parent:IsA("BasePart") and v.Parent.Position
            if pos and (hrp.Position - pos).Magnitude <= 50 then
                v.Enabled = true
                v.MaxActivationDistance = 20
                v.RequiresLineOfSight = false
                v.HoldDuration = 0
            end
        end
    end
    scanBtn.Text = "DONE!"
    task.wait(1)
    scanBtn.Text = "CARI TOMBOL"
end)

-- ============================================================
-- BUY PAGE
-- ============================================================
local buyPage = pages["BUY"]
local buyAmount = 10

makeSlider(buyPage, "BUY AMOUNT PER ITEM", 1, 50, 10, 1, function(v)
    buyAmount = v
end)

local buyStatusCard = card(buyPage, 40, 2)
local buyStatusLbl = Instance.new("TextLabel", buyStatusCard)
buyStatusLbl.Size = UDim2.new(1, -20, 1, 0)
buyStatusLbl.Position = UDim2.new(0, 12, 0, 0)
buyStatusLbl.BackgroundTransparency = 1
buyStatusLbl.Text = "STOPPED"
buyStatusLbl.Font = Enum.Font.GothamBold
buyStatusLbl.TextSize = 13
buyStatusLbl.TextColor3 = C.red
buyStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local buyStartBtn = makeActionBtn(buyPage, "START BUY", C.green, 3)
local buyStopBtn = makeActionBtn(buyPage, "STOP BUY", C.red, 4)
buyStopBtn.Visible = false

local autoBuyRunning = false

local function startAutoBuy()
    if autoBuyRunning then return end
    if not storePurchaseRE then return end
    
    autoBuyRunning = true
    buyStartBtn.Visible = false
    buyStopBtn.Visible = true
    buyStatusLbl.Text = "BUYING..."
    buyStatusLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    task.spawn(function()
        local items = {"Water", "Sugar Block Bag", "Gelatin"}
        for _, item in ipairs(items) do
            if not autoBuyRunning then break end
            for i = 1, buyAmount do
                if not autoBuyRunning then break end
                pcall(function() storePurchaseRE:FireServer(item, 1) end)
                task.wait(0.4)
            end
            task.wait(0.5)
        end
        autoBuyRunning = false
        buyStartBtn.Visible = true
        buyStopBtn.Visible = false
        buyStatusLbl.Text = "COMPLETE!"
        buyStatusLbl.TextColor3 = C.green
        task.wait(2)
        buyStatusLbl.Text = "STOPPED"
        buyStatusLbl.TextColor3 = C.red
    end)
end

buyStartBtn.MouseButton1Click:Connect(startAutoBuy)
buyStopBtn.MouseButton1Click:Connect(function()
    autoBuyRunning = false
    buyStartBtn.Visible = true
    buyStopBtn.Visible = false
    buyStatusLbl.Text = "STOPPED"
    buyStatusLbl.TextColor3 = C.red
end)

-- ============================================================
-- SELL PAGE
-- ============================================================
local sellPage = pages["SELL"]

local sellStatusCard = card(sellPage, 40, 1)
local sellStatusLbl = Instance.new("TextLabel", sellStatusCard)
sellStatusLbl.Size = UDim2.new(1, -20, 1, 0)
sellStatusLbl.Position = UDim2.new(0, 12, 0, 0)
sellStatusLbl.BackgroundTransparency = 1
sellStatusLbl.Text = "STOPPED"
sellStatusLbl.Font = Enum.Font.GothamBold
sellStatusLbl.TextSize = 13
sellStatusLbl.TextColor3 = C.red
sellStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local sellStartBtn = makeActionBtn(sellPage, "START SELL", C.green, 2)
local sellStopBtn = makeActionBtn(sellPage, "STOP SELL", C.red, 3)
sellStopBtn.Visible = false

local autoSellRunning = false

local function startAutoSell()
    if autoSellRunning then return end
    
    autoSellRunning = true
    sellStartBtn.Visible = false
    sellStopBtn.Visible = true
    sellStatusLbl.Text = "SELLING..."
    sellStatusLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    task.spawn(function()
        local sellItems = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
        for _, item in ipairs(sellItems) do
            if not autoSellRunning then break end
            while countItem(item) > 0 and autoSellRunning do
                pcall(function()
                    equip(item)
                    holdE(0.7)
                    task.wait(1)
                end)
            end
        end
        autoSellRunning = false
        sellStartBtn.Visible = true
        sellStopBtn.Visible = false
        sellStatusLbl.Text = "COMPLETE!"
        sellStatusLbl.TextColor3 = C.green
        task.wait(2)
        sellStatusLbl.Text = "STOPPED"
        sellStatusLbl.TextColor3 = C.red
    end)
end

sellStartBtn.MouseButton1Click:Connect(startAutoSell)
sellStopBtn.MouseButton1Click:Connect(function()
    autoSellRunning = false
    sellStartBtn.Visible = true
    sellStopBtn.Visible = false
    sellStatusLbl.Text = "STOPPED"
    sellStatusLbl.TextColor3 = C.red
end)

-- ============================================================
-- SETTINGS PAGE (MACRO F + BLINK)
-- ============================================================
local settingsPage = pages["SETTINGS"]

-- Blink Toggle
local blinkCard = card(settingsPage, 50, 1)
local blinkTitle = Instance.new("TextLabel", blinkCard)
blinkTitle.Size = UDim2.new(0.6, 0, 1, 0)
blinkTitle.Position = UDim2.new(0, 12, 0, 0)
blinkTitle.BackgroundTransparency = 1
blinkTitle.Text = "Shortcut T (Blink Forward)"
blinkTitle.Font = Enum.Font.GothamSemibold
blinkTitle.TextSize = 12
blinkTitle.TextColor3 = C.text
blinkTitle.TextXAlignment = Enum.TextXAlignment.Left

local blinkToggle = Instance.new("TextButton", blinkCard)
blinkToggle.Size = UDim2.new(0, 70, 0, 32)
blinkToggle.Position = UDim2.new(1, -82, 0.5, -16)
blinkToggle.BackgroundColor3 = C.green
blinkToggle.Text = "ON"
blinkToggle.Font = Enum.Font.GothamBold
blinkToggle.TextSize = 12
blinkToggle.TextColor3 = C.text
blinkToggle.BorderSizePixel = 0
Instance.new("UICorner", blinkToggle).CornerRadius = UDim.new(0, 6)

blinkToggle.MouseButton1Click:Connect(function()
    blinkEnabled = not blinkEnabled
    blinkToggle.Text = blinkEnabled and "ON" or "OFF"
    blinkToggle.BackgroundColor3 = blinkEnabled and C.green or C.red
end)

-- Macro F Card
local macroCard = card(settingsPage, 110, 2)
local macroTitle = Instance.new("TextLabel", macroCard)
macroTitle.Size = UDim2.new(0.6, 0, 0, 30)
macroTitle.Position = UDim2.new(0, 12, 0, 5)
macroTitle.BackgroundTransparency = 1
macroTitle.Text = "🔫 Macro F (Spam F otomatis)"
macroTitle.Font = Enum.Font.GothamBold
macroTitle.TextSize = 12
macroTitle.TextColor3 = C.text
macroTitle.TextXAlignment = Enum.TextXAlignment.Left

local macroToggle = Instance.new("TextButton", macroCard)
macroToggle.Size = UDim2.new(0, 70, 0, 32)
macroToggle.Position = UDim2.new(1, -82, 0, 5)
macroToggle.BackgroundColor3 = C.red
macroToggle.Text = "OFF"
macroToggle.Font = Enum.Font.GothamBold
macroToggle.TextSize = 12
macroToggle.TextColor3 = C.text
macroToggle.BorderSizePixel = 0
Instance.new("UICorner", macroToggle).CornerRadius = UDim.new(0, 6)

macroToggle.MouseButton1Click:Connect(function()
    macroFEnabled = not macroFEnabled
    macroToggle.Text = macroFEnabled and "ON" or "OFF"
    macroToggle.BackgroundColor3 = macroFEnabled and C.green or C.red
    if not macroFEnabled then macroFHeld = false end
end)

local macroInfo = Instance.new("TextLabel", macroCard)
macroInfo.Size = UDim2.new(1, -24, 0, 50)
macroInfo.Position = UDim2.new(0, 12, 0, 45)
macroInfo.BackgroundTransparency = 1
macroInfo.Text = "⚠️ Tekan dan TAHAN Klik Kiri untuk spam F otomatis\n⚠️ Lepas Klik Kiri untuk berhenti"
macroInfo.Font = Enum.Font.Gotham
macroInfo.TextSize = 10
macroInfo.TextColor3 = C.textDim
macroInfo.TextXAlignment = Enum.TextXAlignment.Left
macroInfo.TextWrapped = true

-- Interval Slider
local intervalCard = card(settingsPage, 80, 3)
local intervalTitle = Instance.new("TextLabel", intervalCard)
intervalTitle.Size = UDim2.new(1, -80, 0, 25)
intervalTitle.Position = UDim2.new(0, 12, 0, 8)
intervalTitle.BackgroundTransparency = 1
intervalTitle.Text = "Interval Spam F (detik)"
intervalTitle.Font = Enum.Font.Gotham
intervalTitle.TextSize = 11
intervalTitle.TextColor3 = C.textDim
intervalTitle.TextXAlignment = Enum.TextXAlignment.Left

local intervalVal = Instance.new("TextLabel", intervalCard)
intervalVal.Size = UDim2.new(0, 50, 0, 25)
intervalVal.Position = UDim2.new(1, -62, 0, 8)
intervalVal.BackgroundTransparency = 1
intervalVal.Text = "0.3s"
intervalVal.Font = Enum.Font.GothamBold
intervalVal.TextSize = 12
intervalVal.TextColor3 = C.accent
intervalVal.TextXAlignment = Enum.TextXAlignment.Right

local minusBtn = Instance.new("TextButton", intervalCard)
minusBtn.Size = UDim2.new(0, 40, 0, 35)
minusBtn.Position = UDim2.new(0, 12, 0, 38)
minusBtn.BackgroundColor3 = C.accentDim
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.TextColor3 = C.text
minusBtn.BorderSizePixel = 0
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)

local intervalDisplay = Instance.new("TextLabel", intervalCard)
intervalDisplay.Size = UDim2.new(0, 60, 0, 35)
intervalDisplay.Position = UDim2.new(0.5, -30, 0, 38)
intervalDisplay.BackgroundColor3 = C.bg
intervalDisplay.Text = "0.3"
intervalDisplay.Font = Enum.Font.GothamBold
intervalDisplay.TextSize = 14
intervalDisplay.TextColor3 = C.text
intervalDisplay.BorderSizePixel = 0
Instance.new("UICorner", intervalDisplay).CornerRadius = UDim.new(0, 6)

local plusBtn = Instance.new("TextButton", intervalCard)
plusBtn.Size = UDim2.new(0, 40, 0, 35)
plusBtn.Position = UDim2.new(1, -52, 0, 38)
plusBtn.BackgroundColor3 = C.accentDim
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.TextColor3 = C.text
plusBtn.BorderSizePixel = 0
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)

local function setInterval(val)
    macroFInterval = val
    intervalVal.Text = string.format("%.1f", val) .. "s"
    intervalDisplay.Text = string.format("%.1f", val)
end

minusBtn.MouseButton1Click:Connect(function()
    local newVal = math.max(0.1, macroFInterval - 0.1)
    setInterval(newVal)
end)

plusBtn.MouseButton1Click:Connect(function()
    local newVal = math.min(1.0, macroFInterval + 0.1)
    setInterval(newVal)
end)

-- Blink Buttons for Mobile
local mobileCard = card(settingsPage, 130, 4)
local mobileTitle = Instance.new("TextLabel", mobileCard)
mobileTitle.Size = UDim2.new(1, -24, 0, 25)
mobileTitle.Position = UDim2.new(0, 12, 0, 5)
mobileTitle.BackgroundTransparency = 1
mobileTitle.Text = "BLINK BUTTONS (MOBILE)"
mobileTitle.Font = Enum.Font.GothamBold
mobileTitle.TextSize = 11
mobileTitle.TextColor3 = C.accent
mobileTitle.TextXAlignment = Enum.TextXAlignment.Left

local function makeMobileBtn(parent, text, y, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.45, -5, 0, 40)
    btn.Position = UDim2.new(0.03, 0, 0, y)
    btn.BackgroundColor3 = C.accentDim
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = C.text
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

makeMobileBtn(mobileCard, "FORWARD →", 35, function()
    blinkMaju()
end)

makeMobileBtn(mobileCard, "BACKWARD ←", 35, function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame - hrp.CFrame.LookVector * 8 end
end)

makeMobileBtn(mobileCard, "UP ↑", 85, function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, 5, 0) end
end)

makeMobileBtn(mobileCard, "DOWN ↓", 85, function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, -5, 0) end
end)

-- ============================================================
-- BLINK KEYBIND
-- ============================================================
ContextActionService:BindAction("blink", function(_, state)
    if state == Enum.UserInputState.Begin and blinkEnabled then
        blinkMaju()
    end
end, false, Enum.KeyCode.T)

-- ============================================================
-- INVENTORY UPDATE LOOP
-- ============================================================
task.spawn(function()
    while gui and gui.Parent do
        if autoPage.Visible then
            updateInventory()
        end
        if fullyPage.Visible then
            updateFullyInventory()
        end
        task.wait(1)
    end
end)

-- ============================================================
-- STARTUP
-- ============================================================
switchTab("AUTO")
autoPage.Visible = true

print("191 STORE LOADED! Macro F ada di tab SETTINGS - Tekan & Tahan Klik Kiri")
