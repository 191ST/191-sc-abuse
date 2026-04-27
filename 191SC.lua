-- ============================================================
-- TELEPORT PART SCANNER + FIRER (GUI)
-- ============================================================

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportScanner"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 16, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "TELEPORT SCANNER & FIRER"
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
-- TOMBOL SCAN
-- ============================================================
local scanCard = Instance.new("Frame", scroll)
scanCard.Size = UDim2.new(1, 0, 0, 50)
scanCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
Instance.new("UICorner", scanCard).CornerRadius = UDim.new(0, 8)

local scanBtn = Instance.new("TextButton", scanCard)
scanBtn.Size = UDim2.new(0.5, -10, 0, 36)
scanBtn.Position = UDim2.new(0.25, 0, 0.5, -18)
scanBtn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
scanBtn.Text = "🔍 SCAN NOW"
scanBtn.TextColor3 = Color3.new(1,1,1)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 14
Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0, 6)

-- ============================================================
-- STATUS
-- ============================================================
local statusCard = Instance.new("Frame", scroll)
statusCard.Size = UDim2.new(1, 0, 0, 36)
statusCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", statusCard).CornerRadius = UDim.new(0, 8)

local statusText = Instance.new("TextLabel", statusCard)
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Tekan SCAN untuk mencari prompt/remote"
statusText.TextColor3 = Color3.fromRGB(145, 138, 175)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 11
statusText.TextWrapped = true

-- ============================================================
-- PROMPT LIST CARD
-- ============================================================
local promptListCard = Instance.new("Frame", scroll)
promptListCard.Size = UDim2.new(1, 0, 0, 200)
promptListCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", promptListCard).CornerRadius = UDim.new(0, 8)

local promptListTitle = Instance.new("TextLabel", promptListCard)
promptListTitle.Size = UDim2.new(1, -10, 0, 20)
promptListTitle.Position = UDim2.new(0, 5, 0, 5)
promptListTitle.BackgroundTransparency = 1
promptListTitle.Text = "📌 PROXIMITY PROMPTS"
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
-- REMOTE EVENT LIST CARD
-- ============================================================
local remoteCard = Instance.new("Frame", scroll)
remoteCard.Size = UDim2.new(1, 0, 0, 200)
remoteCard.BackgroundColor3 = Color3.fromRGB(24, 21, 40)
Instance.new("UICorner", remoteCard).CornerRadius = UDim.new(0, 8)

local remoteTitle = Instance.new("TextLabel", remoteCard)
remoteTitle.Size = UDim2.new(1, -10, 0, 20)
remoteTitle.Position = UDim2.new(0, 5, 0, 5)
remoteTitle.BackgroundTransparency = 1
remoteTitle.Text = "🔁 REMOTE EVENTS"
remoteTitle.TextColor3 = Color3.fromRGB(220, 215, 245)
remoteTitle.Font = Enum.Font.GothamBold
remoteTitle.TextSize = 12

local remoteScroll = Instance.new("ScrollingFrame", remoteCard)
remoteScroll.Size = UDim2.new(1, -10, 1, -25)
remoteScroll.Position = UDim2.new(0, 5, 0, 25)
remoteScroll.BackgroundTransparency = 1
remoteScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
remoteScroll.ScrollBarThickness = 3

local remoteLayout = Instance.new("UIListLayout", remoteScroll)
remoteLayout.Padding = UDim.new(0, 4)
remoteLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================================
-- FUNGSI FIRE PROMPT
-- ============================================================
local function firePrompt(prompt)
    if not prompt or not prompt.Parent then
        statusText.Text = "❌ Prompt tidak valid!"
        return
    end
    local success, err = pcall(function()
        fireproximityprompt(prompt)
    end)
    if success then
        statusText.Text = "🔥 Prompt di-fire: " .. prompt.Parent:GetFullName()
    else
        statusText.Text = "❌ Gagal fire prompt: " .. tostring(err)
    end
end

-- ============================================================
-- FUNGSI FIRE REMOTE (Coba-coba, mungkin perlu argumen)
-- ============================================================
local function fireRemote(remote)
    if not remote or not remote.Parent then
        statusText.Text = "❌ Remote tidak valid!"
        return
    end
    local success, err = pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer()
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer()
        end
    end)
    if success then
        statusText.Text = "🔥 Remote di-fire: " .. remote.Name
    else
        statusText.Text = "❌ Gagal fire remote: " .. tostring(err)
    end
end

-- ============================================================
-- PROSES SCAN
-- ============================================================
local function clearContainer(container)
    for _, child in pairs(container:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function addButton(container, text, color, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 28, 45)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextWrapped = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function scanAll()
    clearContainer(promptScroll)
    clearContainer(remoteScroll)
    
    statusText.Text = "🔍 Scanning... mohon tunggu"
    task.wait(0.1)
    
    local promptCount = 0
    local remoteCount = 0
    
    -- Scan ProximityPrompt
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            promptCount = promptCount + 1
            local path = obj.Parent:GetFullName()
            addButton(promptScroll, "📌 " .. path, Color3.fromRGB(55, 55, 80), function()
                firePrompt(obj)
            end)
        end
    end
    
    -- Scan RemoteEvent & RemoteFunction di ReplicatedStorage & workspace
    local function scanRemote(service)
        for _, obj in pairs(service:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                remoteCount = remoteCount + 1
                addButton(remoteScroll, "🔁 " .. obj:GetFullName() .. " [Event]", Color3.fromRGB(55, 80, 55), function()
                    fireRemote(obj)
                end)
            elseif obj:IsA("RemoteFunction") then
                remoteCount = remoteCount + 1
                addButton(remoteScroll, "⚙️ " .. obj:GetFullName() .. " [Function]", Color3.fromRGB(55, 80, 55), function()
                    fireRemote(obj)
                end)
            end
        end
    end
    
    scanRemote(game.ReplicatedStorage)
    scanRemote(workspace)
    
    -- Update status
    if promptCount == 0 and remoteCount == 0 then
        statusText.Text = "❌ Tidak ditemukan Prompt atau RemoteEvent"
    else
        statusText.Text = "✅ Selesai! Ditemukan: " .. promptCount .. " Prompt, " .. remoteCount .. " Remote"
    end
    
    -- Update canvas size
    task.wait(0.05)
    promptScroll.CanvasSize = UDim2.new(0, 0, 0, promptLayout.AbsoluteContentSize.Y + 10)
    remoteScroll.CanvasSize = UDim2.new(0, 0, 0, remoteLayout.AbsoluteContentSize.Y + 10)
end

scanBtn.MouseButton1Click:Connect(scanAll)

-- Jalankan scan otomatis saat GUI muncul
task.spawn(function()
    task.wait(0.5)
    scanAll()
end)

print("✅ TELEPORT SCANNER GUI SIAP! Klik SCAN untuk mencari prompt/remote")
