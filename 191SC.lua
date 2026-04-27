-- FULLY NV MINIMAL (PASTI MUNCUL)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

repeat task.wait() until player.Character

local playerGui = player:WaitForChild("PlayerGui")

-- BUAT GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FullyNV_Minimal"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 350, 0, 300)
main.Position = UDim2.new(0.5, -175, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Text = "FULLY NV - APART CASINO"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- CLOSE BUTTON
local close = Instance.new("TextButton", title)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0.5, -15)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- DROPDOWN APART
local apartBtn = Instance.new("TextButton", main)
apartBtn.Size = UDim2.new(0.8, 0, 0, 40)
apartBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
apartBtn.Text = "APART CASINO 1"
apartBtn.TextColor3 = Color3.new(1, 1, 1)
apartBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
apartBtn.Font = Enum.Font.GothamBold
apartBtn.TextSize = 12
Instance.new("UICorner", apartBtn).CornerRadius = UDim.new(0, 8)

-- MENU APART
local apartValue = "APART CASINO 1"
local apartMenu = nil
apartBtn.MouseButton1Click:Connect(function()
    if apartMenu then apartMenu:Destroy() end
    apartMenu = Instance.new("Frame", main)
    apartMenu.Size = UDim2.new(0.6, 0, 0, 120)
    apartMenu.Position = UDim2.new(0.2, 0, 0.3, 0)
    apartMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    Instance.new("UICorner", apartMenu).CornerRadius = UDim.new(0, 8)
    
    local opts = {"APART CASINO 1", "APART CASINO 2", "APART CASINO 3", "APART CASINO 4"}
    for i, opt in ipairs(opts) do
        local btn = Instance.new("TextButton", apartMenu)
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, (i-1)*30)
        btn.Text = opt
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
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

-- START BUTTON
local startBtn = Instance.new("TextButton", main)
startBtn.Size = UDim2.new(0.8, 0, 0, 45)
startBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
startBtn.Text = "▶ START FULLY"
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

-- STOP BUTTON
local stopBtn = Instance.new("TextButton", main)
stopBtn.Size = UDim2.new(0.8, 0, 0, 40)
stopBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
stopBtn.Text = "■ STOP FULLY"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

-- STATUS
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(0.9, 0, 0, 30)
status.Position = UDim2.new(0.05, 0, 0.85, 0)
status.Text = "Status: Siap"
status.TextColor3 = Color3.fromRGB(180, 180, 220)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 11

-- KOORDINAT (APART 1 SAJA DULU BIAR SIMPLE)
local tahap1 = CFrame.new(1196.51, 3.71, -241.13)
local tahap2 = CFrame.new(1199.75, 3.71, -238.12)
local tahap3 = CFrame.new(1199.74, 6.59, -233.05)
local tahap4 = CFrame.new(1199.66, 6.59, -227.75)
local tahap5 = CFrame.new(1199.66, 6.59, -227.75)
local tahap6 = CFrame.new(1199.91, 7.56, -219.75)
local tahap7 = CFrame.new(1199.87, 15.96, -215.33)

local stages = {tahap1, tahap2, tahap3, tahap4, tahap5, tahap6, tahap7}

-- FUNGSI
local function spamE()
    for i = 1, 3 do
        vim:SendKeyEvent(true, "E", false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, "E", false, game)
        task.wait(0.1)
    end
end

local function slowTween(cf)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local tw = TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame = cf})
        tw:Play()
        tw.Completed:Wait()
    end
end

local running = false

local function run()
    running = true
    startBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    startBtn.Text = "RUNNING..."
    stopBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
    status.Text = "Status: Running - " .. apartValue
    status.TextColor3 = Color3.fromRGB(0, 255, 100)
    
    for i, cf in ipairs(stages) do
        if not running then break end
        status.Text = "Status: Tahap " .. i .. "/" .. #stages
        slowTween(cf)
        spamE()
        task.wait(0.2)
    end
    
    running = false
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    startBtn.Text = "▶ START FULLY"
    stopBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    status.Text = "Status: Selesai"
    status.TextColor3 = Color3.fromRGB(180, 180, 220)
end

startBtn.MouseButton1Click:Connect(function()
    if running then return end
    task.spawn(run)
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    startBtn.Text = "▶ START FULLY"
    status.Text = "Status: Dihentikan"
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
end)

-- DRAG
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

print("✅ FULLY NV MINIMAL LOADED")
