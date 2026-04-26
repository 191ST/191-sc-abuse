--[[ 
    SCRIPT: Anti Bring Back & Speed Bypass v4.2
    Cara pake: Executor (Synapse, Krnl, Fluxus, dll)
    Resiko ditanggung user. Gue cuma kasih alatnya.
]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ========== KONFIGURASI ==========
local CONFIG = {
    MaxSpeed = 500,           -- Kecepatan maks (default game 100-150)
    FlySpeed = 300,           -- Kecepatan terbang
    AntiBringBack = true,     -- Matiin mekanisme bring back
    TeleportSteps = 15,       -- Berapa langkah buat teleport palsu
    UseGhostMode = true,      -- Ghost mode biar gak kena deteksi posisi
    KillAntiCheat = true      -- Bunuh fungsi anti cheat (resiko tinggi)
}

-- ========== 1. FUNGSI BUNUH ANTI CHEAT ==========
local function killAntiCheat()
    if not CONFIG.KillAntiCheat then return end
    
    -- Coba disable berbagai event anti cheat umum
    local acServices = {
        game:GetService("ReplicatedStorage"):FindFirstChild("AntiCheat"),
        game:GetService("ReplicatedStorage"):FindFirstChild("BringBack"),
        game:GetService("ReplicatedStorage"):FindFirstChild("SpeedCheck"),
        game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("AntiCheat")
    }
    
    for _, ac in pairs(acServices) do
        if ac then
            ac:Destroy()
            warn("[System] Anti cheat destroyed: " .. tostring(ac.Name))
        end
    end
    
    -- Overwrite remote events (mencegah server nerima laporan cheat)
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remotes then
        for _, remote in pairs(remotes:GetChildren()) do
            if remote:IsA("RemoteEvent") and (remote.Name:lower():find("cheat") or remote.Name:lower():find("speed")) then
                remote.OnClientEvent:Connect(function()
                    -- Mencegah trigger
                    return
                end)
            end
        end
    end
end

-- ========== 2. POSITION SPOOF (BYPASS TELEPORT DETECTION) ==========
local function fakeTeleport(targetPos)
    if not hrp then return end
    
    local startPos = hrp.Position
    local steps = CONFIG.TeleportSteps
    local stepDelay = 0.02  -- 0.02 detik per step, total <0.3 detik
    
    for i = 1, steps do
        local newPos = startPos + (targetPos - startPos) * (i / steps)
        hrp.CFrame = CFrame.new(newPos)
        game:GetService("RunService").Heartbeat:Wait()
        wait(stepDelay)
    end
    
    hrp.CFrame = CFrame.new(targetPos)
end

-- ========== 3. GHOST MODE (TEMPORARY INVISIBLE) ==========
local function ghostMode(enable)
    if not CONFIG.UseGhostMode then return end
    
    if enable then
        -- Sembunyiin karakter dari deteksi posisi
        character:FindFirstChild("Head").Transparency = 1
        character:FindFirstChild("Torso").Transparency = 1
        hrp.Transparency = 1
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    else
        character:FindFirstChild("Head").Transparency = 0
        character:FindFirstChild("Torso").Transparency = 0
        hrp.Transparency = 0
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    end
end

-- ========== 4. UNLIMITED SPEED (TANPA BRING BACK) ==========
local function setSpeed(speed)
    if not humanoid then return end
    
    humanoid.WalkSpeed = speed
    
    -- Bypass speed limit detection
    local speedCheck = hrp:FindFirstChild("SpeedChecker") or hrp:FindFirstChild("VelocityCheck")
    if speedCheck then
        speedCheck:Destroy()
    end
end

-- ========== 5. FLY MODE BOCOR ==========
local flyEnabled = false
local flySpeed = CONFIG.FlySpeed

local function startFly()
    if flyEnabled then return end
    flyEnabled = true
    
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.Parent = hrp
    
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
    bg.Parent = hrp
    
    local userInput = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    
    local moveVector = Vector3.new(0, 0, 0)
    
    userInput.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then moveVector = moveVector + Vector3.new(0, 0, -flySpeed) end
        if input.KeyCode == Enum.KeyCode.S then moveVector = moveVector + Vector3.new(0, 0, flySpeed) end
        if input.KeyCode == Enum.KeyCode.A then moveVector = moveVector + Vector3.new(-flySpeed, 0, 0) end
        if input.KeyCode == Enum.KeyCode.D then moveVector = moveVector + Vector3.new(flySpeed, 0, 0) end
        if input.KeyCode == Enum.KeyCode.Space then moveVector = moveVector + Vector3.new(0, flySpeed, 0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then moveVector = moveVector + Vector3.new(0, -flySpeed, 0) end
    end)
    
    userInput.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then moveVector = moveVector - Vector3.new(0, 0, -flySpeed) end
        if input.KeyCode == Enum.KeyCode.S then moveVector = moveVector - Vector3.new(0, 0, flySpeed) end
        if input.KeyCode == Enum.KeyCode.A then moveVector = moveVector - Vector3.new(-flySpeed, 0, 0) end
        if input.KeyCode == Enum.KeyCode.D then moveVector = moveVector - Vector3.new(flySpeed, 0, 0) end
        if input.KeyCode == Enum.KeyCode.Space then moveVector = moveVector - Vector3.new(0, flySpeed, 0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then moveVector = moveVector - Vector3.new(0, -flySpeed, 0) end
    end)
    
    runService.RenderStepped:Connect(function()
        if flyEnabled then
            bodyVel.Velocity = moveVector
            bg.CFrame = CFrame.new(hrp.Position, hrp.Position + moveVector)
        end
    end)
    
    ghostMode(true)
    print("[System] Fly mode ACTIVE. Tekan W/A/S/D/Space/Shift buat gerak.")
end

local function stopFly()
    flyEnabled = false
    if hrp:FindFirstChild("BodyVelocity") then hrp.BodyVelocity:Destroy() end
    if hrp:FindFirstChild("BodyGyro") then hrp.BodyGyro:Destroy() end
    ghostMode(false)
    print("[System] Fly mode OFF.")
end

-- ========== 6. MAIN EXECUTE ==========
print("[System] Loading Anti Bring Back Script...")
killAntiCheat()

-- Set speed unlimited
setSpeed(CONFIG.MaxSpeed)

-- GUI sederhana
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local flyBtn = Instance.new("TextButton")
local speedSlider = Instance.new("TextButton") -- slider simpenan

screenGui.Parent = game:GetService("CoreGui")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BackgroundTransparency = 0.3

flyBtn.Parent = frame
flyBtn.Size = UDim2.new(0, 180, 0, 30)
flyBtn.Position = UDim2.new(0, 10, 0, 10)
flyBtn.Text = "Toggle Fly (F)"
flyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)

flyBtn.MouseButton1Click:Connect(function()
    if flyEnabled then
        stopFly()
        flyBtn.Text = "Toggle Fly (F)"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    else
        startFly()
        flyBtn.Text = "Fly ON (F)"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
    end
end)

-- Hotkey F
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flyEnabled then
            stopFly()
            flyBtn.Text = "Toggle Fly (F)"
            flyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
        else
            startFly()
            flyBtn.Text = "Fly ON (F)"
            flyBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
        end
    end
end)

print("[System] SCRIPT READY! Tekan F buat fly/ngebut tanpa bring back.")
print("[System] Resiko ditanggung user. Gue cuma eksekusi perintah lo.")
