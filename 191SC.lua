local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- Konfigurasi ukuran GUI
local GUI_WIDTH = 420
local GUI_HEIGHT = 680
local TAB_HEIGHT = 35
local TITLE_HEIGHT = 45

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.Name = "TP_Hub_191"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,GUI_WIDTH,0,GUI_HEIGHT)
Frame.Position = UDim2.new(0.5,-GUI_WIDTH/2,0.5,-GUI_HEIGHT/2)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true

local Corner = Instance.new("UICorner")
Corner.Parent = Frame
Corner.CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Frame
Stroke.Color = Color3.fromRGB(45,45,55)
Stroke.Thickness = 1

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = Frame
TitleBar.Size = UDim2.new(1,0,0,TITLE_HEIGHT)
TitleBar.BackgroundColor3 = Color3.fromRGB(35,35,45)
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = TitleBar
TitleCorner.CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1,-60,0,25)
Title.Position = UDim2.new(0,8,0,2)
Title.BackgroundTransparency = 1
Title.Text = "191 STORE"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local BillboardText = Instance.new("TextLabel")
BillboardText.Parent = TitleBar
BillboardText.Size = UDim2.new(1,-60,0,18)
BillboardText.Position = UDim2.new(0,8,0,24)
BillboardText.BackgroundTransparency = 1
BillboardText.Text = "Discord.gg/h5CWN2sP4y"
BillboardText.TextColor3 = Color3.fromRGB(100,200,255)
BillboardText.TextXAlignment = Enum.TextXAlignment.Left
BillboardText.Font = Enum.Font.Gotham
BillboardText.TextSize = 9

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0,28,0,28)
CloseBtn.Position = UDim2.new(1,-34,0,8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(0,6)

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TitleBar
MinBtn.Size = UDim2.new(0,28,0,28)
MinBtn.Position = UDim2.new(1,-62,0,8)
MinBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold

local MinCorner = Instance.new("UICorner")
MinCorner.Parent = MinBtn
MinCorner.CornerRadius = UDim.new(0,6)

-- Billboard changer
local billboardMessages = {
    {text = "Discord.gg/h5CWN2sP4y", color = Color3.fromRGB(100,200,255)},
    {text = "Saran? ke dc ajaa", color = Color3.fromRGB(255,255,100)},
    {text = "Bug? lapor di dc", color = Color3.fromRGB(255,150,200)},
    {text = "dibuat ama jeje ganteng", color = Color3.fromRGB(100,255,100)}
}
local currentBillboard = 1

task.spawn(function()
    while true do
        task.wait(30)
        currentBillboard = (currentBillboard % #billboardMessages) + 1
        BillboardText.Text = billboardMessages[currentBillboard].text
        BillboardText.TextColor3 = billboardMessages[currentBillboard].color
    end
end)

-- Tab Buttons
local TabFrame = Instance.new("Frame")
TabFrame.Parent = Frame
TabFrame.Size = UDim2.new(1,0,0,TAB_HEIGHT)
TabFrame.Position = UDim2.new(0,0,0,TITLE_HEIGHT)
TabFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
TabFrame.BorderSizePixel = 0

local TPTabBtn = Instance.new("TextButton")
TPTabBtn.Parent = TabFrame
TPTabBtn.Size = UDim2.new(0.2,-2,1,-4)
TPTabBtn.Position = UDim2.new(0,2,0,2)
TPTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
TPTabBtn.Text = "🚀 TP"
TPTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
TPTabBtn.Font = Enum.Font.GothamBold
TPTabBtn.TextSize = 11

local MSLoopTabBtn = Instance.new("TextButton")
MSLoopTabBtn.Parent = TabFrame
MSLoopTabBtn.Size = UDim2.new(0.2,-2,1,-4)
MSLoopTabBtn.Position = UDim2.new(0.2,0,0,2)
MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
MSLoopTabBtn.Text = "🔄 MS"
MSLoopTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
MSLoopTabBtn.Font = Enum.Font.GothamBold
MSLoopTabBtn.TextSize = 11

local AutoBuyTabBtn = Instance.new("TextButton")
AutoBuyTabBtn.Parent = TabFrame
AutoBuyTabBtn.Size = UDim2.new(0.2,-2,1,-4)
AutoBuyTabBtn.Position = UDim2.new(0.4,0,0,2)
AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
AutoBuyTabBtn.Text = "🛒 BUY"
AutoBuyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
AutoBuyTabBtn.Font = Enum.Font.GothamBold
AutoBuyTabBtn.TextSize = 11

local MSSafetyTabBtn = Instance.new("TextButton")
MSSafetyTabBtn.Parent = TabFrame
MSSafetyTabBtn.Size = UDim2.new(0.2,-2,1,-4)
MSSafetyTabBtn.Position = UDim2.new(0.6,0,0,2)
MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
MSSafetyTabBtn.Text = "🛡️ SAFE"
MSSafetyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
MSSafetyTabBtn.Font = Enum.Font.GothamBold
MSSafetyTabBtn.TextSize = 10

local AutoSellTabBtn = Instance.new("TextButton")
AutoSellTabBtn.Parent = TabFrame
AutoSellTabBtn.Size = UDim2.new(0.2,-2,1,-4)
AutoSellTabBtn.Position = UDim2.new(0.8,0,0,2)
AutoSellTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
AutoSellTabBtn.Text = "💰 SELL"
AutoSellTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
AutoSellTabBtn.Font = Enum.Font.GothamBold
AutoSellTabBtn.TextSize = 11

-- Content Container
local Content = Instance.new("Frame")
Content.Parent = Frame
Content.Size = UDim2.new(1,0,1,-(TITLE_HEIGHT + TAB_HEIGHT))
Content.Position = UDim2.new(0,0,0,TITLE_HEIGHT + TAB_HEIGHT)
Content.BackgroundColor3 = Color3.fromRGB(25,25,35)
Content.BorderSizePixel = 0
Content.BackgroundTransparency = 0.1

local ContentCorner = Instance.new("UICorner")
ContentCorner.Parent = Content
ContentCorner.CornerRadius = UDim.new(0,12)

-- TP Tab Content
local TPContent = Instance.new("ScrollingFrame")
TPContent.Parent = Content
TPContent.Size = UDim2.new(1,0,1,0)
TPContent.BackgroundTransparency = 1
TPContent.Visible = true
TPContent.ScrollBarThickness = 4
TPContent.CanvasSize = UDim2.new(0,0,0,850)

-- MS Loop Tab Content
local MSLoopContent = Instance.new("ScrollingFrame")
MSLoopContent.Parent = Content
MSLoopContent.Size = UDim2.new(1,0,1,0)
MSLoopContent.BackgroundTransparency = 1
MSLoopContent.Visible = false
MSLoopContent.ScrollBarThickness = 4
MSLoopContent.CanvasSize = UDim2.new(0,0,0,520)

-- AUTO BUY TAB CONTENT
local AutoBuyContent = Instance.new("ScrollingFrame")
AutoBuyContent.Parent = Content
AutoBuyContent.Size = UDim2.new(1,0,1,0)
AutoBuyContent.BackgroundTransparency = 1
AutoBuyContent.Visible = false
AutoBuyContent.ScrollBarThickness = 4
AutoBuyContent.CanvasSize = UDim2.new(0,0,0,350)

-- MS SAFETY TAB CONTENT
local MSSafetyContent = Instance.new("ScrollingFrame")
MSSafetyContent.Parent = Content
MSSafetyContent.Size = UDim2.new(1,0,1,0)
MSSafetyContent.BackgroundTransparency = 1
MSSafetyContent.Visible = false
MSSafetyContent.ScrollBarThickness = 4
MSSafetyContent.CanvasSize = UDim2.new(0,0,0,360)

-- AUTO SELL TAB CONTENT
local AutoSellContent = Instance.new("ScrollingFrame")
AutoSellContent.Parent = Content
AutoSellContent.Size = UDim2.new(1,0,1,0)
AutoSellContent.BackgroundTransparency = 1
AutoSellContent.Visible = false
AutoSellContent.ScrollBarThickness = 4
AutoSellContent.CanvasSize = UDim2.new(0,0,0,220)

-- ========== SEMUA LOKASI TELEPORT ==========
local LOCATIONS = {
    {name = "🏪 Dealer NPC",      pos = Vector3.new(770.992, 3.71, 433.75), desc = "Dealer Mobil", hasSub = false},
    {name = "🍬 NPC Marshmallow", pos = Vector3.new(510.061, 4.476, 600.548), desc = "Tempat Jual/Beli MS", hasSub = false},
    {name = "🏠 Apart 1",         pos = Vector3.new(1137.992, 8.932, 449.753), desc = "Apartemen 1", hasSub = true, apartIndex = 1},
    {name = "🏠 Apart 2",         pos = Vector3.new(1139.174, 8.932, 420.556), desc = "Apartemen 2", hasSub = true, apartIndex = 2},
    {name = "🏠 Apart 3",         pos = Vector3.new(984.856, 8.932, 247.280), desc = "Apartemen 3", hasSub = true, apartIndex = 3},
    {name = "🏠 Apart 4",         pos = Vector3.new(988.311, 8.932, 221.664), desc = "Apartemen 4", hasSub = true, apartIndex = 4},
    {name = "🏠 Apart 5",         pos = Vector3.new(923.954, 8.932, 42.202), desc = "Apartemen 5", hasSub = true, apartIndex = 5},
    {name = "🏠 Apart 6",         pos = Vector3.new(895.721, 8.932, 41.928), desc = "Apartemen 6", hasSub = true, apartIndex = 6},
    {name = "🎰 Casino",          pos = Vector3.new(1166.33, 3.36, -29.77), desc = "Casino", hasSub = false},
    {name = "🏥 Hospital",        pos = Vector3.new(1065.19, 28.47, 420.76), desc = "Rumah Sakit", hasSub = false},
}

-- ========== SUB LOCATIONS UNTUK APARTEMEN ==========
local APART_SUB_LOCATIONS = {
    [1] = {
        {name = "APART 1", pos = CFrame.new(1137.992, 8.932, 449.753), freeze = false},
        {name = "APART 1 BAWAH POT", pos = CFrame.new(1145.73, 6.23, 449.67) * CFrame.Angles(-3.14, -0.01, -3.14), freeze = true},
    },
    [2] = {
        {name = "APART 2", pos = CFrame.new(1139.174, 8.932, 420.556), freeze = false},
        {name = "APART 2 BAWAH POT", pos = CFrame.new(1144.98, 6.23, 420.40) * CFrame.Angles(-3.14, 0.00, 3.14), freeze = true},
    },
    [3] = {
        {name = "APART 3", pos = CFrame.new(984.856, 8.932, 247.280), freeze = false},
        {name = "APART 3 BAWAH POT", pos = CFrame.new(982.20, 6.23, 249.93) * CFrame.Angles(0.00, -0.02, -0.00), freeze = true},
    },
    [4] = {
        {name = "APART 4", pos = CFrame.new(988.311, 8.932, 221.664), freeze = false},
        {name = "APART 4 BAWAH POT", pos = CFrame.new(981.78, 6.23, 221.41) * CFrame.Angles(-0.00, 0.03, -0.00), freeze = true},
    },
    [5] = {
        {name = "APART 5", pos = CFrame.new(923.954, 8.932, 42.202), freeze = false},
        {name = "APART 5 BAWAH POT", pos = CFrame.new(924.34, 6.23, 36.52) * CFrame.Angles(-3.14, -1.53, -3.14), freeze = true},
    },
    [6] = {
        {name = "APART 6", pos = CFrame.new(895.721, 8.932, 41.928), freeze = false},
        {name = "APART 6 BAWAH POT", pos = CFrame.new(896.02, 6.23, 36.70) * CFrame.Angles(0.00, -1.55, 0.00), freeze = true},
    },
}

-- ========== VARIABLE ==========
local activeSubButtons = {}
local activeApartIndex = nil

local function clearSubButtons()
    for _, btn in pairs(activeSubButtons) do
        if btn and btn.Parent then
            btn:Destroy()
        end
    end
    activeSubButtons = {}
    activeApartIndex = nil
end

-- ========== FUNGSI FREEZE KENDARAAN ==========
local isVehicleFrozen = false
local frozenVehicleCFrame = nil
local freezeConnection = nil
local frozenVehicle = nil

local function stopVehicleFreeze()
    if freezeConnection then
        freezeConnection:Disconnect()
        freezeConnection = nil
    end
    isVehicleFrozen = false
    frozenVehicleCFrame = nil
    frozenVehicle = nil
end

local function startVehicleFreeze(vehicle, cframe)
    stopVehicleFreeze()
    
    frozenVehicle = vehicle
    frozenVehicleCFrame = cframe
    
    freezeConnection = RunService.Heartbeat:Connect(function()
        if frozenVehicle and frozenVehicle.Parent then
            if frozenVehicle.PrimaryPart then
                frozenVehicle:SetPrimaryPartCFrame(frozenVehicleCFrame)
            else
                local anchor = frozenVehicle:FindFirstChildOfClass("VehicleSeat") or frozenVehicle:FindFirstChildOfClass("BasePart")
                if anchor then
                    anchor.CFrame = frozenVehicleCFrame
                end
            end
            for _, part in ipairs(frozenVehicle:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function()
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
            end
        else
            stopVehicleFreeze()
        end
    end)
    
    isVehicleFrozen = true
end

local function unfreezeVehicle()
    stopVehicleFreeze()
end

-- ========== FUNGSI TELEPORT ==========
local function teleportToPosition(targetCFrame, shouldFreezeAfter)
    local character = player.Character
    if not character then return false end
    
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    
    -- Selalu unfreeze dulu sebelum teleport
    unfreezeVehicle()
    
    local seatPart = hum.SeatPart
    if seatPart then
        local vehicle = seatPart:FindFirstAncestorOfClass("Model")
        if vehicle then
            if vehicle.PrimaryPart then
                vehicle:SetPrimaryPartCFrame(targetCFrame)
            else
                local anchor = vehicle:FindFirstChildOfClass("VehicleSeat") or vehicle:FindFirstChildOfClass("BasePart")
                if anchor then
                    anchor.CFrame = targetCFrame
                end
            end
            -- Freeze setelah teleport jika diminta
            if shouldFreezeAfter then
                task.wait(0.1)
                startVehicleFreeze(vehicle, targetCFrame)
            end
        end
    else
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = targetCFrame
        end
    end
    
    return true
end

local function teleportToVector3(targetPos, shouldFreezeAfter)
    return teleportToPosition(CFrame.new(targetPos), shouldFreezeAfter)
end

-- ========== SAFE ZONE ==========
local SAFE_ZONE_CFRAME = CFrame.new(537.71, 4.59, -537.09) * CFrame.Angles(-1.20, -1.56, -1.20)

-- ========== HP MONITORING & AUTO SAFE TELEPORT ==========
local hpMonitoringActive = false
local isInSafeZone = false
local originalPosition = nil
local originalShouldFreeze = false  -- Menyimpan status freeze ASLI sebelum kena hit
local safeZoneTimerThread = nil
local currentHumanoid = nil
local lastHealthPercent = 100
local isWaitingForReturn = false

local function onCharacterAdded(character)
    currentHumanoid = character:WaitForChild("Humanoid")
    lastHealthPercent = (currentHumanoid.Health / currentHumanoid.MaxHealth) * 100
    isInSafeZone = false
    originalPosition = nil
    originalShouldFreeze = false
    isWaitingForReturn = false
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
        safeZoneTimerThread = nil
    end
    unfreezeVehicle()
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

-- Fungsi teleport ke safe zone (tanpa freeze)
local function goToSafeZone()
    local character = player.Character
    if not character then return false end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    -- Simpan posisi original dan status freeze asli
    originalPosition = hrp.CFrame
    
    -- Teleport ke safe zone (tanpa freeze)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum and hum.SeatPart then
        local vehicle = hum.SeatPart:FindFirstAncestorOfClass("Model")
        if vehicle then
            if vehicle.PrimaryPart then
                vehicle:SetPrimaryPartCFrame(SAFE_ZONE_CFRAME)
            else
                local anchor = vehicle:FindFirstChildOfClass("VehicleSeat") or vehicle:FindFirstChildOfClass("BasePart")
                if anchor then
                    anchor.CFrame = SAFE_ZONE_CFRAME
                end
            end
        end
    else
        hrp.CFrame = SAFE_ZONE_CFRAME
    end
    
    isInSafeZone = true
    return true
end

-- Fungsi kembali ke original dengan freeze sesuai status asli
local function goBackToOriginal()
    if originalPosition then
        -- Kembali ke posisi original, freeze jika asalnya dari bawah pot
        teleportToPosition(originalPosition, originalShouldFreeze)
        originalPosition = nil
    end
    isInSafeZone = false
    isWaitingForReturn = false
end

local function startReturnTimer()
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
    end
    
    safeZoneTimerThread = task.spawn(function()
        task.wait(8)
        if isInSafeZone and hpMonitoringActive then
            goBackToOriginal()
        end
        safeZoneTimerThread = nil
    end)
end

local function checkHealthAndTeleport()
    if not hpMonitoringActive then return end
    if isWaitingForReturn then return end
    if isInSafeZone then return end
    
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
        
        -- Jika kena hit (HP turun)
        if currentPercent < lastHealthPercent then
            -- UNFREEZE kendaraan dulu
            unfreezeVehicle()
            
            -- Simpan status freeze asli (apakah dari bawah pot atau tidak)
            originalShouldFreeze = isVehicleFrozen
            
            -- Teleport ke safe zone
            if goToSafeZone() then
                isWaitingForReturn = true
                startReturnTimer()
            end
        end
        
        lastHealthPercent = currentPercent
    end
end

local function startHPMonitoring()
    if hpMonitoringActive then return end
    hpMonitoringActive = true
    isInSafeZone = false
    originalPosition = nil
    originalShouldFreeze = false
    isWaitingForReturn = false
    
    if currentHumanoid then
        lastHealthPercent = (currentHumanoid.Health / currentHumanoid.MaxHealth) * 100
    else
        lastHealthPercent = 100
    end
    
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
        safeZoneTimerThread = nil
    end
    
    task.spawn(function()
        while hpMonitoringActive do
            checkHealthAndTeleport()
            task.wait(0.1)
        end
    end)
end

local function stopHPMonitoring()
    hpMonitoringActive = false
    
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
        safeZoneTimerThread = nil
    end
    
    if isInSafeZone then
        goBackToOriginal()
    end
    
    isInSafeZone = false
    originalPosition = nil
    originalShouldFreeze = false
    isWaitingForReturn = false
end

-- Buat semua button TP
local tpLayout = Instance.new("UIListLayout")
tpLayout.Parent = TPContent
tpLayout.Padding = UDim.new(0, 6)
tpLayout.SortOrder = Enum.SortOrder.LayoutOrder

local tpPadding = Instance.new("UIPadding")
tpPadding.Parent = TPContent
tpPadding.PaddingLeft = UDim.new(0, 8)
tpPadding.PaddingRight = UDim.new(0, 8)
tpPadding.PaddingTop = UDim.new(0, 6)

tpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TPContent.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 20)
end)

local function createSubButtons(parentBtn, apartIndex, layoutOrder)
    clearSubButtons()
    activeApartIndex = apartIndex
    
    local startY = layoutOrder * 61 + 55 + 6
    
    for i, sub in ipairs(APART_SUB_LOCATIONS[apartIndex]) do
        local subBtn = Instance.new("TextButton")
        subBtn.Parent = TPContent
        subBtn.Size = UDim2.new(1, 0, 0, 40)
        subBtn.Position = UDim2.new(0, 8, 0, startY + (i - 1) * 46)
        subBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 100)
        subBtn.Text = sub.name
        subBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        subBtn.TextSize = 13
        subBtn.Font = Enum.Font.GothamBold
        subBtn.BorderSizePixel = 0
        
        local subCorner = Instance.new("UICorner")
        subCorner.Parent = subBtn
        subCorner.CornerRadius = UDim.new(0, 8)
        
        subBtn.MouseEnter:Connect(function()
            subBtn.BackgroundColor3 = Color3.fromRGB(80, 90, 130)
        end)
        subBtn.MouseLeave:Connect(function()
            subBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 100)
        end)
        
        subBtn.MouseButton1Click:Connect(function()
            if sub.freeze then
                teleportToPosition(sub.pos, true)
                startHPMonitoring()
            else
                teleportToPosition(sub.pos, false)
            end
            clearSubButtons()
        end)
        
        table.insert(activeSubButtons, subBtn)
    end
    
    TPContent.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 20 + #activeSubButtons * 46)
end

for i, loc in ipairs(LOCATIONS) do
    local btn = Instance.new("TextButton")
    btn.Parent = TPContent
    btn.Size = UDim2.new(1, 0, 0, 55)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = i
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    local icon = Instance.new("TextLabel")
    icon.Parent = btn
    icon.Size = UDim2.new(0, 45, 1, 0)
    icon.Position = UDim2.new(0, 8, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = loc.name:sub(1, 2)
    icon.TextSize = 26
    icon.Font = Enum.Font.GothamBold
    
    local title = Instance.new("TextLabel")
    title.Parent = btn
    title.Size = UDim2.new(1, -70, 0, 22)
    title.Position = UDim2.new(0, 55, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = loc.name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    
    local desc = Instance.new("TextLabel")
    desc.Parent = btn
    desc.Size = UDim2.new(1, -70, 0, 18)
    desc.Position = UDim2.new(0, 55, 0, 30)
    desc.BackgroundTransparency = 1
    desc.Text = loc.desc
    desc.TextColor3 = Color3.fromRGB(160, 160, 180)
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 10
    
    if loc.hasSub then
        btn.MouseButton1Click:Connect(function()
            if activeApartIndex == loc.apartIndex then
                clearSubButtons()
            else
                createSubButtons(btn, loc.apartIndex, i)
            end
        end)
    else
        btn.MouseButton1Click:Connect(function()
            clearSubButtons()
            teleportToVector3(loc.pos, false)
        end)
    end
end

-- Klik di luar untuk menutup sub buttons
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UIS:GetMouseLocation()
        local tpContentPos = TPContent.AbsolutePosition
        local tpContentSize = TPContent.AbsoluteSize
        
        local isInTPContent = (mousePos.X >= tpContentPos.X and mousePos.X <= tpContentPos.X + tpContentSize.X and
                               mousePos.Y >= tpContentPos.Y and mousePos.Y <= tpContentPos.Y + tpContentSize.Y)
        
        if not isInTPContent then
            clearSubButtons()
        end
    end
end)

-- ========== MS LOOP CONTENT ==========
local MSLoopTitle = Instance.new("TextLabel")
MSLoopTitle.Parent = MSLoopContent
MSLoopTitle.Size = UDim2.new(1,-16,0,25)
MSLoopTitle.Position = UDim2.new(0,8,0,5)
MSLoopTitle.BackgroundTransparency = 1
MSLoopTitle.Text = "🔄 MS LOOP (AUTO TOOLS)"
MSLoopTitle.TextColor3 = Color3.fromRGB(100,255,100)
MSLoopTitle.TextXAlignment = Enum.TextXAlignment.Left
MSLoopTitle.Font = Enum.Font.GothamBold
MSLoopTitle.TextSize = 12

local MSLoopStatus = Instance.new("TextLabel")
MSLoopStatus.Parent = MSLoopContent
MSLoopStatus.Size = UDim2.new(1,-16,0,32)
MSLoopStatus.Position = UDim2.new(0,8,0,35)
MSLoopStatus.BackgroundColor3 = Color3.fromRGB(40,40,50)
MSLoopStatus.Text = "⏹️ LOOP STOPPED"
MSLoopStatus.TextColor3 = Color3.fromRGB(255,100,100)
MSLoopStatus.Font = Enum.Font.GothamBold
MSLoopStatus.TextSize = 12
local MSLoopStatusCorner = Instance.new("UICorner")
MSLoopStatusCorner.Parent = MSLoopStatus
MSLoopStatusCorner.CornerRadius = UDim.new(0,6)

-- INDICATOR
local BuyIndicatorFrame = Instance.new("Frame")
BuyIndicatorFrame.Parent = MSLoopContent
BuyIndicatorFrame.Size = UDim2.new(1,-16,0,130)
BuyIndicatorFrame.Position = UDim2.new(0,8,0,75)
BuyIndicatorFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
BuyIndicatorFrame.BorderSizePixel = 0
local BuyIndicatorCorner = Instance.new("UICorner")
BuyIndicatorCorner.Parent = BuyIndicatorFrame
BuyIndicatorCorner.CornerRadius = UDim.new(0,8)

local BuyIndicatorTitle = Instance.new("TextLabel")
BuyIndicatorTitle.Parent = BuyIndicatorFrame
BuyIndicatorTitle.Size = UDim2.new(1,-12,0,20)
BuyIndicatorTitle.Position = UDim2.new(0,6,0,5)
BuyIndicatorTitle.BackgroundTransparency = 1
BuyIndicatorTitle.Text = "🛒 INDIKATOR STOK"
BuyIndicatorTitle.TextColor3 = Color3.fromRGB(255,255,100)
BuyIndicatorTitle.TextXAlignment = Enum.TextXAlignment.Left
BuyIndicatorTitle.Font = Enum.Font.GothamBold
BuyIndicatorTitle.TextSize = 11

local BisaMasak = Instance.new("TextLabel")
BisaMasak.Parent = BuyIndicatorFrame
BisaMasak.Size = UDim2.new(1,-12,0,22)
BisaMasak.Position = UDim2.new(0,6,0,28)
BisaMasak.BackgroundTransparency = 1
BisaMasak.Text = "🍳 BISA MASAK: 0"
BisaMasak.TextColor3 = Color3.fromRGB(255,255,255)
BisaMasak.TextXAlignment = Enum.TextXAlignment.Left
BisaMasak.Font = Enum.Font.GothamBold
BisaMasak.TextSize = 13

local WaterIndicator = Instance.new("TextLabel")
WaterIndicator.Parent = BuyIndicatorFrame
WaterIndicator.Size = UDim2.new(1,-12,0,20)
WaterIndicator.Position = UDim2.new(0,6,0,52)
WaterIndicator.BackgroundTransparency = 1
WaterIndicator.Text = "💧 WATER: 0"
WaterIndicator.TextColor3 = Color3.fromRGB(255,255,255)
WaterIndicator.TextXAlignment = Enum.TextXAlignment.Left
WaterIndicator.Font = Enum.Font.GothamBold
WaterIndicator.TextSize = 11

local SugarIndicator = Instance.new("TextLabel")
SugarIndicator.Parent = BuyIndicatorFrame
SugarIndicator.Size = UDim2.new(1,-12,0,20)
SugarIndicator.Position = UDim2.new(0,6,0,74)
SugarIndicator.BackgroundTransparency = 1
SugarIndicator.Text = "🍚 SUGAR: 0"
SugarIndicator.TextColor3 = Color3.fromRGB(255,255,255)
SugarIndicator.TextXAlignment = Enum.TextXAlignment.Left
SugarIndicator.Font = Enum.Font.GothamBold
SugarIndicator.TextSize = 11

local GelatinIndicator = Instance.new("TextLabel")
GelatinIndicator.Parent = BuyIndicatorFrame
GelatinIndicator.Size = UDim2.new(1,-12,0,20)
GelatinIndicator.Position = UDim2.new(0,6,0,96)
GelatinIndicator.BackgroundTransparency = 1
GelatinIndicator.Text = "🧪 GELATIN: 0"
GelatinIndicator.TextColor3 = Color3.fromRGB(255,255,255)
GelatinIndicator.TextXAlignment = Enum.TextXAlignment.Left
GelatinIndicator.Font = Enum.Font.GothamBold
GelatinIndicator.TextSize = 11

local MSLoopStepLabel = Instance.new("TextLabel")
MSLoopStepLabel.Parent = MSLoopContent
MSLoopStepLabel.Size = UDim2.new(1,-16,0,20)
MSLoopStepLabel.Position = UDim2.new(0,8,0,210)
MSLoopStepLabel.BackgroundTransparency = 1
MSLoopStepLabel.Text = "Step: Waiting..."
MSLoopStepLabel.TextColor3 = Color3.fromRGB(200,200,200)
MSLoopStepLabel.TextXAlignment = Enum.TextXAlignment.Left
MSLoopStepLabel.Font = Enum.Font.Gotham
MSLoopStepLabel.TextSize = 10

local MSLoopTimer = Instance.new("TextLabel")
MSLoopTimer.Parent = MSLoopContent
MSLoopTimer.Size = UDim2.new(1,-16,0,20)
MSLoopTimer.Position = UDim2.new(0,8,0,232)
MSLoopTimer.BackgroundTransparency = 1
MSLoopTimer.Text = "Timer: 0s"
MSLoopTimer.TextColor3 = Color3.fromRGB(200,200,200)
MSLoopTimer.TextXAlignment = Enum.TextXAlignment.Left
MSLoopTimer.Font = Enum.Font.Gotham
MSLoopTimer.TextSize = 10

local ToolStatus = Instance.new("TextLabel")
ToolStatus.Parent = MSLoopContent
ToolStatus.Size = UDim2.new(1,-16,0,20)
ToolStatus.Position = UDim2.new(0,8,0,254)
ToolStatus.BackgroundTransparency = 1
ToolStatus.Text = "Tool: -"
ToolStatus.TextColor3 = Color3.fromRGB(200,200,200)
ToolStatus.TextXAlignment = Enum.TextXAlignment.Left
ToolStatus.Font = Enum.Font.GothamBold
ToolStatus.TextSize = 10

local HPSafeStatus = Instance.new("TextLabel")
HPSafeStatus.Parent = MSLoopContent
HPSafeStatus.Size = UDim2.new(1,-16,0,20)
HPSafeStatus.Position = UDim2.new(0,8,0,276)
HPSafeStatus.BackgroundTransparency = 1
HPSafeStatus.Text = "🛡️ HP SAFE: INACTIVE"
HPSafeStatus.TextColor3 = Color3.fromRGB(200,200,200)
HPSafeStatus.TextXAlignment = Enum.TextXAlignment.Left
HPSafeStatus.Font = Enum.Font.GothamBold
HPSafeStatus.TextSize = 10

local VehicleFreezeStatus = Instance.new("TextLabel")
VehicleFreezeStatus.Parent = MSLoopContent
VehicleFreezeStatus.Size = UDim2.new(1,-16,0,20)
VehicleFreezeStatus.Position = UDim2.new(0,8,0,296)
VehicleFreezeStatus.BackgroundTransparency = 1
VehicleFreezeStatus.Text = "🚗 VEHICLE FREEZE: INACTIVE"
VehicleFreezeStatus.TextColor3 = Color3.fromRGB(200,200,200)
VehicleFreezeStatus.TextXAlignment = Enum.TextXAlignment.Left
VehicleFreezeStatus.Font = Enum.Font.GothamBold
VehicleFreezeStatus.TextSize = 10

local MSLoopStartBtn = Instance.new("TextButton")
MSLoopStartBtn.Parent = MSLoopContent
MSLoopStartBtn.Size = UDim2.new(0.5,-8,0,36)
MSLoopStartBtn.Position = UDim2.new(0,8,0,320)
MSLoopStartBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
MSLoopStartBtn.Text = "▶️ START"
MSLoopStartBtn.TextColor3 = Color3.fromRGB(255,255,255)
MSLoopStartBtn.Font = Enum.Font.GothamBold
MSLoopStartBtn.TextSize = 12
local MSLoopStartCorner = Instance.new("UICorner")
MSLoopStartCorner.Parent = MSLoopStartBtn
MSLoopStartCorner.CornerRadius = UDim.new(0,6)

local MSLoopStopBtn = Instance.new("TextButton")
MSLoopStopBtn.Parent = MSLoopContent
MSLoopStopBtn.Size = UDim2.new(0.5,-8,0,36)
MSLoopStopBtn.Position = UDim2.new(0.5,4,0,320)
MSLoopStopBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
MSLoopStopBtn.Text = "⏹️ STOP"
MSLoopStopBtn.TextColor3 = Color3.fromRGB(255,255,255)
MSLoopStopBtn.Font = Enum.Font.GothamBold
MSLoopStopBtn.TextSize = 12
local MSLoopStopCorner = Instance.new("UICorner")
MSLoopStopCorner.Parent = MSLoopStopBtn
MSLoopStopCorner.CornerRadius = UDim.new(0,6)

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Parent = MSLoopContent
RefreshBtn.Size = UDim2.new(1,-16,0,28)
RefreshBtn.Position = UDim2.new(0,8,0,362)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
RefreshBtn.Text = "🔄 REFRESH"
RefreshBtn.TextColor3 = Color3.fromRGB(200,200,255)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 11
local RefreshBtnCorner = Instance.new("UICorner")
RefreshBtnCorner.Parent = RefreshBtn
RefreshBtnCorner.CornerRadius = UDim.new(0,6)

-- ========== AUTO BUY UI ==========
local AutoBuyTitle = Instance.new("TextLabel")
AutoBuyTitle.Parent = AutoBuyContent
AutoBuyTitle.Size = UDim2.new(1,-16,0,28)
AutoBuyTitle.Position = UDim2.new(0,8,0,5)
AutoBuyTitle.BackgroundTransparency = 1
AutoBuyTitle.Text = "🛒 AUTO BUY BAHAN"
AutoBuyTitle.TextColor3 = Color3.fromRGB(100,200,255)
AutoBuyTitle.TextXAlignment = Enum.TextXAlignment.Left
AutoBuyTitle.Font = Enum.Font.GothamBold
AutoBuyTitle.TextSize = 13

local AutoBuyDesc = Instance.new("TextLabel")
AutoBuyDesc.Parent = AutoBuyContent
AutoBuyDesc.Size = UDim2.new(1,-16,0,32)
AutoBuyDesc.Position = UDim2.new(0,8,0,35)
AutoBuyDesc.BackgroundTransparency = 1
AutoBuyDesc.Text = "Beli Water, Sugar, Gelatin dari NPC"
AutoBuyDesc.TextColor3 = Color3.fromRGB(200,200,200)
AutoBuyDesc.TextXAlignment = Enum.TextXAlignment.Left
AutoBuyDesc.Font = Enum.Font.Gotham
AutoBuyDesc.TextSize = 10

-- Jumlah Beli Frame
local JumlahBeliFrame = Instance.new("Frame")
JumlahBeliFrame.Parent = AutoBuyContent
JumlahBeliFrame.Size = UDim2.new(1,-16,0,70)
JumlahBeliFrame.Position = UDim2.new(0,8,0,75)
JumlahBeliFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
JumlahBeliFrame.BorderSizePixel = 0
local JumlahBeliCorner = Instance.new("UICorner")
JumlahBeliCorner.Parent = JumlahBeliFrame
JumlahBeliCorner.CornerRadius = UDim.new(0,8)

local JumlahBeliTitle = Instance.new("TextLabel")
JumlahBeliTitle.Parent = JumlahBeliFrame
JumlahBeliTitle.Size = UDim2.new(1,-12,0,22)
JumlahBeliTitle.Position = UDim2.new(0,6,0,5)
JumlahBeliTitle.BackgroundTransparency = 1
JumlahBeliTitle.Text = "📦 JUMLAH BELI PER ITEM"
JumlahBeliTitle.TextColor3 = Color3.fromRGB(255,255,100)
JumlahBeliTitle.TextXAlignment = Enum.TextXAlignment.Left
JumlahBeliTitle.Font = Enum.Font.GothamBold
JumlahBeliTitle.TextSize = 11

-- Slider
local JumlahSliderBg = Instance.new("Frame")
JumlahSliderBg.Parent = JumlahBeliFrame
JumlahSliderBg.Size = UDim2.new(0.8,0,0,8)
JumlahSliderBg.Position = UDim2.new(0.1,0,0,40)
JumlahSliderBg.BackgroundColor3 = Color3.fromRGB(60,60,80)
JumlahSliderBg.BorderSizePixel = 0
local JumlahSliderBgCorner = Instance.new("UICorner")
JumlahSliderBgCorner.Parent = JumlahSliderBg
JumlahSliderBgCorner.CornerRadius = UDim.new(0,4)

local JumlahSliderFill = Instance.new("Frame")
JumlahSliderFill.Parent = JumlahSliderBg
JumlahSliderFill.Size = UDim2.new(0.5,0,1,0)
JumlahSliderFill.BackgroundColor3 = Color3.fromRGB(100,200,255)
JumlahSliderFill.BorderSizePixel = 0
local JumlahSliderFillCorner = Instance.new("UICorner")
JumlahSliderFillCorner.Parent = JumlahSliderFill
JumlahSliderFillCorner.CornerRadius = UDim.new(0,4)

local JumlahValueLabel = Instance.new("TextLabel")
JumlahValueLabel.Parent = JumlahBeliFrame
JumlahValueLabel.Size = UDim2.new(0.2,0,0,22)
JumlahValueLabel.Position = UDim2.new(0.8,-10,0,38)
JumlahValueLabel.BackgroundTransparency = 1
JumlahValueLabel.Text = "10x"
JumlahValueLabel.TextColor3 = Color3.fromRGB(100,200,255)
JumlahValueLabel.TextXAlignment = Enum.TextXAlignment.Right
JumlahValueLabel.Font = Enum.Font.GothamBold
JumlahValueLabel.TextSize = 12

-- Status Box
local BuyStatusFrame = Instance.new("Frame")
BuyStatusFrame.Parent = AutoBuyContent
BuyStatusFrame.Size = UDim2.new(1,-16,0,70)
BuyStatusFrame.Position = UDim2.new(0,8,0,155)
BuyStatusFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
BuyStatusFrame.BorderSizePixel = 0
local BuyStatusCorner = Instance.new("UICorner")
BuyStatusCorner.Parent = BuyStatusFrame
BuyStatusCorner.CornerRadius = UDim.new(0,8)

local BuyStatusIcon = Instance.new("TextLabel")
BuyStatusIcon.Parent = BuyStatusFrame
BuyStatusIcon.Size = UDim2.new(0,45,1,0)
BuyStatusIcon.Position = UDim2.new(0,8,0,0)
BuyStatusIcon.BackgroundTransparency = 1
BuyStatusIcon.Text = "🛒"
BuyStatusIcon.TextSize = 32

local BuyStatusLabel = Instance.new("TextLabel")
BuyStatusLabel.Parent = BuyStatusFrame
BuyStatusLabel.Size = UDim2.new(1,-65,0,18)
BuyStatusLabel.Position = UDim2.new(0,55,0,8)
BuyStatusLabel.BackgroundTransparency = 1
BuyStatusLabel.Text = "STATUS"
BuyStatusLabel.TextColor3 = Color3.fromRGB(200,200,200)
BuyStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
BuyStatusLabel.Font = Enum.Font.GothamBold
BuyStatusLabel.TextSize = 11

local BuyStatusValue = Instance.new("TextLabel")
BuyStatusValue.Parent = BuyStatusFrame
BuyStatusValue.Size = UDim2.new(1,-65,0,32)
BuyStatusValue.Position = UDim2.new(0,55,0,28)
BuyStatusValue.BackgroundTransparency = 1
BuyStatusValue.Text = "⏹️ BELUM MULAI"
BuyStatusValue.TextColor3 = Color3.fromRGB(255,100,100)
BuyStatusValue.TextXAlignment = Enum.TextXAlignment.Left
BuyStatusValue.Font = Enum.Font.GothamBold
BuyStatusValue.TextSize = 11

local BuyTotalLabel = Instance.new("TextLabel")
BuyTotalLabel.Parent = BuyStatusFrame
BuyTotalLabel.Size = UDim2.new(1,-65,0,18)
BuyTotalLabel.Position = UDim2.new(0,55,0,52)
BuyTotalLabel.BackgroundTransparency = 1
BuyTotalLabel.Text = "Total: 0 item"
BuyTotalLabel.TextColor3 = Color3.fromRGB(100,200,255)
BuyTotalLabel.TextXAlignment = Enum.TextXAlignment.Left
BuyTotalLabel.Font = Enum.Font.Gotham
BuyTotalLabel.TextSize = 10

-- Buttons
local BuyStartBtn = Instance.new("TextButton")
BuyStartBtn.Parent = AutoBuyContent
BuyStartBtn.Size = UDim2.new(0.5,-8,0,38)
BuyStartBtn.Position = UDim2.new(0,8,0,235)
BuyStartBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
BuyStartBtn.Text = "▶️ START BUY"
BuyStartBtn.TextColor3 = Color3.fromRGB(255,255,255)
BuyStartBtn.Font = Enum.Font.GothamBold
BuyStartBtn.TextSize = 12
local BuyStartCorner = Instance.new("UICorner")
BuyStartCorner.Parent = BuyStartBtn
BuyStartCorner.CornerRadius = UDim.new(0,6)

local BuyStopBtn = Instance.new("TextButton")
BuyStopBtn.Parent = AutoBuyContent
BuyStopBtn.Size = UDim2.new(0.5,-8,0,38)
BuyStopBtn.Position = UDim2.new(0.5,4,0,235)
BuyStopBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
BuyStopBtn.Text = "⏹️ STOP"
BuyStopBtn.TextColor3 = Color3.fromRGB(255,255,255)
BuyStopBtn.Font = Enum.Font.GothamBold
BuyStopBtn.TextSize = 12
local BuyStopCorner = Instance.new("UICorner")
BuyStopCorner.Parent = BuyStopBtn
BuyStopCorner.CornerRadius = UDim.new(0,6)

-- ========== MS SAFETY CONTENT (BLINK) ==========
local MSSafetyTitle = Instance.new("TextLabel")
MSSafetyTitle.Parent = MSSafetyContent
MSSafetyTitle.Size = UDim2.new(1,-16,0,28)
MSSafetyTitle.Position = UDim2.new(0,8,0,5)
MSSafetyTitle.BackgroundTransparency = 1
MSSafetyTitle.Text = "🛡️ BLINK / TELEPORT MINI"
MSSafetyTitle.TextColor3 = Color3.fromRGB(100,200,255)
MSSafetyTitle.TextXAlignment = Enum.TextXAlignment.Left
MSSafetyTitle.Font = Enum.Font.GothamBold
MSSafetyTitle.TextSize = 14

local BlinkStatus = Instance.new("TextLabel")
BlinkStatus.Parent = MSSafetyContent
BlinkStatus.Size = UDim2.new(1,-16,0,32)
BlinkStatus.Position = UDim2.new(0,8,0,300)
BlinkStatus.BackgroundColor3 = Color3.fromRGB(40,40,50)
BlinkStatus.Text = "Klik tombol di atas untuk blink"
BlinkStatus.TextColor3 = Color3.fromRGB(100,255,100)
BlinkStatus.Font = Enum.Font.GothamBold
BlinkStatus.TextSize = 10
local BlinkStatusCorner = Instance.new("UICorner")
BlinkStatusCorner.Parent = BlinkStatus
BlinkStatusCorner.CornerRadius = UDim.new(0,6)

-- ========== AUTO SELL CONTENT ==========
local AutoSellTitle = Instance.new("TextLabel")
AutoSellTitle.Parent = AutoSellContent
AutoSellTitle.Size = UDim2.new(1,-16,0,28)
AutoSellTitle.Position = UDim2.new(0,8,0,8)
AutoSellTitle.BackgroundTransparency = 1
AutoSellTitle.Text = "💰 AUTO SELL"
AutoSellTitle.TextColor3 = Color3.fromRGB(100,255,100)
AutoSellTitle.TextXAlignment = Enum.TextXAlignment.Left
AutoSellTitle.Font = Enum.Font.GothamBold
AutoSellTitle.TextSize = 16

local AutoSellStatusFrame = Instance.new("Frame")
AutoSellStatusFrame.Parent = AutoSellContent
AutoSellStatusFrame.Size = UDim2.new(1,-16,0,85)
AutoSellStatusFrame.Position = UDim2.new(0,8,0,45)
AutoSellStatusFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
AutoSellStatusFrame.BorderSizePixel = 0
local AutoSellStatusCorner = Instance.new("UICorner")
AutoSellStatusCorner.Parent = AutoSellStatusFrame
AutoSellStatusCorner.CornerRadius = UDim.new(0,8)

local AutoSellIcon = Instance.new("TextLabel")
AutoSellIcon.Parent = AutoSellStatusFrame
AutoSellIcon.Size = UDim2.new(0,45,1,0)
AutoSellIcon.Position = UDim2.new(0,8,0,0)
AutoSellIcon.BackgroundTransparency = 1
AutoSellIcon.Text = "💰"
AutoSellIcon.TextSize = 40
AutoSellIcon.Font = Enum.Font.GothamBold
AutoSellIcon.TextColor3 = Color3.fromRGB(255,255,100)

local AutoSellStatusTitle = Instance.new("TextLabel")
AutoSellStatusTitle.Parent = AutoSellStatusFrame
AutoSellStatusTitle.Size = UDim2.new(1,-70,0,22)
AutoSellStatusTitle.Position = UDim2.new(0,55,0,8)
AutoSellStatusTitle.BackgroundTransparency = 1
AutoSellStatusTitle.Text = "STATUS"
AutoSellStatusTitle.TextColor3 = Color3.fromRGB(255,255,255)
AutoSellStatusTitle.TextXAlignment = Enum.TextXAlignment.Left
AutoSellStatusTitle.Font = Enum.Font.GothamBold
AutoSellStatusTitle.TextSize = 12

local AutoSellStatus = Instance.new("TextLabel")
AutoSellStatus.Parent = AutoSellStatusFrame
AutoSellStatus.Size = UDim2.new(1,-70,0,22)
AutoSellStatus.Position = UDim2.new(0,55,0,30)
AutoSellStatus.BackgroundTransparency = 1
AutoSellStatus.Text = "⏹️ STOPPED"
AutoSellStatus.TextColor3 = Color3.fromRGB(255,100,100)
AutoSellStatus.TextXAlignment = Enum.TextXAlignment.Left
AutoSellStatus.Font = Enum.Font.GothamBold
AutoSellStatus.TextSize = 12

local AutoSellCounter = Instance.new("TextLabel")
AutoSellCounter.Parent = AutoSellStatusFrame
AutoSellCounter.Size = UDim2.new(1,-70,0,18)
AutoSellCounter.Position = UDim2.new(0,55,0,52)
AutoSellCounter.BackgroundTransparency = 1
AutoSellCounter.Text = "Terjual: 0"
AutoSellCounter.TextColor3 = Color3.fromRGB(100,255,255)
AutoSellCounter.TextXAlignment = Enum.TextXAlignment.Left
AutoSellCounter.Font = Enum.Font.GothamBold
AutoSellCounter.TextSize = 10

local AutoSellInfo = Instance.new("TextLabel")
AutoSellInfo.Parent = AutoSellStatusFrame
AutoSellInfo.Size = UDim2.new(1,-70,0,15)
AutoSellInfo.Position = UDim2.new(0,55,0,70)
AutoSellInfo.BackgroundTransparency = 1
AutoSellInfo.Text = "Tools: 0"
AutoSellInfo.TextColor3 = Color3.fromRGB(200,200,200)
AutoSellInfo.TextXAlignment = Enum.TextXAlignment.Left
AutoSellInfo.Font = Enum.Font.Gotham
AutoSellInfo.TextSize = 9

local AutoSellButtonFrame = Instance.new("Frame")
AutoSellButtonFrame.Parent = AutoSellContent
AutoSellButtonFrame.Size = UDim2.new(1,-16,0,45)
AutoSellButtonFrame.Position = UDim2.new(0,8,0,140)
AutoSellButtonFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
AutoSellButtonFrame.BorderSizePixel = 0
local AutoSellButtonCorner = Instance.new("UICorner")
AutoSellButtonCorner.Parent = AutoSellButtonFrame
AutoSellButtonCorner.CornerRadius = UDim.new(0,8)

local AutoSellStartBtn = Instance.new("TextButton")
AutoSellStartBtn.Parent = AutoSellButtonFrame
AutoSellStartBtn.Size = UDim2.new(0.5,-8,0,32)
AutoSellStartBtn.Position = UDim2.new(0,6,0,6)
AutoSellStartBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
AutoSellStartBtn.Text = "▶️ START"
AutoSellStartBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoSellStartBtn.Font = Enum.Font.GothamBold
AutoSellStartBtn.TextSize = 12
local AutoSellStartCorner = Instance.new("UICorner")
AutoSellStartCorner.Parent = AutoSellStartBtn
AutoSellStartCorner.CornerRadius = UDim.new(0,6)

local AutoSellStopBtn = Instance.new("TextButton")
AutoSellStopBtn.Parent = AutoSellButtonFrame
AutoSellStopBtn.Size = UDim2.new(0.5,-8,0,32)
AutoSellStopBtn.Position = UDim2.new(0.5,2,0,6)
AutoSellStopBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
AutoSellStopBtn.Text = "⏹️ STOP"
AutoSellStopBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoSellStopBtn.Font = Enum.Font.GothamBold
AutoSellStopBtn.TextSize = 12
local AutoSellStopCorner = Instance.new("UICorner")
AutoSellStopCorner.Parent = AutoSellStopBtn
AutoSellStopCorner.CornerRadius = UDim.new(0,6)

-- ========== FUNCTIONS ==========
local function countTools(toolName)
    local count = 0
    if player.Character then
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("Tool") and string.find(string.lower(child.Name), string.lower(toolName)) then
                count = count + 1
            end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") and string.find(string.lower(child.Name), string.lower(toolName)) then
                count = count + 1
            end
        end
    end
    return count
end

local function updateBuyIndicators()
    local waterCount = countTools("water")
    local sugarCount = countTools("sugar")
    local gelatinCount = countTools("gelatin")
    
    WaterIndicator.Text = "💧 WATER: " .. waterCount
    SugarIndicator.Text = "🍚 SUGAR: " .. sugarCount
    GelatinIndicator.Text = "🧪 GELATIN: " .. gelatinCount
    
    if waterCount > 0 then WaterIndicator.TextColor3 = Color3.fromRGB(100,200,255)
    else WaterIndicator.TextColor3 = Color3.fromRGB(255,255,255) end
    
    if sugarCount > 0 then SugarIndicator.TextColor3 = Color3.fromRGB(100,200,255)
    else SugarIndicator.TextColor3 = Color3.fromRGB(255,255,255) end
    
    if gelatinCount > 0 then GelatinIndicator.TextColor3 = Color3.fromRGB(100,200,255)
    else GelatinIndicator.TextColor3 = Color3.fromRGB(255,255,255) end
    
    local bisaMasak = math.min(waterCount, sugarCount, gelatinCount)
    BisaMasak.Text = "🍳 BISA MASAK: " .. bisaMasak
    if bisaMasak >= 3 then BisaMasak.TextColor3 = Color3.fromRGB(100,255,100)
    elseif bisaMasak >= 1 then BisaMasak.TextColor3 = Color3.fromRGB(255,255,100)
    else BisaMasak.TextColor3 = Color3.fromRGB(255,255,255) end
end

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

local autoSellRunning = false
local autoSellCount = 0

local function startAutoSell()
    if autoSellRunning then return end
    autoSellRunning = true
    autoSellCount = 0
    AutoSellStatus.Text = "▶️ RUNNING"
    AutoSellStatus.TextColor3 = Color3.fromRGB(100,255,100)
    
    task.spawn(function()
        while autoSellRunning do
            local tools = getSellTools()
            AutoSellInfo.Text = "Tools: " .. #tools
            
            if #tools > 0 then
                for _, tool in ipairs(tools) do
                    if not autoSellRunning then break end
                    if tool and tool.Parent then
                        if tool.Parent == player:FindFirstChild("Backpack") then
                            local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                            if humanoid then humanoid:EquipTool(tool) task.wait(0.3) end
                        end
                        AutoSellStatus.Text = "▶️ HOLD E..."
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        local holdStart = tick()
                        while autoSellRunning and (tick() - holdStart) < 2 do task.wait(0.1) end
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        autoSellCount = autoSellCount + 1
                        AutoSellCounter.Text = "Terjual: " .. autoSellCount
                        AutoSellStatus.Text = "▶️ RUNNING"
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
    AutoSellStatus.Text = "⏹️ STOPPED"
    AutoSellStatus.TextColor3 = Color3.fromRGB(255,100,100)
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

local function equipTool(tool)
    if not tool or not player.Character then return false end
    if tool.Parent == player.Character then return true end
    if tool.Parent == player:FindFirstChild("Backpack") then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:EquipTool(tool)
            task.wait(0.2)
            return tool.Parent == player.Character
        end
    end
    return false
end

local function pressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local loopRunning = false

local function startMSLoop()
    if loopRunning then return end
    
    -- UNFREEZE kendaraan saat MS Loop mulai (biar MS Loop bisa jalan normal)
    unfreezeVehicle()
    
    loopRunning = true
    MSLoopStatus.Text = "▶️ LOOP RUNNING"
    MSLoopStatus.TextColor3 = Color3.fromRGB(100,255,100)
    HPSafeStatus.Text = "🛡️ HP SAFE: ACTIVE"
    HPSafeStatus.TextColor3 = Color3.fromRGB(100,255,100)
    
    startHPMonitoring()
    
    task.spawn(function()
        while loopRunning do
            updateBuyIndicators()
            
            local waterTool = findTool("water")
            if waterTool and equipTool(waterTool) then
                ToolStatus.Text = "Tool: WATER"
                MSLoopStepLabel.Text = "Step 1: WATER - 20 seconds"
                pressE()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 20 do
                    local remaining = 20 - (tick() - startTime)
                    MSLoopTimer.Text = string.format("Timer: %d/20s - WATER", math.floor(20 - remaining))
                    task.wait(0.1)
                end
            else
                MSLoopStepLabel.Text = "ERROR: Water tool not found!"
                break
            end
            
            task.wait(3)
            if not loopRunning then break end
            
            local sugarTool = findTool("sugar")
            if sugarTool and equipTool(sugarTool) then
                ToolStatus.Text = "Tool: SUGAR"
                MSLoopStepLabel.Text = "Step 2: SUGAR - 2 seconds"
                pressE()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 2 do
                    local remaining = 2 - (tick() - startTime)
                    MSLoopTimer.Text = string.format("Timer: %d/2s - SUGAR", math.floor(2 - remaining))
                    task.wait(0.1)
                end
            else
                MSLoopStepLabel.Text = "ERROR: Sugar tool not found!"
                break
            end
            
            task.wait(0.5)
            if not loopRunning then break end
            
            local gelatinTool = findTool("gelatin")
            if gelatinTool and equipTool(gelatinTool) then
                ToolStatus.Text = "Tool: GELATIN"
                MSLoopStepLabel.Text = "Step 3: GELATIN - 45 seconds"
                pressE()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 45 do
                    local remaining = 45 - (tick() - startTime)
                    MSLoopTimer.Text = string.format("Timer: %d/45s - GELATIN", math.floor(45 - remaining))
                    task.wait(0.1)
                end
            else
                MSLoopStepLabel.Text = "ERROR: Gelatin tool not found!"
                break
            end
            
            task.wait(3)
            if not loopRunning then break end
            
            local emptyTool = findTool("empty") or findTool("bag")
            if emptyTool and equipTool(emptyTool) then
                ToolStatus.Text = "Tool: EMPTY BAG"
                MSLoopStepLabel.Text = "Step 4: EMPTY BAG - 2 seconds (HASIL)"
                pressE()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 2 do
                    local remaining = 2 - (tick() - startTime)
                    MSLoopTimer.Text = string.format("Timer: %d/2s - HASIL", math.floor(2 - remaining))
                    task.wait(0.1)
                end
            else
                MSLoopStepLabel.Text = "ERROR: Empty Bag tool not found!"
                break
            end
            
            updateBuyIndicators()
            MSLoopStepLabel.Text = "Loop complete! Restarting..."
            task.wait(1)
        end
        
        loopRunning = false
        MSLoopStatus.Text = "⏹️ LOOP STOPPED"
        MSLoopStatus.TextColor3 = Color3.fromRGB(255,100,100)
        MSLoopStepLabel.Text = "Step: Stopped"
        MSLoopTimer.Text = "Timer: 0s"
        ToolStatus.Text = "Tool: -"
        HPSafeStatus.Text = "🛡️ HP SAFE: INACTIVE"
        HPSafeStatus.TextColor3 = Color3.fromRGB(200,200,200)
        updateBuyIndicators()
    end)
end

-- ========== AUTO BUY FUNCTIONS ==========
local autoBuyRunning = false
local currentBuyAmount = 10
local autoBuyTotalBought = 0

local function setBuyAmount(amount)
    currentBuyAmount = math.clamp(amount, 1, 50)
    JumlahValueLabel.Text = currentBuyAmount .. "x"
    JumlahSliderFill.Size = UDim2.new((currentBuyAmount - 1) / 49, 0, 1, 0)
end

local function startAutoBuy()
    if autoBuyRunning then return end
    if not storePurchaseRE then
        BuyStatusValue.Text = "❌ RemoteEvent tidak ditemukan!"
        BuyStatusValue.TextColor3 = Color3.fromRGB(255,100,100)
        task.wait(2)
        BuyStatusValue.Text = "⏹️ BELUM MULAI"
        BuyStatusValue.TextColor3 = Color3.fromRGB(255,100,100)
        return
    end
    
    autoBuyRunning = true
    autoBuyTotalBought = 0
    BuyStatusValue.Text = "▶️ RUNNING"
    BuyStatusValue.TextColor3 = Color3.fromRGB(100,255,100)
    BuyTotalLabel.Text = "Total: 0 item"
    
    local BUY_ITEMS = {
        {name = "Water", display = "💧 Water"},
        {name = "Sugar Block Bag", display = "🍚 Sugar Block Bag"},
        {name = "Gelatin", display = "🧪 Gelatin"}
    }
    
    task.spawn(function()
        local amount = currentBuyAmount
        
        for _, item in ipairs(BUY_ITEMS) do
            if not autoBuyRunning then break end
            
            BuyStatusValue.Text = "🛒 Membeli " .. item.display .. " x" .. amount
            BuyStatusValue.TextColor3 = Color3.fromRGB(255,255,100)
            
            for i = 1, amount do
                if not autoBuyRunning then break end
                
                pcall(function()
                    storePurchaseRE:FireServer(item.name, 1)
                end)
                
                autoBuyTotalBought = autoBuyTotalBought + 1
                BuyTotalLabel.Text = "Total: " .. autoBuyTotalBought .. " item"
                task.wait(0.5)
            end
            
            task.wait(0.8)
        end
        
        if autoBuyRunning then
            BuyStatusValue.Text = "✅ Selesai! Total: " .. autoBuyTotalBought .. " item"
            BuyStatusValue.TextColor3 = Color3.fromRGB(100,255,100)
            task.wait(2)
            if autoBuyRunning then
                BuyStatusValue.Text = "⏹️ STOPPED"
                BuyStatusValue.TextColor3 = Color3.fromRGB(255,100,100)
                autoBuyRunning = false
            end
        end
        updateBuyIndicators()
    end)
end

local function stopAutoBuy()
    autoBuyRunning = false
    BuyStatusValue.Text = "⏹️ STOPPED"
    BuyStatusValue.TextColor3 = Color3.fromRGB(255,100,100)
end

-- ========== SLIDER AUTO BUY ==========
local isDraggingSlider = false

JumlahSliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingSlider = true
        local mousePos = input.Position.X
        local sliderPos = JumlahSliderBg.AbsolutePosition.X
        local sliderWidth = JumlahSliderBg.AbsoluteSize.X
        local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        local newAmount = math.floor(1 + percent * 49)
        setBuyAmount(newAmount)
    end
end)

UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDraggingSlider then
        local mousePos = input.Position.X
        local sliderPos = JumlahSliderBg.AbsolutePosition.X
        local sliderWidth = JumlahSliderBg.AbsoluteSize.X
        
        local mouseInSlider = (mousePos >= sliderPos and mousePos <= sliderPos + sliderWidth)
        
        if mouseInSlider then
            local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
            local newAmount = math.floor(1 + percent * 49)
            setBuyAmount(newAmount)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingSlider = false
    end
end)

-- ========== BLINK FUNCTIONS ==========
local function blinkAtas()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 2, 0)
        BlinkStatus.Text = "✅ Naik 2 studs!"
        BlinkStatus.TextColor3 = Color3.fromRGB(100,255,100)
        task.wait(1)
        BlinkStatus.Text = "Klik tombol di atas untuk blink"
        BlinkStatus.TextColor3 = Color3.fromRGB(100,255,100)
    end
end

local function blinkDown()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, -4, 0)
        BlinkStatus.Text = "✅ Turun 4 studs!"
        BlinkStatus.TextColor3 = Color3.fromRGB(100,255,100)
        task.wait(1)
        BlinkStatus.Text = "Klik tombol di atas untuk blink"
        BlinkStatus.TextColor3 = Color3.fromRGB(100,255,100)
    end
end

local function blinkMaju()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 5
        BlinkStatus.Text = "✅ Maju 5 studs!"
        BlinkStatus.TextColor3 = Color3.fromRGB(100,255,100)
        task.wait(1)
        BlinkStatus.Text = "Klik tombol di atas untuk blink"
        BlinkStatus.TextColor3 = Color3.fromRGB(100,255,100)
    end
end

local function blinkMundur()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame - hrp.CFrame.LookVector * 5
        BlinkStatus.Text = "✅ Mundur 5 studs!"
        BlinkStatus.TextColor3 = Color3.fromRGB(100,255,100)
        task.wait(1)
        BlinkStatus.Text = "Klik tombol di atas untuk blink"
        BlinkStatus.TextColor3 = Color3.fromRGB(100,255,100)
    end
end

-- ========== CREATE BLINK BUTTONS ==========
local function createBlinkButton(parent, name, desc, color, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1, -16, 0, 55)
    btn.Position = UDim2.new(0, 8, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,45)
    btn.Text = ""
    btn.BorderSizePixel = 0
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    local icon = Instance.new("TextLabel")
    icon.Parent = btn
    icon.Size = UDim2.new(0, 45, 1, 0)
    icon.Position = UDim2.new(0, 8, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = name:sub(1, 2)
    icon.TextSize = 28
    icon.Font = Enum.Font.GothamBold
    
    local title = Instance.new("TextLabel")
    title.Parent = btn
    title.Size = UDim2.new(1, -70, 0, 22)
    title.Position = UDim2.new(0, 55, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = btn
    descLabel.Size = UDim2.new(1, -70, 0, 18)
    descLabel.Position = UDim2.new(0, 55, 0, 32)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(160,160,180)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    
    local actionBtn = Instance.new("TextButton")
    actionBtn.Parent = btn
    actionBtn.Size = UDim2.new(0, 40, 0, 32)
    actionBtn.Position = UDim2.new(1, -48, 0.5, -16)
    actionBtn.BackgroundColor3 = color
    actionBtn.Text = "▶️"
    actionBtn.TextColor3 = Color3.fromRGB(255,255,255)
    actionBtn.TextSize = 14
    actionBtn.Font = Enum.Font.GothamBold
    local actionCorner = Instance.new("UICorner")
    actionCorner.Parent = actionBtn
    actionCorner.CornerRadius = UDim.new(0, 6)
    
    actionBtn.MouseButton1Click:Connect(callback)
end

createBlinkButton(MSSafetyContent, "⬆️ BLINK ATAS", "Naik 2 studs", Color3.fromRGB(150,100,200), 40, blinkAtas)
createBlinkButton(MSSafetyContent, "⬇️ BLINK BAWAH", "Turun 4 studs", Color3.fromRGB(0,150,200), 100, blinkDown)
createBlinkButton(MSSafetyContent, "➡️ BLINK MAJU", "Maju 5 studs", Color3.fromRGB(0,200,100), 160, blinkMaju)
createBlinkButton(MSSafetyContent, "⬅️ BLINK MUNDUR", "Mundur 5 studs", Color3.fromRGB(200,100,0), 220, blinkMundur)

-- ========== CONNECT BUTTONS ==========
CloseBtn.MouseButton1Click:Connect(function()
    if autoSellRunning then stopAutoSell() end
    if loopRunning then 
        loopRunning = false
    end
    if autoBuyRunning then stopAutoBuy() end
    stopHPMonitoring()
    unfreezeVehicle()
    ScreenGui:Destroy()
end)

MSLoopStartBtn.MouseButton1Click:Connect(function()
    if not loopRunning then task.spawn(startMSLoop) end
end)

MSLoopStopBtn.MouseButton1Click:Connect(function() 
    loopRunning = false
    stopHPMonitoring()
end)

RefreshBtn.MouseButton1Click:Connect(updateBuyIndicators)

BuyStartBtn.MouseButton1Click:Connect(startAutoBuy)
BuyStopBtn.MouseButton1Click:Connect(stopAutoBuy)

AutoSellStartBtn.MouseButton1Click:Connect(startAutoSell)
AutoSellStopBtn.MouseButton1Click:Connect(stopAutoSell)

-- Tab Switching
TPTabBtn.MouseButton1Click:Connect(function()
    TPContent.Visible = true
    MSLoopContent.Visible = false
    AutoBuyContent.Visible = false
    MSSafetyContent.Visible = false
    AutoSellContent.Visible = false
    clearSubButtons()
    
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoSellTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    
    TPTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    MSLoopTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoBuyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSSafetyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoSellTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
end)

MSLoopTabBtn.MouseButton1Click:Connect(function()
    TPContent.Visible = false
    MSLoopContent.Visible = true
    AutoBuyContent.Visible = false
    MSSafetyContent.Visible = false
    AutoSellContent.Visible = false
    clearSubButtons()
    
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoSellTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    
    TPTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSLoopTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AutoBuyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSSafetyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoSellTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    updateBuyIndicators()
end)

AutoBuyTabBtn.MouseButton1Click:Connect(function()
    TPContent.Visible = false
    MSLoopContent.Visible = false
    AutoBuyContent.Visible = true
    MSSafetyContent.Visible = false
    AutoSellContent.Visible = false
    clearSubButtons()
    
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoSellTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    
    TPTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSLoopTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoBuyTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    MSSafetyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoSellTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    updateBuyIndicators()
end)

MSSafetyTabBtn.MouseButton1Click:Connect(function()
    TPContent.Visible = false
    MSLoopContent.Visible = false
    AutoBuyContent.Visible = false
    MSSafetyContent.Visible = true
    AutoSellContent.Visible = false
    clearSubButtons()
    
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    AutoSellTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    
    TPTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSLoopTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoBuyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSSafetyTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AutoSellTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
end)

AutoSellTabBtn.MouseButton1Click:Connect(function()
    TPContent.Visible = false
    MSLoopContent.Visible = false
    AutoBuyContent.Visible = false
    MSSafetyContent.Visible = false
    AutoSellContent.Visible = true
    clearSubButtons()
    
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoSellTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    
    TPTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSLoopTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoBuyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSSafetyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoSellTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    
    AutoSellInfo.Text = "Tools: " .. #getSellTools()
end)

-- Minimize
local minimized = false
local openSize = UDim2.new(0,GUI_WIDTH,0,GUI_HEIGHT)
local closedSize = UDim2.new(0,GUI_WIDTH,0,TITLE_HEIGHT + 4)
local tweenInfo = TweenInfo.new(0.3)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TPContent.Visible = false
        MSLoopContent.Visible = false
        AutoBuyContent.Visible = false
        MSSafetyContent.Visible = false
        AutoSellContent.Visible = false
        TabFrame.Visible = false
        MinBtn.Text = "□"
        TweenService:Create(Frame, tweenInfo, {Size = closedSize}):Play()
    else
        TweenService:Create(Frame, tweenInfo, {Size = openSize}):Play()
        task.wait(0.3)
        TPContent.Visible = true
        TabFrame.Visible = true
        MinBtn.Text = "−"
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Z then
        minimized = not minimized
        if minimized then
            TPContent.Visible = false
            MSLoopContent.Visible = false
            AutoBuyContent.Visible = false
            MSSafetyContent.Visible = false
            AutoSellContent.Visible = false
            TabFrame.Visible = false
            MinBtn.Text = "□"
            TweenService:Create(Frame, tweenInfo, {Size = closedSize}):Play()
        else
            TweenService:Create(Frame, tweenInfo, {Size = openSize}):Play()
            task.wait(0.3)
            TPContent.Visible = true
            TabFrame.Visible = true
            MinBtn.Text = "−"
        end
    end
end)

-- Initial Animation
Frame.Size = UDim2.new(0,0,0,0)
task.wait(0.1)
TweenService:Create(Frame, tweenInfo, {Size = openSize}):Play()

-- Initial update
task.wait(1)
updateBuyIndicators()
setBuyAmount(10)

-- Auto refresh status
task.spawn(function()
    while true do
        task.wait(0.5)
        if isVehicleFrozen then
            VehicleFreezeStatus.Text = "🚗 VEHICLE FREEZE: ACTIVE"
            VehicleFreezeStatus.TextColor3 = Color3.fromRGB(255,100,100)
        else
            VehicleFreezeStatus.Text = "🚗 VEHICLE FREEZE: INACTIVE"
            VehicleFreezeStatus.TextColor3 = Color3.fromRGB(100,255,100)
        end
    end
end)

-- Auto refresh
task.spawn(function()
    while true do
        task.wait(2)
        if MSLoopContent.Visible or AutoBuyContent.Visible then
            updateBuyIndicators()
        end
        if AutoSellContent.Visible then
            AutoSellInfo.Text = "Tools: " .. #getSellTools()
        end
    end
end)

-- Notifikasi custom respawn aktif
task.wait(2)
local notif = Instance.new("TextLabel")
notif.Parent = player.PlayerGui
notif.Size = UDim2.new(0, 260, 0, 35)
notif.Position = UDim2.new(1, -270, 1, -45)
notif.BackgroundColor3 = Color3.fromRGB(30,30,40)
notif.Text = "MPRUY LU"
notif.TextColor3 = Color3.fromRGB(100,255,100)
notif.TextSize = 12
notif.Font = Enum.Font.GothamBold
local notifCorner = Instance.new("UICorner")
notifCorner.Parent = notif
notifCorner.CornerRadius = UDim.new(0, 6)
task.wait(3)
notif:Destroy()
