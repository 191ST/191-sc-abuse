-- FULLY NV - BUATAN PIJAKAN DI BAWAH (100% ANTI JATUH)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

repeat task.wait() until player.Character

local playerGui = player:WaitForChild("PlayerGui")
local buyRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
local npcPos = Vector3.new(510.762817, 3.58721066, 600.791504)

local apartData = { -- ... (sama seperti sebelumnya, Anda bisa copy dari script sebelumnya) ... }

local fullyRunning = false
local selectedApart = 1
local selectedPot = "kanan"
local targetMS = 5
local basePlate = nil
local artificialFloor = nil -- Pijakan buatan

-- ============================================================
-- BUAT PIJAKAN BUATAN DI BAWAH KARAKTER
-- ============================================================
local function createArtificialFloor()
    if artificialFloor and artificialFloor.Parent then
        artificialFloor:Destroy()
    end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    artificialFloor = Instance.new("Part")
    artificialFloor.Name = "ArtificialFloor"
    artificialFloor.Size = Vector3.new(5, 1, 5)
    artificialFloor.Position = hrp.Position - Vector3.new(0, 7, 0)
    artificialFloor.Anchored = false
    artificialFloor.CanCollide = true
    artificialFloor.Transparency = 1
    artificialFloor.Parent = workspace
    return artificialFloor
end

local function destroyArtificialFloor()
    if artificialFloor and artificialFloor.Parent then
        artificialFloor:Destroy()
        artificialFloor = nil
    end
end

-- ============================================================
-- BODY VELOCITY DENGAN PIJAKAN BUATAN
-- ============================================================
local function ketarikKeTarget(targetPos, speed)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end

    -- Matikan gravitasi dan collision karakter
    local oldPlatform = hum.PlatformStand
    hum.PlatformStand = true
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- Buat pijakan buatan di bawah karakter
    createArtificialFloor()
    if artificialFloor then
        artificialFloor.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 7, hrp.Position.Z)
    end

    -- Paksa posisi karakter di atas pijakan
    hrp.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 7, hrp.Position.Z)
    task.wait(0.05)

    -- BodyVelocity untuk karakter
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(100000, 0, 100000)
    bv.Parent = hrp

    local direction = (targetPos - hrp.Position).Unit
    bv.Velocity = direction * speed

    -- BodyVelocity untuk pijakan buatan (ikut bergerak)
    local floorBv = nil
    if artificialFloor then
        floorBv = Instance.new("BodyVelocity")
        floorBv.MaxForce = Vector3.new(100000, 0, 100000)
        floorBv.Parent = artificialFloor
        floorBv.Velocity = direction * speed
    end

    -- Tunggu sampai jarak < 3
    repeat
        task.wait(0.05)
        -- Update posisi pijakan mengikuti karakter kalau perlu
        if artificialFloor and hrp then
            artificialFloor.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 7, hrp.Position.Z)
        end
        if not fullyRunning then
            bv:Destroy()
            if floorBv then floorBv:Destroy() end
            destroyArtificialFloor()
            hum.PlatformStand = oldPlatform
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            return false
        end
    until (hrp.Position - targetPos).Magnitude < 3

    bv:Destroy()
    if floorBv then floorBv:Destroy() end
    destroyArtificialFloor()

    hrp.CFrame = CFrame.new(targetPos)
    task.wait(0.05)

    hum.PlatformStand = oldPlatform
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    return true
end

-- ============================================================
-- LOOP UTAMA (PANGGIL ketarikKeTarget DENGAN SPEED 3)
-- ============================================================
local function getStagePos(stage, pot)
    if stage.pos then return stage.pos
    elseif stage[pot] then return stage[pot]
    end
    return nil
end

local function jalankanFully(statusFunc)
    fullyRunning = true
    local apartId = selectedApart
    local pot = selectedPot
    local stages = apartData[apartId].stages
    local target = targetMS

    local apartPos = getStagePos(stages[1], pot)
    if not apartPos then
        statusFunc("❌ Gagal dapat posisi apart!")
        fullyRunning = false
        return
    end

    while fullyRunning do
        statusFunc("🏃 Ketarik ke NPC Buy...")
        ketarikKeTarget(npcPos, 3)

        statusFunc("🛒 Beli bahan x" .. target)
        if not beliBahan(target) then break end

        statusFunc("🏃 Ketarik ke apart...")
        ketarikKeTarget(apartPos, 3)

        for i, stage in ipairs(stages) do
            if not fullyRunning then break end
            local targetPos = getStagePos(stage, pot)
            if not targetPos then
                statusFunc("❌ Stage " .. i .. " tidak ditemukan")
                break
            end

            statusFunc("📍 Stage " .. i .. " - Ketarik...")
            ketarikKeTarget(targetPos, 3)

            statusFunc("🎯 Stage " .. i .. " - Spam E")
            spamE(3)
            task.wait(0.3)

            if stage.isCook then
                statusFunc("🍳 Memasak di stage " .. i)
                local success = cook()
                if not success then break end
                statusFunc("✅ Masak selesai")
                task.wait(1)
            end
        end

        statusFunc("🏃 Ketarik ke NPC Jual...")
        ketarikKeTarget(npcPos, 3)

        statusFunc("💰 Menjual MS")
        jualSemua()

        statusFunc("🔄 Loop selesai, ulang...")
        task.wait(1)
    end

    fullyRunning = false
    statusFunc("⏹ Dihentikan")
end
