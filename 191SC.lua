-- ======================================================
--   191 STORE + MACRO F (WORKING - GUI FIXED)
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
local storePurchaseRE = ReplicatedStorage:FindFirstChild("RemoteEvents") and ReplicatedStorage.RemoteEvents:FindFirstChild("StorePurchase")
local blinkEnabled = true
local macroFEnabled = false
local macroFHeld = false
local macroFInterval = 0.3

-- ========== FUNCTIONS ==========
local function pressF()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end)
end

local function holdE(t)
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(t or 0.7)
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

local function equip(name)
    local char = player.Character
    local tool = player.Backpack:FindFirstChild(name) or char and char:FindFirstChild(name)
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

local function blinkMaju()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 8
    end
end

-- ========== MACRO F (HOLD KLIK KIRI) ==========
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

-- Color Palette
local colors = {
    bg = Color3.fromRGB(20, 20, 30),
    card = Color3.fromRGB(30, 30, 40),
    accent = Color3.fromRGB(0, 120, 255),
    accentDim = Color3.fromRGB(0, 80, 180),
    green = Color3.fromRGB(0, 200, 100),
    red = Color3.fromRGB(220, 50, 50),
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(150, 150, 180),
}

-- Main Window
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 500)
main.Position = UDim2.new(0.5, -200, 0.5, -250)
main.BackgroundColor3 = colors.bg
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Title Bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = colors.card
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "191 STORE"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = colors.text
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = colors.red
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = colors.text
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Tab Buttons
local tabContainer = Instance.new("Frame", main)
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundColor3 = colors.card
tabContainer.BorderSizePixel = 0

local autoTab = Instance.new("TextButton", tabContainer)
autoTab.Size = UDim2.new(0.5, 0, 1, 0)
autoTab.Position = UDim2.new(0, 0, 0, 0)
autoTab.BackgroundColor3 = colors.accentDim
autoTab.Text = "AUTO"
autoTab.Font = Enum.Font.GothamBold
autoTab.TextSize = 14
autoTab.TextColor3 = colors.text
autoTab.BorderSizePixel = 0

local settingsTab = Instance.new("TextButton", tabContainer)
settingsTab.Size = UDim2.new(0.5, 0, 1, 0)
settingsTab.Position = UDim2.new(0.5, 0, 0, 0)
settingsTab.BackgroundColor3 = colors.card
settingsTab.Text = "SETTINGS"
settingsTab.Font = Enum.Font.GothamBold
settingsTab.TextSize = 14
settingsTab.TextColor3 = colors.textDim
settingsTab.BorderSizePixel = 0

-- Content Container
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -120)
content.Position = UDim2.new(0, 0, 0, 80)
content.BackgroundTransparency = 1

-- ============================================================
-- AUTO TAB
-- ============================================================
local autoPage = Instance.new("ScrollingFrame", content)
autoPage.Size = UDim2.new(1, 0, 1, 0)
autoPage.BackgroundTransparency = 1
autoPage.ScrollBarThickness = 3
autoPage.CanvasSize = UDim2.new(0, 0, 0, 400)

local autoLayout = Instance.new("UIListLayout", autoPage)
autoLayout.Padding = UDim.new(0, 10)
autoLayout.SortOrder = Enum.SortOrder.LayoutOrder

local autoPad = Instance.new("UIPadding", autoPage)
autoPad.PaddingTop = UDim.new(0, 10)
autoPad.PaddingLeft = UDim.new(0, 10)
autoPad.PaddingRight = UDim.new(0, 10)

-- Inventory Display
local invFrame = Instance.new("Frame", autoPage)
invFrame.Size = UDim2.new(1, 0, 0, 120)
invFrame.BackgroundColor3 = colors.card
invFrame.LayoutOrder = 1
Instance.new("UICorner", invFrame).CornerRadius = UDim.new(0, 8)

local invTitle = Instance.new("TextLabel", invFrame)
invTitle.Size = UDim2.new(1, 0, 0, 25)
invTitle.Position = UDim2.new(0, 10, 0, 5)
invTitle.BackgroundTransparency = 1
invTitle.Text = "INVENTORY"
invTitle.Font = Enum.Font.GothamBold
invTitle.TextSize = 12
invTitle.TextColor3 = colors.accent
invTitle.TextXAlignment = Enum.TextXAlignment.Left

local waterText = Instance.new("TextLabel", invFrame)
waterText.Size = UDim2.new(1, -20, 0, 20)
waterText.Position = UDim2.new(0, 10, 0, 35)
waterText.BackgroundTransparency = 1
waterText.Text = "💧 Water: 0"
waterText.Font = Enum.Font.Gotham
waterText.TextSize = 12
waterText.TextColor3 = colors.textDim
waterText.TextXAlignment = Enum.TextXAlignment.Left

local sugarText = Instance.new("TextLabel", invFrame)
sugarText.Size = UDim2.new(1, -20, 0, 20)
sugarText.Position = UDim2.new(0, 10, 0, 55)
sugarText.BackgroundTransparency = 1
sugarText.Text = "🧂 Sugar: 0"
sugarText.Font = Enum.Font.Gotham
sugarText.TextSize = 12
sugarText.TextColor3 = colors.textDim
sugarText.TextXAlignment = Enum.TextXAlignment.Left

local gelatinText = Instance.new("TextLabel", invFrame)
gelatinText.Size = UDim2.new(1, -20, 0, 20)
gelatinText.Position = UDim2.new(0, 10, 0, 75)
gelatinText.BackgroundTransparency = 1
gelatinText.Text = "🟡 Gelatin: 0"
gelatinText.Font = Enum.Font.Gotham
gelatinText.TextSize = 12
gelatinText.TextColor3 = colors.textDim
gelatinText.TextXAlignment = Enum.TextXAlignment.Left

local emptyText = Instance.new("TextLabel", invFrame)
emptyText.Size = UDim2.new(1, -20, 0, 20)
emptyText.Position = UDim2.new(0, 10, 0, 95)
emptyText.BackgroundTransparency = 1
emptyText.Text = "📦 Empty Bag: 0"
emptyText.Font = Enum.Font.Gotham
emptyText.TextSize = 12
emptyText.TextColor3 = colors.textDim
emptyText.TextXAlignment = Enum.TextXAlignment.Left

-- Status
local statusFrame = Instance.new("Frame", autoPage)
statusFrame.Size = UDim2.new(1, 0, 0, 40)
statusFrame.BackgroundColor3 = colors.card
statusFrame.LayoutOrder = 2
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 8)

local statusText = Instance.new("TextLabel", statusFrame)
statusText.Size = UDim2.new(1, -20, 1, 0)
statusText.Position = UDim2.new(0, 10, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "● STOPPED"
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 12
statusText.TextColor3 = colors.red
statusText.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons
local startBtn = Instance.new("TextButton", autoPage)
startBtn.Size = UDim2.new(1, 0, 0, 45)
startBtn.BackgroundColor3 = colors.green
startBtn.Text = "START MS LOOP"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
startBtn.TextColor3 = colors.text
startBtn.LayoutOrder = 3
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", autoPage)
stopBtn.Size = UDim2.new(1, 0, 0, 45)
stopBtn.BackgroundColor3 = colors.red
stopBtn.Text = "STOP MS LOOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.TextColor3 = colors.text
stopBtn.LayoutOrder = 4
stopBtn.Visible = false
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

-- MS Loop Logic
local msRunning = false

local function updateInventory()
    waterText.Text = "💧 Water: " .. countItem("Water")
    sugarText.Text = "🧂 Sugar: " .. countItem("Sugar Block Bag")
    gelatinText.Text = "🟡 Gelatin: " .. countItem("Gelatin")
    emptyText.Text = "📦 Empty Bag: " .. countItem("Empty Bag")
end

local function msLoop()
    while msRunning do
        updateInventory()
        statusText.Text = "● COOKING..."
        statusText.TextColor3 = Color3.fromRGB(255, 200, 0)
        cookProcess()
        updateInventory()
        task.wait(2)
    end
    statusText.Text = "● STOPPED"
    statusText.TextColor3 = colors.red
end

startBtn.MouseButton1Click:Connect(function()
    if not msRunning then
        msRunning = true
        startBtn.Visible = false
        stopBtn.Visible = true
        statusText.Text = "● RUNNING"
        statusText.TextColor3 = colors.green
        task.spawn(msLoop)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    msRunning = false
    startBtn.Visible = true
    stopBtn.Visible = false
end)

-- ============================================================
-- SETTINGS TAB
-- ============================================================
local settingsPage = Instance.new("ScrollingFrame", content)
settingsPage.Size = UDim2.new(1, 0, 1, 0)
settingsPage.BackgroundTransparency = 1
settingsPage.ScrollBarThickness = 3
settingsPage.CanvasSize = UDim2.new(0, 0, 0, 320)
settingsPage.Visible = false

local settingsLayout = Instance.new("UIListLayout", settingsPage)
settingsLayout.Padding = UDim.new(0, 10)
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder

local settingsPad = Instance.new("UIPadding", settingsPage)
settingsPad.PaddingTop = UDim.new(0, 10)
settingsPad.PaddingLeft = UDim.new(0, 10)
settingsPad.PaddingRight = UDim.new(0, 10)

-- Blink Toggle
local blinkCard = Instance.new("Frame", settingsPage)
blinkCard.Size = UDim2.new(1, 0, 0, 50)
blinkCard.BackgroundColor3 = colors.card
blinkCard.LayoutOrder = 1
Instance.new("UICorner", blinkCard).CornerRadius = UDim.new(0, 8)

local blinkTitle = Instance.new("TextLabel", blinkCard)
blinkTitle.Size = UDim2.new(0.6, 0, 1, 0)
blinkTitle.Position = UDim2.new(0, 12, 0, 0)
blinkTitle.BackgroundTransparency = 1
blinkTitle.Text = "🔷 Shortcut T (Blink)"
blinkTitle.Font = Enum.Font.Gotham
blinkTitle.TextSize = 12
blinkTitle.TextColor3 = colors.text
blinkTitle.TextXAlignment = Enum.TextXAlignment.Left

local blinkToggle = Instance.new("TextButton", blinkCard)
blinkToggle.Size = UDim2.new(0, 70, 0, 32)
blinkToggle.Position = UDim2.new(1, -82, 0.5, -16)
blinkToggle.BackgroundColor3 = colors.green
blinkToggle.Text = "ON"
blinkToggle.Font = Enum.Font.GothamBold
blinkToggle.TextSize = 12
blinkToggle.TextColor3 = colors.text
blinkToggle.BorderSizePixel = 0
Instance.new("UICorner", blinkToggle).CornerRadius = UDim.new(0, 6)

blinkToggle.MouseButton1Click:Connect(function()
    blinkEnabled = not blinkEnabled
    blinkToggle.Text = blinkEnabled and "ON" or "OFF"
    blinkToggle.BackgroundColor3 = blinkEnabled and colors.green or colors.red
end)

-- Macro F Card
local macroCard = Instance.new("Frame", settingsPage)
macroCard.Size = UDim2.new(1, 0, 0, 110)
macroCard.BackgroundColor3 = colors.card
macroCard.LayoutOrder = 2
Instance.new("UICorner", macroCard).CornerRadius = UDim.new(0, 8)

local macroTitle = Instance.new("TextLabel", macroCard)
macroTitle.Size = UDim2.new(0.6, 0, 0, 30)
macroTitle.Position = UDim2.new(0, 12, 0, 5)
macroTitle.BackgroundTransparency = 1
macroTitle.Text = "🔫 Macro F (Spam F)"
macroTitle.Font = Enum.Font.GothamBold
macroTitle.TextSize = 12
macroTitle.TextColor3 = colors.text
macroTitle.TextXAlignment = Enum.TextXAlignment.Left

local macroToggle = Instance.new("TextButton", macroCard)
macroToggle.Size = UDim2.new(0, 70, 0, 32)
macroToggle.Position = UDim2.new(1, -82, 0, 5)
macroToggle.BackgroundColor3 = colors.red
macroToggle.Text = "OFF"
macroToggle.Font = Enum.Font.GothamBold
macroToggle.TextSize = 12
macroToggle.TextColor3 = colors.text
macroToggle.BorderSizePixel = 0
Instance.new("UICorner", macroToggle).CornerRadius = UDim.new(0, 6)

macroToggle.MouseButton1Click:Connect(function()
    macroFEnabled = not macroFEnabled
    macroToggle.Text = macroFEnabled and "ON" or "OFF"
    macroToggle.BackgroundColor3 = macroFEnabled and colors.green or colors.red
    if not macroFEnabled then
        macroFHeld = false
    end
end)

local macroInfo = Instance.new("TextLabel", macroCard)
macroInfo.Size = UDim2.new(1, -24, 0, 50)
macroInfo.Position = UDim2.new(0, 12, 0, 45)
macroInfo.BackgroundTransparency = 1
macroInfo.Text = "⚠️ Tekan dan TAHAN Klik Kiri untuk spam F\n⚠️ Lepas Klik Kiri untuk berhenti"
macroInfo.Font = Enum.Font.Gotham
macroInfo.TextSize = 10
macroInfo.TextColor3 = colors.textDim
macroInfo.TextXAlignment = Enum.TextXAlignment.Left
macroInfo.TextWrapped = true

-- Interval Slider
local intervalCard = Instance.new("Frame", settingsPage)
intervalCard.Size = UDim2.new(1, 0, 0, 80)
intervalCard.BackgroundColor3 = colors.card
intervalCard.LayoutOrder = 3
Instance.new("UICorner", intervalCard).CornerRadius = UDim.new(0, 8)

local intervalTitle = Instance.new("TextLabel", intervalCard)
intervalTitle.Size = UDim2.new(1, -80, 0, 25)
intervalTitle.Position = UDim2.new(0, 12, 0, 8)
intervalTitle.BackgroundTransparency = 1
intervalTitle.Text = "Interval Spam F (detik)"
intervalTitle.Font = Enum.Font.Gotham
intervalTitle.TextSize = 11
intervalTitle.TextColor3 = colors.textDim
intervalTitle.TextXAlignment = Enum.TextXAlignment.Left

local intervalValue = Instance.new("TextLabel", intervalCard)
intervalValue.Size = UDim2.new(0, 50, 0, 25)
intervalValue.Position = UDim2.new(1, -62, 0, 8)
intervalValue.BackgroundTransparency = 1
intervalValue.Text = "0.3s"
intervalValue.Font = Enum.Font.GothamBold
intervalValue.TextSize = 12
intervalValue.TextColor3 = colors.accent
intervalValue.TextXAlignment = Enum.TextXAlignment.Right

local function setInterval(val)
    macroFInterval = val
    intervalValue.Text = string.format("%.1f", val) .. "s"
end

-- Minus Button
local minusBtn = Instance.new("TextButton", intervalCard)
minusBtn.Size = UDim2.new(0, 40, 0, 30)
minusBtn.Position = UDim2.new(0, 12, 0, 40)
minusBtn.BackgroundColor3 = colors.accentDim
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 16
minusBtn.TextColor3 = colors.text
minusBtn.BorderSizePixel = 0
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)

local intervalDisplay = Instance.new("TextLabel", intervalCard)
intervalDisplay.Size = UDim2.new(0, 60, 0, 30)
intervalDisplay.Position = UDim2.new(0.5, -30, 0, 40)
intervalDisplay.BackgroundColor3 = colors.bg
intervalDisplay.Text = "0.3"
intervalDisplay.Font = Enum.Font.GothamBold
intervalDisplay.TextSize = 14
intervalDisplay.TextColor3 = colors.text
intervalDisplay.BorderSizePixel = 0
Instance.new("UICorner", intervalDisplay).CornerRadius = UDim.new(0, 6)

local plusBtn = Instance.new("TextButton", intervalCard)
plusBtn.Size = UDim2.new(0, 40, 0, 30)
plusBtn.Position = UDim2.new(1, -52, 0, 40)
plusBtn.BackgroundColor3 = colors.accentDim
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 16
plusBtn.TextColor3 = colors.text
plusBtn.BorderSizePixel = 0
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)

local currentInterval = 0.3
intervalDisplay.Text = "0.3"

minusBtn.MouseButton1Click:Connect(function()
    currentInterval = math.max(0.1, currentInterval - 0.1)
    intervalDisplay.Text = string.format("%.1f", currentInterval)
    setInterval(currentInterval)
end)

plusBtn.MouseButton1Click:Connect(function()
    currentInterval = math.min(1.0, currentInterval + 0.1)
    intervalDisplay.Text = string.format("%.1f", currentInterval)
    setInterval(currentInterval)
end)

-- Blink Buttons for Mobile
local mobileCard = Instance.new("Frame", settingsPage)
mobileCard.Size = UDim2.new(1, 0, 0, 130)
mobileCard.BackgroundColor3 = colors.card
mobileCard.LayoutOrder = 4
Instance.new("UICorner", mobileCard).CornerRadius = UDim.new(0, 8)

local mobileTitle2 = Instance.new("TextLabel", mobileCard)
mobileTitle2.Size = UDim2.new(1, -24, 0, 25)
mobileTitle2.Position = UDim2.new(0, 12, 0, 5)
mobileTitle2.BackgroundTransparency = 1
mobileTitle2.Text = "📱 BLINK BUTTONS (MOBILE)"
mobileTitle2.Font = Enum.Font.GothamBold
mobileTitle2.TextSize = 11
mobileTitle2.TextColor3 = colors.accent
mobileTitle2.TextXAlignment = Enum.TextXAlignment.Left

local function makeBlinkBtn(parent, text, y, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.45, -5, 0, 40)
    btn.Position = UDim2.new(0.03, 0, 0, y)
    btn.BackgroundColor3 = colors.accentDim
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = colors.text
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

makeBlinkBtn(mobileCard, "⬆️ FORWARD", 35, function()
    blinkMaju()
end)

makeBlinkBtn(mobileCard, "⬇️ BACKWARD", 35, function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame - hrp.CFrame.LookVector * 8
    end
end)

makeBlinkBtn(mobileCard, "⬆️ UP", 85, function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 5, 0)
    end
end)

makeBlinkBtn(mobileCard, "⬇️ DOWN", 85, function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, -5, 0)
    end
end)

-- ============================================================
-- TAB SWITCHING
-- ============================================================
autoTab.MouseButton1Click:Connect(function()
    autoPage.Visible = true
    settingsPage.Visible = false
    autoTab.BackgroundColor3 = colors.accentDim
    autoTab.TextColor3 = colors.text
    settingsTab.BackgroundColor3 = colors.card
    settingsTab.TextColor3 = colors.textDim
end)

settingsTab.MouseButton1Click:Connect(function()
    autoPage.Visible = false
    settingsPage.Visible = true
    settingsTab.BackgroundColor3 = colors.accentDim
    settingsTab.TextColor3 = colors.text
    autoTab.BackgroundColor3 = colors.card
    autoTab.TextColor3 = colors.textDim
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
-- STARTUP
-- ============================================================
autoPage.Visible = true
settingsPage.Visible = false

-- Update inventory every second
task.spawn(function()
    while gui and gui.Parent do
        updateInventory()
        task.wait(1)
    end
end)

print("191 STORE LOADED! Macro F: Tekan & Tahan Klik Kiri")
