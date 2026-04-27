-- ELIXIR 3.5 LITE -- FULLY NV + ALL FEATURES
-- PASTIKAN BISA MUNCUL

local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local ContextActionService = game:GetService("ContextActionService")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

repeat task.wait() until player.Character
repeat task.wait() until player.Character:FindFirstChild("HumanoidRootPart")

local playerGui = player:WaitForChild("PlayerGui")

-- HAPUS GUI LAMA
pcall(function() playerGui:FindFirstChild("ELIXIR_3_5"):Destroy() end)
pcall(function() game.CoreGui:FindFirstChild("ELIXIR_3_5"):Destroy() end)

-- VARIABLES
local running = false
local buyAmount = 1
local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

-- HELPERS
local function holdE(t)
	pcall(function()
		vim:SendKeyEvent(true,"E",false,game)
		task.wait(t)
		vim:SendKeyEvent(false,"E",false,game)
	end)
end

local function equip(name)
	local char = player.Character
	if not char then return false end
	local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
	if tool and char:FindFirstChild("Humanoid") then
		char.Humanoid:EquipTool(tool)
		task.wait(.2)
		return true
	end
	return false
end

local function countItem(name)
	local total = 0
	for _,v in pairs(player.Backpack:GetChildren()) do
		if v.Name == name then total += 1 end
	end
	local char = player.Character
	if char then
		for _,v in pairs(char:GetChildren()) do
			if v:IsA("Tool") and v.Name == name then total += 1 end
		end
	end
	return total
end

-- ANTI AFK
pcall(function()
	player.Idled:Connect(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
end)

-- COLOR
local C = {
	bg = Color3.fromRGB(20,18,28),
	card = Color3.fromRGB(30,28,40),
	accent = Color3.fromRGB(130,60,240),
	green = Color3.fromRGB(55,200,110),
	red = Color3.fromRGB(220,60,75),
	text = Color3.fromRGB(255,255,255),
	textMid = Color3.fromRGB(180,175,200),
}

-- NOTIF
local function notify(title, msg, ntype)
	pcall(function()
		local color = ntype == "success" and C.green or ntype == "error" and C.red or C.accent
		local notif = Instance.new("Frame", gui)
		notif.Size = UDim2.new(0, 250, 0, 50)
		notif.Position = UDim2.new(1, -260, 1, -60)
		notif.BackgroundColor3 = C.card
		notif.BorderSizePixel = 0
		Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
		
		local t = Instance.new("TextLabel", notif)
		t.Size = UDim2.new(1, -10, 0, 18)
		t.Position = UDim2.new(0, 5, 0, 5)
		t.BackgroundTransparency = 1
		t.Text = title
		t.Font = Enum.Font.GothamBold
		t.TextSize = 11
		t.TextColor3 = color
		t.TextXAlignment = Enum.TextXAlignment.Left
		
		local m = Instance.new("TextLabel", notif)
		m.Size = UDim2.new(1, -10, 0, 20)
		m.Position = UDim2.new(0, 5, 0, 24)
		m.BackgroundTransparency = 1
		m.Text = msg
		m.Font = Enum.Font.Gotham
		m.TextSize = 10
		m.TextColor3 = C.textMid
		m.TextXAlignment = Enum.TextXAlignment.Left
		
		notif.Position = UDim2.new(1, 0, 1, -60)
		TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, -260, 1, -60)}):Play()
		task.delay(3, function()
			TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 1, -60)}):Play()
			task.wait(0.3)
			notif:Destroy()
		end)
	end)
end

-- ============================================================
-- GUI
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIR_3_5"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.Enabled = true

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 400)
main.Position = UDim2.new(0.5, -250, 0.5, -200)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- TITLE BAR
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = C.card
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1, 0, 1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "ELIXIR 3.5 - FULLY NV"
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 14
titleLbl.TextColor3 = C.text

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = C.red
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = C.text
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- TAB BUTTONS
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.Position = UDim2.new(0, 0, 0, 35)
tabBar.BackgroundColor3 = C.card
tabBar.BorderSizePixel = 0

local tabs = {"FARM", "AUTO", "FULLY NV", "TP", "STATUS"}
local tabBtns = {}
local pages = {}

for i, tabName in ipairs(tabs) do
	local btn = Instance.new("TextButton", tabBar)
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.Position = UDim2.new(0, (i-1)*100, 0, 0)
	btn.BackgroundTransparency = 1
	btn.Text = tabName
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.TextColor3 = (i == 1) and C.accent or C.textMid
	
	local page = Instance.new("ScrollingFrame", main)
	page.Size = UDim2.new(1, 0, 1, -75)
	page.Position = UDim2.new(0, 0, 0, 75)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.Visible = (i == 1)
	page.CanvasSize = UDim2.new(0, 0, 0, 400)
	
	tabBtns[i] = btn
	pages[tabName] = page
	
	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do p.Visible = false end
		for _, b in pairs(tabBtns) do b.TextColor3 = C.textMid end
		btn.TextColor3 = C.accent
		pages[tabName].Visible = true
	end)
end

-- UI HELPER
local function card(parent, y, h)
	local f = Instance.new("Frame", parent)
	f.Size = UDim2.new(1, -20, 0, h or 40)
	f.Position = UDim2.new(0, 10, 0, y)
	f.BackgroundColor3 = C.card
	f.BorderSizePixel = 0
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	return f
end

local function btn(parent, y, text, color)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1, -20, 0, 35)
	b.Position = UDim2.new(0, 10, 0, y)
	b.BackgroundColor3 = color or C.accent
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.TextColor3 = C.text
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	return b
end

local function label(parent, y, text, col)
	local l = Instance.new("TextLabel", parent)
	l.Size = UDim2.new(1, -20, 0, 20)
	l.Position = UDim2.new(0, 10, 0, y)
	l.BackgroundTransparency = 1
	l.Text = text
	l.Font = Enum.Font.Gotham
	l.TextSize = 11
	l.TextColor3 = col or C.textMid
	l.TextXAlignment = Enum.TextXAlignment.Left
	return l
end

-- ============================================================
-- FARM PAGE
-- ============================================================
local farmPage = pages["FARM"]

local invY = 10
label(farmPage, invY, "Inventory:")

local waterLabel = label(farmPage, invY+25, "Water: 0", C.text)
local sugarLabel = label(farmPage, invY+50, "Sugar: 0", C.text)
local gelatinLabel = label(farmPage, invY+75, "Gelatin: 0", C.text)
local bagLabel = label(farmPage, invY+100, "Empty Bag: 0", C.text)

local farmRunning = false
local farmBtn = btn(farmPage, 160, "START FARM", C.green)

local function updateInventory()
	waterLabel.Text = "Water: " .. countItem("Water")
	sugarLabel.Text = "Sugar Block Bag: " .. countItem("Sugar Block Bag")
	gelatinLabel.Text = "Gelatin: " .. countItem("Gelatin")
	bagLabel.Text = "Empty Bag: " .. countItem("Empty Bag")
end

local function farmLoop()
	while farmRunning do
		if countItem("Water") == 0 or countItem("Sugar Block Bag") == 0 or countItem("Gelatin") == 0 then
			notify("Farm", "Bahan habis!", "error")
			break
		end
		if equip("Water") then holdE(0.7) task.wait(20) end
		if equip("Sugar Block Bag") then holdE(0.7) task.wait(1) end
		if equip("Gelatin") then holdE(0.7) task.wait(1) end
		task.wait(45)
		if equip("Empty Bag") then holdE(0.7) task.wait(1) end
		updateInventory()
	end
	farmBtn.Text = "START FARM"
	farmBtn.BackgroundColor3 = C.green
end

farmBtn.MouseButton1Click:Connect(function()
	farmRunning = not farmRunning
	if farmRunning then
		farmBtn.Text = "STOP FARM"
		farmBtn.BackgroundColor3 = C.red
		notify("Farm", "Auto farm dimulai", "success")
		task.spawn(farmLoop)
	else
		notify("Farm", "Auto farm dihentikan", "error")
	end
end)

-- BUY BUTTON
local buyBtn = btn(farmPage, 210, "BUY BAHAN (1x)", C.accent)
buyBtn.MouseButton1Click:Connect(function()
	pcall(function() buyRemote:FireServer("Water") end) task.wait(0.3)
	pcall(function() buyRemote:FireServer("Sugar Block Bag") end) task.wait(0.3)
	pcall(function() buyRemote:FireServer("Gelatin") end) task.wait(0.3)
	pcall(function() buyRemote:FireServer("Empty Bag") end)
	task.wait(0.5)
	updateInventory()
	notify("Buy", "Bahan dibeli", "success")
end)

-- SELL BUTTON
local sellRunning = false
local sellBtn = btn(farmPage, 260, "AUTO SELL: OFF", C.card)
sellBtn.MouseButton1Click:Connect(function()
	sellRunning = not sellRunning
	if sellRunning then
		sellBtn.Text = "AUTO SELL: ON"
		sellBtn.BackgroundColor3 = C.green
		task.spawn(function()
			while sellRunning do
				local bags = {"Small Marshmallow Bag","Medium Marshmallow Bag","Large Marshmallow Bag"}
				for _,bag in pairs(bags) do
					while countItem(bag) > 0 and sellRunning do
						if equip(bag) then holdE(0.7) task.wait(1) end
					end
				end
				task.wait(2)
			end
		end)
		notify("Sell", "Auto sell aktif", "success")
	else
		sellBtn.Text = "AUTO SELL: OFF"
		sellBtn.BackgroundColor3 = C.card
		notify("Sell", "Auto sell nonaktif", "error")
	end
end)

-- ============================================================
-- FULLY NV PAGE
-- ============================================================
local fullyPage = pages["FULLY NV"]

local fullyRunning = false
local selectedApart = 1
local selectedPosition = "kanan"

-- APART CONFIG
local APART_STAGES = {
	[1] = {
		name = "APART CASINO 1",
		stages = {
			CFrame.new(1196.51, 3.71, -241.13) * CFrame.Angles(-0.00, -0.05, 0.00),
			CFrame.new(1199.75, 3.71, -238.12) * CFrame.Angles(-0.00, -0.05, -0.00),
			CFrame.new(1199.74, 6.59, -233.05) * CFrame.Angles(-0.00, 0.00, -0.00),
			CFrame.new(1199.66, 6.59, -227.75) * CFrame.Angles(0.00, -0.00, 0.00),
			CFrame.new(1199.66, 6.59, -227.75) * CFrame.Angles(0.00, -0.00, 0.00),
			CFrame.new(1199.91, 7.56, -219.75) * CFrame.Angles(-0.00, 0.05, 0.00),
			CFrame.new(1199.87, 15.96, -215.33) * CFrame.Angles(0.00, 0.05, 0.00),
		},
		altStages = {
			nil, nil, nil, nil,
			CFrame.new(1199.95, 7.07, -177.69) * CFrame.Angles(-0.00, 0.01, 0.00),
			CFrame.new(1199.75, 7.45, -217.66) * CFrame.Angles(0.00, -0.12, -0.00),
			CFrame.new(1199.38, 15.96, -220.53) * CFrame.Angles(0.00, 0.06, 0.00),
		}
	},
	[2] = {
		name = "APART CASINO 2",
		stages = {
			CFrame.new(1186.34, 3.71, -242.92) * CFrame.Angles(0.00, -0.06, 0.00),
			CFrame.new(1183.00, 6.59, -233.78) * CFrame.Angles(-0.00, 0.00, 0.00),
			CFrame.new(1182.70, 7.32, -229.73) * CFrame.Angles(-0.00, -0.01, 0.00),
			CFrame.new(1182.75, 6.59, -224.78) * CFrame.Angles(-0.00, -0.01, 0.00),
			CFrame.new(1183.43, 15.96, -229.66) * CFrame.Angles(0.00, 0.02, -0.00),
		},
		altStages = {nil, nil, nil, nil, CFrame.new(1183.22, 15.96, -225.63) * CFrame.Angles(0.00, -0.04, -0.00)}
	},
	[3] = {
		name = "APART CASINO 3",
		stages = {
			CFrame.new(1196.17, 3.71, -205.72) * CFrame.Angles(0.00, -0.03, -0.00),
			CFrame.new(1199.76, 3.71, -196.51) * CFrame.Angles(0.00, -0.04, 0.00),
			CFrame.new(1199.69, 6.59, -191.16) * CFrame.Angles(-0.00, -0.06, -0.00),
			CFrame.new(1199.42, 6.59, -185.27) * CFrame.Angles(-0.00, 0.01, 0.00),
			CFrame.new(1199.42, 6.59, -185.27) * CFrame.Angles(-0.00, 0.01, 0.00),
			CFrame.new(1199.55, 15.96, -181.89) * CFrame.Angles(0.00, -0.09, 0.00),
		},
		altStages = {nil, nil, nil, nil, CFrame.new(1199.95, 7.07, -177.69) * CFrame.Angles(-0.00, 0.01, 0.00), CFrame.new(1199.46, 15.96, -177.81) * CFrame.Angles(-0.00, -0.05, -0.00)}
	},
	[4] = {
		name = "APART CASINO 4",
		stages = {
			CFrame.new(1187.70, 3.71, -209.73) * CFrame.Angles(0.00, -0.03, 0.00),
			CFrame.new(1182.27, 3.71, -204.65) * CFrame.Angles(-0.00, 0.09, -0.00),
			CFrame.new(1182.23, 3.71, -198.77) * CFrame.Angles(0.00, -0.04, -0.00),
			CFrame.new(1183.06, 6.59, -193.92) * CFrame.Angles(0.00, 0.08, -0.00),
			CFrame.new(1182.60, 7.56, -191.29) * CFrame.Angles(-0.00, -0.02, -0.00),
			CFrame.new(1183.24, 15.96, -191.25) * CFrame.Angles(-0.00, -0.01, 0.00),
		},
		altStages = {nil, nil, nil, nil, CFrame.new(1183.36, 6.72, -187.25) * CFrame.Angles(-0.00, -0.04, -0.00), CFrame.new(1183.08, 15.96, -187.36) * CFrame.Angles(-0.00, -0.05, -0.00)}
	}
}

label(fullyPage, 10, "Pilih Apart:")
local apartRow = card(fullyPage, 35, 40)
for i = 1, 4 do
	local apartBtn = Instance.new("TextButton", apartRow)
	apartBtn.Size = UDim2.new(0, 60, 0, 30)
	apartBtn.Position = UDim2.new(0, 10 + (i-1)*70, 0.5, -15)
	apartBtn.BackgroundColor3 = (i == 1) and C.accent or C.card
	apartBtn.Text = tostring(i)
	apartBtn.Font = Enum.Font.GothamBold
	apartBtn.TextSize = 14
	apartBtn.TextColor3 = C.text
	apartBtn.BorderSizePixel = 0
	Instance.new("UICorner", apartBtn).CornerRadius = UDim.new(0, 6)
	apartBtn.MouseButton1Click:Connect(function()
		selectedApart = i
		for _, btn in pairs(apartRow:GetChildren()) do
			if btn:IsA("TextButton") then
				btn.BackgroundColor3 = C.card
			end
		end
		apartBtn.BackgroundColor3 = C.accent
		notify("Fully NV", "Apart " .. i .. " dipilih", "success")
	end)
end

label(fullyPage, 90, "Pilih Posisi:")
local posRow = card(fullyPage, 115, 40)
local posKanan = Instance.new("TextButton", posRow)
posKanan.Size = UDim2.new(0, 80, 0, 30)
posKanan.Position = UDim2.new(0, 10, 0.5, -15)
posKanan.BackgroundColor3 = C.accent
posKanan.Text = "KANAN"
posKanan.Font = Enum.Font.GothamBold
posKanan.TextSize = 12
posKanan.TextColor3 = C.text
posKanan.BorderSizePixel = 0
Instance.new("UICorner", posKanan).CornerRadius = UDim.new(0, 6)

local posKiri = Instance.new("TextButton", posRow)
posKiri.Size = UDim2.new(0, 80, 0, 30)
posKiri.Position = UDim2.new(0, 100, 0.5, -15)
posKiri.BackgroundColor3 = C.card
posKiri.Text = "KIRI"
posKiri.Font = Enum.Font.GothamBold
posKiri.TextSize = 12
posKiri.TextColor3 = C.text
posKiri.BorderSizePixel = 0
Instance.new("UICorner", posKiri).CornerRadius = UDim.new(0, 6)

posKanan.MouseButton1Click:Connect(function()
	selectedPosition = "kanan"
	posKanan.BackgroundColor3 = C.accent
	posKiri.BackgroundColor3 = C.card
	notify("Fully NV", "Posisi Kanan dipilih", "success")
end)

posKiri.MouseButton1Click:Connect(function()
	selectedPosition = "kiri"
	posKanan.BackgroundColor3 = C.card
	posKiri.BackgroundColor3 = C.accent
	notify("Fully NV", "Posisi Kiri dipilih", "success")
end)

local fullyStatus = label(fullyPage, 170, "Status: Siap", C.textMid)

local function blinkTo(pos)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = pos
		root.AssemblyLinearVelocity = Vector3.zero
	end
end

local function spamEOnce()
	for i = 1, 3 do
		vim:SendKeyEvent(true, "E", false, game)
		task.wait(0.05)
		vim:SendKeyEvent(false, "E", false, game)
		task.wait(0.05)
	end
end

local function cookStep()
	if equip("Water") then spamEOnce() task.wait(20) end
	if equip("Sugar Block Bag") then spamEOnce() task.wait(1) end
	if equip("Gelatin") then spamEOnce() task.wait(1) task.wait(0.5) end
	if equip("Empty Bag") then spamEOnce() task.wait(1.5) end
end

local function fullyLoop()
	local apart = selectedApart
	local pos = selectedPosition
	local stages = APART_STAGES[apart].stages
	local altStages = APART_STAGES[apart].altStages
	
	fullyStatus.Text = "Status: Berjalan di " .. APART_STAGES[apart].name
	notify("Fully NV", "Memulai proses", "success")
	
	while fullyRunning do
		if countItem("Water") == 0 or countItem("Sugar Block Bag") == 0 or countItem("Gelatin") == 0 then
			fullyStatus.Text = "Status: Bahan habis!"
			notify("Fully NV", "Bahan habis, berhenti", "error")
			break
		end
		
		for i, cf in ipairs(stages) do
			if not fullyRunning then break end
			
			local targetCF = cf
			if pos == "kiri" and altStages[i] then
				targetCF = altStages[i]
			end
			
			fullyStatus.Text = "Status: Tahap " .. i
			blinkTo(targetCF)
			task.wait(1)
			spamEOnce()
			task.wait(0.3)
			cookStep()
		end
		
		fullyStatus.Text = "Status: Selesai 1 siklus"
		task.wait(1)
	end
	
	fullyStatus.Text = "Status: Berhenti"
end

local startBtn = btn(fullyPage, 220, "START FULLY NV", C.green)
local stopBtn = btn(fullyPage, 270, "STOP FULLY NV", C.red)
stopBtn.Visible = false

startBtn.MouseButton1Click:Connect(function()
	if fullyRunning then return end
	fullyRunning = true
	startBtn.Visible = false
	stopBtn.Visible = true
	task.spawn(fullyLoop)
end)

stopBtn.MouseButton1Click:Connect(function()
	fullyRunning = false
	startBtn.Visible = true
	stopBtn.Visible = false
	notify("Fully NV", "Proses dihentikan", "error")
end)

-- ============================================================
-- AUTO PAGE
-- ============================================================
local autoPage = pages["AUTO"]

local autoStatus = label(autoPage, 10, "Auto Farm: Nonaktif", C.textMid)
local autoBtn = btn(autoPage, 40, "START AUTO FARM", C.green)

local autoFarmRun = false
local autoFarmCooldown = false
local storePos = Vector3.new(510.7584,3.5872,600.3163)

local function autoTeleport(pos)
	local char = player.Character
	local hum = char and char:FindFirstChild("Humanoid")
	local seat = hum and hum.SeatPart
	if seat then
		local vehicle = seat:FindFirstAncestorOfClass("Model")
		if vehicle then
			if not vehicle.PrimaryPart then vehicle.PrimaryPart = seat end
			pcall(function() vehicle:SetPrimaryPartCFrame(CFrame.new(pos)) end)
			task.wait(0.5)
		end
	else
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then root.CFrame = CFrame.new(pos) end
	end
end

local function autoFarmLoop()
	local apartPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
	
	while autoFarmRun do
		autoStatus.Text = "Auto Farm: Beli bahan..."
		autoTeleport(storePos)
		task.wait(0.5)
		for i = 1, 5 do
			pcall(function() buyRemote:FireServer("Water") end) task.wait(0.3)
			pcall(function() buyRemote:FireServer("Sugar Block Bag") end) task.wait(0.3)
			pcall(function() buyRemote:FireServer("Gelatin") end) task.wait(0.3)
			pcall(function() buyRemote:FireServer("Empty Bag") end) task.wait(0.3)
		end
		
		autoStatus.Text = "Auto Farm: Masak..."
		autoTeleport(apartPos)
		task.wait(0.5)
		
		for i = 1, 5 do
			if equip("Water") then holdE(0.7) task.wait(20) end
			if equip("Sugar Block Bag") then holdE(0.7) task.wait(1) end
			if equip("Gelatin") then holdE(0.7) task.wait(1) end
			task.wait(45)
			if equip("Empty Bag") then holdE(0.7) task.wait(1) end
		end
		
		autoStatus.Text = "Auto Farm: Jual..."
		autoTeleport(storePos)
		task.wait(0.5)
		local bags = {"Small Marshmallow Bag","Medium Marshmallow Bag","Large Marshmallow Bag"}
		for _,bag in pairs(bags) do
			while countItem(bag) > 0 do
				if equip(bag) then holdE(0.7) task.wait(1) end
			end
		end
		
		autoStatus.Text = "Auto Farm: Loop..."
		task.wait(2)
	end
	autoStatus.Text = "Auto Farm: Berhenti"
end

autoBtn.MouseButton1Click:Connect(function()
	autoFarmRun = not autoFarmRun
	if autoFarmRun then
		autoBtn.Text = "STOP AUTO FARM"
		autoBtn.BackgroundColor3 = C.red
		autoStatus.Text = "Auto Farm: Berjalan"
		notify("Auto Farm", "Dimulai", "success")
		task.spawn(autoFarmLoop)
	else
		autoBtn.Text = "START AUTO FARM"
		autoBtn.BackgroundColor3 = C.green
		notify("Auto Farm", "Dihentikan", "error")
	end
end)

-- ============================================================
-- TP PAGE
-- ============================================================
local tpPage = pages["TP"]

local tpList = {
	{"NPC Store", Vector3.new(510.76, 3.58, 600.79)},
	{"Apart 1", Vector3.new(1140.3, 10.1, 450.25)},
	{"Apart 2", Vector3.new(1141.4, 10.1, 422.8)},
	{"Apart 3", Vector3.new(986.98, 10.1, 248.43)},
	{"Apart 4", Vector3.new(986.29, 10.1, 219.94)},
	{"CSN 1", Vector3.new(1178.83, 3.95, -227.37)},
	{"CSN 2", Vector3.new(1205.08, 3.95, -220.54)},
	{"CSN 3", Vector3.new(1204.28, 3.71, -182.85)},
	{"CSN 4", Vector3.new(1178.58, 3.71, -189.71)},
}

for i, loc in ipairs(tpList) do
	local yPos = 10 + (i-1) * 35
	local tpBtn2 = btn(tpPage, yPos, loc[1], C.card)
	tpBtn2.MouseButton1Click:Connect(function()
		vehicleTeleport(CFrame.new(loc[2]))
		notify("Teleport", "Ke " .. loc[1], "success")
	end)
end

-- ============================================================
-- STATUS PAGE
-- ============================================================
local statusPage = pages["STATUS"]

local statWater = label(statusPage, 10, "Water: 0")
local statSugar = label(statusPage, 35, "Sugar Block Bag: 0")
local statGelatin = label(statusPage, 60, "Gelatin: 0")
local statSmall = label(statusPage, 85, "Small Marshmallow: 0")
local statMedium = label(statusPage, 110, "Medium Marshmallow: 0")
local statLarge = label(statusPage, 135, "Large Marshmallow: 0")
local statTotal = label(statusPage, 160, "Total MS: 0", C.accent)

task.spawn(function()
	while gui and gui.Parent do
		pcall(function()
			statWater.Text = "Water: " .. countItem("Water")
			statSugar.Text = "Sugar Block Bag: " .. countItem("Sugar Block Bag")
			statGelatin.Text = "Gelatin: " .. countItem("Gelatin")
			local sm = countItem("Small Marshmallow Bag")
			local md = countItem("Medium Marshmallow Bag")
			local lg = countItem("Large Marshmallow Bag")
			statSmall.Text = "Small Marshmallow: " .. sm
			statMedium.Text = "Medium Marshmallow: " .. md
			statLarge.Text = "Large Marshmallow: " .. lg
			statTotal.Text = "Total MS: " .. (sm+md+lg)
		end)
		task.wait(1)
	end
end)

-- DRAG
local dragStart, startPos
titleBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragStart = i.Position
		startPos = main.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragStart and i.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = i.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragStart = nil
	end
end)

-- KEYBIND Z
ContextActionService:BindAction("toggleUI", function(_, state)
	if state == Enum.UserInputState.Begin then
		main.Visible = not main.Visible
	end
end, false, Enum.KeyCode.Z)

-- START
notify("ELIXIR", "Script loaded! Tekan Z untuk hide/show", "success")
print("ELIXIR 3.5 LOADED - GUI HARUS MUNCUL")
