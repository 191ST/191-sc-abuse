-- ELIXIR 3.5 XENO EDITION -- FIXED VERSION
-- KHUSUS XENO EXECUTOR (MANUAL POSITIONING)

local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local ContextActionService = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

repeat task.wait() until player.Character
repeat task.wait() until player.Character:FindFirstChild("HumanoidRootPart")

local playerGui = player:WaitForChild("PlayerGui")

pcall(function() playerGui:FindFirstChild("ELIXIR_3_5"):Destroy() end)
pcall(function() game.CoreGui:FindFirstChild("ELIXIR_3_5"):Destroy() end)

-- ============================================================
-- VARIABLES
-- ============================================================
local running = false
local autoSellEnabled = false
local buyAmount = 1
local autoFarmRunning = false
local autoFarmStopping = false
local cookAmount = 5
local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase
local npcPos = CFrame.new(510.762817,3.58721066,600.791504)
local tierPos = CFrame.new(1110.18726,4.28433371,117.139168)

-- ============================================================
-- HELPERS
-- ============================================================
local function holdE(t)
	pcall(function()
		vim:SendKeyEvent(true,"E",false,game)
		task.wait(t or 0.7)
		vim:SendKeyEvent(false,"E",false,game)
	end)
end

local function equip(name)
	local char = player.Character
	if not char then return false end
	local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
	if tool and char:FindFirstChild("Humanoid") then
		char.Humanoid:EquipTool(tool)
		task.wait(.3)
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

local function vehicleTeleport(cf)
	local char = player.Character
	if not char then return end
	local humanoid = char:FindFirstChild("Humanoid")
	if not humanoid then return end
	local seat = humanoid.SeatPart
	if not seat then return end
	local vehicle = seat:FindFirstAncestorOfClass("Model")
	if not vehicle then return end
	if not vehicle.PrimaryPart then vehicle.PrimaryPart = seat end
	pcall(function() vehicle:SetPrimaryPartCFrame(cf) end)
	task.wait(0.5)
end

-- ============================================================
-- NOTIFICATION
-- ============================================================
local notifContainer = Instance.new("Frame")
notifContainer.Size = UDim2.new(0, 270, 1, 0)
notifContainer.Position = UDim2.new(1, -280, 0, 0)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 100

local function notify(title, msg, ntype)
	pcall(function()
		local color = ntype == "success" and Color3.fromRGB(55,200,110) or ntype == "error" and Color3.fromRGB(220,60,75) or Color3.fromRGB(130,60,240)
		local card = Instance.new("Frame", notifContainer)
		card.Size = UDim2.new(1, 0, 0, 50)
		card.BackgroundColor3 = Color3.fromRGB(24,21,40)
		card.BorderSizePixel = 0
		card.ZIndex = 100
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
		
		local t = Instance.new("TextLabel", card)
		t.Position = UDim2.new(0, 14, 0, 5)
		t.Size = UDim2.new(1, -22, 0, 18)
		t.BackgroundTransparency = 1
		t.Text = title
		t.Font = Enum.Font.GothamBold
		t.TextSize = 12
		t.TextColor3 = color
		t.TextXAlignment = Enum.TextXAlignment.Left
		
		local m = Instance.new("TextLabel", card)
		m.Position = UDim2.new(0, 14, 0, 24)
		m.Size = UDim2.new(1, -22, 0, 20)
		m.BackgroundTransparency = 1
		m.Text = msg
		m.Font = Enum.Font.Gotham
		m.TextSize = 10
		m.TextColor3 = Color3.fromRGB(180,175,200)
		m.TextXAlignment = Enum.TextXAlignment.Left
		m.TextWrapped = true
		
		card.Position = UDim2.new(1, 16, 0, 0)
		task.delay(3, function() pcall(function() card:Destroy() end) end)
	end)
end

-- ============================================================
-- COLOR PALETTE
-- ============================================================
local C = {
	bg        = Color3.fromRGB(8,  7,  14),
	surface   = Color3.fromRGB(14, 12, 24),
	panel     = Color3.fromRGB(18, 16, 30),
	card      = Color3.fromRGB(24, 21, 40),
	sidebar   = Color3.fromRGB(11,  9, 20),
	accent    = Color3.fromRGB(130, 60, 240),
	accentDim = Color3.fromRGB(75,  35, 140),
	accentGlow= Color3.fromRGB(175, 120, 255),
	text      = Color3.fromRGB(220, 215, 245),
	textMid   = Color3.fromRGB(145, 138, 175),
	textDim   = Color3.fromRGB(75,  68, 100),
	green     = Color3.fromRGB(55,  200, 110),
	greenD    = Color3.fromRGB(30,  140, 70),
	red       = Color3.fromRGB(220, 60,  75),
	orange    = Color3.fromRGB(255, 160, 40),
	border    = Color3.fromRGB(38,  32,  62),
}

-- ============================================================
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIR_3_5"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.Enabled = true

notifContainer.Parent = gui

-- MAIN WINDOW
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 660, 0, 480)
main.Position = UDim2.new(0.5, -330, 0.5, -240)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- TOP BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 46)
topBar.BackgroundColor3 = C.surface
topBar.ZIndex = 2
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Position = UDim2.new(0, 16, 0, 0)
titleLbl.Size = UDim2.new(0, 200, 1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "ELIXIR 3.5"
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextColor3 = C.text
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 22)
closeBtn.Text = "x"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = C.red
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -72, 0.5, -14)
minBtn.BackgroundColor3 = C.card
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.TextColor3 = C.textMid
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- SIDEBAR
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 80, 1, -46)
sidebar.Position = UDim2.new(0, 0, 0, 46)
sidebar.BackgroundColor3 = C.sidebar
sidebar.ZIndex = 2

local sidebarLine = Instance.new("Frame", main)
sidebarLine.Size = UDim2.new(0, 1, 1, -46)
sidebarLine.Position = UDim2.new(0, 79, 0, 46)
sidebarLine.BackgroundColor3 = C.border
sidebarLine.BorderSizePixel = 0
sidebarLine.ZIndex = 3

-- CONTENT AREA (Simple Frame tanpa ScrollingFrame)
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -80, 1, -46)
content.Position = UDim2.new(0, 80, 0, 46)
content.BackgroundColor3 = C.panel
content.ClipsDescendants = true

-- ============================================================
-- TAB SYSTEM (Manual)
-- ============================================================
local pages = {}
local currentPage = "FARM"

local tabNames = {"FARM", "AUTO", "STATUS", "TP", "ESP", "RESPAWN", "UNDERPOT", "FULLY NV"}
local tabButtons = {}

for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(0, 68, 0, 36)
	btn.Position = UDim2.new(0, 6, 0, 8 + (i-1) * 40)
	btn.BackgroundTransparency = 1
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.TextColor3 = C.textDim
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
	
	local page = Instance.new("Frame", content)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = (i == 1)
	page.ZIndex = 2
	
	pages[name] = page
	tabButtons[name] = btn
	
	btn.MouseButton1Click:Connect(function()
		currentPage = name
		for n, p in pairs(pages) do p.Visible = (n == name) end
		for n, b in pairs(tabButtons) do b.TextColor3 = (n == name) and C.accentGlow or C.textDim end
	end)
end

-- ============================================================
-- UI BUILDERS (Manual Positioning)
-- ============================================================
local function addLabel(parent, y, text, color, size)
	local l = Instance.new("TextLabel", parent)
	l.Size = UDim2.new(1, -24, 0, size or 20)
	l.Position = UDim2.new(0, 12, 0, y)
	l.BackgroundTransparency = 1
	l.Text = text
	l.Font = Enum.Font.GothamBold
	l.TextSize = size or 11
	l.TextColor3 = color or C.textMid
	l.TextXAlignment = Enum.TextXAlignment.Left
	return l
end

local function addCard(parent, y, h)
	local f = Instance.new("Frame", parent)
	f.Size = UDim2.new(1, -24, 0, h or 40)
	f.Position = UDim2.new(0, 12, 0, y)
	f.BackgroundColor3 = C.card
	f.BorderSizePixel = 0
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	return f
end

local function addButton(parent, y, text, color)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1, -24, 0, 36)
	b.Position = UDim2.new(0, 12, 0, y)
	b.BackgroundColor3 = color or C.accentDim
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.TextColor3 = C.text
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	return b
end

local function addStatRow(parent, y, label)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, -24, 0, 30)
	row.Position = UDim2.new(0, 12, 0, y)
	row.BackgroundColor3 = C.card
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
	
	local lbl = Instance.new("TextLabel", row)
	lbl.Size = UDim2.new(0.6, 0, 1, 0)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = label
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 11
	lbl.TextColor3 = C.textMid
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	
	local val = Instance.new("TextLabel", row)
	val.Size = UDim2.new(0.4, -10, 1, 0)
	val.Position = UDim2.new(0.6, 0, 0, 0)
	val.BackgroundTransparency = 1
	val.Text = "0"
	val.Font = Enum.Font.GothamBold
	val.TextSize = 12
	val.TextColor3 = C.accentGlow
	val.TextXAlignment = Enum.TextXAlignment.Right
	return val
end

-- ============================================================
-- FARM PAGE
-- ============================================================
local fp = pages["FARM"]

addLabel(fp, 5, "STATUS", C.textDim, 18)
local statusCard = addCard(fp, 25, 36)
local statusLabel = Instance.new("TextLabel", statusCard)
statusLabel.Size = UDim2.new(1, -20, 1, 0)
statusLabel.Position = UDim2.new(0, 12, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "IDLE"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 12
statusLabel.TextColor3 = C.textMid
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

addLabel(fp, 75, "INVENTORY", C.textDim, 18)
local waterVal = addStatRow(fp, 95, "Water")
local sugarVal = addStatRow(fp, 130, "Sugar Block Bag")
local gelatinVal = addStatRow(fp, 165, "Gelatin")
local bagVal = addStatRow(fp, 200, "Empty Bag")

addLabel(fp, 245, "CONTROLS", C.textDim, 18)
local farmBtn = addButton(fp, 265, "START FARM", C.accentDim)
local sellBtn = addButton(fp, 310, "AUTO SELL : OFF", C.card)

-- FARM LOGIC
local farmRun = false
local function cookLoop()
	while farmRun do
		if countItem("Water") == 0 or countItem("Sugar Block Bag") == 0 or countItem("Gelatin") == 0 then
			statusLabel.Text = "Bahan habis!"
			break
		end
		if equip("Water") then statusLabel.Text = "Cooking Water..." holdE(0.7) task.wait(20) end
		if equip("Sugar Block Bag") then statusLabel.Text = "Cooking Sugar..." holdE(0.7) task.wait(1) end
		if equip("Gelatin") then statusLabel.Text = "Cooking Gelatin..." holdE(0.7) task.wait(1) end
		statusLabel.Text = "Waiting..." task.wait(45)
		if equip("Empty Bag") then statusLabel.Text = "Collecting..." holdE(0.7) task.wait(1) end
	end
	statusLabel.Text = "IDLE"
end

farmBtn.MouseButton1Click:Connect(function()
	farmRun = not farmRun
	if farmRun then
		farmBtn.Text = "STOP FARM"
		farmBtn.BackgroundColor3 = C.red
		notify("Farm", "Auto farm dimulai!", "success")
		task.spawn(cookLoop)
	else
		farmBtn.Text = "START FARM"
		farmBtn.BackgroundColor3 = C.accentDim
		notify("Farm", "Auto farm dihentikan.", "error")
	end
end)

local sellRun = false
local function autoSellLoop()
	local bags = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
	while sellRun do
		for _, bag in pairs(bags) do
			while countItem(bag) > 0 and sellRun do
				if equip(bag) then holdE(0.7) task.wait(1) end
			end
		end
		task.wait(1)
	end
end

sellBtn.MouseButton1Click:Connect(function()
	sellRun = not sellRun
	if sellRun then
		sellBtn.Text = "AUTO SELL : ON"
		sellBtn.BackgroundColor3 = C.accentDim
		notify("Sell", "Auto sell aktif!", "success")
		task.spawn(autoSellLoop)
	else
		sellBtn.Text = "AUTO SELL : OFF"
		sellBtn.BackgroundColor3 = C.card
		notify("Sell", "Auto sell nonaktif.", "error")
	end
end)

-- ============================================================
-- STATUS PAGE
-- ============================================================
local sp = pages["STATUS"]

addLabel(sp, 5, "INVENTORY", C.textDim, 18)
local statWater = addStatRow(sp, 25, "Water")
local statSugar = addStatRow(sp, 60, "Sugar Block Bag")
local statGelatin = addStatRow(sp, 95, "Gelatin")
local statBag = addStatRow(sp, 130, "Empty Bag")

addLabel(sp, 175, "MARSHMALLOW BAGS", C.textDim, 18)
local statSmall = addStatRow(sp, 195, "Small Bag")
local statMed = addStatRow(sp, 230, "Medium Bag")
local statLarge = addStatRow(sp, 265, "Large Bag")

local totalCard = addCard(sp, 305, 40)
local totalLbl = Instance.new("TextLabel", totalCard)
totalLbl.Size = UDim2.new(0.5, 0, 1, 0)
totalLbl.Position = UDim2.new(0, 12, 0, 0)
totalLbl.BackgroundTransparency = 1
totalLbl.Text = "Total Bags"
totalLbl.Font = Enum.Font.GothamBold
totalLbl.TextSize = 12
totalLbl.TextColor3 = C.text
totalLbl.TextXAlignment = Enum.TextXAlignment.Left

local totalVal = Instance.new("TextLabel", totalCard)
totalVal.Size = UDim2.new(0.5, -12, 1, 0)
totalVal.Position = UDim2.new(0.5, 0, 0, 0)
totalVal.BackgroundTransparency = 1
totalVal.Text = "0"
totalVal.Font = Enum.Font.GothamBlack
totalVal.TextSize = 15
totalVal.TextColor3 = C.accentGlow
totalVal.TextXAlignment = Enum.TextXAlignment.Right

-- ============================================================
-- TP PAGE
-- ============================================================
local tp = pages["TP"]

local tpLocations = {
	{"NPC Store", Vector3.new(510.76, 3.58, 600.79)},
	{"Tier", Vector3.new(1110.18, 4.28, 117.13)},
	{"Apart 1", Vector3.new(1140.31, 10.10, 450.25)},
	{"Apart 2", Vector3.new(1141.39, 10.10, 422.80)},
	{"Apart 3", Vector3.new(986.98, 10.10, 248.43)},
	{"Apart 4", Vector3.new(986.29, 10.10, 219.94)},
	{"CSN 1", Vector3.new(1178.83, 3.95, -227.37)},
	{"CSN 2", Vector3.new(1205.08, 3.95, -220.54)},
}

for i, loc in ipairs(tpLocations) do
	local yPos = 10 + (i-1) * 42
	local btn = addButton(tp, yPos, loc[1], C.card)
	btn.MouseButton1Click:Connect(function()
		vehicleTeleport(CFrame.new(loc[2]))
		notify("Teleport", "Ke " .. loc[1], "success")
	end)
end

-- ============================================================
-- ESP PAGE (TextLabel based)
-- ============================================================
local ep = pages["ESP"]

addLabel(ep, 5, "ESP PLAYER", C.textDim, 18)
local espBtn = addButton(ep, 25, "ENABLE ESP", C.accentDim)

local espEnabled = false
local espLabels = {}

local function updateESP()
	for _, lbl in pairs(espLabels) do pcall(function() lbl:Destroy() end) end
	espLabels = {}
	if not espEnabled then return end
	
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			local label = Instance.new("TextLabel", gui)
			label.Size = UDim2.new(0, 120, 0, 18)
			label.BackgroundTransparency = 1
			label.Text = plr.Name
			label.Font = Enum.Font.GothamBold
			label.TextSize = 11
			label.TextColor3 = C.accentGlow
			label.TextStrokeTransparency = 0.3
			label.ZIndex = 999
			espLabels[plr] = label
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		espBtn.Text = "DISABLE ESP"
		espBtn.BackgroundColor3 = C.red
		updateESP()
		notify("ESP", "ESP diaktifkan", "success")
	else
		espBtn.Text = "ENABLE ESP"
		espBtn.BackgroundColor3 = C.accentDim
		for _, lbl in pairs(espLabels) do pcall(function() lbl:Destroy() end) end
		espLabels = {}
		notify("ESP", "ESP dimatikan", "error")
	end
end)

RunService.RenderStepped:Connect(function()
	if not espEnabled then return end
	local camera = workspace.CurrentCamera
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	
	for plr, label in pairs(espLabels) do
		local plrChar = plr.Character
		local plrRoot = plrChar and plrChar:FindFirstChild("HumanoidRootPart")
		if plrRoot and plrRoot.Position then
			local pos, onScreen = camera:WorldToViewportPoint(plrRoot.Position)
			if onScreen then
				local dist = (root.Position - plrRoot.Position).Magnitude
				if dist < 150 then
					label.Text = plr.Name .. " [" .. math.floor(dist) .. "]"
					label.Position = UDim2.new(0, pos.X - 60, 0, pos.Y - 40)
					label.Visible = true
				else
					label.Visible = false
				end
			else
				label.Visible = false
			end
		else
			label.Visible = false
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	if espEnabled and plr ~= player then
		local label = Instance.new("TextLabel", gui)
		label.Size = UDim2.new(0, 120, 0, 18)
		label.BackgroundTransparency = 1
		label.Text = plr.Name
		label.Font = Enum.Font.GothamBold
		label.TextSize = 11
		label.TextColor3 = C.accentGlow
		label.TextStrokeTransparency = 0.3
		label.ZIndex = 999
		espLabels[plr] = label
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	if espLabels[plr] then pcall(function() espLabels[plr]:Destroy() end) end
	espLabels[plr] = nil
end)

-- ============================================================
-- RESPAWN PAGE
-- ============================================================
local rp = pages["RESPAWN"]

addLabel(rp, 5, "PILIH SPAWN", C.textDim, 18)

local respStatusCard = addCard(rp, 25, 36)
local respStatusLbl = Instance.new("TextLabel", respStatusCard)
respStatusLbl.Size = UDim2.new(1, -20, 1, 0)
respStatusLbl.Position = UDim2.new(0, 12, 0, 0)
respStatusLbl.BackgroundTransparency = 1
respStatusLbl.Text = "Belum dipilih"
respStatusLbl.Font = Enum.Font.GothamSemibold
respStatusLbl.TextSize = 11
respStatusLbl.TextColor3 = C.textMid
respStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local spawnPoints = {
	{"Dealer", Vector3.new(511, 3, 601)},
	{"RS 1", Vector3.new(1140.8, 10.1, 451.8)},
	{"RS 2", Vector3.new(1141.2, 10.1, 423.2)},
	{"Tier 1", Vector3.new(985.9, 10.1, 247)},
	{"Tier 2", Vector3.new(989.3, 11.0, 228.3)},
	{"GS Ujung", Vector3.new(-467.1, 4.8, 353.5)},
	{"GS Mid", Vector3.new(218.7, 3.7, -176.2)},
}

local selectedSpawn = nil
local spawnBtns = {}

for i, sp in ipairs(spawnPoints) do
	local yPos = 70 + (i-1) * 38
	local btn = addButton(rp, yPos, sp[1], C.card)
	btn.MouseButton1Click:Connect(function()
		selectedSpawn = sp[2]
		for _, b in pairs(spawnBtns) do b.BackgroundColor3 = C.card end
		btn.BackgroundColor3 = C.accentDim
		respStatusLbl.Text = sp[1]
		notify("Spawn", sp[1] .. " dipilih", "success")
	end)
	spawnBtns[i] = btn
end

local respawnBtn = addButton(rp, 70 + #spawnPoints * 38 + 10, "RESPAWN SEKARANG", C.accent)
respawnBtn.MouseButton1Click:Connect(function()
	if not selectedSpawn then
		notify("Respawn", "Pilih spawn terlebih dulu!", "error")
		return
	end
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	notify("Respawn", "Sedang respawn...", "info")
	task.wait(0.3)
	hum.Health = 0
	task.wait(0.2)
	player.CharacterAdded:Wait()
	task.wait(0.5)
	local newChar = player.Character
	local hrp = newChar and newChar:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.CFrame = CFrame.new(selectedSpawn) end
	notify("Respawn", "Berhasil respawn!", "success")
	respStatusLbl.Text = "Respawn berhasil!"
end)

-- ============================================================
-- UNDERPOT PAGE
-- ============================================================
local up = pages["UNDERPOT"]

addLabel(up, 5, "LOWER ROAD", C.textDim, 18)
local lowerBtn = addButton(up, 25, "LOWER ROAD (6 studs)", C.accentDim)

local roadLowered = false
local loweredParts = {}

lowerBtn.MouseButton1Click:Connect(function()
	roadLowered = not roadLowered
	if roadLowered then
		lowerBtn.Text = "RESTORE ROAD"
		lowerBtn.BackgroundColor3 = C.green
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and (obj.Name:lower():find("road") or obj.Name:lower():find("ground")) then
				table.insert(loweredParts, {obj = obj, cf = obj.CFrame})
				obj.CFrame = obj.CFrame * CFrame.new(0, -6, 0)
			end
		end
		notify("Underpot", "Road diturunkan", "success")
	else
		lowerBtn.Text = "LOWER ROAD"
		lowerBtn.BackgroundColor3 = C.accentDim
		for _, data in pairs(loweredParts) do
			if data.obj and data.obj.Parent then data.obj.CFrame = data.cf end
		end
		loweredParts = {}
		notify("Underpot", "Road dikembalikan", "error")
	end
end)

addLabel(up, 80, "DELETE FLOOR", C.textDim, 18)
local deleteBtn = addButton(up, 100, "DELETE FLOOR DI BAWAH", C.red)
deleteBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local result = workspace:Raycast(hrp.Position, Vector3.new(0, -15, 0))
	if result and result.Instance then
		result.Instance:Destroy()
		notify("Underpot", "Part dihapus", "success")
	else
		notify("Underpot", "Tidak ada part", "error")
	end
end)

addLabel(up, 155, "PROMPT SCANNER", C.textDim, 18)
local scanBtn = addButton(up, 175, "SCAN PROMPTS", C.accentDim)
local restorePromptBtn = addButton(up, 220, "RESTORE PROMPTS", C.card)

local scannedPrompts = {}

scanBtn.MouseButton1Click:Connect(function()
	local count = 0
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			scannedPrompts[v] = {maxDist = v.MaxActivationDistance, lineSight = v.RequiresLineOfSight, enabled = v.Enabled}
			v.MaxActivationDistance = 20
			v.RequiresLineOfSight = false
			v.Enabled = true
			count += 1
		end
	end
	notify("Prompt", count .. " prompt dimodifikasi", "success")
end)

restorePromptBtn.MouseButton1Click:Connect(function()
	local count = 0
	for prompt, data in pairs(scannedPrompts) do
		if prompt and prompt.Parent then
			prompt.MaxActivationDistance = data.maxDist
			prompt.RequiresLineOfSight = data.lineSight
			prompt.Enabled = data.enabled
			count += 1
		end
	end
	scannedPrompts = {}
	notify("Prompt", count .. " prompt di-restore", "info")
end)

-- ============================================================
-- FULLY NV PAGE
-- ============================================================
local fullyPage = pages["FULLY NV"]

addLabel(fullyPage, 5, "FULLY NV - APART CASINO", C.accentGlow, 16)

local infoCard = addCard(fullyPage, 28, 50)
local infoLbl = Instance.new("TextLabel", infoCard)
infoLbl.Size = UDim2.new(1, -16, 1, 0)
infoLbl.Position = UDim2.new(0, 8, 0, 0)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "Auto Cook di Apart Casino | Teleport + Spam E otomatis"
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextSize = 11
infoLbl.TextColor3 = C.textMid
infoLbl.TextWrapped = true

addLabel(fullyPage, 90, "PILIH APART", C.textDim, 16)

local apartRow = addCard(fullyPage, 108, 45)
local apartLabel = Instance.new("TextLabel", apartRow)
apartLabel.Size = UDim2.new(0.3, 0, 1, 0)
apartLabel.Position = UDim2.new(0, 10, 0, 0)
apartLabel.BackgroundTransparency = 1
apartLabel.Text = "Apart:"
apartLabel.Font = Enum.Font.GothamBold
apartLabel.TextSize = 12
apartLabel.TextColor3 = C.text
apartLabel.TextXAlignment = Enum.TextXAlignment.Left

local selectedApart = 1
local apartBtns = {}
for i = 1, 4 do
	local btn = Instance.new("TextButton", apartRow)
	btn.Size = UDim2.new(0, 50, 0, 30)
	btn.Position = UDim2.new(0.35 + (i-1) * 0.15, 0, 0.5, -15)
	btn.BackgroundColor3 = (i == 1) and C.accent or C.card
	btn.Text = tostring(i)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = C.text
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(function()
		selectedApart = i
		for _, b in pairs(apartBtns) do b.BackgroundColor3 = C.card end
		btn.BackgroundColor3 = C.accent
		notify("Fully NV", "Apart " .. i .. " dipilih", "success")
	end)
	apartBtns[i] = btn
end

addLabel(fullyPage, 168, "PILIH POSISI", C.textDim, 16)

local posRow = addCard(fullyPage, 186, 45)
local selectedPos = "kanan"
local posKanan = Instance.new("TextButton", posRow)
posKanan.Size = UDim2.new(0, 80, 0, 30)
posKanan.Position = UDim2.new(0.25, 0, 0.5, -15)
posKanan.BackgroundColor3 = C.accent
posKanan.Text = "KANAN"
posKanan.Font = Enum.Font.GothamBold
posKanan.TextSize = 12
posKanan.TextColor3 = C.text
posKanan.BorderSizePixel = 0
Instance.new("UICorner", posKanan).CornerRadius = UDim.new(0, 6)

local posKiri = Instance.new("TextButton", posRow)
posKiri.Size = UDim2.new(0, 80, 0, 30)
posKiri.Position = UDim2.new(0.55, 0, 0.5, -15)
posKiri.BackgroundColor3 = C.card
posKiri.Text = "KIRI"
posKiri.Font = Enum.Font.GothamBold
posKiri.TextSize = 12
posKiri.TextColor3 = C.text
posKiri.BorderSizePixel = 0
Instance.new("UICorner", posKiri).CornerRadius = UDim.new(0, 6)

posKanan.MouseButton1Click:Connect(function()
	selectedPos = "kanan"
	posKanan.BackgroundColor3 = C.accent
	posKiri.BackgroundColor3 = C.card
	notify("Fully NV", "Posisi Kanan dipilih", "success")
end)

posKiri.MouseButton1Click:Connect(function()
	selectedPos = "kiri"
	posKanan.BackgroundColor3 = C.card
	posKiri.BackgroundColor3 = C.accent
	notify("Fully NV", "Posisi Kiri dipilih", "success")
end)

addLabel(fullyPage, 246, "STATUS", C.textDim, 16)

local nvStatusCard = addCard(fullyPage, 264, 36)
local nvStatusLbl = Instance.new("TextLabel", nvStatusCard)
nvStatusLbl.Size = UDim2.new(1, -16, 1, 0)
nvStatusLbl.Position = UDim2.new(0, 8, 0, 0)
nvStatusLbl.BackgroundTransparency = 1
nvStatusLbl.Text = "Belum dimulai"
nvStatusLbl.Font = Enum.Font.Gotham
nvStatusLbl.TextSize = 11
nvStatusLbl.TextColor3 = C.textMid
nvStatusLbl.TextWrapped = true

-- APART CASINO COORDINATES
local APART_STAGES = {
	[1] = {
		name = "APART CASINO 1",
		stages = {
			CFrame.new(1196.51, 3.71, -241.13),
			CFrame.new(1199.75, 3.71, -238.12),
			CFrame.new(1199.74, 6.59, -233.05),
			CFrame.new(1199.66, 6.59, -227.75),
			CFrame.new(1199.66, 6.59, -227.75),
			CFrame.new(1199.91, 7.56, -219.75),
			CFrame.new(1199.87, 15.96, -215.33),
		},
		alt = {nil, nil, nil, nil, CFrame.new(1199.95, 7.07, -177.69), CFrame.new(1199.75, 7.45, -217.66), CFrame.new(1199.38, 15.96, -220.53)}
	},
	[2] = {
		name = "APART CASINO 2",
		stages = {
			CFrame.new(1186.34, 3.71, -242.92),
			CFrame.new(1183.00, 6.59, -233.78),
			CFrame.new(1182.70, 7.32, -229.73),
			CFrame.new(1182.75, 6.59, -224.78),
			CFrame.new(1183.43, 15.96, -229.66),
		},
		alt = {nil, nil, nil, nil, CFrame.new(1183.22, 15.96, -225.63)}
	},
	[3] = {
		name = "APART CASINO 3",
		stages = {
			CFrame.new(1196.17, 3.71, -205.72),
			CFrame.new(1199.76, 3.71, -196.51),
			CFrame.new(1199.69, 6.59, -191.16),
			CFrame.new(1199.42, 6.59, -185.27),
			CFrame.new(1199.42, 6.59, -185.27),
			CFrame.new(1199.55, 15.96, -181.89),
		},
		alt = {nil, nil, nil, nil, CFrame.new(1199.95, 7.07, -177.69), CFrame.new(1199.46, 15.96, -177.81)}
	},
	[4] = {
		name = "APART CASINO 4",
		stages = {
			CFrame.new(1187.70, 3.71, -209.73),
			CFrame.new(1182.27, 3.71, -204.65),
			CFrame.new(1182.23, 3.71, -198.77),
			CFrame.new(1183.06, 6.59, -193.92),
			CFrame.new(1182.60, 7.56, -191.29),
			CFrame.new(1183.24, 15.96, -191.25),
		},
		alt = {nil, nil, nil, nil, CFrame.new(1183.36, 6.72, -187.25), CFrame.new(1183.08, 15.96, -187.36)}
	}
}

local function blinkTo(cf)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = cf
		root.AssemblyLinearVelocity = Vector3.zero
	end
end

local function spamEThree()
	for i = 1, 3 do
		pcall(function()
			vim:SendKeyEvent(true, "E", false, game)
			task.wait(0.05)
			vim:SendKeyEvent(false, "E", false, game)
			task.wait(0.05)
		end)
	end
end

local function cookStepNV()
	if equip("Water") then spamEThree() task.wait(20) end
	if equip("Sugar Block Bag") then spamEThree() task.wait(1) end
	if equip("Gelatin") then spamEThree() task.wait(1) task.wait(0.5) end
	if equip("Empty Bag") then spamEThree() task.wait(1.5) end
end

local fullyRunning = false

local function fullyNVLoop()
	local apart = selectedApart
	local pos = selectedPos
	local config = APART_STAGES[apart]
	local stages = config.stages
	local altStages = config.alt
	
	nvStatusLbl.Text = "Berjalan di " .. config.name .. " (" .. pos .. ")"
	
	while fullyRunning do
		if countItem("Water") == 0 or countItem("Sugar Block Bag") == 0 or countItem("Gelatin") == 0 then
			nvStatusLbl.Text = "Bahan habis! Berhenti"
			break
		end
		
		for i, cf in ipairs(stages) do
			if not fullyRunning then break end
			
			local targetCF = cf
			if pos == "kiri" and altStages[i] then
				targetCF = altStages[i]
			end
			
			nvStatusLbl.Text = "Tahap " .. i
			blinkTo(targetCF)
			task.wait(1.5)
			spamEThree()
			task.wait(0.3)
			cookStepNV()
		end
		
		if fullyRunning then
			nvStatusLbl.Text = "Selesai 1 siklus"
			task.wait(1)
		end
	end
	
	nvStatusLbl.Text = "Berhenti"
end

local startNVBtn = addButton(fullyPage, 315, "▶ START FULLY NV", C.greenD)
local stopNVBtn = addButton(fullyPage, 360, "■ STOP FULLY NV", C.red)
stopNVBtn.Visible = false

startNVBtn.MouseButton1Click:Connect(function()
	if fullyRunning then return end
	fullyRunning = true
	startNVBtn.Visible = false
	stopNVBtn.Visible = true
	notify("Fully NV", "Proses dimulai", "success")
	task.spawn(fullyNVLoop)
end)

stopNVBtn.MouseButton1Click:Connect(function()
	fullyRunning = false
	startNVBtn.Visible = true
	stopNVBtn.Visible = false
	notify("Fully NV", "Proses dihentikan", "error")
end)

-- ============================================================
-- AUTO PAGE
-- ============================================================
local autoPage = pages["AUTO"]

addLabel(autoPage, 5, "AUTO FARM", C.textDim, 18)
local autoFarmBtn = addButton(autoPage, 25, "START AUTO FARM", C.accentDim)
local autoStatus = addLabel(autoPage, 70, "Status: Berhenti", C.textMid, 12)

local autoFarmRun = false
local storePos = Vector3.new(510.7584, 3.5872, 600.3163)

local function autoFarmLoop()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local apartPos = root and root.Position or Vector3.new(0, 0, 0)
	
	while autoFarmRun do
		autoStatus.Text = "Status: Beli bahan..."
		vehicleTeleport(CFrame.new(storePos))
		task.wait(0.5)
		for i = 1, 3 do
			pcall(function() buyRemote:FireServer("Water") end) task.wait(0.3)
			pcall(function() buyRemote:FireServer("Sugar Block Bag") end) task.wait(0.3)
			pcall(function() buyRemote:FireServer("Gelatin") end) task.wait(0.3)
			pcall(function() buyRemote:FireServer("Empty Bag") end) task.wait(0.3)
		end
		
		autoStatus.Text = "Status: Masak..."
		vehicleTeleport(CFrame.new(apartPos))
		task.wait(0.5)
		for i = 1, 3 do
			if equip("Water") then holdE(0.7) task.wait(20) end
			if equip("Sugar Block Bag") then holdE(0.7) task.wait(1) end
			if equip("Gelatin") then holdE(0.7) task.wait(1) end
			task.wait(45)
			if equip("Empty Bag") then holdE(0.7) task.wait(1) end
		end
		
		autoStatus.Text = "Status: Jual..."
		vehicleTeleport(CFrame.new(storePos))
		task.wait(0.5)
		local bags = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}
		for _, bag in pairs(bags) do
			while countItem(bag) > 0 do
				if equip(bag) then holdE(0.7) task.wait(1) end
			end
		end
		
		autoStatus.Text = "Status: Loop..."
		task.wait(2)
	end
	autoStatus.Text = "Status: Berhenti"
end

autoFarmBtn.MouseButton1Click:Connect(function()
	autoFarmRun = not autoFarmRun
	if autoFarmRun then
		autoFarmBtn.Text = "STOP AUTO FARM"
		autoFarmBtn.BackgroundColor3 = C.red
		notify("Auto Farm", "Dimulai", "success")
		task.spawn(autoFarmLoop)
	else
		autoFarmBtn.Text = "START AUTO FARM"
		autoFarmBtn.BackgroundColor3 = C.accentDim
		notify("Auto Farm", "Dihentikan", "error")
	end
end)

-- ============================================================
-- STATUS LOOP
-- ============================================================
task.spawn(function()
	while gui and gui.Parent do
		pcall(function()
			local w = countItem("Water")
			local sg = countItem("Sugar Block Bag")
			local ge = countItem("Gelatin")
			local bg = countItem("Empty Bag")
			local sm = countItem("Small Marshmallow Bag")
			local md = countItem("Medium Marshmallow Bag")
			local lg = countItem("Large Marshmallow Bag")
			
			if waterVal then waterVal.Text = tostring(w) end
			if sugarVal then sugarVal.Text = tostring(sg) end
			if gelatinVal then gelatinVal.Text = tostring(ge) end
			if bagVal then bagVal.Text = tostring(bg) end
			if statWater then statWater.Text = tostring(w) end
			if statSugar then statSugar.Text = tostring(sg) end
			if statGelatin then statGelatin.Text = tostring(ge) end
			if statBag then statBag.Text = tostring(bg) end
			if statSmall then statSmall.Text = tostring(sm) end
			if statMed then statMed.Text = tostring(md) end
			if statLarge then statLarge.Text = tostring(lg) end
			if totalVal then totalVal.Text = tostring(sm+md+lg) end
		end)
		task.wait(0.5)
	end
end)

-- ============================================================
-- MINIMIZE BUTTON
-- ============================================================
local bodyVisible = true
minBtn.MouseButton1Click:Connect(function()
	bodyVisible = not bodyVisible
	sidebar.Visible = bodyVisible
	content.Visible = bodyVisible
	if bodyVisible then
		main.Size = UDim2.new(0, 660, 0, 480)
	else
		main.Size = UDim2.new(0, 660, 0, 46)
	end
end)

-- ============================================================
-- HIDE BUTTON & KEYBIND Z
-- ============================================================
local hideBtn = Instance.new("TextButton", gui)
hideBtn.Size = UDim2.new(0, 42, 0, 42)
hideBtn.Position = UDim2.new(1, -52, 0.5, -21)
hideBtn.Text = "E"
hideBtn.Font = Enum.Font.GothamBlack
hideBtn.TextSize = 15
hideBtn.BackgroundColor3 = C.accent
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Active = true
hideBtn.Draggable = true
hideBtn.BorderSizePixel = 0
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 10)

hideBtn.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

ContextActionService:BindAction("toggleUI", function(_, state)
	if state == Enum.UserInputState.Begin then
		main.Visible = not main.Visible
	end
end, false, Enum.KeyCode.Z)

-- ============================================================
-- DRAG WINDOW
-- ============================================================
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

-- ============================================================
-- STARTUP
-- ============================================================
task.wait(0.3)
notify("ELIXIR 3.5", "Script loaded! Tekan Z untuk hide/show", "success")
print("=== ELIXIR 3.5 XENO EDITION LOADED ===")
