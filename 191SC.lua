-- SIMPLE 191 STORE + MACRO F
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local playerGui = player:WaitForChild("PlayerGui")

-- ========== MACRO F ==========
local macroEnabled = false
local holding = false
local interval = 0.3

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and macroEnabled then
        holding = true
        task.spawn(function()
            while holding and macroEnabled do
                pcall(function()
                    VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    task.wait(0.05)
                    VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                end)
                task.wait(interval)
            end
        end)
    end
end)

UIS.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        holding = false
    end
end)

-- ========== FUNGSI MASAK ==========
local function holdE()
    VIM:SendKeyEvent(true, "E", false, game)
    task.wait(0.7)
    VIM:SendKeyEvent(false, "E", false, game)
end

local function equip(name)
    local tool = player.Backpack:FindFirstChild(name)
    if tool and player.Character and player.Character.Humanoid then
        player.Character.Humanoid:EquipTool(tool)
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
    if player.Character then
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("Tool") and v.Name == name then total = total + 1 end
        end
    end
    return total
end

-- ========== GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "MainGUI"
gui.Parent = playerGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 350, 0, 450)
main.Position = UDim2.new(0.5, -175, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.Text = "191 STORE"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- Close button
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.BorderSizePixel = 0
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Tab buttons
local tabAuto = Instance.new("TextButton", main)
tabAuto.Size = UDim2.new(0.5, 0, 0, 35)
tabAuto.Position = UDim2.new(0, 0, 0, 40)
tabAuto.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
tabAuto.Text = "AUTO"
tabAuto.Font = Enum.Font.GothamBold
tabAuto.TextSize = 14
tabAuto.TextColor3 = Color3.fromRGB(255, 255, 255)
tabAuto.BorderSizePixel = 0

local tabSetting = Instance.new("TextButton", main)
tabSetting.Size = UDim2.new(0.5, 0, 0, 35)
tabSetting.Position = UDim2.new(0.5, 0, 0, 40)
tabSetting.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
tabSetting.Text = "SETTINGS"
tabSetting.Font = Enum.Font.GothamBold
tabSetting.TextSize = 14
tabSetting.TextColor3 = Color3.fromRGB(180, 180, 200)
tabSetting.BorderSizePixel = 0

-- Content frame
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -20, 1, -95)
content.Position = UDim2.new(0, 10, 0, 80)
content.BackgroundTransparency = 1

-- ========== AUTO PAGE ==========
local autoPage = Instance.new("Frame", content)
autoPage.Size = UDim2.new(1, 0, 1, 0)
autoPage.BackgroundTransparency = 1

local invFrame = Instance.new("Frame", autoPage)
invFrame.Size = UDim2.new(1, 0, 0, 130)
invFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", invFrame).CornerRadius = UDim.new(0, 8)

local invTitle = Instance.new("TextLabel", invFrame)
invTitle.Size = UDim2.new(1, -20, 0, 25)
invTitle.Position = UDim2.new(0, 10, 0, 5)
invTitle.BackgroundTransparency = 1
invTitle.Text = "INVENTORY"
invTitle.Font = Enum.Font.GothamBold
invTitle.TextSize = 12
invTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
invTitle.TextXAlignment = Enum.TextXAlignment.Left

local waterLbl = Instance.new("TextLabel", invFrame)
waterLbl.Size = UDim2.new(1, -20, 0, 20)
waterLbl.Position = UDim2.new(0, 10, 0, 35)
waterLbl.BackgroundTransparency = 1
waterLbl.Text = "💧 Water: 0"
waterLbl.Font = Enum.Font.Gotham
waterLbl.TextSize = 12
waterLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
waterLbl.TextXAlignment = Enum.TextXAlignment.Left

local sugarLbl = Instance.new("TextLabel", invFrame)
sugarLbl.Size = UDim2.new(1, -20, 0, 20)
sugarLbl.Position = UDim2.new(0, 10, 0, 55)
sugarLbl.BackgroundTransparency = 1
sugarLbl.Text = "🧂 Sugar: 0"
sugarLbl.Font = Enum.Font.Gotham
sugarLbl.TextSize = 12
sugarLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
sugarLbl.TextXAlignment = Enum.TextXAlignment.Left

local gelatinLbl = Instance.new("TextLabel", invFrame)
gelatinLbl.Size = UDim2.new(1, -20, 0, 20)
gelatinLbl.Position = UDim2.new(0, 10, 0, 75)
gelatinLbl.BackgroundTransparency = 1
gelatinLbl.Text = "🟡 Gelatin: 0"
gelatinLbl.Font = Enum.Font.Gotham
gelatinLbl.TextSize = 12
gelatinLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
gelatinLbl.TextXAlignment = Enum.TextXAlignment.Left

local emptyLbl = Instance.new("TextLabel", invFrame)
emptyLbl.Size = UDim2.new(1, -20, 0, 20)
emptyLbl.Position = UDim2.new(0, 10, 0, 95)
emptyLbl.BackgroundTransparency = 1
emptyLbl.Text = "📦 Empty Bag: 0"
emptyLbl.Font = Enum.Font.Gotham
emptyLbl.TextSize = 12
emptyLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
emptyLbl.TextXAlignment = Enum.TextXAlignment.Left

local statusFrame = Instance.new("Frame", autoPage)
statusFrame.Size = UDim2.new(1, 0, 0, 40)
statusFrame.Position = UDim2.new(0, 0, 0, 140)
statusFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 8)

local statusLbl = Instance.new("TextLabel", statusFrame)
statusLbl.Size = UDim2.new(1, -20, 1, 0)
statusLbl.Position = UDim2.new(0, 10, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "⚫ STOPPED"
statusLbl.Font = Enum.Font.GothamBold
statusLbl.TextSize = 12
statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

local startBtn = Instance.new("TextButton", autoPage)
startBtn.Size = UDim2.new(1, 0, 0, 45)
startBtn.Position = UDim2.new(0, 0, 0, 190)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
startBtn.Text = "START MS LOOP"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", autoPage)
stopBtn.Size = UDim2.new(1, 0, 0, 45)
stopBtn.Position = UDim2.new(0, 0, 0, 190)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.Text = "STOP MS LOOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Visible = false
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

-- Auto masak logic
local autoRunning = false

local function updateInv()
    waterLbl.Text = "💧 Water: " .. countItem("Water")
    sugarLbl.Text = "🧂 Sugar: " .. countItem("Sugar Block Bag")
    gelatinLbl.Text = "🟡 Gelatin: " .. countItem("Gelatin")
    emptyLbl.Text = "📦 Empty Bag: " .. countItem("Empty Bag")
end

local function cook()
    pcall(function()
        equip("Water")
        holdE()
        for i = 1, 20 do task.wait(1) end
        
        equip("Sugar Block Bag")
        holdE()
        task.wait(1)
        
        equip("Gelatin")
        holdE()
        task.wait(1)
        
        for i = 1, 45 do task.wait(1) end
        
        equip("Empty Bag")
        holdE()
        task.wait(1)
    end)
end

local function loopCook()
    while autoRunning do
        updateInv()
        statusLbl.Text = "🟡 COOKING..."
        statusLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
        cook()
        updateInv()
        task.wait(2)
    end
    statusLbl.Text = "⚫ STOPPED"
    statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
end

startBtn.MouseButton1Click:Connect(function()
    if not autoRunning then
        autoRunning = true
        startBtn.Visible = false
        stopBtn.Visible = true
        statusLbl.Text = "🟢 RUNNING"
        statusLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.spawn(loopCook)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    autoRunning = false
    startBtn.Visible = true
    stopBtn.Visible = false
end)

-- ========== SETTINGS PAGE ==========
local settingPage = Instance.new("Frame", content)
settingPage.Size = UDim2.new(1, 0, 1, 0)
settingPage.BackgroundTransparency = 1
settingPage.Visible = false

-- Macro F Card
local macroCard = Instance.new("Frame", settingPage)
macroCard.Size = UDim2.new(1, 0, 0, 100)
macroCard.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", macroCard).CornerRadius = UDim.new(0, 8)

local macroTitle = Instance.new("TextLabel", macroCard)
macroTitle.Size = UDim2.new(1, -20, 0, 30)
macroTitle.Position = UDim2.new(0, 10, 0, 5)
macroTitle.BackgroundTransparency = 1
macroTitle.Text = "🔫 MACRO F (SPAM F)"
macroTitle.Font = Enum.Font.GothamBold
macroTitle.TextSize = 12
macroTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
macroTitle.TextXAlignment = Enum.TextXAlignment.Left

local macroToggle = Instance.new("TextButton", macroCard)
macroToggle.Size = UDim2.new(0, 70, 0, 32)
macroToggle.Position = UDim2.new(1, -80, 0, 5)
macroToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
macroToggle.Text = "OFF"
macroToggle.Font = Enum.Font.GothamBold
macroToggle.TextSize = 12
macroToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
macroToggle.BorderSizePixel = 0
Instance.new("UICorner", macroToggle).CornerRadius = UDim.new(0, 6)

macroToggle.MouseButton1Click:Connect(function()
    macroEnabled = not macroEnabled
    macroToggle.Text = macroEnabled and "ON" or "OFF"
    macroToggle.BackgroundColor3 = macroEnabled and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(200, 50, 50)
    if not macroEnabled then holding = false end
end)

local macroInfo = Instance.new("TextLabel", macroCard)
macroInfo.Size = UDim2.new(1, -20, 0, 40)
macroInfo.Position = UDim2.new(0, 10, 0, 50)
macroInfo.BackgroundTransparency = 1
macroInfo.Text = "⚠️ Tekan dan TAHAN Klik Kiri untuk spam F\n⚠️ Lepas Klik Kiri untuk berhenti"
macroInfo.Font = Enum.Font.Gotham
macroInfo.TextSize = 10
macroInfo.TextColor3 = Color3.fromRGB(150, 150, 180)
macroInfo.TextXAlignment = Enum.TextXAlignment.Left
macroInfo.TextWrapped = true

-- Interval Card
local intervalCard = Instance.new("Frame", settingPage)
intervalCard.Size = UDim2.new(1, 0, 0, 80)
intervalCard.Position = UDim2.new(0, 0, 0, 110)
intervalCard.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", intervalCard).CornerRadius = UDim.new(0, 8)

local intervalTitle = Instance.new("TextLabel", intervalCard)
intervalTitle.Size = UDim2.new(1, -20, 0, 25)
intervalTitle.Position = UDim2.new(0, 10, 0, 5)
intervalTitle.BackgroundTransparency = 1
intervalTitle.Text = "⏱️ INTERVAL SPAM F (detik)"
intervalTitle.Font = Enum.Font.Gotham
intervalTitle.TextSize = 11
intervalTitle.TextColor3 = Color3.fromRGB(150, 150, 180)
intervalTitle.TextXAlignment = Enum.TextXAlignment.Left

local intervalVal = Instance.new("TextLabel", intervalCard)
intervalVal.Size = UDim2.new(0, 50, 0, 25)
intervalVal.Position = UDim2.new(1, -60, 0, 5)
intervalVal.BackgroundTransparency = 1
intervalVal.Text = "0.3s"
intervalVal.Font = Enum.Font.GothamBold
intervalVal.TextSize = 12
intervalVal.TextColor3 = Color3.fromRGB(0, 150, 255)
intervalVal.TextXAlignment = Enum.TextXAlignment.Right

local minusInt = Instance.new("TextButton", intervalCard)
minusInt.Size = UDim2.new(0, 40, 0, 35)
minusInt.Position = UDim2.new(0, 10, 0, 35)
minusInt.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
minusInt.Text = "-"
minusInt.Font = Enum.Font.GothamBold
minusInt.TextSize = 18
minusInt.TextColor3 = Color3.fromRGB(255, 255, 255)
minusInt.BorderSizePixel = 0
Instance.new("UICorner", minusInt).CornerRadius = UDim.new(0, 6)

local intervalDisplay = Instance.new("TextLabel", intervalCard)
intervalDisplay.Size = UDim2.new(0, 60, 0, 35)
intervalDisplay.Position = UDim2.new(0.5, -30, 0, 35)
intervalDisplay.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
intervalDisplay.Text = "0.3"
intervalDisplay.Font = Enum.Font.GothamBold
intervalDisplay.TextSize = 14
intervalDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalDisplay.BorderSizePixel = 0
Instance.new("UICorner", intervalDisplay).CornerRadius = UDim.new(0, 6)

local plusInt = Instance.new("TextButton", intervalCard)
plusInt.Size = UDim2.new(0, 40, 0, 35)
plusInt.Position = UDim2.new(1, -50, 0, 35)
plusInt.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
plusInt.Text = "+"
plusInt.Font = Enum.Font.GothamBold
plusInt.TextSize = 18
plusInt.TextColor3 = Color3.fromRGB(255, 255, 255)
plusInt.BorderSizePixel = 0
Instance.new("UICorner", plusInt).CornerRadius = UDim.new(0, 6)

local intValue = 0.3
intervalDisplay.Text = "0.3"

minusInt.MouseButton1Click:Connect(function()
    intValue = math.max(0.1, intValue - 0.1)
    intervalDisplay.Text = string.format("%.1f", intValue)
    intervalVal.Text = string.format("%.1f", intValue) .. "s"
    interval = intValue
end)

plusInt.MouseButton1Click:Connect(function()
    intValue = math.min(1.0, intValue + 0.1)
    intervalDisplay.Text = string.format("%.1f", intValue)
    intervalVal.Text = string.format("%.1f", intValue) .. "s"
    interval = intValue
end)

-- Blink Card
local blinkCard = Instance.new("Frame", settingPage)
blinkCard.Size = UDim2.new(1, 0, 0, 50)
blinkCard.Position = UDim2.new(0, 0, 0, 200)
blinkCard.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", blinkCard).CornerRadius = UDim.new(0, 8)

local blinkTitle = Instance.new("TextLabel", blinkCard)
blinkTitle.Size = UDim2.new(0.6, 0, 1, 0)
blinkTitle.Position = UDim2.new(0, 10, 0, 0)
blinkTitle.BackgroundTransparency = 1
blinkTitle.Text = "🔷 BLINK (Tombol T)"
blinkTitle.Font = Enum.Font.Gotham
blinkTitle.TextSize = 12
blinkTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
blinkTitle.TextXAlignment = Enum.TextXAlignment.Left

local blinkToggle = Instance.new("TextButton", blinkCard)
blinkToggle.Size = UDim2.new(0, 70, 0, 32)
blinkToggle.Position = UDim2.new(1, -80, 0.5, -16)
blinkToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
blinkToggle.Text = "ON"
blinkToggle.Font = Enum.Font.GothamBold
blinkToggle.TextSize = 12
blinkToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
blinkToggle.BorderSizePixel = 0
Instance.new("UICorner", blinkToggle).CornerRadius = UDim.new(0, 6)

local blinkActive = true
blinkToggle.MouseButton1Click:Connect(function()
    blinkActive = not blinkActive
    blinkToggle.Text = blinkActive and "ON" or "OFF"
    blinkToggle.BackgroundColor3 = blinkActive and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(200, 50, 50)
end)

-- Blink function
local function blink()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 8
    end
end

-- Keybind T
game:GetService("ContextActionService"):BindAction("blink", function(_, state)
    if state == Enum.UserInputState.Begin and blinkActive then
        blink()
    end
end, false, Enum.KeyCode.T)

-- Tab switching
tabAuto.MouseButton1Click:Connect(function()
    autoPage.Visible = true
    settingPage.Visible = false
    tabAuto.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    tabAuto.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabSetting.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    tabSetting.TextColor3 = Color3.fromRGB(180, 180, 200)
end)

tabSetting.MouseButton1Click:Connect(function()
    autoPage.Visible = false
    settingPage.Visible = true
    tabSetting.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    tabSetting.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabAuto.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    tabAuto.TextColor3 = Color3.fromRGB(180, 180, 200)
end)

-- Update inventory loop
task.spawn(function()
    while gui and gui.Parent do
        updateInv()
        task.wait(1)
    end
end)

print("✅ 191 STORE LOADED! Macro F ada di tab SETTINGS")
