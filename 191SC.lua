-- FULLY_NV - APART CASINO (STANDALONE, PASTI MUNCUL)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

repeat task.wait() until player.Character
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "FULLY_NV"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 450, 0, 550)
main.Position = UDim2.new(0.5, -225, 0.5, -275)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local title = Instance.new("Frame", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
title.Position = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local titleLbl = Instance.new("TextLabel", title)
titleLbl.Size = UDim2.new(1, -50, 1, 0)
titleLbl.Position = UDim2.new(0, 15, 0, 0)
titleLbl.Text = "FULLY NV - APART CASINO"
titleLbl.TextColor3 = Color3.new(1, 1, 1)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 16
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", title)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Scroll
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, 0, 1, -45)
scroll.Position = UDim2.new(0, 0, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.ScrollBarThickness = 4

local pad = Instance.new("UIPadding", scroll)
pad.PaddingLeft = UDim.new(0, 15)
pad.PaddingRight = UDim.new(0, 15)
pad.PaddingTop = UDim.new(0, 15)
pad.PaddingBottom = UDim.new(0, 15)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 12)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================================
-- HELPER FUNGSI
-- ============================================================
local function notify(msg, color)
    local notif = Instance.new("TextLabel", gui)
    notif.Size = UDim2.new(0, 250, 0, 30)
    notif.Position = UDim2.new(0.5, -125, 1, -50)
    notif.Text = msg
    notif.TextColor3 = Color3.new(1, 1, 1)
    notif.BackgroundColor3 = color or Color3.fromRGB(30, 30, 60)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 12
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -125, 1, -80)}):Play()
    task.delay(2, function() notif:Destroy() end)
end

local function goDown()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local tw = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 6, hrp.Position.Z)})
        tw:Play()
        tw.Completed:Wait()
    end
end

local function goUp()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local tw = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y + 6, hrp.Position.Z)})
        tw:Play()
        tw.Completed:Wait()
    end
end

local function slowTween(cf)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local tw = TweenService:Create(hrp, TweenInfo.new(2.0, Enum.EasingStyle.Linear), {CFrame = cf})
        tw:Play()
        tw.Completed:Wait()
    end
end

local function spamE()
    for i = 1, 3 do
        vim:SendKeyEvent(true, "E", false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, "E", false, game)
        task.wait(0.1)
    end
end

local function blink(cf)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cf end
end

local function teleportTo(pos)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(pos) end
end

local function buyMaterials(qty)
    for i = 1, qty do
        buyRemote:FireServer("Water")
        task.wait(0.15)
        buyRemote:FireServer("Sugar Block Bag")
        task.wait(0.15)
        buyRemote:FireServer("Gelatin")
        task.wait(0.15)
        buyRemote:FireServer("Empty Bag")
        task.wait(0.2)
    end
    notify("Beli " .. qty .. " set selesai", Color3.fromRGB(50, 200, 100))
end

local function countItem(name)
    local total = 0
    for _, v in pairs(player.Backpack:GetChildren()) do if v.Name == name then total = total + 1 end end
    for _, v in pairs(player.Character:GetChildren()) do if v:IsA("Tool") and v.Name == name then total = total + 1 end end
    return total
end

local function equipTool(name)
    local tool = player.Backpack:FindFirstChild(name) or player.Character:FindFirstChild(name)
    if tool and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:EquipTool(tool)
        task.wait(0.3)
        return true
    end
    return false
end

local function sellAllMS()
    local bags = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
    for _, bag in pairs(bags) do
        while countItem(bag) > 0 do
            if equipTool(bag) then
                vim:SendKeyEvent(true, "E", false, game)
                task.wait(0.8)
                vim:SendKeyEvent(false, "E", false, game)
                task.wait(0.3)
            else
                break
            end
        end
    end
    notify("Penjualan MS selesai", Color3.fromRGB(50, 200, 100))
end

-- ============================================================
-- KOORDINAT
-- ============================================================
local npcDealerPos = Vector3.new(510.762817, 3.5872, 600.791504)

-- Apart Casino 1
local a1 = {
    CFrame.new(1196.51, 3.71, -241.13),
    CFrame.new(1199.75, 3.71, -238.12),
    CFrame.new(1199.74, 6.59, -233.05),
    CFrame.new(1199.66, 6.59, -227.75),
    CFrame.new(1199.66, 6.59, -227.75),
    CFrame.new(1199.91, 7.56, -219.75),
    CFrame.new(1199.87, 15.96, -215.33),
}

-- ============================================================
-- VARIABEL
-- ============================================================
local running = false
local buyQty = 5

-- ============================================================
-- UI ELEMENTS
-- ============================================================
local function card(parent, h)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, h)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    return f
end

-- Slider jumlah beli
local sliderCard = card(scroll, 70)
local sliderLbl = Instance.new("TextLabel", sliderCard)
sliderLbl.Size = UDim2.new(1, -20, 0, 25)
sliderLbl.Position = UDim2.new(0, 10, 0, 5)
sliderLbl.Text = "Jumlah Beli Bahan: " .. buyQty
sliderLbl.TextColor3 = Color3.new(1, 1, 1)
sliderLbl.BackgroundTransparency = 1
sliderLbl.Font = Enum.Font.GothamBold
sliderLbl.TextSize = 12
sliderLbl.TextXAlignment = Enum.TextXAlignment.Left

local minus = Instance.new("TextButton", sliderCard)
minus.Size = UDim2.new(0, 35, 0, 30)
minus.Position = UDim2.new(0, 10, 0, 35)
minus.Text = "-"
minus.TextColor3 = Color3.new(1, 1, 1)
minus.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
minus.Font = Enum.Font.GothamBold
minus.TextSize = 18
Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 6)

local plus = Instance.new("TextButton", sliderCard)
plus.Size = UDim2.new(0, 35, 0, 30)
plus.Position = UDim2.new(1, -45, 0, 35)
plus.Text = "+"
plus.TextColor3 = Color3.new(1, 1, 1)
plus.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
plus.Font = Enum.Font.GothamBold
plus.TextSize = 18
Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 6)

minus.MouseButton1Click:Connect(function()
    buyQty = math.max(1, buyQty - 1)
    sliderLbl.Text = "Jumlah Beli Bahan: " .. buyQty
end)
plus.MouseButton1Click:Connect(function()
    buyQty = math.min(20, buyQty + 1)
    sliderLbl.Text = "Jumlah Beli Bahan: " .. buyQty
end)

-- Dropdown Apart
local apartCard = card(scroll, 70)
local apartLbl = Instance.new("TextLabel", apartCard)
apartLbl.Size = UDim2.new(1, -20, 0, 25)
apartLbl.Position = UDim2.new(0, 10, 0, 5)
apartLbl.Text = "Pilih Apartemen"
apartLbl.TextColor3 = Color3.new(1, 1, 1)
apartLbl.BackgroundTransparency = 1
apartLbl.Font = Enum.Font.GothamBold
apartLbl.TextSize = 12
apartLbl.TextXAlignment = Enum.TextXAlignment.Left

local apartValue = "APART CASINO 1"
local apartBtn = Instance.new("TextButton", apartCard)
apartBtn.Size = UDim2.new(0.8, 0, 0, 32)
apartBtn.Position = UDim2.new(0.1, 0, 0, 32)
apartBtn.Text = apartValue
apartBtn.TextColor3 = Color3.new(1, 1, 1)
apartBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 180)
apartBtn.Font = Enum.Font.GothamBold
apartBtn.TextSize = 12
Instance.new("UICorner", apartBtn).CornerRadius = UDim.new(0, 8)

local apartMenu = nil
apartBtn.MouseButton1Click:Connect(function()
    if apartMenu then apartMenu:Destroy() end
    apartMenu = Instance.new("Frame", scroll)
    apartMenu.Size = UDim2.new(0.6, 0, 0, 120)
    apartMenu.Position = UDim2.new(0, apartBtn.AbsolutePosition.X + 20, apartBtn.AbsolutePosition.Y + 50)
    apartMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    Instance.new("UICorner", apartMenu).CornerRadius = UDim.new(0, 8)
    local opts = {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}
    for i, opt in ipairs(opts) do
        local btn = Instance.new("TextButton", apartMenu)
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, (i-1)*30)
        btn.Text = opt
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            apartValue = opt
            apartBtn.Text = apartValue
            apartMenu:Destroy()
            apartMenu = nil
        end)
    end
    task.delay(5, function() if apartMenu then apartMenu:Destroy() end end)
end)

-- START/STOP BUTTON
local btnCard = card(scroll, 80)
local startBtn = Instance.new("TextButton", btnCard)
startBtn.Size = UDim2.new(0.45, -5, 0, 40)
startBtn.Position = UDim2.new(0, 10, 0.5, -20)
startBtn.Text = "▶ START FULLY"
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", btnCard)
stopBtn.Size = UDim2.new(0.45, -5, 0, 40)
stopBtn.Position = UDim2.new(0.55, 5, 0.5, -20)
stopBtn.Text = "■ STOP FULLY"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

local statusCard = card(scroll, 50)
local statusLbl = Instance.new("TextLabel", statusCard)
statusLbl.Size = UDim2.new(1, -20, 1, 0)
statusLbl.Position = UDim2.new(0, 10, 0, 0)
statusLbl.Text = "Status: Siap"
statusLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
statusLbl.BackgroundTransparency = 1
statusLbl.Font = Enum.Font.GothamBold
statusLbl.TextSize = 12

-- ============================================================
-- FUNGSI UTAMA
-- ============================================================
local function runFully()
    running = true
    startBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    startBtn.Text = "RUNNING..."
    statusLbl.Text = "Status: Running - " .. apartValue
    statusLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    -- Beli bahan
    statusLbl.Text = "Status: Pergi ke NPC..."
    teleportTo(npcDealerPos)
    task.wait(0.5)
    goDown()
    buyMaterials(buyQty)
    goUp()
    
    -- Ke apart
    statusLbl.Text = "Status: Ke Apart..."
    teleportTo(Vector3.new(1196.51, 3.71, -241.13))
    task.wait(0.5)
    goDown()
    slowTween(CFrame.new(1196.51, 3.71, -241.13))
    goUp()
    
    -- Tahapan
    for idx, cf in ipairs(a1) do
        if not running then break end
        statusLbl.Text = "Status: Tahap " .. idx .. "/" .. #a1
        goDown()
        local oldPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local oldVec = oldPos and oldPos.Position or Vector3.zero
        slowTween(cf)
        task.wait(0.1)
        local newPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if newPos and (newPos.Position - oldVec).Magnitude < 2 then
            blink(cf)
        end
        goUp()
        spamE()
        task.wait(0.2)
    end
    
    -- Masak (sederhana)
    statusLbl.Text = "Status: Memasak..."
    if equipTool("Water") then
        vim:SendKeyEvent(true, "E", false, game)
        task.wait(0.5)
        vim:SendKeyEvent(false, "E", false, game)
        task.wait(20)
    end
    if equipTool("Sugar Block Bag") then
        vim:SendKeyEvent(true, "E", false, game)
        task.wait(0.5)
        vim:SendKeyEvent(false, "E", false, game)
        task.wait(1)
    end
    if equipTool("Gelatin") then
        vim:SendKeyEvent(true, "E", false, game)
        task.wait(0.5)
        vim:SendKeyEvent(false, "E", false, game)
        task.wait(1)
    end
    task.wait(45)
    if equipTool("Empty Bag") then
        vim:SendKeyEvent(true, "E", false, game)
        task.wait(0.5)
        vim:SendKeyEvent(false, "E", false, game)
        task.wait(1)
    end
    
    -- Jual
    statusLbl.Text = "Status: Menjual..."
    teleportTo(npcDealerPos)
    task.wait(0.5)
    goDown()
    sellAllMS()
    goUp()
    
    running = false
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    startBtn.Text = "▶ START FULLY"
    statusLbl.Text = "Status: Selesai"
    statusLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    notify("Fully NV Selesai!", Color3.fromRGB(50, 200, 100))
end

startBtn.MouseButton1Click:Connect(function()
    if running then
        notify("Masih berjalan!", Color3.fromRGB(200, 50, 50))
        return
    end
    task.spawn(runFully)
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    startBtn.Text = "▶ START FULLY"
    statusLbl.Text = "Status: Dihentikan"
    statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
    notify("Dihentikan!", Color3.fromRGB(200, 50, 50))
end)

-- Drag
local dragStart, startPos, dragging = nil, nil, false
title.InputBegan:Connect(function(i)
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

print("✅ FULLY_NV LOADED (STANDALONE)")
notify("Fully NV siap digunakan!", Color3.fromRGB(100, 100, 255))
