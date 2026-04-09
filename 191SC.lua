local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

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

-- ========== REMOTE EVENTS ==========
local remotes = ReplicatedStorage:FindFirstChild("RemoteEvents")
local storePurchaseRE = remotes and remotes:FindFirstChild("StorePurchase")

-- ========== ANTI AFK ==========
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ========== FUNGSI UMUM ==========
local function holdE(t)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(t)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function equip(name)
    local char = player.Character or player.CharacterAdded:Wait()
    local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
    if tool then
        char.Humanoid:EquipTool(tool)
        task.wait(0.3)
        return true
    end
    return false
end

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

-- ========== TELEPORT FUNCTIONS ==========
local function moveVehicle(vehicle, targetCFrame)
    local anchor = vehicle.PrimaryPart or vehicle:FindFirstChildOfClass("VehicleSeat") or vehicle:FindFirstChildOfClass("BasePart")
    if not anchor then return end
    
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

local function teleportToNPC()
    local character = player.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not hum then return end
    
    local seatPart = hum.SeatPart
    if seatPart then
        local vehicle = seatPart:FindFirstAncestorOfClass("Model")
        if vehicle then
            moveVehicle(vehicle, CFrame.new(510.762817, 3.58721066, 600.791504))
        end
    else
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(510.762817, 3.58721066, 600.791504)
        end
    end
end

-- ========== FREEZE KENDARAAN ==========
local isVehicleFrozen = false
local frozenVehicle = nil
local frozenCFrame = nil
local frozenParts = {}
local freezeConnection = nil

local function stopVehicleFreeze()
    if freezeConnection then
        freezeConnection:Disconnect()
        freezeConnection = nil
    end
    for _, part in ipairs(frozenParts) do
        if part and part.Parent then
            part.Anchored = false
        end
    end
    frozenParts = {}
    isVehicleFrozen = false
    frozenVehicle = nil
    frozenCFrame = nil
end

local function startVehicleFreeze(vehicle, cframe)
    stopVehicleFreeze()
    frozenVehicle = vehicle
    frozenCFrame = cframe
    
    for _, part in ipairs(vehicle:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored then
            table.insert(frozenParts, part)
            part.Anchored = true
            pcall(function()
                part.AssemblyLinearVelocity = Vector3.zero
                part.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end
    
    freezeConnection = RunService.Heartbeat:Connect(function()
        if frozenVehicle and frozenVehicle.Parent and frozenCFrame then
            if frozenVehicle.PrimaryPart then
                frozenVehicle:SetPrimaryPartCFrame(frozenCFrame)
            else
                local anchor = frozenVehicle:FindFirstChildOfClass("VehicleSeat") or frozenVehicle:FindFirstChildOfClass("BasePart")
                if anchor then
                    anchor.CFrame = frozenCFrame
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

-- ========== AUTO MS LOOP ==========
local loopRunning = false
local statusLabel = nil

local function startMSLoop()
    if loopRunning then return end
    
    loopRunning = true
    if statusLabel then statusLabel.Text = "Status: RUNNING" end
    
    task.spawn(function()
        while loopRunning do
            -- Step 1: Water
            local waterTool = findTool("water")
            if waterTool and equip("Water") then
                holdE(0.7)
                task.wait(20)
            else
                if statusLabel then statusLabel.Text = "ERROR: Water not found!" end
                break
            end
            
            task.wait(3)
            if not loopRunning then break end
            
            -- Step 2: Sugar
            local sugarTool = findTool("sugar")
            if sugarTool and equip("Sugar Block Bag") then
                holdE(0.7)
                task.wait(1)
            else
                if statusLabel then statusLabel.Text = "ERROR: Sugar not found!" end
                break
            end
            
            task.wait(0.5)
            if not loopRunning then break end
            
            -- Step 3: Gelatin
            local gelatinTool = findTool("gelatin")
            if gelatinTool and equip("Gelatin") then
                holdE(0.7)
                task.wait(1)
            else
                if statusLabel then statusLabel.Text = "ERROR: Gelatin not found!" end
                break
            end
            
            task.wait(3)
            if not loopRunning then break end
            
            -- Step 4: Collect
            if equip("Empty Bag") then
                holdE(0.7)
                task.wait(1)
            else
                if statusLabel then statusLabel.Text = "ERROR: Empty Bag not found!" end
                break
            end
            
            task.wait(1)
        end
        
        loopRunning = false
        if statusLabel then statusLabel.Text = "Status: STOPPED" end
    end)
end

local function stopMSLoop()
    loopRunning = false
    if statusLabel then statusLabel.Text = "Status: STOPPED" end
end

-- ========== AUTO SELL ==========
local autoSellEnabled = false
local sellBtn = nil

local function countBag(bagName)
    local count = 0
    if player.Character then
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("Tool") and child.Name == bagName then
                count = count + 1
            end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") and child.Name == bagName then
                count = count + 1
            end
        end
    end
    return count
end

local function autoSell()
    local bags = {
        "Small Marshmallow Bag",
        "Medium Marshmallow Bag",
        "Large Marshmallow Bag"
    }
    
    for _, bag in pairs(bags) do
        while countBag(bag) > 0 and autoSellEnabled do
            if equip(bag) then
                holdE(0.7)
                task.wait(1)
            else
                break
            end
        end
    end
end

local function startAutoSell()
    autoSellEnabled = true
    if sellBtn then sellBtn.Text = "AUTO SELL : ON" end
    task.spawn(function()
        while autoSellEnabled do
            autoSell()
            task.wait(2)
        end
    end)
end

local function stopAutoSell()
    autoSellEnabled = false
    if sellBtn then sellBtn.Text = "AUTO SELL : OFF" end
end

-- ========== AUTO BUY ==========
local autoBuyRunning = false
local currentBuyAmount = 10
local buyBtn = nil

local function startAutoBuy()
    if autoBuyRunning then return end
    if not storePurchaseRE then return end
    
    autoBuyRunning = true
    if buyBtn then buyBtn.Text = "AUTO BUY : ON" end
    
    local BUY_ITEMS = {
        {name = "Water", display = "Water"},
        {name = "Sugar Block Bag", display = "Sugar"},
        {name = "Gelatin", display = "Gelatin"}
    }
    
    task.spawn(function()
        local amount = currentBuyAmount
        
        for _, item in ipairs(BUY_ITEMS) do
            if not autoBuyRunning then break end
            
            for i = 1, amount do
                if not autoBuyRunning then break end
                pcall(function()
                    storePurchaseRE:FireServer(item.name, 1)
                end)
                task.wait(0.5)
            end
            task.wait(0.8)
        end
        
        autoBuyRunning = false
        if buyBtn then buyBtn.Text = "AUTO BUY : OFF" end
    end)
end

local function stopAutoBuy()
    autoBuyRunning = false
    if buyBtn then buyBtn.Text = "AUTO BUY : OFF" end
end

-- ========== BLINK (KEY T) ==========
local blinkEnabled = false
local blinkBtn = nil

local function toggleBlink()
    blinkEnabled = not blinkEnabled
    if blinkBtn then blinkBtn.Text = blinkEnabled and "BLINK : ON (T)" or "BLINK : OFF (T)" end
end

local function blinkMaju()
    if not blinkEnabled then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 5
    end
end

-- Keybind T untuk blink
ContextActionService:BindAction(
    "BlinkForward",
    function(_, state)
        if state == Enum.UserInputState.Begin and blinkEnabled then
            blinkMaju()
        end
    end,
    false,
    Enum.KeyCode.T
)

-- ========== GUI ==========
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ELIXIRSTORE"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 380)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(80, 150, 255)
stroke.Thickness = 1.5

-- Title Bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.BorderSizePixel = 0

local titleBarCorner = Instance.new("UICorner", titleBar)
titleBarCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -60, 0, 20)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "ELIXIRSTORE"
title.TextColor3 = Color3.fromRGB(230, 200, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- Credit Label
local creditLabel = Instance.new("TextLabel", titleBar)
creditLabel.Size = UDim2.new(1, -60, 0, 14)
creditLabel.Position = UDim2.new(0, 10, 0, 22)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "SCRIPTER - jee | BIG SUPPORT - GEN x 191"
creditLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
creditLabel.TextXAlignment = Enum.TextXAlignment.Left
creditLabel.Font = Enum.Font.Gotham
creditLabel.TextSize = 8

-- Close Button
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    loopRunning = false
    autoSellEnabled = false
    autoBuyRunning = false
    gui:Destroy()
end)

-- Tab Buttons
local tabFrame = Instance.new("Frame", frame)
tabFrame.Position = UDim2.new(0, 0, 0, 32)
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.BackgroundTransparency = 1

local function createTab(name, xPos)
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(0, 100, 0, 24)
    btn.Position = UDim2.new(0, xPos, 0, 3)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    return btn
end

local farmTab = createTab("AUTO MS", 10)
local buyTab = createTab("AUTO BUY", 115)
local sellTab = createTab("AUTO SELL", 215)

-- Containers
local farmContainer = Instance.new("ScrollingFrame", frame)
farmContainer.Position = UDim2.new(0, 8, 0, 65)
farmContainer.Size = UDim2.new(1, -16, 1, -75)
farmContainer.BackgroundTransparency = 1
farmContainer.ScrollBarThickness = 3

local buyContainer = Instance.new("ScrollingFrame", frame)
buyContainer.Position = farmContainer.Position
buyContainer.Size = farmContainer.Size
buyContainer.BackgroundTransparency = 1
buyContainer.ScrollBarThickness = 3
buyContainer.Visible = false

local sellContainer = Instance.new("ScrollingFrame", frame)
sellContainer.Position = farmContainer.Position
sellContainer.Size = farmContainer.Size
sellContainer.BackgroundTransparency = 1
sellContainer.ScrollBarThickness = 3
sellContainer.Visible = false

-- Layouts
local farmLayout = Instance.new("UIListLayout", farmContainer)
farmLayout.Padding = UDim.new(0, 6)
farmLayout.SortOrder = Enum.SortOrder.LayoutOrder

local buyLayout = Instance.new("UIListLayout", buyContainer)
buyLayout.Padding = UDim.new(0, 6)
buyLayout.SortOrder = Enum.SortOrder.LayoutOrder

local sellLayout = Instance.new("UIListLayout", sellContainer)
sellLayout.Padding = UDim.new(0, 6)
sellLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Update canvas size
farmLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    farmContainer.CanvasSize = UDim2.new(0, 0, 0, farmLayout.AbsoluteContentSize.Y + 10)
end)
buyLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    buyContainer.CanvasSize = UDim2.new(0, 0, 0, buyLayout.AbsoluteContentSize.Y + 10)
end)
sellLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    sellContainer.CanvasSize = UDim2.new(0, 0, 0, sellLayout.AbsoluteContentSize.Y + 10)
end)

-- Tab switching
farmTab.MouseButton1Click:Connect(function()
    farmContainer.Visible = true
    buyContainer.Visible = false
    sellContainer.Visible = false
    farmTab.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    buyTab.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sellTab.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
end)

buyTab.MouseButton1Click:Connect(function()
    farmContainer.Visible = false
    buyContainer.Visible = true
    sellContainer.Visible = false
    farmTab.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    buyTab.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    sellTab.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
end)

sellTab.MouseButton1Click:Connect(function()
    farmContainer.Visible = false
    buyContainer.Visible = false
    sellContainer.Visible = true
    farmTab.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    buyTab.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sellTab.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
end)

-- ========== FARM TAB CONTENT ==========
-- Status Label
statusLabel = Instance.new("TextLabel", farmContainer)
statusLabel.Size = UDim2.new(1, 0, 0, 22)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: STOPPED"
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 12
statusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.LayoutOrder = 1

-- Start/Stop Button
local farmBtn = Instance.new("TextButton", farmContainer)
farmBtn.Size = UDim2.new(1, 0, 0, 28)
farmBtn.Text = "AUTO MS : OFF"
farmBtn.Font = Enum.Font.GothamBold
farmBtn.TextSize = 12
farmBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
local farmBtnCorner = Instance.new("UICorner", farmBtn)
farmBtnCorner.CornerRadius = UDim.new(0, 6)
farmBtn.LayoutOrder = 2

farmBtn.MouseButton1Click:Connect(function()
    if loopRunning then
        stopMSLoop()
        farmBtn.Text = "AUTO MS : OFF"
        farmBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    else
        startMSLoop()
        farmBtn.Text = "AUTO MS : ON"
        farmBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 70)
    end
end)

-- TP NPC Button
local tpBtn = Instance.new("TextButton", farmContainer)
tpBtn.Size = UDim2.new(1, 0, 0, 28)
tpBtn.Text = "TELEPORT NPC"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 12
tpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
local tpBtnCorner = Instance.new("UICorner", tpBtn)
tpBtnCorner.CornerRadius = UDim.new(0, 6)
tpBtn.LayoutOrder = 3

tpBtn.MouseButton1Click:Connect(function()
    teleportToNPC()
end)

-- Blink Toggle Button
blinkBtn = Instance.new("TextButton", farmContainer)
blinkBtn.Size = UDim2.new(1, 0, 0, 28)
blinkBtn.Text = "BLINK : OFF (T)"
blinkBtn.Font = Enum.Font.GothamBold
blinkBtn.TextSize = 12
blinkBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
local blinkBtnCorner = Instance.new("UICorner", blinkBtn)
blinkBtnCorner.CornerRadius = UDim.new(0, 6)
blinkBtn.LayoutOrder = 4

blinkBtn.MouseButton1Click:Connect(function()
    toggleBlink()
    if blinkEnabled then
        blinkBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 70)
    else
        blinkBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end
end)

-- ========== BUY TAB CONTENT ==========
-- Auto Buy Button
buyBtn = Instance.new("TextButton", buyContainer)
buyBtn.Size = UDim2.new(1, 0, 0, 28)
buyBtn.Text = "AUTO BUY : OFF"
buyBtn.Font = Enum.Font.GothamBold
buyBtn.TextSize = 12
buyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
local buyBtnCorner = Instance.new("UICorner", buyBtn)
buyBtnCorner.CornerRadius = UDim.new(0, 6)
buyBtn.LayoutOrder = 1

buyBtn.MouseButton1Click:Connect(function()
    if autoBuyRunning then
        stopAutoBuy()
        buyBtn.Text = "AUTO BUY : OFF"
        buyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    else
        startAutoBuy()
        buyBtn.Text = "AUTO BUY : ON"
        buyBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 70)
    end
end)

-- Jumlah Label
local amountLabel = Instance.new("TextLabel", buyContainer)
amountLabel.Size = UDim2.new(1, 0, 0, 20)
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "Jumlah Beli: 10x"
amountLabel.Font = Enum.Font.GothamBold
amountLabel.TextSize = 11
amountLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
amountLabel.TextXAlignment = Enum.TextXAlignment.Left
amountLabel.LayoutOrder = 2

-- Slider
local sliderBg = Instance.new("Frame", buyContainer)
sliderBg.Size = UDim2.new(1, 0, 0, 6)
sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
local sliderBgCorner = Instance.new("UICorner", sliderBg)
sliderBgCorner.CornerRadius = UDim.new(0, 3)
sliderBg.LayoutOrder = 3

local sliderFill = Instance.new("Frame", sliderBg)
sliderFill.Size = UDim2.new(0.18, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
local sliderFillCorner = Instance.new("UICorner", sliderFill)
sliderFillCorner.CornerRadius = UDim.new(0, 3)

local function setBuyAmount(amount)
    currentBuyAmount = math.clamp(amount, 1, 50)
    amountLabel.Text = "Jumlah Beli: " .. currentBuyAmount .. "x"
    sliderFill.Size = UDim2.new((currentBuyAmount - 1) / 49, 0, 1, 0)
end

local isDragging = false
sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        local mouseX = input.Position.X
        local sliderPos = sliderBg.AbsolutePosition.X
        local sliderW = sliderBg.AbsoluteSize.X
        local percent = math.clamp((mouseX - sliderPos) / sliderW, 0, 1)
        local newAmount = math.floor(1 + percent * 49)
        setBuyAmount(newAmount)
    end
end)

UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
        local mouseX = input.Position.X
        local sliderPos = sliderBg.AbsolutePosition.X
        local sliderW = sliderBg.AbsoluteSize.X
        if mouseX >= sliderPos and mouseX <= sliderPos + sliderW then
            local percent = math.clamp((mouseX - sliderPos) / sliderW, 0, 1)
            local newAmount = math.floor(1 + percent * 49)
            setBuyAmount(newAmount)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- ========== SELL TAB CONTENT ==========
-- Auto Sell Button
sellBtn = Instance.new("TextButton", sellContainer)
sellBtn.Size = UDim2.new(1, 0, 0, 28)
sellBtn.Text = "AUTO SELL : OFF"
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextSize = 12
sellBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
local sellBtnCorner = Instance.new("UICorner", sellBtn)
sellBtnCorner.CornerRadius = UDim.new(0, 6)
sellBtn.LayoutOrder = 1

sellBtn.MouseButton1Click:Connect(function()
    if autoSellEnabled then
        stopAutoSell()
        sellBtn.Text = "AUTO SELL : OFF"
        sellBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    else
        startAutoSell()
        sellBtn.Text = "AUTO SELL : ON"
        sellBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 70)
    end
end)

-- Small Marshmallow
local smallLabel = Instance.new("TextLabel", sellContainer)
smallLabel.Size = UDim2.new(1, 0, 0, 18)
smallLabel.BackgroundTransparency = 1
smallLabel.Text = "Small Marshmallow: 0"
smallLabel.Font = Enum.Font.Gotham
smallLabel.TextSize = 11
smallLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
smallLabel.TextXAlignment = Enum.TextXAlignment.Left
smallLabel.LayoutOrder = 2

-- Medium Marshmallow
local mediumLabel = Instance.new("TextLabel", sellContainer)
mediumLabel.Size = UDim2.new(1, 0, 0, 18)
mediumLabel.BackgroundTransparency = 1
mediumLabel.Text = "Medium Marshmallow: 0"
mediumLabel.Font = Enum.Font.Gotham
mediumLabel.TextSize = 11
mediumLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
mediumLabel.TextXAlignment = Enum.TextXAlignment.Left
mediumLabel.LayoutOrder = 3

-- Large Marshmallow
local largeLabel = Instance.new("TextLabel", sellContainer)
largeLabel.Size = UDim2.new(1, 0, 0, 18)
largeLabel.BackgroundTransparency = 1
largeLabel.Text = "Large Marshmallow: 0"
largeLabel.Font = Enum.Font.Gotham
largeLabel.TextSize = 11
largeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
largeLabel.TextXAlignment = Enum.TextXAlignment.Left
largeLabel.LayoutOrder = 4

-- Total Label
local totalLabelSell = Instance.new("TextLabel", sellContainer)
totalLabelSell.Size = UDim2.new(1, 0, 0, 18)
totalLabelSell.BackgroundTransparency = 1
totalLabelSell.Text = "Total: 0"
totalLabelSell.Font = Enum.Font.GothamBold
totalLabelSell.TextSize = 12
totalLabelSell.TextColor3 = Color3.fromRGB(100, 180, 255)
totalLabelSell.TextXAlignment = Enum.TextXAlignment.Left
totalLabelSell.LayoutOrder = 5

-- ========== COUNTER LOOP ==========
local function findTool(name)
    if player.Character then
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("Tool") and string.find(string.lower(child.Name), string.lower(name)) then
                return child
            end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") and string.find(string.lower(child.Name), string.lower(name)) then
                return child
            end
        end
    end
    return nil
end

task.spawn(function()
    while gui and gui.Parent do
        -- Update sell tab
        local small = countBag("Small Marshmallow Bag")
        local medium = countBag("Medium Marshmallow Bag")
        local large = countBag("Large Marshmallow Bag")
        local total = small + medium + large
        
        smallLabel.Text = "Small Marshmallow: " .. small
        mediumLabel.Text = "Medium Marshmallow: " .. medium
        largeLabel.Text = "Large Marshmallow: " .. large
        totalLabelSell.Text = "Total: " .. total
        
        task.wait(0.5)
    end
end)

-- ========== INITIAL SETUP ==========
setBuyAmount(10)

-- Keybind P untuk toggle GUI
ContextActionService:BindAction(
    "ToggleGUI",
    function(_, state)
        if state == Enum.UserInputState.Begin then
            frame.Visible = not frame.Visible
        end
    end,
    false,
    Enum.KeyCode.P
)

-- Animasi awal
frame.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.1)
TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 320, 0, 380)}):Play()
