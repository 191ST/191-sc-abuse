-- ======================================================
--   191 STORE + MACRO F (WORKING)
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
local SAFE_ZONE_CFRAME = CFrame.new(537.71, 4.59, -537.09) * CFrame.Angles(-1.20, -1.56, -1.20)
local buyAmount = 10
local blinkEnabled = true
local fullyTarget = 5

-- ============================================================
-- MACRO F (TEKAN DAN TAHAN KLIK KIRI)
-- ============================================================
local macroFEnabled = false
local macroFHeld = false
local macroFInterval = 0.3

local function spamF()
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
                spamF()
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

-- ============================================================
-- HP SAFE ZONE
-- ============================================================
local hpMonitoringActive = false
local isInSafeZone = false
local originalCFrame = nil
local safeZoneTimerThread = nil
local currentHumanoid = nil
local lastHealthPercent = 100

local function teleportToSafeZone()
    local character = player.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not hum then return false end
    
    local seatPart = hum.SeatPart
    if seatPart then
        local vehicle = seatPart:FindFirstAncestorOfClass("Model")
        if vehicle then
            local anchor = vehicle.PrimaryPart or vehicle:FindFirstChildOfClass("VehicleSeat") or vehicle:FindFirstChildOfClass("BasePart")
            if anchor then
                for _,p in ipairs(vehicle:GetDescendants()) do
                    if p:IsA("BasePart") then
                        pcall(function()
                            p.AssemblyLinearVelocity = Vector3.zero
                            p.AssemblyAngularVelocity = Vector3.zero
                            p.Anchored = true
                        end)
                    end
                end
                task.wait(0.05)
                if vehicle.PrimaryPart then
                    vehicle:SetPrimaryPartCFrame(SAFE_ZONE_CFRAME)
                else
                    anchor.CFrame = SAFE_ZONE_CFRAME
                end
                task.wait(0.05)
                for _,p in ipairs(vehicle:GetDescendants()) do
                    if p:IsA("BasePart") then
                        pcall(function()
                            p.Anchored = false
                            p.AssemblyLinearVelocity = Vector3.zero
                            p.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                end
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

local function teleportToOriginalCFrame(targetCFrame)
    local character = player.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not hum then return false end
    
    local seatPart = hum.SeatPart
    if seatPart then
        local vehicle = seatPart:FindFirstAncestorOfClass("Model")
        if vehicle then
            local anchor = vehicle.PrimaryPart or vehicle:FindFirstChildOfClass("VehicleSeat") or vehicle:FindFirstChildOfClass("BasePart")
            if anchor then
                for _,p in ipairs(vehicle:GetDescendants()) do
                    if p:IsA("BasePart") then
                        pcall(function()
                            p.AssemblyLinearVelocity = Vector3.zero
                            p.AssemblyAngularVelocity = Vector3.zero
                            p.Anchored = true
                        end)
                    end
                end
                task.wait(0.05)
                if vehicle.PrimaryPart then
                    vehicle:SetPrimaryPartCFrame(targetCFrame)
                else
                    anchor.CFrame = targetCFrame
                end
                task.wait(0.05)
                for _,p in ipairs(vehicle:GetDescendants()) do
                    if p:IsA("BasePart") then
                        pcall(function()
                            p.Anchored = false
                            p.AssemblyLinearVelocity = Vector3.zero
                            p.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                end
            end
            return true
        end
    else
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
            hrp.CFrame = targetCFrame
            task.wait(0.05)
            hrp.Anchored = false
            return true
        end
    end
    return false
end

local function onCharacterAdded(character)
    currentHumanoid = character:WaitForChild("Humanoid")
    lastHealthPercent = (currentHumanoid.Health / currentHumanoid.MaxHealth) * 100
    isInSafeZone = false
    originalCFrame = nil
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
        safeZoneTimerThread = nil
    end
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

local function saveOriginalPosition()
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp then
        originalCFrame = hrp.CFrame
        return true
    end
    return false
end

local function teleportBackToOriginal()
    if originalCFrame then
        teleportToOriginalCFrame(originalCFrame)
        originalCFrame = nil
    end
    isInSafeZone = false
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
    originalCFrame = nil
    
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
    originalCFrame = nil
end

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

-- ============================================================
-- COLOR PALETTE
-- ============================================================
local C = {
    bg        = Color3.fromRGB(8, 8, 16),
    surface   = Color3.fromRGB(13, 13, 22),
    panel     = Color3.fromRGB(18, 18, 28),
    card      = Color3.fromRGB(22, 22, 36),
    sidebar   = Color3.fromRGB(10, 10, 20),
    accent    = Color3.fromRGB(0, 110, 220),
    accentDim = Color3.fromRGB(0, 70, 150),
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
main.Size = UDim2.new(0, 500, 0, 400)
main.Position = UDim2.new(0.5, -250, 0.5, -200)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = C.border
mainStroke.Thickness = 1

-- ============================================================
-- TOP BAR
-- ============================================================
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = C.surface
topBar.ZIndex = 2
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.Size = UDim2.new(0, 150, 1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "191 STORE"
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 14
titleLbl.TextColor3 = C.text
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 22)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = C.red
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ============================================================
-- BUTTON MENU
-- ============================================================
local buttons = {}
local currentPage = nil

local pages = {
    auto = Instance.new("ScrollingFrame", main),
    settings = Instance.new("ScrollingFrame", main),
}

for _, page in pairs(pages) do
    page.Size = UDim2.new(1, -20, 1, -60)
    page.Position = UDim2.new(0, 10, 0, 50)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.Visible = false
    page.BorderSizePixel = 0
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 5)
end

local function switchPage(pageName)
    for name, page in pairs(pages) do
        page.Visible = (name == pageName)
    end
    for _, btn in pairs(buttons) do
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C.card}):Play()
        btn.TextColor3 = C.textMid
    end
    if buttons[pageName] then
        TweenService:Create(buttons[pageName], TweenInfo.new(0.1), {BackgroundColor3 = C.accentDim}):Play()
        buttons[pageName].TextColor3 = C.accentGlow
    end
end

-- ============================================================
-- AUTO PAGE
-- ============================================================
local waterVal = Instance.new("TextLabel")
local sugarVal = Instance.new("TextLabel")
local gelatinVal = Instance.new("TextLabel")
local emptyVal = Instance.new("TextLabel")

local function updateInventory()
    waterVal.Text = countItem("Water")
    sugarVal.Text = countItem("Sugar Block Bag")
    gelatinVal.Text = countItem("Gelatin")
    emptyVal.Text = countItem("Empty Bag")
end

local function makeStatRow(parent, label, order)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 32)
    f.BackgroundColor3 = C.card
    f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.5, -10, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextColor3 = C.textMid
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local val = Instance.new("TextLabel", f)
    val.Size = UDim2.new(0.5, -10, 1, 0)
    val.Position = UDim2.new(0.5, 0, 0, 0)
    val.BackgroundTransparency = 1
    val.Text = "0"
    val.Font = Enum.Font.GothamBold
    val.TextSize = 12
    val.TextColor3 = C.accentGlow
    val.TextXAlignment = Enum.TextXAlignment.Right
    
    return val
end

waterVal = makeStatRow(pages.auto, "Water", 1)
sugarVal = makeStatRow(pages.auto, "Sugar Block Bag", 2)
gelatinVal = makeStatRow(pages.auto, "Gelatin", 3)
emptyVal = makeStatRow(pages.auto, "Empty Bag", 4)

local msStatusLbl = Instance.new("TextLabel", pages.auto)
msStatusLbl.Size = UDim2.new(1, 0, 0, 36)
msStatusLbl.BackgroundColor3 = C.card
msStatusLbl.Text = "STOPPED"
msStatusLbl.Font = Enum.Font.GothamBold
msStatusLbl.TextSize = 13
msStatusLbl.TextColor3 = C.red
msStatusLbl.LayoutOrder = 5
Instance.new("UICorner", msStatusLbl).CornerRadius = UDim.new(0, 6)

local msStartBtn = Instance.new("TextButton", pages.auto)
msStartBtn.Size = UDim2.new(1, 0, 0, 36)
msStartBtn.BackgroundColor3 = C.green
msStartBtn.Text = "START MS LOOP"
msStartBtn.Font = Enum.Font.GothamBold
msStartBtn.TextSize = 12
msStartBtn.TextColor3 = C.text
msStartBtn.LayoutOrder = 6
Instance.new("UICorner", msStartBtn).CornerRadius = UDim.new(0, 6)

local msStopBtn = Instance.new("TextButton", pages.auto)
msStopBtn.Size = UDim2.new(1, 0, 0, 36)
msStopBtn.BackgroundColor3 = C.red
msStopBtn.Text = "STOP MS LOOP"
msStopBtn.Font = Enum.Font.GothamBold
msStopBtn.TextSize = 12
msStopBtn.TextColor3 = C.text
msStopBtn.LayoutOrder = 7
msStopBtn.Visible = false
Instance.new("UICorner", msStopBtn).CornerRadius = UDim.new(0, 6)

local msRunning = false

local function cookProcess()
    pcall(function()
        equip("Water")
        holdE(0.7)
        for i = 20, 1, -1 do task.wait(1) end
        
        equip("Sugar Block Bag")
        holdE(0.7)
        task.wait(1)
        
        equip("Gelatin")
        holdE(0.7)
        task.wait(1)
        
        for i = 45, 1, -1 do task.wait(1) end
        
        equip("Empty Bag")
        holdE(0.7)
        task.wait(1)
    end)
end

local function msLoop()
    while msRunning do
        updateInventory()
        msStatusLbl.Text = "COOKING..."
        msStatusLbl.TextColor3 = Color3.fromRGB(255,200,100)
        cookProcess()
        updateInventory()
        task.wait(2)
    end
    msStatusLbl.Text = "STOPPED"
    msStatusLbl.TextColor3 = C.red
end

msStartBtn.MouseButton1Click:Connect(function()
    if not msRunning then
        startHPMonitoring()
        msRunning = true
        msStartBtn.Visible = false
        msStopBtn.Visible = true
        msStatusLbl.Text = "RUNNING"
        msStatusLbl.TextColor3 = C.green
        task.spawn(msLoop)
    end
end)

msStopBtn.MouseButton1Click:Connect(function()
    msRunning = false
    stopHPMonitoring()
    msStartBtn.Visible = true
    msStopBtn.Visible = false
    msStatusLbl.Text = "STOPPED"
    msStatusLbl.TextColor3 = C.red
end)

-- ============================================================
-- SETTINGS PAGE
-- ============================================================
-- Blink Toggle
local blinkCard = Instance.new("Frame", pages.settings)
blinkCard.Size = UDim2.new(1, 0, 0, 50)
blinkCard.BackgroundColor3 = C.card
blinkCard.LayoutOrder = 1
Instance.new("UICorner", blinkCard).CornerRadius = UDim.new(0, 8)

local blinkTitle = Instance.new("TextLabel", blinkCard)
blinkTitle.Size = UDim2.new(0.6, 0, 1, 0)
blinkTitle.Position = UDim2.new(0, 12, 0, 0)
blinkTitle.BackgroundTransparency = 1
blinkTitle.Text = "Shortcut T (Blink Forward)"
blinkTitle.Font = Enum.Font.Gotham
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

-- Macro F Toggle
local macroCard = Instance.new("Frame", pages.settings)
macroCard.Size = UDim2.new(1, 0, 0, 90)
macroCard.BackgroundColor3 = C.card
macroCard.LayoutOrder = 2
Instance.new("UICorner", macroCard).CornerRadius = UDim.new(0, 8)

local macroTitle = Instance.new("TextLabel", macroCard)
macroTitle.Size = UDim2.new(0.6, 0, 0, 30)
macroTitle.Position = UDim2.new(0, 12, 0, 5)
macroTitle.BackgroundTransparency = 1
macroTitle.Text = "🔫 Macro F (Spam F)"
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
    if not macroFEnabled then
        macroFHeld = false
    end
end)

local macroInfo = Instance.new("TextLabel", macroCard)
macroInfo.Size = UDim2.new(1, -24, 0, 40)
macroInfo.Position = UDim2.new(0, 12, 0, 42)
macroInfo.BackgroundTransparency = 1
macroInfo.Text = "⚠️ Tekan dan TAHAN Klik Kiri untuk spam F otomatis\n⚠️ Lepas Klik Kiri untuk berhenti"
macroInfo.Font = Enum.Font.Gotham
macroInfo.TextSize = 10
macroInfo.TextColor3 = C.textDim
macroInfo.TextXAlignment = Enum.TextXAlignment.Left
macroInfo.TextWrapped = true

-- Slider Interval
local intervalCard = Instance.new("Frame", pages.settings)
intervalCard.Size = UDim2.new(1, 0, 0, 60)
intervalCard.BackgroundColor3 = C.card
intervalCard.LayoutOrder = 3
Instance.new("UICorner", intervalCard).CornerRadius = UDim.new(0, 8)

local intervalTitle = Instance.new("TextLabel", intervalCard)
intervalTitle.Size = UDim2.new(1, -80, 0, 25)
intervalTitle.Position = UDim2.new(0, 12, 0, 5)
intervalTitle.BackgroundTransparency = 1
intervalTitle.Text = "Interval Spam F (detik)"
intervalTitle.Font = Enum.Font.Gotham
intervalTitle.TextSize = 11
intervalTitle.TextColor3 = C.textMid
intervalTitle.TextXAlignment = Enum.TextXAlignment.Left

local intervalVal = Instance.new("TextLabel", intervalCard)
intervalVal.Size = UDim2.new(0, 50, 0, 25)
intervalVal.Position = UDim2.new(1, -62, 0, 5)
intervalVal.BackgroundTransparency = 1
intervalVal.Text = "0.3s"
intervalVal.Font = Enum.Font.GothamBold
intervalVal.TextSize = 12
intervalVal.TextColor3 = C.accentGlow
intervalVal.TextXAlignment = Enum.TextXAlignment.Right

local intervalSlider = Instance.new("Frame", intervalCard)
intervalSlider.Size = UDim2.new(1, -24, 0, 4)
intervalSlider.Position = UDim2.new(0, 12, 0, 40)
intervalSlider.BackgroundColor3 = C.border
intervalSlider.BorderSizePixel = 0
Instance.new("UICorner", intervalSlider).CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame", intervalSlider)
sliderFill.Size = UDim2.new(0.3, 0, 1, 0)
sliderFill.BackgroundColor3 = C.accent
sliderFill.BorderSizePixel = 0
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local function updateInterval(val)
    macroFInterval = val
    intervalVal.Text = string.format("%.1f", val) .. "s"
    sliderFill.Size = UDim2.new((val - 0.1) / 2.9, 0, 1, 0)
end

-- Blink buttons for mobile
local mobileCard = Instance.new("Frame", pages.settings)
mobileCard.Size = UDim2.new(1, 0, 0, 140)
mobileCard.BackgroundColor3 = C.card
mobileCard.LayoutOrder = 4
Instance.new("UICorner", mobileCard).CornerRadius = UDim.new(0, 8)

local mobileTitle = Instance.new("TextLabel", mobileCard)
mobileTitle.Size = UDim2.new(1, -24, 0, 25)
mobileTitle.Position = UDim2.new(0, 12, 0, 5)
mobileTitle.BackgroundTransparency = 1
mobileTitle.Text = "BLINK BUTTONS (MOBILE)"
mobileTitle.Font = Enum.Font.GothamBold
mobileTitle.TextSize = 11
mobileTitle.TextColor3 = C.textMid

local btnF = Instance.new("TextButton", mobileCard)
btnF.Size = UDim2.new(0.45, -5, 0, 36)
btnF.Position = UDim2.new(0.03, 0, 0, 35)
btnF.BackgroundColor3 = C.accentDim
btnF.Text = "BLINK ↑"
btnF.Font = Enum.Font.GothamBold
btnF.TextSize = 12
btnF.TextColor3 = C.text
btnF.BorderSizePixel = 0
Instance.new("UICorner", btnF).CornerRadius = UDim.new(0, 8)
btnF.MouseButton1Click:Connect(blinkMaju)

local btnB = Instance.new("TextButton", mobileCard)
btnB.Size = UDim2.new(0.45, -5, 0, 36)
btnB.Position = UDim2.new(0.52, 0, 0, 35)
btnB.BackgroundColor3 = C.accentDim
btnB.Text = "BLINK ↓"
btnB.Font = Enum.Font.GothamBold
btnB.TextSize = 12
btnB.TextColor3 = C.text
btnB.BorderSizePixel = 0
Instance.new("UICorner", btnB).CornerRadius = UDim.new(0, 8)
btnB.MouseButton1Click:Connect(blinkMundur)

local btnU = Instance.new("TextButton", mobileCard)
btnU.Size = UDim2.new(0.45, -5, 0, 36)
btnU.Position = UDim2.new(0.03, 0, 0, 80)
btnU.BackgroundColor3 = C.accentDim
btnU.Text = "BLINK ⬆"
btnU.Font = Enum.Font.GothamBold
btnU.TextSize = 12
btnU.TextColor3 = C.text
btnU.BorderSizePixel = 0
Instance.new("UICorner", btnU).CornerRadius = UDim.new(0, 8)
btnU.MouseButton1Click:Connect(blinkAtas)

local btnD = Instance.new("TextButton", mobileCard)
btnD.Size = UDim2.new(0.45, -5, 0, 36)
btnD.Position = UDim2.new(0.52, 0, 0, 80)
btnD.BackgroundColor3 = C.accentDim
btnD.Text = "BLINK ⬇"
btnD.Font = Enum.Font.GothamBold
btnD.TextSize = 12
btnD.TextColor3 = C.text
btnD.BorderSizePixel = 0
Instance.new("UICorner", btnD).CornerRadius = UDim.new(0, 8)
btnD.MouseButton1Click:Connect(blinkBawah)

-- ============================================================
-- BOTTOM MENU BUTTONS
-- ============================================================
local btnContainer = Instance.new("Frame", main)
btnContainer.Size = UDim2.new(1, 0, 0, 44)
btnContainer.Position = UDim2.new(0, 0, 1, -44)
btnContainer.BackgroundColor3 = C.surface
btnContainer.BorderSizePixel = 0

local btnAuto = Instance.new("TextButton", btnContainer)
btnAuto.Size = UDim2.new(0.5, 0, 1, 0)
btnAuto.Position = UDim2.new(0, 0, 0, 0)
btnAuto.BackgroundColor3 = C.accentDim
btnAuto.Text = "AUTO"
btnAuto.Font = Enum.Font.GothamBold
btnAuto.TextSize = 12
btnAuto.TextColor3 = C.accentGlow
btnAuto.BorderSizePixel = 0

local btnSettings = Instance.new("TextButton", btnContainer)
btnSettings.Size = UDim2.new(0.5, 0, 1, 0)
btnSettings.Position = UDim2.new(0.5, 0, 0, 0)
btnSettings.BackgroundColor3 = C.card
btnSettings.Text = "SETTINGS"
btnSettings.Font = Enum.Font.GothamBold
btnSettings.TextSize = 12
btnSettings.TextColor3 = C.textMid
btnSettings.BorderSizePixel = 0

buttons["auto"] = btnAuto
buttons["settings"] = btnSettings

btnAuto.MouseButton1Click:Connect(function()
    switchPage("auto")
end)

btnSettings.MouseButton1Click:Connect(function()
    switchPage("settings")
end)

-- ============================================================
-- INVENTORY UPDATE LOOP
-- ============================================================
task.spawn(function()
    while gui and gui.Parent do
        updateInventory()
        task.wait(1)
    end
end)

-- ============================================================
-- STARTUP
-- ============================================================
switchPage("auto")
pages.auto.Visible = true

print("[191 STORE] Script loaded! Macro F: Tekan & Tahan Klik Kiri")
