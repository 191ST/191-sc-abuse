--[[
    PROXIMITY PROMPT FORCE TRIGGER
    - Teleport item ke player
    - Force trigger prompt
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RS = game:GetService("RunService")

-- Tunggu karakter
local Character = LP.Character or LP.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Target item
local targetItemPath = ReplicatedStorage:FindFirstChild("Workspace"):FindFirstChild("PromptPurchases"):FindFirstChild("G17 Dual Laser Drum")
local promptPart = nil

-- Cari ProximityPrompt yang sebenarnya
local function findRealPrompt()
    if not targetItemPath then return nil end
    
    for _, child in pairs(targetItemPath:GetDescendants()) do
        if child:IsA("ProximityPrompt") then
            return child
        end
    end
    return nil
end

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ForcePrompt"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 150)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -75)
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
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔫 FORCE PROMPT 🔫"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Method buttons
local method1Btn = Instance.new("TextButton")
method1Btn.Size = UDim2.new(0.9, 0, 0, 35)
method1Btn.Position = UDim2.new(0.05, 0, 0, 45)
method1Btn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
method1Btn.Text = "📦 METHOD 1: CLONE & TP"
method1Btn.TextColor3 = Color3.fromRGB(255,255,255)
method1Btn.TextSize = 12
method1Btn.Font = Enum.Font.GothamBold
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = method1Btn
method1Btn.Parent = mainFrame

local method2Btn = Instance.new("TextButton")
method2Btn.Size = UDim2.new(0.9, 0, 0, 35)
method2Btn.Position = UDim2.new(0.05, 0, 0, 88)
method2Btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
method2Btn.Text = "🚶 METHOD 2: TP PLAYER"
method2Btn.TextColor3 = Color3.fromRGB(255,255,255)
method2Btn.TextSize = 12
method2Btn.Font = Enum.Font.GothamBold
local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 8)
btnCorner2.Parent = method2Btn
method2Btn.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 1, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.fromRGB(150,150,150)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

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

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- === METHOD 1: Clone item ke dekat player ===
local function method1_CloneAndTrigger()
    statusLabel.Text = "Cloning item..."
    statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
    
    if not targetItemPath then
        statusLabel.Text = "ERROR: Item not found!"
        statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        return false
    end
    
    -- Clone seluruh item
    local cloned = targetItemPath:Clone()
    cloned.Parent = workspace
    
    -- Cari ProximityPrompt di clone
    local prompt = nil
    for _, child in pairs(cloned:GetDescendants()) do
        if child:IsA("ProximityPrompt") then
            prompt = child
            break
        end
    end
    
    if not prompt then
        statusLabel.Text = "ERROR: No ProximityPrompt found in clone!"
        statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        cloned:Destroy()
        return false
    end
    
    -- Buat part kecil di depan player sebagai holder
    local holder = Instance.new("Part")
    holder.Size = Vector3.new(2, 2, 2)
    holder.CFrame = RootPart.CFrame + RootPart.CFrame.LookVector * 3
    holder.Anchored = true
    holder.Transparency = 1
    holder.CanCollide = false
    holder.Parent = workspace
    
    -- Pindahkan prompt ke holder
    prompt.Parent = holder
    
    -- Force trigger prompt
    statusLabel.Text = "Triggering prompt..."
    pcall(function()
        prompt:Prompt(LP)
    end)
    
    -- Coba juga metode alternative
    task.wait(0.3)
    pcall(function()
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = 50
        prompt:Prompt(LP)
    end)
    
    task.wait(1)
    holder:Destroy()
    cloned:Destroy()
    
    statusLabel.Text = "Method 1 executed! Check if you got item"
    statusLabel.TextColor3 = Color3.fromRGB(100,255,100)
    return true
end

-- === METHOD 2: Teleport player ke item (lebih agresif) ===
local function method2_TeleportPlayer()
    statusLabel.Text = "Teleporting to item location..."
    statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
    
    if not targetItemPath then
        statusLabel.Text = "ERROR: Item not found!"
        statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        return false
    end
    
    -- Cari part yang memiliki position di dalam item
    local targetPosition = nil
    for _, child in pairs(targetItemPath:GetDescendants()) do
        if child:IsA("BasePart") and child.Position.Magnitude > 0 then
            targetPosition = child.Position
            break
        end
    end
    
    if not targetPosition then
        -- Fallback: pakai posisi item pertama yang ditemukan
        for _, child in pairs(targetItemPath:GetDescendants()) do
            if child:IsA("Instance") and child:FindFirstChild("Position") then
                pcall(function()
                    targetPosition = child.Position
                end)
                if targetPosition then break end
            end
        end
    end
    
    if not targetPosition then
        statusLabel.Text = "ERROR: Cannot find target position!"
        statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        return false
    end
    
    -- Simpan posisi awal
    local originalCFrame = RootPart.CFrame
    
    -- Teleport player ke item
    pcall(function()
        RootPart.CFrame = CFrame.new(targetPosition) + Vector3.new(0, 3, 0)
        task.wait(0.1)
    end)
    
    -- Cari prompt di item original (bukan clone)
    local originalPrompt = findRealPrompt()
    
    if originalPrompt then
        statusLabel.Text = "Triggering prompt..."
        pcall(function()
            originalPrompt:Prompt(LP)
        end)
        
        task.wait(0.5)
        pcall(function()
            originalPrompt.HoldDuration = 0
            originalPrompt:Prompt(LP)
        end)
    else
        -- Alternative: cari proximity prompt di sekitar
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and (prompt.Parent.Position - RootPart.Position).Magnitude < 10 then
                pcall(function()
                    prompt:Prompt(LP)
                end)
            end
        end
    end
    
    task.wait(1)
    
    -- Teleport balik
    pcall(function()
        RootPart.CFrame = originalCFrame
    end)
    
    statusLabel.Text = "Method 2 executed! Check inventory"
    statusLabel.TextColor3 = Color3.fromRGB(100,255,100)
    return true
end

-- === METHOD 3: Remote Spy (cari remote event yang dipanggil saat prompt) ===
local function method3_RemoteSpy()
    statusLabel.Text = "Searching for RemoteEvents..."
    statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
    
    -- Cari semua remote yang berhubungan dengan pembelian
    local remotes = {}
    
    -- Di ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and (string.find(obj.Name:lower(), "purchase") or string.find(obj.Name:lower(), "buy") or string.find(obj.Name:lower(), "prompt")) then
            table.insert(remotes, obj)
        end
    end
    
    -- Di workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") and (string.find(obj.Name:lower(), "purchase") or string.find(obj.Name:lower(), "buy")) then
            table.insert(remotes, obj)
        end
    end
    
    if #remotes == 0 then
        statusLabel.Text = "No purchase-related remotes found!"
        statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        return false
    end
    
    -- Fire semua remote yang ditemukan dengan berbagai parameter
    for _, remote in pairs(remotes) do
        pcall(function()
            -- Coba berbagai format parameter
            remote:FireServer("G17 Dual Laser Drum")
            remote:FireServer("Purchase", "G17 Dual Laser Drum")
            remote:FireServer({Item = "G17 Dual Laser Drum"})
            remote:FireServer(123456) -- ID produk
        end)
    end
    
    statusLabel.Text = "Fired " .. #remotes .. " remote(s)! Check if it worked"
    statusLabel.TextColor3 = Color3.fromRGB(100,255,100)
    return true
end

-- Tombol connections
method1Btn.MouseButton1Click:Connect(function()
    method1_CloneAndTrigger()
end)

method2Btn.MouseButton1Click:Connect(function()
    method2_TeleportPlayer()
end)

print("Force Prompt Exploit Loaded")
print("If prompt still doesn't appear, the game uses server-side validation")
