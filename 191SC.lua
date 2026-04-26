-- TEST SCRIPT FULLY NV - PASTE DAN JALANKAN
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "TEST_FULLY_NV"
gui.Parent = playerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BackgroundTransparency = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
title.Text = "FULLY NV TEST"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Position = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.5, -25)
btn.BackgroundColor3 = Color3.fromRGB(55, 200, 110)
btn.Text = "TEST BUTTON"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

btn.MouseButton1Click:Connect(function()
    print("Button ditekan!")
    btn.Text = "BERHASIL!"
    task.wait(1)
    btn.Text = "TEST BUTTON"
end)

print("GUI harusnya muncul. Kalo ga muncul, cek output error.")
