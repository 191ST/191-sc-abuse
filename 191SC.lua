-- VERSI YANG BENERAN SPAM TERUS SAMPE BERHASIL

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local targetCF = CFrame.new(1202.31, 3.71, -182.55) * CFrame.Angles(3.14, 0.11, 3.14)

local spamming = false
local attempts = 0
local success = false

-- GUI simpel
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local label = Instance.new("TextLabel")
local startBtn = Instance.new("TextButton")
local stopBtn = Instance.new("TextButton")

gui.Parent = game:GetService("CoreGui")
frame.Parent = gui
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)

label.Parent = frame
label.Size = UDim2.new(0, 230, 0, 50)
label.Position = UDim2.new(0, 10, 0, 10)
label.Text = "Attempts: 0\nStatus: Idle"
label.TextColor3 = Color3.fromRGB(255,255,0)
label.TextScaled = true

startBtn.Parent = frame
startBtn.Size = UDim2.new(0, 100, 0, 30)
startBtn.Position = UDim2.new(0, 10, 0, 70)
startBtn.Text = "START SPAM"
startBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)

stopBtn.Parent = frame
stopBtn.Size = UDim2.new(0, 100, 0, 30)
stopBtn.Position = UDim2.new(0, 130, 0, 70)
stopBtn.Text = "STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
stopBtn.Visible = false

-- FUNGSI SPAM YANG BENERAN
local function startSpamming()
    spamming = true
    success = false
    attempts = 0
    
    while spamming and not success do
        attempts = attempts + 1
        label.Text = "Attempts: " .. attempts .. "\nStatus: Spamming..."
        
        -- Teleport ke target
        hrp.CFrame = targetCF
        
        -- Jeda super pendek (biar loop cepet)
        task.wait(0.005)
        
        -- Cek apakah berhasil (masih di target atau udah ke bring back?)
        local distToTarget = (hrp.Position - targetCF.Position).magnitude
        
        if distToTarget < 5 then
            -- BERHASIL! Gak kena bring back
            success = true
            label.Text = "SUCCESS! Att: " .. attempts .. "\nTarget tercapai!"
            label.TextColor3 = Color3.fromRGB(0,255,0)
            spamming = false
            startBtn.Visible = true
            stopBtn.Visible = false
        else
            -- GAGAL: kena bring back, ulang lagi dari awal (otomatis)
            -- Gak perlu ngapa-ngapain, loop lanjut lagi
            if attempts % 50 == 0 then
                label.Text = "Attempts: " .. attempts .. "\nStill spamming..."
            end
        end
        
        -- Jeda lagi biar gak overload, tapi tetep cepet
        task.wait(0.005)
    end
    
    if not spamming and not success then
        label.Text = "Stopped at: " .. attempts .. " attempts"
        startBtn.Visible = true
        stopBtn.Visible = false
    end
end

-- TOMBOL START
startBtn.MouseButton1Click:Connect(function()
    if spamming then return end
    startBtn.Visible = false
    stopBtn.Visible = true
    label.TextColor3 = Color3.fromRGB(255,255,0)
    spawn(startSpamming)
end)

-- TOMBOL STOP
stopBtn.MouseButton1Click:Connect(function()
    spamming = false
    label.Text = "Stopping..."
    task.wait(0.1)
    label.Text = "Stopped at: " .. attempts .. " attempts"
    startBtn.Visible = true
    stopBtn.Visible = false
end)

print("[System] V6 READY - Spam tanpa henti sampe berhasil")
print("[System] Klik START SPAM, biarin jalan, nanti tiba-tiba berhasil")
