local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local PathfindingService = game:GetService("PathfindingService")

-- Local player
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkexHub"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Create Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 340)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Draggable Title Bar
local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
title.Text = "DarkexHub - South Bronx"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

title.InputBegan:Connect(function(input)
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

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Tab Buttons Frame
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(1, 0, 0, 36)
tabButtonsFrame.Position = UDim2.new(0, 0, 0, 36)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 4)
tabLayout.Parent = tabButtonsFrame

-- Create Tab Button
local function createTabButton(name)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.24, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = tabButtonsFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    return button
end

-- Tabs
local espTabButton = createTabButton("ESP")
local autoFarmTabButton = createTabButton("Auto Farm")
local aimbotTabButton = createTabButton("Aimbot")
local currencyTabButton = createTabButton("Currency")

-- Tab Content Frames
local function createTabContent()
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -72)
    content.Position = UDim2.new(0, 0, 0, 72)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame
    content.Visible = false

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = content

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 8)
    padding.Parent = content

    return content
end

local espContent = createTabContent()
local autoFarmContent = createTabContent()
local aimbotContent = createTabContent()
local currencyContent = createTabContent()

-- Switch Tab
local function switchTab(selectedButton, selectedContent)
    espTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    autoFarmTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    aimbotTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    currencyTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    selectedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

    espContent.Visible = false
    autoFarmContent.Visible = false
    aimbotContent.Visible = false
    currencyContent.Visible = false
    selectedContent.Visible = true
end

espTabButton.MouseButton1Click:Connect(function() switchTab(espTabButton, espContent) end)
autoFarmTabButton.MouseButton1Click:Connect(function() switchTab(autoFarmTabButton, autoFarmContent) end)
aimbotTabButton.MouseButton1Click:Connect(function() switchTab(aimbotTabButton, aimbotContent) end)
currencyTabButton.MouseButton1Click:Connect(function() switchTab(currencyTabButton, currencyContent) end)

switchTab(espTabButton, espContent)

-- ESP Tab
local boxButton = Instance.new("TextButton")
boxButton.Size = UDim2.new(1, 0, 0, 36)
boxButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
boxButton.Text = "Box: OFF"
boxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
boxButton.TextScaled = true
boxButton.Font = Enum.Font.SourceSans
boxButton.LayoutOrder = 1
boxButton.Parent = espContent

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = boxButton

local skeletonButton = Instance.new("TextButton")
skeletonButton.Size = UDim2.new(1, 0, 0, 36)
skeletonButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
skeletonButton.Text = "Skeleton: OFF"
skeletonButton.TextColor3 = Color3.fromRGB(255, 255, 255)
skeletonButton.TextScaled = true
skeletonButton.Font = Enum.Font.SourceSans
skeletonButton.LayoutOrder = 2
skeletonButton.Parent = espContent

local skeletonCorner = Instance.new("UICorner")
skeletonCorner.CornerRadius = UDim.new(0, 6)
skeletonCorner.Parent = skeletonButton

-- Auto Farm Tab
local marshmallowToggle = Instance.new("TextButton")
marshmallowToggle.Size = UDim2.new(1, 0, 0, 36)
marshmallowToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
marshmallowToggle.Text = "Marshmallow Farm: OFF"
marshmallowToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
marshmallowToggle.TextScaled = true
marshmallowToggle.Font = Enum.Font.SourceSans
marshmallowToggle.LayoutOrder = 1
marshmallowToggle.Parent = autoFarmContent

local marshmallowCorner = Instance.new("UICorner")
marshmallowCorner.CornerRadius = UDim.new(0, 6)
marshmallowCorner.Parent = marshmallowToggle

local crateJobToggle = Instance.new("TextButton")
crateJobToggle.Size = UDim2.new(1, 0, 0, 36)
crateJobToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
crateJobToggle.Text = "Crate Job: OFF"
crateJobToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
crateJobToggle.TextScaled = true
crateJobToggle.Font = Enum.Font.SourceSans
crateJobToggle.LayoutOrder = 2
crateJobToggle.Parent = autoFarmContent

local crateJobCorner = Instance.new("UICorner")
crateJobCorner.CornerRadius = UDim.new(0, 6)
crateJobCorner.Parent = crateJobToggle

local marshmallowDropdown = Instance.new("TextButton")
marshmallowDropdown.Size = UDim2.new(1, 0, 0, 36)
marshmallowDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
marshmallowDropdown.Text = "Marshmallows: 1"
marshmallowDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
marshmallowDropdown.TextScaled = true
marshmallowDropdown.Font = Enum.Font.SourceSans
marshmallowDropdown.LayoutOrder = 3
marshmallowDropdown.Parent = autoFarmContent

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = marshmallowDropdown

-- Aimbot Tab
local aimassistToggle = Instance.new("TextButton")
aimassistToggle.Size = UDim2.new(1, 0, 0, 36)
aimassistToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
aimassistToggle.Text = "Aim Assist: OFF"
aimassistToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
aimassistToggle.TextScaled = true
aimassistToggle.Font = Enum.Font.SourceSans
aimassistToggle.LayoutOrder = 1
aimassistToggle.Parent = aimbotContent

local aimassistCorner = Instance.new("UICorner")
aimassistCorner.CornerRadius = UDim.new(0, 6)
aimassistCorner.Parent = aimassistToggle

local softaimToggle = Instance.new("TextButton")
softaimToggle.Size = UDim2.new(1, 0, 0, 36)
softaimToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
softaimToggle.Text = "Softaim: OFF"
softaimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
softaimToggle.TextScaled = true
softaimToggle.Font = Enum.Font.SourceSans
softaimToggle.LayoutOrder = 2
softaimToggle.Parent = aimbotContent

local softaimCorner = Instance.new("UICorner")
softaimCorner.CornerRadius = UDim.new(0, 6)
softaimCorner.Parent = softaimToggle

local fovToggle = Instance.new("TextButton")
fovToggle.Size = UDim2.new(1, 0, 0, 36)
fovToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
fovToggle.Text = "FOV Circle: OFF"
fovToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
fovToggle.TextScaled = true
fovToggle.Font = Enum.Font.SourceSans
fovToggle.LayoutOrder = 3
fovToggle.Parent = aimbotContent

local fovToggleCorner = Instance.new("UICorner")
fovToggleCorner.CornerRadius = UDim.new(0, 6)
fovToggleCorner.Parent = fovToggle

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, 0, 0, 36)
sliderFrame.BackgroundTransparency = 1
sliderFrame.LayoutOrder = 4
sliderFrame.Parent = aimbotContent

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(0.4, 0, 1, 0)
sliderLabel.Text = "FOV: 200"
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.TextScaled = true
sliderLabel.Font = Enum.Font.SourceSans
sliderLabel.Parent = sliderFrame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.6, 0, 0.2, 0)
sliderBar.Position = UDim2.new(0.4, 0, 0.4, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
sliderBar.Parent = sliderFrame

local sliderBarCorner = Instance.new("UICorner")
sliderBarCorner.CornerRadius = UDim.new(0, 5)
sliderBarCorner.Parent = sliderBar

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 18, 1.5, 0)
sliderKnob.Position = UDim2.new(0.5, -9, -0.25, 0)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
sliderKnob.Parent = sliderBar

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(0, 5)
knobCorner.Parent = sliderKnob

-- Currency Tab
local currencyButton = Instance.new("TextButton")
currencyButton.Size = UDim2.new(1, 0, 0, 36)
currencyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
currencyButton.Text = "Add 100K Money (Risky)"
currencyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
currencyButton.TextScaled = true
currencyButton.Font = Enum.Font.SourceSans
currencyButton.LayoutOrder = 1
currencyButton.Parent = currencyContent

local currencyCorner = Instance.new("UICorner")
currencyCorner.CornerRadius = UDim.new(0, 6)
currencyCorner.Parent = currencyButton

-- State Variables
local boxEnabled = false
local skeletonEnabled = false
local aimassistEnabled = false
local softaimEnabled = false
local fovCircleEnabled = false
local fovRadius = 200
local marshmallowFarmEnabled = false
local crateJobEnabled = false
local marshmallowCount = 1
local lockedTarget = nil
local instantInteractEnabled = false

-- FOV Circle
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.Size = UDim2.new(0, 400, 0, 400)
fovCircle.Position = UDim2.new(0.5, -200, 0.5, -200)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = screenGui

local circleStroke = Instance.new("UIStroke")
circleStroke.Color = Color3.new(1, 1, 1)
circleStroke.Thickness = 2
circleStroke.Parent = fovCircle

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = fovCircle

-- Slider Dragging
local draggingKnob = false
sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingKnob = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingKnob = false
    end
end)

RunService.RenderStepped:Connect(function()
    if draggingKnob then
        local mouseX = UserInputService:GetMouseLocation().X
        local barX = sliderBar.AbsolutePosition.X
        local barWidth = sliderBar.AbsoluteSize.X
        local relative = math.clamp((mouseX - barX) / barWidth, 0, 1)
        sliderKnob.Position = UDim2.new(relative, -9, -0.25, 0)
        local maxFOV = camera.ViewportSize.Y / 2
        fovRadius = math.floor(relative * maxFOV)
        sliderLabel.Text = "FOV: " .. fovRadius
        fovCircle.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
        fovCircle.Position = UDim2.new(0.5, -fovRadius, 0.5, -fovRadius)
    end
end)

fovToggle.MouseButton1Click:Connect(function()
    fovCircleEnabled = not fovCircleEnabled
    fovToggle.Text = "FOV Circle: " .. (fovCircleEnabled and "ON" or "OFF")
    fovToggle.BackgroundColor3 = fovCircleEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(70, 70, 70)
    fovCircle.Visible = fovCircleEnabled and (aimassistEnabled or softaimEnabled)
end)

-- Marshmallow Dropdown
local marshmallowOptions = {1, 5, 10, 20}
local currentOptionIndex = 1
marshmallowDropdown.MouseButton1Click:Connect(function()
    currentOptionIndex = currentOptionIndex % #marshmallowOptions + 1
    marshmallowCount = marshmallowOptions[currentOptionIndex]
    marshmallowDropdown.Text = "Marshmallows: " .. marshmallowCount
end)

-- Anti-AFK
local antiAfkEnabled = true
local function antiAFK()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        if antiAfkEnabled then
            vu:Button2Down(Vector2.new(0, 0), camera.CFrame)
            wait(math.random(0.5, 1.5))
            vu:Button2Up(Vector2.new(0, 0), camera.CFrame)
        end
    end)
end
antiAFK()

-- Instant Interact (Controlled)
local function applyInstantInteract(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = math.random(0.1, 0.3)
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = 15
    end
end

game.DescendantAdded:Connect(function(obj)
    if instantInteractEnabled and obj:IsA("ProximityPrompt") then
        applyInstantInteract(obj)
    end
end)

instantInteractEnabled = true

-- Pathfinding Movement
local function moveToPosition(targetPos)
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then
        return false
    end

    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    local startPos = root.Position
    local distance = (targetPos - startPos).Magnitude

    if distance > 500 then
        return false
    end

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        Costs = {Water = math.huge}
    })

    local success, err = pcall(function()
        path:ComputeAsync(startPos, targetPos + Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)))
    end)

    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in ipairs(waypoints) do
            if not crateJobEnabled then return false end
            humanoid:MoveTo(waypoint.Position)
            humanoid.MoveToFinished:Wait()
            wait(math.random(0.1, 0.3))
        end
        return true
    else
        root.CanCollide = false
        root.Anchored = true
        for t = 0, 1, 0.05 do
            root.CFrame = CFrame.new(startPos:Lerp(targetPos, t))
            wait(math.random(0.05, 0.1))
        end
        root.CFrame = CFrame.new(targetPos)
        wait(0.1)
        root.Anchored = false
        root.CanCollide = true
        return true
    end
end

-- Marshmallow Farm
local function equipItem(itemName)
    local backpack = player:FindFirstChild("Backpack")
    local item = backpack and backpack:FindFirstChild(itemName)
    if item then
        local success, err = pcall(function()
            player.Character.Humanoid:EquipTool(item)
        end)
        if success then
            return true
        end
    end
    return false
end

local function pressE()
    local success, err = pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
        wait(math.random(0.1, 0.2))
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
    end)
    return success
end

local function buyItem(itemName)
    local shop = workspace:FindFirstChild("Shop")
    if shop then
        local prompt = shop:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            local success, err = pcall(function()
                applyInstantInteract(prompt)
                if (player.Character.HumanoidRootPart.Position - prompt.Parent.Position).Magnitude > 10 then
                    moveToPosition(prompt.Parent.Position)
                end
                fireproximityprompt(prompt)
            end)
            if success then
                return true
            end
        end
    end
    return false
end

local function startMarshmallowFarm()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return
    end

    local marshmallowPos = Vector3.new(-250, 5, -700)
    if (char.HumanoidRootPart.Position - marshmallowPos).Magnitude > 10 then
        moveToPosition(marshmallowPos)
    end

    for _, item in ipairs({"Water", "Sugar Block Bag", "Gelatin", "Empty Bag"}) do
        if not player.Backpack:FindFirstChild(item) then
            buyItem(item)
            wait(math.random(1, 2))
        end
    end

    for i = 1, marshmallowCount do
        if not marshmallowFarmEnabled then break end
        local success = true
        if success then success = equipItem("Water") end
        if success then success = pressE() end
        if success then wait(math.random(22, 24)) end
        if success then success = equipItem("Sugar Block Bag") end
        if success then success = pressE() end
        if success then wait(math.random(2.5, 3.5)) end
        if success then success = equipItem("Gelatin") end
        if success then success = pressE() end
        if success then wait(math.random(44, 46)) end
        if success then success = equipItem("Empty Bag") end
        if success then success = pressE() end
        if success then wait(math.random(0.8, 1.2)) end
    end
end

marshmallowToggle.MouseButton1Click:Connect(function()
    marshmallowFarmEnabled = not marshmallowFarmEnabled
    marshmallowToggle.Text = "Marshmallow Farm: " .. (marshmallowFarmEnabled and "ON" or "OFF")
    marshmallowToggle.BackgroundColor3 = marshmallowFarmEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(70, 70, 70)
    if marshmallowFarmEnabled then
        spawn(startMarshmallowFarm)
    end
end)

-- Crate Job
local function findCrateManager()
    local manager = nil
    local managerPos = Vector3.new(-284, 6, -765)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():match("manager") or obj.Name:lower():match("crate")) then
            local humanoidRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("Part")
            if humanoidRoot then
                manager = obj
                managerPos = humanoidRoot.Position
                break
            end
        end
    end
    return manager, managerPos
end

local function findCrate()
    local crate = nil
    local cratePos = Vector3.new(-290, 6, -770)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():match("crate") and obj:FindFirstChildOfClass("ProximityPrompt") then
            crate = obj
            cratePos = obj.Position
            break
        end
    end
    return crate, cratePos
end

local function findDeliveryPoint(cratePos)
    local deliveryPos = Vector3.new(-280, 6, -760)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():match("delivery") and obj:FindFirstChildOfClass("ProximityPrompt") then
            deliveryPos = obj.Position
            break
        end
        if obj:IsA("ProximityPrompt") and (obj.Parent.Position - cratePos).Magnitude < 20 then
            deliveryPos = obj.Parent.Position
            break
        end
    end
    return deliveryPos
end

local function startCrateJob()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return
    end

    local manager, managerPos = findCrateManager()
    if (char.HumanoidRootPart.Position - managerPos).Magnitude > 10 then
        if not moveToPosition(managerPos) then return end
    end

    local success, err = pcall(function()
        if manager then
            local prompt = manager:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                applyInstantInteract(prompt)
                if (char.HumanoidRootPart.Position - managerPos).Magnitude < 15 then
                    fireproximityprompt(prompt)
                    wait(math.random(1.5, 2.5))
                end
            end
        end
    end)
    if not success then
        return
    end

    while crateJobEnabled do
        local crate, cratePos = findCrate()
        if crate then
            if (char.HumanoidRootPart.Position - cratePos).Magnitude > 10 then
                if not moveToPosition(cratePos + Vector3.new(0, 3, 0)) then return end
            end
            local prompt = crate:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                local promptSuccess, promptErr = pcall(function()
                    applyInstantInteract(prompt)
                    if (char.HumanoidRootPart.Position - cratePos).Magnitude < 15 then
                        fireproximityprompt(prompt)
                    end
                end)
                wait(math.random(0.4, 0.6))
            end
        else
            if (char.HumanoidRootPart.Position - cratePos).Magnitude > 10 then
                moveToPosition(cratePos + Vector3.new(0, 3, 0))
            end
            wait(math.random(0.8, 1.2))
        end

        local deliveryPos = findDeliveryPoint(cratePos)
        if (char.HumanoidRootPart.Position - deliveryPos).Magnitude > 10 then
            if not moveToPosition(deliveryPos) then return end
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if crateJobEnabled and obj:IsA("ProximityPrompt") and (obj.Parent.Position - deliveryPos).Magnitude < 5 then
                local deliverySuccess, deliveryErr = pcall(function()
                    applyInstantInteract(obj)
                    if (char.HumanoidRootPart.Position - obj.Parent.Position).Magnitude < 15 then
                        fireproximityprompt(obj)
                    end
                end)
                break
            end
        end
        wait(math.random(0.8, 1.2))
    end
end

crateJobToggle.MouseButton1Click:Connect(function()
    crateJobEnabled = not crateJobEnabled
    crateJobToggle.Text = "Crate Job: " .. (crateJobEnabled and "ON" or "OFF")
    crateJobToggle.BackgroundColor3 = crateJobEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(70, 70, 70)
    if crateJobEnabled then
        spawn(function()
            startCrateJob()
        end)
    end
end)

-- ESP Functions
local function addBox(char)
    if char and not char:FindFirstChild("PlayerBoxGui") then
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "PlayerBoxGui"
        billboardGui.Parent = char
        billboardGui.Adornee = char:FindFirstChild("HumanoidRootPart")
        billboardGui.AlwaysOnTop = true
        billboardGui.Size = UDim2.new(4, 0, 6, 0)
        billboardGui.StudsOffset = Vector3.new(0, 0, 0)
        billboardGui.MaxDistance = 0

        local boxFrame = Instance.new("Frame")
        boxFrame.Size = UDim2.new(1, 0, 1, 0)
        boxFrame.BackgroundTransparency = 1
        boxFrame.Parent = billboardGui

        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = Color3.fromRGB(255, 0, 0)
        uiStroke.Thickness = 2
        uiStroke.Parent = boxFrame
    end
end

local function removeBox(char)
    local boxGui = char:FindFirstChild("PlayerBoxGui")
    if boxGui then
        boxGui:Destroy()
    end
end

local function addSkeleton(char)
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then
            return
        end

        local rigType = humanoid.RigType
        local bodyParts = {}

        if rigType == Enum.HumanoidRigType.R15 then
            bodyParts = {
                {part = "Head", att0Pos = Vector3.new(0, 0.5, 0), att1Pos = Vector3.new(0, -0.5, 0)},
                {part = "UpperTorso", att0Pos = Vector3.new(0, 1.0, 0), att1Pos = Vector3.new(0, -0.5, 0)},
                {part = "LowerTorso", att0Pos = Vector3.new(0, 0.5, 0), att1Pos = Vector3.new(0, -0.5, 0)},
                {part = "LeftUpperArm", att0Pos = Vector3.new(0, 0.7, 0), att1Pos = Vector3.new(0, -0.7, 0)},
                {part = "LeftLowerArm", att0Pos = Vector3.new(0, 0.7, 0), att1Pos = Vector3.new(0, -0.7, 0)},
                {part = "LeftHand", att0Pos = Vector3.new(0, 0.4, 0), att1Pos = Vector3.new(0, -0.4, 0)},
                {part = "RightUpperArm", att0Pos = Vector3.new(0, 0.7, 0), att1Pos = Vector3.new(0, -0.7, 0)},
                {part = "RightLowerArm", att0Pos = Vector3.new(0, 0.7, 0), att1Pos = Vector3.new(0, -0.7, 0)},
                {part = "RightHand", att0Pos = Vector3.new(0, 0.4, 0), att1Pos = Vector3.new(0, -0.4, 0)},
                {part = "LeftUpperLeg", att0Pos = Vector3.new(0, 0.8, 0), att1Pos = Vector3.new(0, -0.8, 0)},
                {part = "LeftLowerLeg", att0Pos = Vector3.new(0, 0.8, 0), att1Pos = Vector3.new(0, -0.8, 0)},
                {part = "LeftFoot", att0Pos = Vector3.new(0, 0.5, 0), att1Pos = Vector3.new(0, -0.5, 0)},
                {part = "RightUpperLeg", att0Pos = Vector3.new(0, 0.8, 0), att1Pos = Vector3.new(0, -0.8, 0)},
                {part = "RightLowerLeg", att0Pos = Vector3.new(0, 0.8, 0), att1Pos = Vector3.new(0, -0.8, 0)},
                {part = "RightFoot", att0Pos = Vector3.new(0, 0.5, 0), att1Pos = Vector3.new(0, -0.5, 0)}
            }
        elseif rigType == Enum.HumanoidRigType.R6 then
            bodyParts = {
                {part = "Head", att0Pos = Vector3.new(0, 0.5, 0), att1Pos = Vector3.new(0, -0.5, 0)},
                {part = "Torso", att0Pos = Vector3.new(0, 1.5, 0), att1Pos = Vector3.new(0, -1.5, 0)},
                {part = "Left Arm", att0Pos = Vector3.new(0, 1.5, 0), att1Pos = Vector3.new(0, -1.5, 0)},
                {part = "Right Arm", att0Pos = Vector3.new(0, 1.5, 0), att1Pos = Vector3.new(0, -1.5, 0)},
                {part = "Left Leg", att0Pos = Vector3.new(0, 1.5, 0), att1Pos = Vector3.new(0, -1.5, 0)},
                {part = "Right Leg", att0Pos = Vector3.new(0, 1.5, 0), att1Pos = Vector3.new(0, -1.5, 0)}
            }
        end

        for _, bodyPart in ipairs(bodyParts) do
            local part = char:FindFirstChild(bodyPart.part)
            if part then
                if not part:FindFirstChild("SkeletonBeam_" .. bodyPart.part) then
                    local att0 = Instance.new("Attachment")
                    att0.Name = "SkeletonAtt0_" .. bodyPart.part
                    att0.Position = bodyPart.att0Pos
                    att0.Parent = part

                    local att1 = Instance.new("Attachment")
                    att1.Name = "SkeletonAtt1_" .. bodyPart.part
                    att1.Position = bodyPart.att1Pos
                    att1.Parent = part

                    local beam = Instance.new("Beam")
                    beam.Name = "SkeletonBeam_" .. bodyPart.part
                    beam.Attachment0 = att0
                    beam.Attachment1 = att1
                    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                    beam.Width0 = 0.2
                    beam.Width1 = 0.2
                    beam.Transparency = NumberSequence.new(0)
                    beam.FaceCamera = true
                    beam.LightEmission = 0
                    beam.LightInfluence = 0
                    beam.Parent = part
                end
            end
        end
    end
end

local function removeSkeleton(char)
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                for _, child in ipairs(part:GetChildren()) do
                    if (child:IsA("Beam") and child.Name:match("SkeletonBeam_")) or (child:IsA("Attachment") and child.Name:match("SkeletonAtt")) then
                        child:Destroy()
                    end
                end
            end
        end
    end
end

local function updateHighlights()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if boxEnabled then
                addBox(p.Character)
            else
                removeBox(p.Character)
            end
            if skeletonEnabled then
                addSkeleton(p.Character)
            else
                removeSkeleton(p.Character)
            end
        end
    end
end

updateHighlights()

Players.PlayerAdded:Connect(function(p)
    if p ~= player then
        p.CharacterAdded:Connect(function(char)
            if boxEnabled then addBox(char) end
            if skeletonEnabled then addSkeleton(char) end
        end)
        if p.Character then
            if boxEnabled then addBox(p.Character) end
            if skeletonEnabled then addSkeleton(p.Character) end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if p.Character then
        removeBox(p.Character)
        removeSkeleton(p.Character)
    end
end)

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then
        p.CharacterAdded:Connect(function(char)
            if boxEnabled then addBox(char) end
            if skeletonEnabled then addSkeleton(char) end
        end)
    end
end

boxButton.MouseButton1Click:Connect(function()
    boxEnabled = not boxEnabled
    boxButton.Text = "Box: " .. (boxEnabled and "ON" or "OFF")
    boxButton.BackgroundColor3 = boxEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(70, 70, 70)
    updateHighlights()
end)

skeletonButton.MouseButton1Click:Connect(function()
    skeletonEnabled = not skeletonEnabled
    skeletonButton.Text = "Skeleton: " .. (skeletonEnabled and "ON" or "OFF")
    skeletonButton.BackgroundColor3 = skeletonEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(70, 70, 70)
    updateHighlights()
end)

-- Currency Logic (Risky)
currencyButton.MouseButton1Click:Connect(function()
    print("[DarkexHub] Warning: Direct currency modification is highly detectable. Use autofarms instead.")
end)

-- Aim Assist and Softaim
local function getClosestPlayerToMouse()
    local mousePos = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local shortestDistance = fovRadius

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local vector, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local distance = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
                if distance < shortestDistance then
                    local ray = Ray.new(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 1000)
                    local hit, hitPos = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
                    if hit and hit:IsDescendantOf(p.Character) then
                        shortestDistance = distance
                        closestPlayer = p
                    end
                end
            end
        end
    end

    return closestPlayer
end

local aimConnection
aimassistToggle.MouseButton1Click:Connect(function()
    aimassistEnabled = not aimassistEnabled
    aimassistToggle.Text = "Aim Assist: " .. (aimassistEnabled and "ON" or "OFF")
    aimassistToggle.BackgroundColor3 = aimassistEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(70, 70, 70)
    fovCircle.Visible = fovCircleEnabled and (aimassistEnabled or softaimEnabled)
    lockedTarget = nil

    if aimassistEnabled then
        aimConnection = RunService.RenderStepped:Connect(function()
            local delta = UserInputService:GetMouseDelta()
            if delta.Magnitude > 5 then
                lockedTarget = getClosestPlayerToMouse()
            end
            if lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("Head") then
                local success, err = pcall(function()
                    local targetPos = lockedTarget.Character.Head.Position + Vector3.new(math.random(-0.5, 0.5), math.random(-0.5, 0.5), math.random(-0.5, 0.5))
                    local camPos = camera.CFrame.Position
                    local lerpValue = math.random(0.6, 0.8)
                    camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camPos, targetPos), lerpValue)
                    wait(math.random(0.05, 0.1))
                end)
            end
        end)
    else
        if aimConnection then
            aimConnection:Disconnect()
            aimConnection = nil
        end
    end
end)

local softaimConnection
softaimToggle.MouseButton1Click:Connect(function()
    softaimEnabled = not softaimEnabled
    softaimToggle.Text = "Softaim: " .. (softaimEnabled and "ON" or "OFF")
    softaimToggle.BackgroundColor3 = softaimEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(70, 70, 70)
    fovCircle.Visible = fovCircleEnabled and (aimassistEnabled or softaimEnabled)

    if softaimEnabled then
        softaimConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local target = getClosestPlayerToMouse()
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    local success, err = pcall(function()
                        local targetPos = target.Character.Head.Position + Vector3.new(math.random(-0.5, 0.5), math.random(-0.5, 0.5), math.random(-0.5, 0.5))
                        local camPos = camera.CFrame.Position
                        local lerpValue = math.random(0.6, 0.8)
                        camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camPos, targetPos), lerpValue)
                        wait(math.random(0.05, 0.1))
                        VirtualInputManager:SendMouseButtonEvent(true, 1, false, camera.CFrame)
                        wait(math.random(0.05, 0.1))
                        VirtualInputManager:SendMouseButtonEvent(false, 1, false, camera.CFrame)
                    end)
                end
            end
        end)
    else
        if softaimConnection then
            softaimConnection:Disconnect()
            softaimConnection = nil
        end
    end
end)
