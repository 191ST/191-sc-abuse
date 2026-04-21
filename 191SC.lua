--[[
    PURCHASE ITEM EXPLOIT
    Mencoba mem-fire RemoteEvent PurchaseItem dengan berbagai parameter
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not remoteEvents then
    warn("RemoteEvents not found!")
    return
end

local purchaseItem = remoteEvents:FindFirstChild("PurchaseItem")
local storePurchase = remoteEvents:FindFirstChild("StorePurchase")
local moneyTransfer = remoteEvents:FindFirstChild("MoneyTransfer")

-- GUI Sederhana
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExploitGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "💰 PURCHASE EXPLOIT 💰"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Tombol PurchaseItem
local purchaseBtn = Instance.new("TextButton")
purchaseBtn.Size = UDim2.new(0.9, 0, 0, 40)
purchaseBtn.Position = UDim2.new(0.05, 0, 0, 45)
purchaseBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
purchaseBtn.Text = "💸 PURCHASE ITEM"
purchaseBtn.TextColor3 = Color3.fromRGB(255,255,255)
purchaseBtn.TextSize = 12
purchaseBtn.Font = Enum.Font.GothamBold
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = purchaseBtn
purchaseBtn.Parent = mainFrame

-- Tombol StorePurchase
local storeBtn = Instance.new("TextButton")
storeBtn.Size = UDim2.new(0.9, 0, 0, 40)
storeBtn.Position = UDim2.new(0.05, 0, 0, 95)
storeBtn.BackgroundColor3 = Color3.fromRGB(180, 80, 40)
storeBtn.Text = "🏪 STORE PURCHASE"
storeBtn.TextColor3 = Color3.fromRGB(255,255,255)
storeBtn.TextSize = 12
storeBtn.Font = Enum.Font.GothamBold
local storeCorner = Instance.new("UICorner")
storeCorner.CornerRadius = UDim.new(0, 8)
storeCorner.Parent = storeBtn
storeBtn.Parent = mainFrame

-- Tombol MoneyTransfer
local moneyBtn = Instance.new("TextButton")
moneyBtn.Size = UDim2.new(0.9, 0, 0, 40)
moneyBtn.Position = UDim2.new(0.05, 0, 0, 145)
moneyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
moneyBtn.Text = "💵 MONEY TRANSFER"
moneyBtn.TextColor3 = Color3.fromRGB(255,255,255)
moneyBtn.TextSize = 12
moneyBtn.Font = Enum.Font.GothamBold
local moneyCorner = Instance.new("UICorner")
moneyCorner.CornerRadius = UDim.new(0, 8)
moneyCorner.Parent = moneyBtn
moneyBtn.Parent = mainFrame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 1, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.fromRGB(150,150,150)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,100,100)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Draggable
local dragStart, startPos, dragging = nil, nil, false
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Fungsi Fire Remote dengan berbagai parameter
local function fireRemote(remote, ...)
    if not remote then
        statusLabel.Text = "ERROR: Remote not found!"
        statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        return false
    end
    
    local args = {...}
    local success, err = pcall(function()
        remote:FireServer(unpack(args))
    end)
    
    if success then
        statusLabel.Text = "Fired: " .. remote.Name .. " with " .. #args .. " args"
        statusLabel.TextColor3 = Color3.fromRGB(100,255,100)
        return true
    else
        statusLabel.Text = "Failed: " .. tostring(err)
        statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        return false
    end
end

-- PurchaseItem - coba berbagai format parameter
purchaseBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Trying PurchaseItem..."
    statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
    
    -- Coba berbagai format parameter
    local attempts = {
        {"G17 Dual Laser Drum", 10},
        {"G17 Dual Laser Drum", 1},
        {"G17 Dual Laser Drum"},
        {1, "G17 Dual Laser Drum"},
        {1234567890}, -- ID item
        {ItemName = "G17 Dual Laser Drum", Price = 10},
        {["ItemName"] = "G17 Dual Laser Drum"},
        {"Purchase", "G17 Dual Laser Drum", 10},
    }
    
    for i, args in pairs(attempts) do
        task.wait(0.2)
        fireRemote(purchaseItem, unpack(args))
    end
end)

-- StorePurchase
storeBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Trying StorePurchase..."
    statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
    
    local attempts = {
        {"G17 Dual Laser Drum", 10},
        {"G17 Dual Laser Drum", 1},
        {1, 10},
        {productId = 1234567890},
    }
    
    for _, args in pairs(attempts) do
        task.wait(0.2)
        fireRemote(storePurchase, unpack(args))
    end
end)

-- MoneyTransfer
moneyBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Trying MoneyTransfer..."
    statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
    
    local targetPlayer = LP.Name
    local attempts = {
        {targetPlayer, 9999999},
        {LP.UserId, 9999999},
        {"All", 9999999},
        {targetPlayer, 999999999},
        {LP, 9999999},
    }
    
    for _, args in pairs(attempts) do
        task.wait(0.2)
        fireRemote(moneyTransfer, unpack(args))
    end
end)

print("Purchase Exploit GUI Loaded")
print("Target Remotes: PurchaseItem, StorePurchase, MoneyTransfer")
