-- ELIXIR 3.5 XENO EDITION -- FULL SCRIPT + FULLY NV
-- KHUSUS XENO EXECUTOR

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
main.Size = UDim2.new(0, 660, 0, 430)
main.Position = UDim2.new(0.5, -330, 0.5, -215)
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

-- CONTENT AREA
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -80, 1, -46)
content.Position = UDim2.new(0, 80, 0, 46)
content.BackgroundColor3 = C.panel
content.ClipsDescendants = true

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local pages = {}
local tabBtns = {}

local tabDefs = {
	{label = "FARM",     order = 1},
	{label = "AUTO",     order = 2},
	{label = "STATUS",   order = 3},
	{label = "TP",       order = 4},
	{label = "ESP",      order = 5},
	{label = "RESPAWN",  order = 6},
	{label = "UNDERPOT", order = 7},
	{label = "FULLY NV", order = 8},
}

local function switchTab(name)
	for n, p in pairs(pages) do if p then p.Visible = (n == name) end end
	for n, b in pairs(tabBtns) do if b then b.TextColor3 = (n == name) and C.accentGlow or C.textDim end end
end

for i, def in ipairs(tabDefs) do
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(0, 68, 0, 36)
	btn.Position = UDim2.new(0, 6, 0, 8 + (i-1) * 40)
	btn.BackgroundTransparency = 1
	btn.Text = def.label
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.TextColor3 = C.textDim
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
	
	local page = Instance.new("ScrollingFrame", content)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.Visible = false
	page.BorderSizePixel = 0
	
	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0, 7)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	
	local pad = Instance.new("UIPadding", page)
	pad.PaddingTop = UDim.new(0, 14)
	pad.PaddingLeft = UDim.new(0, 12)
	pad.PaddingRight = UDim.new(0, 12)
	pad.PaddingBottom = UDim.new(0, 14)
	
	pages[def.label] = page
	tabBtns[def.label] = btn
	
	btn.MouseButton1Click:Connect(function() switchTab(def.label) end)
end

-- ============================================================
-- UI COMPONENT BUILDERS
-- ============================================================
local function sectionLabel(parent, text, order)
	local wrap = Instance.new("Frame", parent)
	wrap.Size = UDim2.new(1, 0, 0, 22)
	wrap.BackgroundTransparency = 1
	wrap.LayoutOrder = order or 0
	
	local lbl = Instance.new("TextLabel", wrap)
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text:upper()
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 9
	lbl.TextColor3 = C.textDim
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	return wrap
end

local function card(parent, h, order)
	local f = Instance.new("Frame", parent)
	f.Size = UDim2.new(1, 0, 0, h or 46)
	f.BackgroundColor3 = C.card
	f.BorderSizePixel = 0
	f.LayoutOrder = order or 0
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	return f
end

local function makeActionBtn(parent, text, color, order)
	local f = Instance.new("TextButton", parent)
	f.Size = UDim2.new(1, 0, 0, 36)
	f.BackgroundColor3 = color or C.accentDim
	f.Font = Enum.Font.GothamBold
	f.TextSize = 12
	f.TextColor3 = C.text
	f.Text = text
	f.BorderSizePixel = 0
	f.LayoutOrder = order or 0
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	return f
end

local function makeStatusRow(parent, label, order)
	local f = card(parent, 30, order)
	local lbl2 = Instance.new("TextLabel", f)
	lbl2.Position = UDim2.new(0, 12, 0, 0)
	lbl2.Size = UDim2.new(0.6, 0, 1, 0)
	lbl2.BackgroundTransparency = 1
	lbl2.Text = label
	lbl2.Font = Enum.Font.GothamSemibold
	lbl2.TextSize = 11
	lbl2.TextColor3 = C.textMid
	lbl2.TextXAlignment = Enum.TextXAlignment.Left
	
	local val2 = Instance.new("TextLabel", f)
	val2.Position = UDim2.new(0.6, 0, 0, 0)
	val2.Size = UDim2.new(0.4, -10, 1, 0)
	val2.BackgroundTransparency = 1
	val2.Text = "0"
	val2.Font = Enum.Font.GothamBold
	val2.TextSize = 12
	val2.TextColor3 = C.accentGlow
	val2.TextXAlignment = Enum.TextXAlignment.Right
	return val2
end

local function statRow(parent, y, icon, lbl, valCol)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, -24, 0, 34)
	row.Position = UDim2.new(0, 12, 0, y)
	row.BackgroundColor3 = C.card
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
	
	local nm = Instance.new("TextLabel", row)
	nm.Size = UDim2.new(0.6, 0, 1, 0)
	nm.Position = UDim2.new(0, 12, 0, 0)
	nm.BackgroundTransparency = 1
	nm.Text = lbl
	nm.Font = Enum.Font.Gotham
	nm.TextSize = 11
	nm.TextColor3 = C.textMid
	nm.TextXAlignment = Enum.TextXAlignment.Left
	
	local vl = Instance.new("TextLabel", row)
	vl.Size = UDim2.new(0.4, -10, 1, 0)
	vl.Position = UDim2.new(0.6, 0, 0, 0)
	vl.BackgroundTransparency = 1
	vl.Text = "0"
	vl.Font = Enum.Font.GothamBold
	vl.TextSize = 13
	vl.TextColor3 = valCol or C.accent
	vl.TextXAlignment = Enum.TextXAlignment.Right
	return vl
end

local function line(parent, y)
	local l = Instance.new("Frame", parent)
	l.Size = UDim2.new(1, -24, 0, 1)
	l.Position = UDim2.new(0, 12, 0, y)
	l.BackgroundColor3 = C.border
	l.BorderSizePixel = 0
end

local function secHdr(parent, y, txt)
	local l = Instance.new("TextLabel", parent)
	l.Size = UDim2.new(1, -24, 0, 18)
	l.Position = UDim2.new(0, 12, 0, y)
	l.BackgroundTransparency = 1
	l.Text = txt
	l.Font = Enum.Font.GothamBold
	l.TextSize = 10
	l.TextColor3 = C.textMid
	l.TextXAlignment = Enum.TextXAlignment.Left
	return l
end

-- ============================================================
-- FARM PAGE
-- ============================================================
local fp = pages["FARM"]

secHdr(fp, 8, "STATUS")
local statusCard = card(fp, 36, 2)
local statusLabel = Instance.new("TextLabel", statusCard)
statusLabel.Size = UDim2.new(1, -20, 1, 0)
statusLabel.Position = UDim2.new(0, 12, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "IDLE"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 12
statusLabel.TextColor3 = C.textMid
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

secHdr(fp, 50, "INVENTORY")
local waterVal = makeStatusRow(fp, "Water", 4)
local sugarVal = makeStatusRow(fp, "Sugar Block Bag", 5)
local gelatinVal = makeStatusRow(fp, "Gelatin", 6)
local bagVal = makeStatusRow(fp, "Empty Bag", 7)

secHdr(fp, 190, "CONTROLS")
local farmToggleBtn = makeActionBtn(fp, "START FARM", C.accentDim, 10)
local sellToggleBtn = makeActionBtn(fp, "AUTO SELL : OFF", C.card, 11)

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

farmToggleBtn.MouseButton1Click:Connect(function()
	farmRun = not farmRun
	if farmRun then
		farmToggleBtn.Text = "STOP FARM"
		farmToggleBtn.BackgroundColor3 = C.red
		notify("Farm", "Auto farm dimulai!", "success")
		task.spawn(cookLoop)
	else
		farmToggleBtn.Text = "START FARM"
		farmToggleBtn.BackgroundColor3 = C.accentDim
		notify("Farm", "Auto farm dihentikan.", "error")
	end
end)

-- AUTO SELL
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

sellToggleBtn.MouseButton1Click:Connect(function()
	sellRun = not sellRun
	if sellRun then
		sellToggleBtn.Text = "AUTO SELL : ON"
		sellToggleBtn.BackgroundColor3 = C.accentDim
		notify("Sell", "Auto sell aktif!", "success")
		task.spawn(autoSellLoop)
	else
		sellToggleBtn.Text = "AUTO SELL : OFF"
		sellToggleBtn.BackgroundColor3 = C.card
		notify("Sell", "Auto sell nonaktif.", "error")
	end
end)

-- ============================================================
-- STATUS PAGE
-- ============================================================
local sp = pages["STATUS"]

local avatarCard = card(sp, 70, 1)
local avatarImg = Instance.new("ImageLabel", avatarCard)
avatarImg.Position = UDim2.new(0, 10, 0.5, -26)
avatarImg.Size = UDim2.new(0, 52, 0, 52)
avatarImg.BackgroundColor3 = C.border
avatarImg.BorderSizePixel = 0
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 8)

local usernameLbl = Instance.new("TextLabel", avatarCard)
usernameLbl.Position = UDim2.new(0, 72, 0, 14)
usernameLbl.Size = UDim2.new(1, -82, 0, 20)
usernameLbl.BackgroundTransparency = 1
usernameLbl.Text = player.Name
usernameLbl.Font = Enum.Font.GothamBlack
usernameLbl.TextSize = 15
usernameLbl.TextColor3 = C.text
usernameLbl.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
	pcall(function()
		local img = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		avatarImg.Image = img
	end)
end)

secHdr(sp, 90, "INVENTORY")
local statWater = makeStatusRow(sp, "Water", 3)
local statSugar = makeStatusRow(sp, "Sugar Block Bag", 4)
local statGelatin = makeStatusRow(sp, "Gelatin", 5)
local statBag = makeStatusRow(sp, "Empty Bag", 6)

secHdr(sp, 210, "MARSHMALLOW BAGS")
local statSmall = makeStatusRow(sp, "Small Bag", 7)
local statMed = makeStatusRow(sp, "Medium Bag", 8)
local statLarge = makeStatusRow(sp, "Large Bag", 9)

local totalCard = card(sp, 36, 10)
local totalLbl = Instance.new("TextLabel", totalCard)
totalLbl.Position = UDim2.new(0, 12, 0, 0)
totalLbl.Size = UDim2.new(0.5, 0, 1, 0)
totalLbl.BackgroundTransparency = 1
totalLbl.Text = "Total Bags"
totalLbl.Font = Enum.Font.GothamBold
totalLbl.TextSize = 12
totalLbl.TextColor3 = C.text
totalLbl.TextXAlignment = Enum.TextXAlignment.Left

local totalVal = Instance.new("TextLabel", totalCard)
totalVal.Position = UDim2.new(0.5, 0, 0, 0)
totalVal.Size = UDim2.new(0.5, -12, 1, 0)
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

local locations = {
	{"NPC Store", Vector3.new(510.76, 3.58, 600.79)},
	{"Tier", Vector3.new(1110.18, 4.28, 117.13)},
	{"Apart 1", Vector3.new(1140.31, 10.10, 450.25)},
	{"Apart 2", Vector3.new(1141.39, 10.10, 422.80)},
	{"Apart 3", Vector3.new(986.98, 10.10, 248.43)},
	{"Apart 4", Vector3.new(986.29, 10.10, 219.94)},
	{"Apart 5", Vector3.new(924.78, 10.10, 41.13)},
	{"Apart 6", Vector3.new(896.67, 10.10, 40.64)},
	{"CSN 1", Vector3.new(1178.83, 3.95, -227.37)},
	{"CSN 2", Vector3.new(1205.08, 3.95, -220.54)},
	{"CSN 3", Vector3.new(1204.28, 3.71, -182.85)},
	{"CSN 4", Vector3.new(1178.58, 3.71, -189.71)},
}

for i, loc in ipairs(locations) do
	local yPos = 30 + (i-1) * 42
	local btn = makeActionBtn(tp, loc[1], C.card, i)
	btn.Position = UDim2.new(0, 12, 0, yPos)
	btn.MouseButton1Click:Connect(function()
		vehicleTeleport(CFrame.new(loc[2]))
		notify("Teleport", "Ke " .. loc[1], "success")
	end)
end

-- ============================================================
-- ESP PAGE (tanpa Drawing, pake TextLabel sederhana)
-- ============================================================
local ep = pages["ESP"]

secHdr(ep, 8, "ESP PLAYER")
local espToggleBtn = makeActionBtn(ep, "ENABLE ESP", C.accentDim, 2)

local espEnabled = false
local espLabels = {}

local function updateESP()
	for _, lbl in pairs(espLabels) do
		if lbl then pcall(function() lbl:Destroy() end) end
	end
	espLabels = {}
	
	if not espEnabled then return end
	
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			local label = Instance.new("TextLabel", gui)
			label.Size = UDim2.new(0, 100, 0, 20)
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

espToggleBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		espToggleBtn.Text = "DISABLE ESP"
		espToggleBtn.BackgroundColor3 = C.red
		updateESP()
		notify("ESP", "ESP diaktifkan", "success")
	else
		espToggleBtn.Text = "ENABLE ESP"
		espToggleBtn.BackgroundColor3 = C.accentDim
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
				if dist < 100 then
					label.Text = plr.Name .. " [" .. math.floor(dist) .. "]"
					label.Position = UDim2.new(0, pos.X - 50, 0, pos.Y - 40)
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
		label.Size = UDim2.new(0, 100, 0, 20)
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
	if espLabels[plr] then
		pcall(function() espLabels[plr]:Destroy() end)
		espLabels[plr] = nil
	end
end)

-- ============================================================
-- RESPAWN PAGE
-- ============================================================
local rp = pages["RESPAWN"]

local selectedSpawn = nil

local respStatusCard = card(rp, 36, 1)
local respStatusLbl = Instance.new("TextLabel", respStatusCard)
respStatusLbl.Size = UDim2.new(1, -20, 1, 0)
respStatusLbl.Position = UDim2.new(0, 12, 0, 0)
respStatusLbl.BackgroundTransparency = 1
respStatusLbl.Text = "Belum dipilih"
respStatusLbl.Font = Enum.Font.GothamSemibold
respStatusLbl.TextSize = 11
respStatusLbl.TextColor3 = C.textMid
respStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

secHdr(rp, 50, "PILIH SPAWN")

local spawnPoints = {
	{"Dealer", Vector3.new(511, 3, 601)},
	{"RS 1", Vector3.new(1140.8, 10.1, 451.8)},
	{"RS 2", Vector3.new(1141.2, 10.1, 423.2)},
	{"Tier 1", Vector3.new(985.9, 10.1, 247)},
	{"Tier 2", Vector3.new(989.3, 11.0, 228.3)},
	{"Trash 1", Vector3.new(890.9, 10.1, 44.3)},
	{"Trash 2", Vector3.new(920.4, 10.1, 46.3)},
	{"Dealership", Vector3.new(733.5, 4.6, 431.9)},
	{"GS Ujung", Vector3.new(-467.1, 4.8, 353.5)},
	{"GS Mid", Vector3.new(218.7, 3.7, -176.2)},
}

local spawnBtns = {}
for i, sp in ipairs(spawnPoints) do
	local yPos = 70 + (i-1) * 38
	local btn = makeActionBtn(rp, sp[1], C.card, i)
	btn.Position = UDim2.new(0, 12, 0, yPos)
	btn.MouseButton1Click:Connect(function()
		selectedSpawn = sp[2]
		for _, b in pairs(spawnBtns) do b.BackgroundColor3 = C.card end
		btn.BackgroundColor3 = C.accentDim
		respStatusLbl.Text = sp[1]
		notify("Spawn", sp[1] .. " dipilih", "success")
	end)
	spawnBtns[i] = btn
end

local respawnBtn = makeActionBtn(rp, "RESPAWN SEKARANG", C.accent, #spawnPoints + 1)
respawnBtn.Position = UDim2.new(0, 12, 0, 70 + #spawnPoints * 38)

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
	if hrp then
		hrp.CFrame = CFrame.new(selectedSpawn)
	end
	notify("Respawn", "Berhasil respawn!", "success")
	respStatusLbl.Text = "Respawn berhasil!"
end)

-- ============================================================
-- UNDERPOT PAGE (SEDERHANA)
-- ============================================================
local up = pages["UNDERPOT"]

secHdr(up, 8, "LOWER ROAD")
local lowerRoadBtn = makeActionBtn(up, "LOWER ROAD (6 studs)", C.accentDim, 2)

local roadLowered = false
local loweredParts = {}

lowerRoadBtn.MouseButton1Click:Connect(function()
	roadLowered = not roadLowered
	if roadLowered then
		lowerRoadBtn.Text = "RESTORE ROAD"
		lowerRoadBtn.BackgroundColor3 = C.green
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and (obj.Name:lower():find("road") or obj.Name:lower():find("ground") or obj.Name:lower():find("floor")) then
				table.insert(loweredParts, {obj = obj, cf = obj.CFrame})
				obj.CFrame = obj.CFrame * CFrame.new(0, -6, 0)
			end
		end
		notify("Underpot", "Road diturunkan 6 studs", "success")
	else
		lowerRoadBtn.Text = "LOWER ROAD"
		lowerRoadBtn.BackgroundColor3 = C.accentDim
		for _, data in pairs(loweredParts) do
			if data.obj and data.obj.Parent then
				data.obj.CFrame = data.cf
			end
		end
		loweredParts = {}
		notify("Underpot", "Road dikembalikan", "error")
	end
end)

secHdr(up, 55, "DELETE FLOOR")
local deleteBtn = makeActionBtn(up, "DELETE FLOOR DI BAWAH", C.red, 3)

deleteBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {char}
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local result = workspace:Raycast(hrp.Position, Vector3.new(0, -15, 0), rayParams)
	if result and result.Instance then
		result.Instance:Destroy()
		notify("Underpot", "Part dihapus: " .. result.Instance.Name, "success")
	else
		notify("Underpot", "Tidak ada part di bawah", "error")
	end
end)

secHdr(up, 105, "PROMPT SCANNER")
local scanBtn = makeActionBtn(up, "SCAN PROMPTS", C.accentDim, 4)
local restorePromptBtn = makeActionBtn(up, "RESTORE PROMPTS", C.card, 5)

local scannedPrompts = {}

scanBtn.MouseButton1Click:Connect(function()
	local count = 0
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			scannedPrompts[v] = {
				maxDist = v.MaxActivationDistance,
				lineSight = v.RequiresLineOfSight,
				enabled = v.Enabled,
			}
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
-- FULLY NV PAGE (APART CASINO)
-- ============================================================
local fullyPage = pages["FULLY NV"]

secHdr(fullyPage, 8, "FULLY NV - APART CASINO")

local infoCard = card(fullyPage, 32, 2)
local infoLbl = Instance.new("TextLabel", infoCard)
infoLbl.Size = UDim2.new(1, -16, 1, 0)
infoLbl.Position = UDim2.new(0, 8, 0, 0)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "Auto Cook di Apart Casino | Teleport + Spam E otomatis"
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextSize = 11
infoLbl.TextColor3 = C.textMid
infoLbl.TextWrapped = true

secHdr(fullyPage, 78, "PILIH APART")

local apartRow = card(fullyPage, 96, 3)
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
	btn.Size = UDim2.new(0, 50, 0, 28)
	btn.Position = UDim2.new(0.35 + (i-1) * 0.15, 0, 0.5, -14)
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

secHdr(fullyPage, 148, "PILIH POSISI")

local posRow = card(fullyPage, 166, 4)
local selectedPos = "kanan"
local posKanan = Instance.new("TextButton", posRow)
posKanan.Size = UDim2.new(0, 80, 0, 28)
posKanan.Position = UDim2.new(0.3, 0, 0.5, -14)
posKanan.BackgroundColor3 = C.accent
posKanan.Text = "KANAN"
posKanan.Font = Enum.Font.GothamBold
posKanan.TextSize = 12
posKanan.TextColor3 = C.text
posKanan.BorderSizePixel = 0
Instance.new("UICorner", posKanan).CornerRadius = UDim.new(0, 6)

local posKiri = Instance.new("TextButton", posRow)
posKiri.Size = UDim2.new(0, 80, 0, 28)
posKiri.Position = UDim2.new(0.55, 0, 0.5, -14)
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

secHdr(fullyPage, 210, "STATUS")

local nvStatusCard = card(fullyPage, 228, 5)
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
		alt = {
			nil, nil, nil, nil,
			CFrame.new(1199.95, 7.07, -177.69),
			CFrame.new(1199.75, 7.45, -217.66),
			CFrame.new(1199.38, 15.96, -220.53),
		}
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

local startBtn = makeActionBtn(fullyPage, "▶ START FULLY NV", C.greenD, 6)
local stopBtn = makeActionBtn(fullyPage, "■ STOP FULLY NV", C.red, 7)
stopBtn.Visible = false

startBtn.MouseButton1Click:Connect(function()
	if fullyRunning then return end
	fullyRunning = true
	startBtn.Visible = false
	stopBtn.Visible = true
	notify("Fully NV", "Proses dimulai", "success")
	task.spawn(fullyNVLoop)
end)

stopBtn.MouseButton1Click:Connect(function()
	fullyRunning = false
	startBtn.Visible = true
	stopBtn.Visible = false
	notify("Fully NV", "Proses dihentikan", "error")
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
		main.Size = UDim2.new(0, 660, 0, 430)
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
switchTab("FULLY NV")
task.wait(0.3)
notify("ELIXIR 3.5", "Script loaded! Tekan Z untuk hide/show", "success")

print("=== ELIXIR 3.5 XENO EDITION LOADED ===")
print("Fitur: FARM, AUTO, STATUS, TP, ESP, RESPAWN, UNDERPOT, FULLY NV")
