-- ELIXIR 3.5 -- REDESIGNED: DEEP PURPLE THEME + TEXT SIDEBAR
-- DITAMBAH: PAGE FULLY NV (APART CASINO 1-4) DENGAN BLINK TP & AUTO COOK

local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local ContextActionService = game:GetService("ContextActionService")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

repeat task.wait() until player.Character

local playerGui = player:WaitForChild("PlayerGui")

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
-- ANTI AFK
-- ============================================================
player.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

-- ============================================================
-- HELPERS
-- ============================================================
local function holdE(t)
	vim:SendKeyEvent(true,"E",false,game)
	task.wait(t)
	vim:SendKeyEvent(false,"E",false,game)
end

local function equip(name)
	local char = player.Character
	local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
	if tool then
		char.Humanoid:EquipTool(tool)
		task.wait(.3)
		return true
	end
end

local function countItem(name)
	local total = 0
	for _,v in pairs(player.Backpack:GetChildren()) do
		if v.Name == name then total += 1 end
	end
	for _,v in pairs(player.Character:GetChildren()) do
		if v:IsA("Tool") and v.Name == name then total += 1 end
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
	vehicle:SetPrimaryPartCFrame(cf)
	task.wait(1)
	seat.Throttle = 1
	task.wait(0.5)
	seat.Throttle = 0
end

local function fill(bar, time)
	bar.Size = UDim2.new(0,0,1,0)
	bar:TweenSize(UDim2.new(1,0,1,0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, time, true)
	task.delay(time, function() bar.Size = UDim2.new(0,0,1,0) end)
end

-- ============================================================
-- NO CLIP / BLINK TP SYSTEM
-- ============================================================
local noclipEnabled = false
local noclipConn = nil
local blinkEnabled = false

local function toggleNoclip(state)
	noclipEnabled = state
	if noclipEnabled then
		if noclipConn then noclipConn:Disconnect() end
		noclipConn = RunService.Stepped:Connect(function()
			local char = player.Character
			if not char then return end
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					pcall(function() part.CanCollide = false end)
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() end
		noclipConn = nil
	end
end

local function blinkForward(dist)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = root.CFrame + root.CFrame.LookVector * (dist or 6)
		-- Reset velocity
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
	end
end

-- Blink TP with wall detection
local function blinkToPosition(targetCF)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	
	-- Try to move smoothly first
	local startPos = root.Position
	local targetPos = targetCF.Position
	local direction = (targetPos - startPos).Unit
	local distance = (targetPos - startPos).Magnitude
	
	-- Check if wall blocks the path using raycast
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {char}
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local rayResult = workspace:Raycast(startPos, direction * distance, rayParams)
	
	if rayResult and rayResult.Instance then
		-- Wall detected, blink teleport
		root.CFrame = targetCF
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		return true
	else
		-- No wall, smooth move
		root.CFrame = targetCF
		return true
	end
end

-- ============================================================
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIR_3_5"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

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
-- SIMPLE LOADING OVERLAY
-- ============================================================
local showLoading, hideLoading
do
	local loadGui = Instance.new("ScreenGui")
	loadGui.Name = "ELIXIR_LOAD"
	loadGui.IgnoreGuiInset = true
	loadGui.ResetOnSpawn = false
	loadGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	loadGui.DisplayOrder = 999
	loadGui.Enabled = false
	pcall(function() loadGui.Parent = game:GetService("CoreGui") end)
	if not loadGui.Parent then loadGui.Parent = playerGui end

	local bg = Instance.new("Frame", loadGui)
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 0
	bg.BorderSizePixel = 0
	bg.ZIndex = 10

	local glow = Instance.new("Frame", bg)
	glow.Size = UDim2.new(0, 400, 0, 180)
	glow.Position = UDim2.new(0.5, -200, 0.5, -90)
	glow.BackgroundColor3 = Color3.fromRGB(80, 30, 160)
	glow.BackgroundTransparency = 0.88
	glow.BorderSizePixel = 0
	glow.ZIndex = 11
	Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

	local title = Instance.new("TextLabel", bg)
	title.Size = UDim2.new(0, 500, 0, 56)
	title.Position = UDim2.new(0.5, -250, 0.5, -50)
	title.BackgroundTransparency = 1
	title.Text = "ELIXIR STORE"
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 44
	title.TextColor3 = Color3.fromRGB(220, 215, 245)
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.ZIndex = 12
	do
		local g = Instance.new("UIGradient", title)
		g.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 120, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 215, 245)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 60, 240)),
		})
	end

	local line = Instance.new("Frame", bg)
	line.Size = UDim2.new(0, 200, 0, 1)
	line.Position = UDim2.new(0.5, -100, 0.5, 14)
	line.BackgroundColor3 = Color3.fromRGB(130, 60, 240)
	line.BackgroundTransparency = 0.3
	line.BorderSizePixel = 0
	line.ZIndex = 12
	Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)

	local subLbl = Instance.new("TextLabel", bg)
	subLbl.Size = UDim2.new(0, 400, 0, 22)
	subLbl.Position = UDim2.new(0.5, -200, 0.5, 24)
	subLbl.BackgroundTransparency = 1
	subLbl.Text = "Teleporting..."
	subLbl.Font = Enum.Font.Gotham
	subLbl.TextSize = 13
	subLbl.TextColor3 = Color3.fromRGB(100, 55, 190)
	subLbl.TextXAlignment = Enum.TextXAlignment.Center
	subLbl.ZIndex = 12

	local ver = Instance.new("TextLabel", bg)
	ver.Size = UDim2.new(1, 0, 0, 18)
	ver.Position = UDim2.new(0, 0, 1, -22)
	ver.BackgroundTransparency = 1
	ver.Text = "ELIXIR v3.5  •  Deep Purple Edition"
	ver.Font = Enum.Font.Gotham
	ver.TextSize = 11
	ver.TextColor3 = Color3.fromRGB(45, 38, 70)
	ver.TextXAlignment = Enum.TextXAlignment.Center
	ver.ZIndex = 12

	task.spawn(function()
		local pats = {"Teleporting", "Teleporting.", "Teleporting..", "Teleporting..."}
		local idx = 1
		while loadGui and loadGui.Parent do
			if loadGui.Enabled then
				subLbl.Text = pats[idx]
				idx = (idx % #pats) + 1
			end
			task.wait(0.3)
		end
	end)

	showLoading = function(subText)
		subLbl.Text = subText or "Teleporting"
		loadGui.Enabled = true
	end

	hideLoading = function()
		loadGui.Enabled = false
	end
end

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

-- ============================================================
-- TOP BAR
-- ============================================================
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

-- ============================================================
-- TEXT SIDEBAR
-- ============================================================
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

-- ============================================================
-- CONTENT AREA
-- ============================================================
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -80, 1, -46)
content.Position = UDim2.new(0, 80, 0, 46)
content.BackgroundColor3 = C.panel
content.ClipsDescendants = true
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 0)

local contentFix = Instance.new("Frame", content)
contentFix.Size = UDim2.new(0, 12, 1, 0)
contentFix.BackgroundColor3 = C.panel
contentFix.BorderSizePixel = 0

-- ============================================================
-- TAB SYSTEM
-- ============================================================
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
	{label = "CASINO",   order = 8},  -- NEW PAGE FULLY NV
}

local function switchTab(name)
	for n, p in pairs(pages) do
		p.Visible = (n == name)
	end
	for n, b in pairs(tabBtns) do
		if n == name then
			b.BackgroundColor3 = C.accentDim
			b.BackgroundTransparency = 0
			b.TextColor3 = C.accentGlow
		else
			b.BackgroundTransparency = 1
			b.TextColor3 = C.textDim
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
			local ind = b2:FindFirstChild("Frame")
			if ind then ind.Visible = (b2 == btn) end
		end
	end)
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

local function makeToggleBtn(parent, text, order)
	local f = card(parent, 38, order)
	local btn = Instance.new("TextButton", f)
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 12
	btn.TextColor3 = C.text
	btn.Text = text
	btn.BorderSizePixel = 0

	local pill = Instance.new("Frame", f)
	pill.Size = UDim2.new(0, 28, 0, 14)
	pill.Position = UDim2.new(1, -40, 0.5, -7)
	pill.BackgroundColor3 = C.textDim
	pill.BorderSizePixel = 0
	Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame", pill)
	knob.Size = UDim2.new(0, 10, 0, 10)
	knob.Position = UDim2.new(0, 2, 0.5, -5)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	knob.BorderSizePixel = 0
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local state = false
	local function setToggle(on)
		state = on
		if on then
			TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = C.accent}):Play()
			TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(1, -12, 0.5, -5)}):Play()
			btn.TextColor3 = C.accentGlow
		else
			TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = C.textDim}):Play()
			TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(0, 2, 0.5, -5)}):Play()
			btn.TextColor3 = C.text
		end
	end

	btn.MouseButton1Click:Connect(function()
		setToggle(not state)
	end)

	return btn, f, setToggle
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

local function makeSlider(parent, labelText, minV, maxV, defaultV, order, callback)
	local wrap = card(parent, 54, order)

	local lbl = Instance.new("TextLabel", wrap)
	lbl.Position = UDim2.new(0, 12, 0, 8)
	lbl.Size = UDim2.new(1, -80, 0, 16)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.Font = Enum.Font.GothamSemibold
	lbl.TextSize = 11
	lbl.TextColor3 = C.textMid
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local valLbl = Instance.new("TextLabel", wrap)
	valLbl.Position = UDim2.new(1, -52, 0, 8)
	valLbl.Size = UDim2.new(0, 42, 0, 16)
	valLbl.BackgroundTransparency = 1
	valLbl.Text = tostring(defaultV)
	valLbl.Font = Enum.Font.GothamBold
	valLbl.TextSize = 12
	valLbl.TextColor3 = C.accentGlow
	valLbl.TextXAlignment = Enum.TextXAlignment.Right

	local track = Instance.new("Frame", wrap)
	track.Position = UDim2.new(0, 12, 0, 34)
	track.Size = UDim2.new(1, -24, 0, 5)
	track.BackgroundColor3 = C.border
	track.BorderSizePixel = 0
	track.Active = true
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local fill2 = Instance.new("Frame", track)
	fill2.Size = UDim2.new((defaultV - minV)/(maxV - minV), 0, 1, 0)
	fill2.BackgroundColor3 = C.accent
	fill2.BorderSizePixel = 0
	Instance.new("UICorner", fill2).CornerRadius = UDim.new(1, 0)

	local knob2 = Instance.new("Frame", track)
	local kp = (defaultV - minV)/(maxV - minV)
	knob2.Size = UDim2.new(0, 14, 0, 14)
	knob2.Position = UDim2.new(kp, -7, 0.5, -7)
	knob2.BackgroundColor3 = Color3.new(1,1,1)
	knob2.BorderSizePixel = 0
	Instance.new("UICorner", knob2).CornerRadius = UDim.new(1, 0)

	local ks = Instance.new("UIStroke", knob2)
	ks.Color = C.accent
	ks.Thickness = 2

	local dragging = false

	local function update(x)
		local pos = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local val = math.floor(minV + pos * (maxV - minV))
		knob2.Position = UDim2.new(pos, -7, 0.5, -7)
		fill2.Size = UDim2.new(pos, 0, 1, 0)
		valLbl.Text = tostring(val)
		if callback then callback(val) end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			update(input.Position.X)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	return wrap, valLbl
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

-- ============================================================
-- CASINO PAGE - FULLY NV (APART CASINO 1-4)
-- ============================================================
local casinoPage = pages["CASINO"]

-- Data Apart Casino
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
local selectedPosition = "kanan" -- "kanan" or "kiri"
local currentStageIndex = 1
local cookingActive = false
local stepDelay = 1.5 -- detik antar tahap

-- Helper untuk teleport ke titik dengan blink jika ada tembok
local function teleportToStage(cf)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	
	-- Cek jarak
	local distance = (root.Position - cf.Position).Magnitude
	
	if distance > 10 then
		-- Jika jauh, langsung teleport
		root.CFrame = cf
		root.AssemblyLinearVelocity = Vector3.zero
	else
		-- Coba jalan dulu, jika ada tembok blink
		local startPos = root.Position
		local targetPos = cf.Position
		local direction = (targetPos - startPos).Unit
		
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {char}
		rayParams.FilterType = Enum.RaycastFilterType.Exclude
		
		local rayResult = workspace:Raycast(startPos, direction * distance, rayParams)
		
		if rayResult and rayResult.Instance then
			-- Ada tembok, blink
			root.CFrame = cf
			root.AssemblyLinearVelocity = Vector3.zero
		else
			-- Tidak ada tembok, smooth move
			root.CFrame = cf
		end
	end
	
	return true
end

-- Spam E 3x setiap sampai koordinat
local function spamE()
	for i = 1, 3 do
		vim:SendKeyEvent(true, "E", false, game)
		task.wait(0.05)
		vim:SendKeyEvent(false, "E", false, game)
		task.wait(0.05)
	end
end

-- Proses memasak di setiap tahap (Water → Sugar → Gelatin → Bag)
local function processCooking()
	local hasWater = countItem("Water") > 0
	local hasSugar = countItem("Sugar Block Bag") > 0
	local hasGelatin = countItem("Gelatin") > 0
	local hasBag = countItem("Empty Bag") > 0
	
	if not hasWater or not hasSugar or not hasGelatin then
		return false, "Bahan habis!"
	end
	
	-- Step 1: Water
	if equip("Water") then
		spamE()
		task.wait(20) -- Water cooking time
	end
	
	-- Step 2: Sugar
	if equip("Sugar Block Bag") then
		spamE()
		task.wait(1) -- Sugar cooking time
	end
	
	-- Step 3: Gelatin
	if equip("Gelatin") then
		spamE()
		task.wait(1) -- Gelatin cooking time
		-- Tunggu setelah Gelatin diinteract, baru naik
		task.wait(0.5)
	end
	
	-- Step 4: Empty Bag (ambil hasil)
	if equip("Empty Bag") then
		spamE()
		task.wait(1.5)
	end
	
	return true, "Cook selesai"
end

-- Loop utama Fully NV
local function fullyNVLoop(setStatusFunc)
	local apart = selectedApart
	local posChoice = selectedPosition
	local stages = APART_CONFIGS[apart].stages
	
	setStatusFunc("🚀 Memulai Fully NV di " .. APART_CONFIGS[apart].name .. " (" .. posChoice .. ")", C.accentGlow)
	
	-- Loop hingga bahan habis atau dihentikan
	while fullyNVRunning do
		-- Cek bahan
		local waterCount = countItem("Water")
		local sugarCount = countItem("Sugar Block Bag")
		local gelatinCount = countItem("Gelatin")
		
		if waterCount == 0 or sugarCount == 0 or gelatinCount == 0 then
			setStatusFunc("⚠️ Bahan habis! Menghentikan...", C.orange)
			notify("Fully NV", "Bahan habis, proses berhenti", "error")
			break
		end
		
		-- Loop setiap tahap
		for i, stage in ipairs(stages) do
			if not fullyNVRunning then break end
			
			-- Pilih CFrame berdasarkan posisi yang dipilih
			local targetCF = stage.cf
			local stageName = stage.name
			
			if posChoice == "kiri" and stage.alt then
				targetCF = stage.alt
				stageName = stage.altName or stage.name .. " (Kiri)"
			end
			
			setStatusFunc("📍 Menuju " .. stageName, C.textMid)
			
			-- Teleport ke tahap dengan blink jika perlu
			local success = teleportToStage(targetCF)
			if not success then
				setStatusFunc("❌ Gagal teleport ke " .. stageName, C.red)
				task.wait(1)
				break
			end
			
			task.wait(stepDelay)
			
			-- Spam E setiap sampai koordinat
			spamE()
			task.wait(0.3)
			
			-- Proses memasak di tahap ini
			if fullyNVRunning then
				setStatusFunc("🍳 Memasak di " .. stageName, C.green)
				
				local cookSuccess, cookMsg = processCooking()
				
				if not cookSuccess then
					setStatusFunc("❌ " .. cookMsg, C.red)
					notify("Fully NV", cookMsg, "error")
					break
				end
				
				setStatusFunc("✅ Selesai " .. stageName, C.green)
				task.wait(0.5)
			end
		end
		
		-- Selesai 1 loop, cek bahan lagi
		if fullyNVRunning then
			setStatusFunc("🔄 Selesai 1 siklus, lanjut...", C.textMid)
			task.wait(1)
		end
	end
	
	setStatusFunc("✅ Fully NV Berhenti", C.green)
	notify("Fully NV", "Proses selesai/berhenti", "success")
end

-- ============================================================
-- BUILD CASINO PAGE UI
-- ============================================================
sectionLabel(casinoPage, "FULLY NV - APART CASINO", 1)

-- Info card
local nvInfoCard = card(casinoPage, 50, 2)
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

-- Pilih Apart
sectionLabel(casinoPage, "PILIH APART", 3)

local apartSelectRow = card(casinoPage, 46, 4)
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

-- Pilih Posisi (Kanan/Kiri)
sectionLabel(casinoPage, "PILIH POSISI (KANAN/KIRI)", 5)

local posSelectRow = card(casinoPage, 46, 6)

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

-- Setting delay
sectionLabel(casinoPage, "PENGATURAN", 7)

local getStepDelay = stepperRowFloat(casinoPage, 8, "Delay antar tahap", 0.5, 3.0, 1.5, 0.1, "s")

-- Status
sectionLabel(casinoPage, "STATUS", 9)

local nvStatusCard = card(casinoPage, 36, 10)
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

-- Buttons START/STOP
local startNVW, startNVB = actionBtn(casinoPage, 11, "▶ START FULLY NV", C.greenD, C.txt)
local stopNVW, stopNVB = actionBtn(casinoPage, 11, "■ STOP FULLY NV", C.red, C.txt)
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
	setNVStatus("🚀 Auto Fully NV berjalan...", C.green)
	
	task.spawn(function()
		fullyNVLoop(setNVStatus)
		fullyNVRunning = false
		setNVUI(false)
		if fullyNVRunning == false then
			setNVStatus("✅ Dihentikan", C.orange)
		end
	end)
end)

stopNVB.MouseButton1Click:Connect(function()
	fullyNVRunning = false
	setNVUI(false)
	setNVStatus("⏹ Dihentikan", C.red)
	notify("Fully NV", "Proses dihentikan", "info")
end)

hoverBtn(startNVW, startNVB, C.greenD, Color3.fromRGB(50, 180, 90))
hoverBtn(stopNVW, stopNVB, C.red, Color3.fromRGB(220, 50, 50))

-- Update delay saat running
RunService.Heartbeat:Connect(function()
	if fullyNVRunning then
		stepDelay = getStepDelay()
	end
end)

-- ============================================================
-- CONTINUE WITH ORIGINAL PAGES (FARM, AUTO, STATUS, TP, ESP, RESPAWN, UNDERPOT)
-- ============================================================
-- [KONTINUASI SCRIPT ORIGINAL DARI SINI...]
-- Karena panjang, saya lanjutkan di response berikutnya
