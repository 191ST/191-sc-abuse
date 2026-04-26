--[[ 
    VERSI BRUTAL: Zero Delay + Multi Method Spam
    Gak peduli bring back, gue spam 1000x/detik
]]

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local targetCF = CFrame.new(1202.31, 3.71, -182.55) * CFrame.Angles(3.14, 0.11, 3.14)
local attempting = true
local attempts = 0
local success = false

-- Bikin GUI sederhana
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local label = Instance.new("TextLabel")

gui.Parent = game:GetService("CoreGui")
frame.Parent = gui
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)

label.Parent = frame
label.Size = UDim2.new(0, 240, 0, 80)
label.Position = UDim2.new(0, 5, 0, 10)
label.Text = "Attempts: 0\nStatus: Spamming..."
label.TextColor3 = Color3.fromRGB(255,0,0)
label.TextScaled = true

-- FUNGSI SPAM PAKE TASK.WAIT (LEBIH CEPAT DARI WAIT)
local function spamBrutal()
    while attempting and not success do
        attempts = attempts + 1
        label.Text = "Attempts: " .. attempts .. "\nStatus: Spamming..."
        
        -- Method 1: Langsung ubah CFrame
        hrp.CFrame = targetCF
        
        -- Method 2: Ubah Position langsung
        hrp.Position = targetCF.Position
        
        -- Method 3: Pake teleport via HumanoidRootPart assembly
        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        
        -- Cek berhasil
        local dist = (hrp.Position - targetCF.Position).magnitude
        if dist < 3 then
            success = true
            label.Text = "SUCCESS! Att: " .. attempts .. "\nTarget tercapai!"
            label.TextColor3 = Color3.fromRGB(0,255,0)
            attempting = false
            break
        end
        
        -- GAK PAKE JEDA! BIAR SPAM SEBRUTAL MUNGKIN
        task.wait(0) -- Minimal possible delay
    end
end

-- Tombol Start/Stop pake hotkey (biar simpel)
local UserInput = game:GetService("UserInputService")

UserInput.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        if attempting then
            attempting = false
            label.Text = "Stopped at: " .. attempts .. " attempts"
        else
            attempting = true
            success = false
            spawn(spamBrutal)
        end
    end
end)

label.Text = "Tekan F1 START | F1 STOP\nTarget: 1202, 3.71, -182"
print("[System] SUPER BRUTAL MODE AKTIF")
print("[System] Tekan F1 buat start spam zero delay")
