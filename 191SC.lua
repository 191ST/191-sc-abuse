-- ============================================================
-- TELEPORT RECORDER + GUI DRAGABLE
-- ============================================================

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local vim = game:GetService("VirtualInputManager")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Variabel rekaman
local recordedPrompts = {}
local recordedRemotes = {}
local teleportHistory = {}

-- ============================================================
-- GUI DRAGABLE
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportRecorder"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 16, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Title bar (buat drag)
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🎯 TELEPORT RECORDER (Drag me)"
titleText.TextColor3 = Color3.new(1,1,1)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 75)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Scroll area
local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================================
-- STATUS
-- ============================================================
local statusCard = Instance.new("Frame", scroll)
statusCard.Size = UDim2.new(1, 0, 0, 50)
statusCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", statusCard).CornerRadius = UDim.new(0, 8)

local statusText = Instance.new("TextLabel", statusCard)
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Belum ada aktivitas. Pergi ke stasiun dan interact (E)."
statusText.TextColor3 = Color3.fromRGB(145, 138, 175)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 11
statusText.TextWrapped = true

-- ============================================================
-- LIST PROMPT TEREKAM
-- ============================================================
local promptListCard = Instance.new("Frame", scroll)
promptListCard.Size = UDim2.new(1, 0, 0, 200)
promptListCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", promptListCard).CornerRadius = UDim.new(0, 8)

local promptListTitle = Instance.new("TextLabel", promptListCard)
promptListTitle.Size = UDim2.new(1, -10, 0, 20)
promptListTitle.Position = UDim2.new(0, 5, 0, 5)
promptListTitle.BackgroundTransparency = 1
promptListTitle.Text = "📌 PROMPT YANG DI-INTERACT"
promptListTitle.TextColor3 = Color3.fromRGB(220, 215, 245)
promptListTitle.Font = Enum.Font.GothamBold
promptListTitle.TextSize = 12

local promptScroll = Instance.new("ScrollingFrame", promptListCard)
promptScroll.Size = UDim2.new(1, -10, 1, -25)
promptScroll.Position = UDim2.new(0, 5, 0, 25)
promptScroll.BackgroundTransparency = 1
promptScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
promptScroll.ScrollBarThickness = 3

local promptLayout = Instance.new("UIListLayout", promptScroll)
promptLayout.Padding = UDim.new(0, 4)
promptLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================================
-- LIST REMOTE YANG TERPANGGIL
-- ============================================================
local remoteListCard = Instance.new("Frame", scroll)
remoteListCard.Size = UDim2.new(1, 0, 0, 200)
remoteListCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", remoteListCard).CornerRadius = UDim.new(0, 8)

local remoteListTitle = Instance.new("TextLabel", remoteListCard)
remoteListTitle.Size = UDim2.new(1, -10, 0, 20)
remoteListTitle.Position = UDim2.new(0, 5, 0, 5)
remoteListTitle.BackgroundTransparency = 1
remoteListTitle.Text = "🔁 REMOTE EVENT YANG TERPANGGIL"
remoteListTitle.TextColor3 = Color3.fromRGB(220, 215, 245)
remoteListTitle.Font = Enum.Font.GothamBold
remoteListTitle.TextSize = 12

local remoteScroll = Instance.new("ScrollingFrame", remoteListCard)
remoteScroll.Size = UDim2.new(1, -10, 1, -25)
remoteScroll.Position = UDim2.new(0, 5, 0, 25)
remoteScroll.BackgroundTransparency = 1
remoteScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
remoteScroll.ScrollBarThickness = 3

local remoteLayout = Instance.new("UIListLayout", remoteScroll)
remoteLayout.Padding = UDim.new(0, 4)
remoteLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================================
-- LIST PERUBAHAN POSISI (TELEPORT)
-- ============================================================
local tpListCard = Instance.new("Frame", scroll)
tpListCard.Size = UDim2.new(1, 0, 0, 200)
tpListCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", tpListCard).CornerRadius = UDim.new(0, 8)

local tpListTitle = Instance.new("TextLabel", tpListCard)
tpListTitle.Size = UDim2.new(1, -10, 0, 20)
tpListTitle.Position = UDim2.new(0, 5, 0, 5)
tpListTitle.BackgroundTransparency = 1
tpListTitle.Text = "📍 TELEPORT YANG TERJADI"
tpListTitle.TextColor3 = Color3.fromRGB(220, 215, 245)
tpListTitle.Font = Enum.Font.GothamBold
tpListTitle.TextSize = 12

local tpScroll = Instance.new("ScrollingFrame", tpListCard)
tpScroll.Size = UDim2.new(1, -10, 1, -25)
tpScroll.Position = UDim2.new(0, 5, 0, 25)
tpScroll.BackgroundTransparency = 1
tpScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
tpScroll.ScrollBarThickness = 3

local tpLayout = Instance.new("UIListLayout", tpScroll)
tpLayout.Padding = UDim.new(0, 4)
tpLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================================
-- FUNGSI TAMBAHKAN LOG
-- ============================================================
local function addLog(container, text, color)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, -10, 0, 24)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 28, 45)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextWrapped = true
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

-- ============================================================
-- HOOK PROXIMITY PROMPT
-- ============================================================
local oldTrigger = nil
if fireproximityprompt then
    oldTrigger = fireproximityprompt
    fireproximityprompt = function(prompt)
        -- Catat prompt yang di-fire
        local path = prompt.Parent:GetFullName()
        if not recordedPrompts[path] then
            recordedPrompts[path] = true
            addLog(promptScroll, "🔘 " .. path .. " (di-fire)", Color3.fromRGB(75, 45, 100))
            statusText.Text = "📌 Prompt di-fire: " .. path
            task.wait(0.05)
            promptScroll.CanvasSize = UDim2.new(0, 0, 0, promptLayout.AbsoluteContentSize.Y + 10)
        end
        return oldTrigger(prompt)
    end
end

-- Hooking RemoteEvent/FireServer
local oldFireServer = nil
if game:GetService("ReplicatedStorage") then
    local metatable = debug.getmetatable(game:GetService("ReplicatedStorage"))
    if metatable then
        oldFireServer = metatable.__index and metatable.__index.fireServer
        metatable.__index.fireServer = function(remote, ...)
            local path = remote:GetFullName()
            if not recordedRemotes[path] then
                recordedRemotes[path] = true
                addLog(remoteScroll, "🔁 " .. path, Color3.fromRGB(55, 80, 55))
                statusText.Text = "🔁 Remote event terpanggil: " .. path
                task.wait(0.05)
                remoteScroll.CanvasSize = UDim2.new(0, 0, 0, remoteLayout.AbsoluteContentSize.Y + 10)
            end
            return oldFireServer(remote, ...)
        end
    end
end

-- Monitor teleport (perubahan CFrame mendadak)
local lastPos = nil
local lastTime = tick()
game:GetService("RunService").Heartbeat:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local currentPos = hrp.Position
        if lastPos then
            local distance = (currentPos - lastPos).Magnitude
            if distance > 50 and tick() - lastTime > 1 then
                lastTime = tick()
                addLog(tpScroll, "📍 Teleport: " .. tostring(currentPos), Color3.fromRGB(75, 55, 100))
                statusText.Text = "📍 Teleport terdeteksi! Jarak: " .. math.floor(distance) .. " studs"
                task.wait(0.05)
                tpScroll.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 10)
            end
        end
        lastPos = currentPos
    end
end)

-- ============================================================
-- TOMBOL RESET
-- ============================================================
local resetCard = Instance.new("Frame", scroll)
resetCard.Size = UDim2.new(1, 0, 0, 50)
resetCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
Instance.new("UICorner", resetCard).CornerRadius = UDim.new(0, 8)

local resetBtn = Instance.new("TextButton", resetCard)
resetBtn.Size = UDim2.new(0.5, -10, 0, 36)
resetBtn.Position = UDim2.new(0.25, 0, 0.5, -18)
resetBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 75)
resetBtn.Text = "🗑️ RESET SEMUA REKAMAN"
resetBtn.TextColor3 = Color3.new(1,1,1)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 12
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)

resetBtn.MouseButton1Click:Connect(function()
    -- Clear semua list
    for _, child in pairs(promptScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, child in pairs(remoteScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, child in pairs(tpScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    recordedPrompts = {}
    recordedRemotes = {}
    teleportHistory = {}
    statusText.Text = "🗑️ Rekaman direset. Sekarang coba interact dengan prompt."
    promptScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    remoteScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

print("✅ TELEPORT RECORDER SIAP!")
print("📌 GUI bisa di-drag dari title bar")
print("🔍 Pergi ke stasiun, tekan E pada prompt teleport")
print("📝 Semua aktivitas akan terekam di GUI")
