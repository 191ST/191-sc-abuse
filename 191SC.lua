-- BRUTE FORCE PROMPT TRIGGER
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local targetPath = "Workspace.PromptPurchases.G17 Dual Laser Drum"
local target = ReplicatedStorage

for _, part in pairs(string.split(targetPath, ".")) do
    target = target and target:FindFirstChild(part)
    if not target then break end
end

if not target then
    warn("Target not found!")
    return
end

print("Target found! Attempting to trigger...")

-- Method: Cari semua interaksi
local function findAllInteractions(obj)
    for _, child in pairs(obj:GetDescendants()) do
        -- ProximityPrompt
        if child:IsA("ProximityPrompt") then
            print("Found Prompt: " .. child.Name)
            pcall(function()
                child.Enabled = true
                child.MaxActivationDistance = 100
                child:Prompt(LP)
                print("✅ Prompt triggered")
            end)
        end
        
        -- ClickDetector
        if child:IsA("ClickDetector") then
            print("Found ClickDetector: " .. child.Name)
            pcall(function()
                child:FireClick(LP)
                print("✅ ClickDetector fired")
            end)
        end
        
        -- Tool
        if child:IsA("Tool") then
            print("Found Tool: " .. child.Name)
            pcall(function()
                LP.Backpack:WaitForChild(child.Name)
                print("✅ Tool equipped")
            end)
        end
    end
end

-- Clone ke workspace dulu
local cloned = target:Clone()
cloned.Parent = workspace
cloned.Position = Vector3.new(0, 10, 0)

task.wait(1)

findAllInteractions(cloned)
findAllInteractions(target)

-- Teleport player ke item
local char = LP.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if hrp and cloned:FindFirstChild("Model") then
    local model = cloned:FindFirstChild("Model")
    if model and model:FindFirstChild("Handle") then
        local oldPos = hrp.CFrame
        hrp.CFrame = model.Handle.CFrame + Vector3.new(0, 3, 0)
        task.wait(1)
        hrp.CFrame = oldPos
        print("✅ Teleport done")
    end
end

task.wait(2)
cloned:Destroy()

print("Brute force completed!")
