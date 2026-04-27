-- ELIXIR 3.5 -- REDESIGNED: DEEP PURPLE THEME + TEXT SIDEBAR
-- FIXED: GUI MUNCUL

local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local ContextActionService = game:GetService("ContextActionService")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- PASTIKAN KARAKTER ADA
repeat task.wait() until player.Character
repeat task.wait() until player.Character:FindFirstChild("HumanoidRootPart")

local playerGui = player:WaitForChild("PlayerGui")

-- CEK APAKAH GUI SUDAH ADA
if playerGui:FindFirstChild("ELIXIR_3_5") then
	playerGui.ELIXIR_3_5:Destroy()
end

local running = false
local autoSellEnabled = false
local buyAmount = 1

local autoFarmRunning = false
local autoFarmStopping = false
local cookAmount = 5

local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

local npcPos = CFrame.new(510.762817,3.58721066,600.791504)
local tierPos = CFrame.new(1110.18726,4.28433371,117.139168)

-- ANTI AFK
player.Idled:Connect(function()
	pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
end)

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
	pcall(function()
		vehicle:SetPrimaryPartCFrame(cf)
	end)
	task.wait(1)
	if seat then
		pcall(function() seat.Throttle = 1 end)
		task.wait(0.5)
		pcall(function() seat.Throttle = 0 end)
	end
end

local function fill(bar, time)
	if not bar then return end
	bar.Size = UDim2.new(0,0,1,0)
	bar:TweenSize(UDim2.new(1,0,1,0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, time, true)
	task.delay(time, function() if bar then bar.Size = UDim2.new(0,0,1,0) end end)
end

-- ============================================================
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIR_3_5"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Pastikan gui tampil
gui.Enabled = true

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
	accentSoft= Color3.fromRGB(100, 55, 190),
	text      = Color3.fromRGB(220, 215, 245),
	textMid   = Color3.fromRGB(145, 138, 175),
	textDim   = Color3.fromRGB(75,  68, 100),
	green     = Color3.fromRGB(55,  200, 110),
	red       = Color3.fromRGB(220, 60,  75),
	border    = Color3.fromRGB(38,  32,  62),
	borderAct = Color3.fromRGB(100, 55, 190),
}

-- ============================================================
-- NOTIFICATION SYSTEM
-- ============================================================
local notifContainer = Instance.new("Frame", gui)
notifContainer.Size = UDim2.new(0, 270, 1, 0)
notifContainer.Position = UDim2.new(1, -280, 0, 0)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 100

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 6)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

local notifPadding = Instance.new("UIPadding", notifContainer)
notifPadding.PaddingBottom = UDim.new(0, 14)
notifPadding.PaddingRight = UDim.new(0, 8)

local notifCount = 0
local function notify(title, msg, ntype)
	notifCount += 1
	local color = ntype == "success" and C.green or ntype == "error" and C.red or C.accent

	local card = Instance.new("Frame", notifContainer)
	card.Size = UDim2.new(1, 0, 0, 58)
	card.BackgroundColor3 = C.card
	card.BorderSizePixel = 0
	card.ClipsDescendants = true
	card.ZIndex = 100
	card.LayoutOrder = notifCount

	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke", card)
	stroke.Color = color
	stroke.Thickness = 1
	stroke.Transparency = 0.5

	local bar_left = Instance.new("Frame", card)
	bar_left.Size = UDim2.new(0, 3, 1, 0)
	bar_left.BackgroundColor3 = color
	bar_left.BorderSizePixel = 0
	bar_left.ZIndex = 101

	local t = Instance.new("TextLabel", card)
	t.Position = UDim2.new(0, 14, 0, 7)
	t.Size = UDim2.new(1, -22, 0, 18)
	t.BackgroundTransparency = 1
	t.Text = title
	t.Font = Enum.Font.GothamBold
	t.TextSize = 13
	t.TextColor3 = C.text
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.ZIndex = 101

	local m = Instance.new("TextLabel", card)
	m.Position = UDim2.new(0, 14, 0, 26)
	m.Size = UDim2.new(1, -22, 0, 26)
	m.BackgroundTransparency = 1
	m.Text = msg
	m.Font = Enum.Font.Gotham
	m.TextSize = 11
	m.TextColor3 = C.textMid
	m.TextXAlignment = Enum.TextXAlignment.Left
	m.TextWrapped = true
	m.ZIndex = 101

	local timerBar = Instance.new("Frame", card)
	timerBar.Position = UDim2.new(0, 3, 1, -2)
	timerBar.Size = UDim2.new(1, -3, 0, 2)
	timerBar.BackgroundColor3 = color
	timerBar.BorderSizePixel = 0
	timerBar.ZIndex = 101

	card.Position = UDim2.new(1, 16, 0, 0)
	TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0,0,0,0)}):Play()
	TweenService:Create(timerBar, TweenInfo.new(3.5, Enum.EasingStyle.Linear), {Size = UDim2.new(0,3,0,2)}):Play()

	task.delay(3.5, function()
		TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Position = UDim2.new(1,16,0,0)}):Play()
		task.wait(0.3)
		card:Destroy()
	end)
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 660, 0, 430)
main.Position = UDim2.new(0.5, -330, 0.5, -215)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
main.ClipsDescendants = false

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = C.border
mainStroke.Thickness = 1

local topGlow = Instance.new("Frame", main)
topGlow.Size = UDim2.new(1, 0, 0, 1)
topGlow.BackgroundColor3 = C.accentSoft
topGlow.BorderSizePixel = 0
topGlow.ZIndex = 5
topGlow.BackgroundTransparency = 0.3

-- TOP BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 46)
topBar.BackgroundColor3 = C.surface
topBar.ZIndex = 2
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

do
	local fix = Instance.new("Frame", topBar)
	fix.Size = UDim2.new(1, 0, 0, 12)
	fix.Position = UDim2.new(0, 0, 1, -12)
	fix.BackgroundColor3 = C.surface
	fix.BorderSizePixel = 0

	local accentLine = Instance.new("Frame", topBar)
	accentLine.Size = UDim2.new(1, 0, 0, 1)
	accentLine.Position = UDim2.new(0, 0, 1, -1)
	accentLine.BackgroundColor3 = C.border
	accentLine.BorderSizePixel = 0

	local sq = Instance.new("Frame", topBar)
	sq.Size = UDim2.new(0, 4, 0, 20)
	sq.Position = UDim2.new(0, 16, 0.5, -10)
	sq.BackgroundColor3 = C.accent
	sq.BorderSizePixel = 0
	Instance.new("UICorner", sq).CornerRadius = UDim.new(0, 2)

	local titleLbl = Instance.new("TextLabel", topBar)
	titleLbl.Position = UDim2.new(0, 28, 0, 0)
	titleLbl.Size = UDim2.new(0, 160, 1, 0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "ELIXIR 3.5"
	titleLbl.Font = Enum.Font.GothamBlack
	titleLbl.TextSize = 15
	titleLbl.TextColor3 = C.text
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left

	local badge = Instance.new("Frame", topBar)
	badge.Size = UDim2.new(0, 38, 0, 18)
	badge.Position = UDim2.new(0, 190, 0.5, -9)
	badge.BackgroundColor3 = C.accentDim
	badge.BorderSizePixel = 0
	Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)
	local badgeTxt = Instance.new("TextLabel", badge)
	badgeTxt.Size = UDim2.new(1,0,1,0)
	badgeTxt.BackgroundTransparency = 1
	badgeTxt.Text = "v3.5"
	badgeTxt.Font = Enum.Font.GothamBold
	badgeTxt.TextSize = 10
	badgeTxt.TextColor3 = C.accentGlow
end

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

closeBtn.MouseButton1Click:Connect(function()
	running = false
	autoSellEnabled = false
	notify("Elixir", "Script dihentikan.", "error")
	task.wait(0.4)
	gui:Destroy()
end)

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
sidebar.ClipsDescendants = false

local sidebarLine = Instance.new("Frame", main)
sidebarLine.Size = UDim2.new(0, 1, 1, -46)
sidebarLine.Position = UDim2.new(0, 79, 0, 46)
sidebarLine.BackgroundColor3 = C.border
sidebarLine.BorderSizePixel = 0
sidebarLine.ZIndex = 3

local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Top
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local sidebarPad = Instance.new("UIPadding", sidebar)
sidebarPad.PaddingTop = UDim.new(0, 10)

-- CONTENT AREA
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -80, 1, -46)
content.Position = UDim2.new(0, 80, 0, 46)
content.BackgroundColor3 = C.panel
content.ClipsDescendants = true
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 0)

-- TAB SYSTEM
local pages = {}
local tabBtns = {}
local currentTab = nil

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
	for n, p in pairs(pages) do
		if p then p.Visible = (n == name) end
	end
	for n, b in pairs(tabBtns) do
		if b then
			if n == name then
				b.BackgroundColor3 = C.accentDim
				b.BackgroundTransparency = 0
				b.TextColor3 = C.accentGlow
			else
				b.BackgroundTransparency = 1
				b.TextColor3 = C.textDim
			end
		end
	end
	currentTab = name
end

for i, def in ipairs(tabDefs) do
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(0, 68, 0, 36)
	btn.BackgroundTransparency = 1
	btn.Text = def.label
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.TextColor3 = C.textDim
	btn.BorderSizePixel = 0
	btn.LayoutOrder = def.order
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

	local indicator = Instance.new("Frame", btn)
	indicator.Size = UDim2.new(0, 2, 0, 18)
	indicator.Position = UDim2.new(0, 0, 0.5, -9)
	indicator.BackgroundColor3 = C.accent
	indicator.BorderSizePixel = 0
	indicator.Visible = false
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

	local page = Instance.new("ScrollingFrame", content)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = C.accentSoft
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

	btn.MouseButton1Click:Connect(function()
		switchTab(def.label)
		for _, b2 in pairs(tabBtns) do
			local ind = b2 and b2:FindFirstChild("Frame")
			if ind then ind.Visible = (b2 == btn) end
		end
	end)
end

-- UI COMPONENT BUILDERS
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
	lbl.LayoutOrder = order or 0

	local line = Instance.new("Frame", wrap)
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3 = C.border
	line.BorderSizePixel = 0

	return wrap
end

local function card(parent, h, order)
	local f = Instance.new("Frame", parent)
	f.Size = UDim2.new(1, 0, 0, h or 46)
	f.BackgroundColor3 = C.card
	f.BorderSizePixel = 0
	f.LayoutOrder = order or 0
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	local s = Instance.new("UIStroke", f)
	s.Color = C.border
	s.Thickness = 1
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

	local s = Instance.new("UIStroke", f)
	s.Color = C.border
	s.Thickness = 1

	f.MouseEnter:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = C.accent}):Play()
	end)
	f.MouseLeave:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = color or C.accentDim}):Play()
	end)
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

	return val2, f
end

local function corner(p, r)
	Instance.new("UICorner", p).CornerRadius = UDim.new(0, r or 8)
end

local function hoverBtn(w, b, nc, hc)
	b.MouseEnter:Connect(function()
		TweenService:Create(w, TweenInfo.new(0.1), {BackgroundColor3=hc}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(w, TweenInfo.new(0.1), {BackgroundColor3=nc}):Play()
	end)
end

local function stepperRowFloat(parent, y, lbl, minV, maxV, defV, step, unit)
	local row = card(parent, 44, 0)
	row.Position = UDim2.new(0, 12, 0, y)
	
	local nm = Instance.new("TextLabel", row)
	nm.Size = UDim2.new(0.5, 0, 1, 0)
	nm.Position = UDim2.new(0, 10, 0, 0)
	nm.BackgroundTransparency = 1
	nm.Text = lbl
	nm.Font = Enum.Font.Gotham
	nm.TextSize = 11
	nm.TextColor3 = C.textMid
	nm.TextXAlignment = Enum.TextXAlignment.Left
	
	local curVal = defV
	local valL = Instance.new("TextLabel", row)
	valL.Size = UDim2.new(0, 56, 0, 24)
	valL.Position = UDim2.new(0.5, -28, 0, 10)
	valL.BackgroundTransparency = 1
	valL.Text = string.format("%.1f", curVal) .. (unit or "")
	valL.Font = Enum.Font.GothamBold
	valL.TextSize = 13
	valL.TextColor3 = C.accentGlow
	valL.TextXAlignment = Enum.TextXAlignment.Center
	
	local minusW = Instance.new("Frame", row)
	minusW.Size = UDim2.new(0, 28, 0, 24)
	minusW.Position = UDim2.new(0.5, -28-34, 0, 10)
	minusW.BackgroundColor3 = C.blueD
	corner(minusW, 6)
	local minusB = Instance.new("TextButton", minusW)
	minusB.Size = UDim2.new(1,0,1,0)
	minusB.BackgroundTransparency = 1
	minusB.Text = "−"
	minusB.Font = Enum.Font.GothamBold
	minusB.TextSize = 14
	minusB.TextColor3 = C.text
	
	local plusW = Instance.new("Frame", row)
	plusW.Size = UDim2.new(0, 28, 0, 24)
	plusW.Position = UDim2.new(0.5, 28+6, 0, 10)
	plusW.BackgroundColor3 = C.blueD
	corner(plusW, 6)
	local plusB = Instance.new("TextButton", plusW)
	plusB.Size = UDim2.new(1,0,1,0)
	plusB.BackgroundTransparency = 1
	plusB.Text = "+"
	plusB.Font = Enum.Font.GothamBold
	plusB.TextSize = 14
	plusB.TextColor3 = C.text
	
	local function updateVal(v)
		curVal = math.clamp(math.floor(v * 10 + 0.5) / 10, minV, maxV)
		valL.Text = string.format("%.1f", curVal) .. (unit or "")
	end
	
	minusB.MouseButton1Click:Connect(function() updateVal(curVal - step) end)
	plusB.MouseButton1Click:Connect(function() updateVal(curVal + step) end)
	
	return function() return curVal end
end

-- ============================================================
-- FARM PAGE (SEDERHANA)
-- ============================================================
local fp = pages["FARM"]

sectionLabel(fp, "Status", 1)

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

sectionLabel(fp, "Inventory", 3)

local waterVal, _  = makeStatusRow(fp, "Water", 4)
local sugarVal, _  = makeStatusRow(fp, "Sugar Block Bag", 5)
local gelatinVal,_ = makeStatusRow(fp, "Gelatin", 6)
local bagVal, _    = makeStatusRow(fp, "Empty Bag", 7)

sectionLabel(fp, "Controls", 8)

local farmToggleBtn = makeActionBtn(fp, "START FARM", C.accentDim, 10)

-- FARM LOGIC SEDERHANA
local farmRunning = false
local function simpleCook()
	while farmRunning do
		if countItem("Water") == 0 or countItem("Sugar Block Bag") == 0 or countItem("Gelatin") == 0 then
			statusLabel.Text = "Bahan habis!"
			break
		end
		
		if equip("Water") then
			statusLabel.Text = "Cooking Water..."
			holdE(.7)
			task.wait(20)
		end
		if equip("Sugar Block Bag") then
			statusLabel.Text = "Cooking Sugar..."
			holdE(.7)
			task.wait(1)
		end
		if equip("Gelatin") then
			statusLabel.Text = "Cooking Gelatin..."
			holdE(.7)
			task.wait(1)
		end
		statusLabel.Text = "Waiting..."
		task.wait(45)
		if equip("Empty Bag") then
			statusLabel.Text = "Collecting..."
			holdE(.7)
			task.wait(1)
		end
	end
	statusLabel.Text = "IDLE"
end

farmToggleBtn.MouseButton1Click:Connect(function()
	farmRunning = not farmRunning
	if farmRunning then
		farmToggleBtn.Text = "STOP FARM"
		farmToggleBtn.BackgroundColor3 = C.red
		notify("Farm", "Auto farm dimulai!", "success")
		task.spawn(simpleCook)
	else
		farmToggleBtn.Text = "START FARM"
		farmToggleBtn.BackgroundColor3 = C.accentDim
		notify("Farm", "Auto farm dihentikan.", "error")
	end
end)

-- ============================================================
-- FULLY NV PAGE
-- ============================================================
local fullyNVPage = pages["FULLY NV"]

local APART_CONFIGS = {
	[1] = {
		name = "APART CASINO 1",
		stages = {
			{cf = CFrame.new(1196.51, 3.71, -241.13) * CFrame.Angles(-0.00, -0.05, 0.00), name = "Tahap 1"},
			{cf = CFrame.new(1199.75, 3.71, -238.12) * CFrame.Angles(-0.00, -0.05, -0.00), name = "Tahap 2"},
			{cf = CFrame.new(1199.74, 6.59, -233.05) * CFrame.Angles(-0.00, 0.00, -0.00), name = "Tahap 3"},
			{cf = CFrame.new(1199.66, 6.59, -227.75) * CFrame.Angles(0.00, -0.00, 0.00), name = "Tahap 4"},
			{cf = CFrame.new(1199.66, 6.59, -227.75) * CFrame.Angles(0.00, -0.00, 0.00), name = "Tahap 5 Kanan", alt = CFrame.new(1199.95, 7.07, -177.69) * CFrame.Angles(-0.00, 0.01, 0.00), altName = "Tahap 5 Kiri"},
			{cf = CFrame.new(1199.91, 7.56, -219.75) * CFrame.Angles(-0.00, 0.05, 0.00), name = "Tahap 6 Kanan", alt = CFrame.new(1199.75, 7.45, -217.66) * CFrame.Angles(0.00, -0.12, -0.00), altName = "Tahap 6 Kiri"},
			{cf = CFrame.new(1199.87, 15.96, -215.33) * CFrame.Angles(0.00, 0.05, 0.00), name = "Tahap 7 Kanan", alt = CFrame.new(1199.38, 15.96, -220.53) * CFrame.Angles(0.00, 0.06, 0.00), altName = "Tahap 7 Kiri"},
		}
	},
	[2] = {
		name = "APART CASINO 2",
		stages = {
			{cf = CFrame.new(1186.34, 3.71, -242.92) * CFrame.Angles(0.00, -0.06, 0.00), name = "Tahap 1"},
			{cf = CFrame.new(1183.00, 6.59, -233.78) * CFrame.Angles(-0.00, 0.00, 0.00), name = "Tahap 2"},
			{cf = CFrame.new(1182.70, 7.32, -229.73) * CFrame.Angles(-0.00, -0.01, 0.00), name = "Tahap 3"},
			{cf = CFrame.new(1182.75, 6.59, -224.78) * CFrame.Angles(-0.00, -0.01, 0.00), name = "Tahap 4"},
			{cf = CFrame.new(1183.43, 15.96, -229.66) * CFrame.Angles(0.00, 0.02, -0.00), name = "Tahap 5 Kanan", alt = CFrame.new(1183.22, 15.96, -225.63) * CFrame.Angles(0.00, -0.04, -0.00), altName = "Tahap 5 Kiri"},
		}
	},
	[3] = {
		name = "APART CASINO 3",
		stages = {
			{cf = CFrame.new(1196.17, 3.71, -205.72) * CFrame.Angles(0.00, -0.03, -0.00), name = "Tahap 1"},
			{cf = CFrame.new(1199.76, 3.71, -196.51) * CFrame.Angles(0.00, -0.04, 0.00), name = "Tahap 2"},
			{cf = CFrame.new(1199.69, 6.59, -191.16) * CFrame.Angles(-0.00, -0.06, -0.00), name = "Tahap 3"},
			{cf = CFrame.new(1199.42, 6.59, -185.27) * CFrame.Angles(-0.00, 0.01, 0.00), name = "Tahap 4"},
			{cf = CFrame.new(1199.42, 6.59, -185.27) * CFrame.Angles(-0.00, 0.01, 0.00), name = "Tahap 5 Kanan", alt = CFrame.new(1199.95, 7.07, -177.69) * CFrame.Angles(-0.00, 0.01, 0.00), altName = "Tahap 5 Kiri"},
			{cf = CFrame.new(1199.55, 15.96, -181.89) * CFrame.Angles(0.00, -0.09, 0.00), name = "Tahap 6 Kanan", alt = CFrame.new(1199.46, 15.96, -177.81) * CFrame.Angles(-0.00, -0.05, -0.00), altName = "Tahap 6 Kiri"},
		}
	},
	[4] = {
		name = "APART CASINO 4",
		stages = {
			{cf = CFrame.new(1187.70, 3.71, -209.73) * CFrame.Angles(0.00, -0.03, 0.00), name = "Tahap 1"},
			{cf = CFrame.new(1182.27, 3.71, -204.65) * CFrame.Angles(-0.00, 0.09, -0.00), name = "Tahap 2"},
			{cf = CFrame.new(1182.23, 3.71, -198.77) * CFrame.Angles(0.00, -0.04, -0.00), name = "Tahap 3"},
			{cf = CFrame.new(1183.06, 6.59, -193.92) * CFrame.Angles(0.00, 0.08, -0.00), name = "Tahap 4"},
			{cf = CFrame.new(1182.60, 7.56, -191.29) * CFrame.Angles(-0.00, -0.02, -0.00), name = "Tahap 5 Kanan", alt = CFrame.new(1183.36, 6.72, -187.25) * CFrame.Angles(-0.00, -0.04, -0.00), altName = "Tahap 5 Kiri"},
			{cf = CFrame.new(1183.24, 15.96, -191.25) * CFrame.Angles(-0.00, -0.01, 0.00), name = "Tahap 6 Kanan", alt = CFrame.new(1183.08, 15.96, -187.36) * CFrame.Angles(-0.00, -0.05, -0.00), altName = "Tahap 6 Kiri"},
		}
	}
}

local fullyNVRunning = false
local selectedApart = 1
local selectedPosition = "kanan"
local stepDelay = 1.5

local function teleportToStage(cf)
	local char = player.Character
	if not char then return false end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	pcall(function()
		root.CFrame = cf
		root.AssemblyLinearVelocity = Vector3.zero
	end)
	return true
end

local function spamE()
	for i = 1, 3 do
		pcall(function()
			vim:SendKeyEvent(true, "E", false, game)
			task.wait(0.05)
			vim:SendKeyEvent(false, "E", false, game)
			task.wait(0.05)
		end)
	end
end

local function processCooking()
	if countItem("Water") == 0 or countItem("Sugar Block Bag") == 0 or countItem("Gelatin") == 0 then
		return false, "Bahan habis!"
	end
	
	if equip("Water") then
		spamE()
		task.wait(20)
	end
	
	if equip("Sugar Block Bag") then
		spamE()
		task.wait(1)
	end
	
	if equip("Gelatin") then
		spamE()
		task.wait(1)
		task.wait(0.5)
	end
	
	if equip("Empty Bag") then
		spamE()
		task.wait(1.5)
	end
	
	return true, "Cook selesai"
end

local function fullyNVLoop(setStatusFunc)
	local apart = selectedApart
	local posChoice = selectedPosition
	local stages = APART_CONFIGS[apart].stages
	
	setStatusFunc("Memulai di " .. APART_CONFIGS[apart].name .. " (" .. posChoice .. ")", C.accentGlow)
	
	while fullyNVRunning do
		if countItem("Water") == 0 or countItem("Sugar Block Bag") == 0 or countItem("Gelatin") == 0 then
			setStatusFunc("Bahan habis! Berhenti...", C.orange)
			break
		end
		
		for i, stage in ipairs(stages) do
			if not fullyNVRunning then break end
			
			local targetCF = stage.cf
			local stageName = stage.name
			
			if posChoice == "kiri" and stage.alt then
				targetCF = stage.alt
				stageName = stage.altName or stage.name .. " (Kiri)"
			end
			
			setStatusFunc(stageName, C.textMid)
			
			local success = teleportToStage(targetCF)
			if not success then
				setStatusFunc("Gagal ke " .. stageName, C.red)
				break
			end
			
			task.wait(stepDelay)
			spamE()
			task.wait(0.3)
			
			if fullyNVRunning then
				setStatusFunc("Memasak di " .. stageName, C.green)
				local cookSuccess, cookMsg = processCooking()
				if not cookSuccess then
					setStatusFunc(cookMsg, C.red)
					break
				end
				setStatusFunc("Selesai " .. stageName, C.green)
				task.wait(0.5)
			end
		end
		
		if fullyNVRunning then
			setStatusFunc("Selesai 1 siklus, lanjut...", C.textMid)
			task.wait(1)
		end
	end
	
	setStatusFunc("Berhenti", C.green)
end

-- BUILD UI FULLY NV
sectionLabel(fullyNVPage, "FULLY NV - APART CASINO", 1)

local nvInfoCard = card(fullyNVPage, 50, 2)
stroke(nvInfoCard, C.accent, 1)
local nvInfoL = Instance.new("TextLabel", nvInfoCard)
nvInfoL.Size = UDim2.new(1, -16, 1, 0)
nvInfoL.Position = UDim2.new(0, 8, 0, 0)
nvInfoL.BackgroundTransparency = 1
nvInfoL.Text = "Auto Cook di Apart Casino\nBlink jika nabrak tembok | Spam E di setiap koordinat"
nvInfoL.Font = Enum.Font.Gotham
nvInfoL.TextSize = 11
nvInfoL.TextColor3 = C.textMid
nvInfoL.TextWrapped = true

sectionLabel(fullyNVPage, "PILIH APART", 3)

local apartSelectRow = card(fullyNVPage, 46, 4)
local apartLabel = Instance.new("TextLabel", apartSelectRow)
apartLabel.Size = UDim2.new(0.4, 0, 1, 0)
apartLabel.Position = UDim2.new(0, 12, 0, 0)
apartLabel.BackgroundTransparency = 1
apartLabel.Text = "Pilih Apart:"
apartLabel.Font = Enum.Font.GothamBold
apartLabel.TextSize = 12
apartLabel.TextColor3 = C.text
apartLabel.TextXAlignment = Enum.TextXAlignment.Left

local apartBtns = {}
for i = 1, 4 do
	local btnW = Instance.new("Frame", apartSelectRow)
	btnW.Size = UDim2.new(0, 60, 0, 30)
	btnW.Position = UDim2.new(0.42 + (i-1) * 0.14, 0, 0.5, -15)
	btnW.BackgroundColor3 = (i == 1) and C.accent or C.card
	corner(btnW, 6)
	
	local btn = Instance.new("TextButton", btnW)
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = tostring(i)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = C.text
	
	btn.MouseButton1Click:Connect(function()
		selectedApart = i
		for _, bw in pairs(apartBtns) do
			TweenService:Create(bw, TweenInfo.new(0.1), {BackgroundColor3 = C.card}):Play()
		end
		TweenService:Create(btnW, TweenInfo.new(0.1), {BackgroundColor3 = C.accent}):Play()
		notify("Fully NV", "Apart " .. i .. " dipilih", "success")
	end)
	
	apartBtns[i] = btnW
end

sectionLabel(fullyNVPage, "PILIH POSISI", 5)

local posSelectRow = card(fullyNVPage, 46, 6)

local posKananW = Instance.new("Frame", posSelectRow)
posKananW.Size = UDim2.new(0, 70, 0, 30)
posKananW.Position = UDim2.new(0.35, 0, 0.5, -15)
posKananW.BackgroundColor3 = C.accent
corner(posKananW, 6)
local posKananB = Instance.new("TextButton", posKananW)
posKananB.Size = UDim2.new(1, 0, 1, 0)
posKananB.BackgroundTransparency = 1
posKananB.Text = "KANAN"
posKananB.Font = Enum.Font.GothamBold
posKananB.TextSize = 11
posKananB.TextColor3 = C.text

local posKiriW = Instance.new("Frame", posSelectRow)
posKiriW.Size = UDim2.new(0, 70, 0, 30)
posKiriW.Position = UDim2.new(0.55, 0, 0.5, -15)
posKiriW.BackgroundColor3 = C.card
corner(posKiriW, 6)
local posKiriB = Instance.new("TextButton", posKiriW)
posKiriB.Size = UDim2.new(1, 0, 1, 0)
posKiriB.BackgroundTransparency = 1
posKiriB.Text = "KIRI"
posKiriB.Font = Enum.Font.GothamBold
posKiriB.TextSize = 11
posKiriB.TextColor3 = C.text

posKananB.MouseButton1Click:Connect(function()
	selectedPosition = "kanan"
	TweenService:Create(posKananW, TweenInfo.new(0.1), {BackgroundColor3 = C.accent}):Play()
	TweenService:Create(posKiriW, TweenInfo.new(0.1), {BackgroundColor3 = C.card}):Play()
	notify("Fully NV", "Posisi Kanan dipilih", "success")
end)

posKiriB.MouseButton1Click:Connect(function()
	selectedPosition = "kiri"
	TweenService:Create(posKananW, TweenInfo.new(0.1), {BackgroundColor3 = C.card}):Play()
	TweenService:Create(posKiriW, TweenInfo.new(0.1), {BackgroundColor3 = C.accent}):Play()
	notify("Fully NV", "Posisi Kiri dipilih", "success")
end)

sectionLabel(fullyNVPage, "PENGATURAN", 7)

local getStepDelay = stepperRowFloat(fullyNVPage, 8, "Delay antar tahap", 0.5, 3.0, 1.5, 0.1, "s")

sectionLabel(fullyNVPage, "STATUS", 9)

local nvStatusCard = card(fullyNVPage, 36, 10)
local nvStatusLbl = Instance.new("TextLabel", nvStatusCard)
nvStatusLbl.Size = UDim2.new(1, -16, 1, 0)
nvStatusLbl.Position = UDim2.new(0, 8, 0, 0)
nvStatusLbl.BackgroundTransparency = 1
nvStatusLbl.Text = "Belum dimulai"
nvStatusLbl.Font = Enum.Font.Gotham
nvStatusLbl.TextSize = 11
nvStatusLbl.TextColor3 = C.textMid
nvStatusLbl.TextWrapped = true

local function setNVStatus(msg, col)
	nvStatusLbl.Text = msg
	nvStatusLbl.TextColor3 = col or C.textMid
end

local startNVW, startNVB = makeActionBtn(fullyNVPage, "▶ START FULLY NV", C.greenD, 11)
local stopNVW, stopNVB = makeActionBtn(fullyNVPage, "■ STOP FULLY NV", C.red, 12)
stopNVW.Visible = false

local function setNVUI(running)
	startNVW.Visible = not running
	stopNVW.Visible = running
end

startNVB.MouseButton1Click:Connect(function()
	if fullyNVRunning then return end
	
	stepDelay = getStepDelay()
	fullyNVRunning = true
	setNVUI(true)
	setNVStatus("Berjalan...", C.green)
	
	task.spawn(function()
		fullyNVLoop(setNVStatus)
		fullyNVRunning = false
		setNVUI(false)
		if fullyNVRunning == false then
			setNVStatus("Dihentikan", C.orange)
		end
	end)
end)

stopNVB.MouseButton1Click:Connect(function()
	fullyNVRunning = false
	setNVUI(false)
	setNVStatus("Dihentikan", C.red)
	notify("Fully NV", "Proses dihentikan", "info")
end)

hoverBtn(startNVW, startNVB, C.greenD, Color3.fromRGB(50, 180, 90))
hoverBtn(stopNVW, stopNVB, C.red, Color3.fromRGB(220, 50, 50))

RunService.Heartbeat:Connect(function()
	if fullyNVRunning then
		stepDelay = getStepDelay()
	end
end)

-- ============================================================
-- STARTUP
-- ============================================================
switchTab("FULLY NV")
task.wait(0.3)
notify("ELIXIR 3.5", "Script berhasil diload! Klik tab FULLY NV", "success")

print("=== ELIXIR 3.5 LOADED ===")
print("GUI harus muncul. Jika tidak, cek output untuk error.")
