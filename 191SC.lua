local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local VirtualUser = game:GetService("VirtualUser")

-- ========== CUSTOM RESPAWN ==========
local RESPAWN_POINT = CFrame.new(729.86, 3.71, 444.46) * CFrame.Angles(-3.14, 0.01, -3.14)

local function setupCustomRespawn()
    player.CharacterAdded:Connect(function(character)
        task.wait(0.1)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
            hrp.CFrame = RESPAWN_POINT
            task.wait(0.05)
            hrp.Anchored = false
        end
    end)
end

setupCustomRespawn()

-- ========== AMBIL REMOTE EVENTS ==========
local remotes = ReplicatedStorage:FindFirstChild("RemoteEvents")
local storePurchaseRE = remotes and remotes:FindFirstChild("StorePurchase")

repeat task.wait() until player.Character

local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local running = false
local buyAmount = 10

local buyRemote = ReplicatedStorage:FindFirstChild("RemoteEvents") and ReplicatedStorage.RemoteEvents:FindFirstChild("StorePurchase")

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
	VirtualInputManager:SendKeyEvent(true,"E",false,game)
	task.wait(t or 0.7)
	VirtualInputManager:SendKeyEvent(false,"E",false,game)
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

local function findTool(toolName)
    if player.Character then
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("Tool") and string.find(string.lower(child.Name), string.lower(toolName)) then
                return child
            end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") and string.find(string.lower(child.Name), string.lower(toolName)) then
                return child
            end
        end
    end
    return nil
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

-- ============================================================
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "191_STORE"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ============================================================
-- COLOR PALETTE (BIRU & HITAM)
-- ============================================================
local C = {
	bg        = Color3.fromRGB(10, 10, 18),
	surface   = Color3.fromRGB(15, 15, 25),
	panel     = Color3.fromRGB(18, 20, 30),
	card      = Color3.fromRGB(22, 24, 36),
	sidebar   = Color3.fromRGB(12, 12, 22),
	accent    = Color3.fromRGB(0, 120, 215),
	accentDim = Color3.fromRGB(0, 80, 150),
	accentGlow= Color3.fromRGB(50, 160, 255),
	accentSoft= Color3.fromRGB(0, 100, 190),
	text      = Color3.fromRGB(235, 240, 255),
	textMid   = Color3.fromRGB(160, 170, 200),
	textDim   = Color3.fromRGB(90, 95, 120),
	green     = Color3.fromRGB(40, 200, 100),
	red       = Color3.fromRGB(220, 60, 70),
	border    = Color3.fromRGB(40, 45, 65),
}

-- ============================================================
-- SIMPLE LOADING OVERLAY
-- ============================================================
local showLoading, hideLoading
do
	local loadGui = Instance.new("ScreenGui")
	loadGui.Name = "191_LOAD"
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
	glow.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
	glow.BackgroundTransparency = 0.88
	glow.BorderSizePixel = 0
	glow.ZIndex = 11
	Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

	local title = Instance.new("TextLabel", bg)
	title.Size = UDim2.new(0, 500, 0, 56)
	title.Position = UDim2.new(0.5, -250, 0.5, -50)
	title.BackgroundTransparency = 1
	title.Text = "191 STORE"
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 44
	title.TextColor3 = Color3.fromRGB(50, 160, 255)
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.ZIndex = 12

	local line = Instance.new("Frame", bg)
	line.Size = UDim2.new(0, 200, 0, 1)
	line.Position = UDim2.new(0.5, -100, 0.5, 14)
	line.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
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
	subLbl.TextColor3 = Color3.fromRGB(0, 100, 190)
	subLbl.TextXAlignment = Enum.TextXAlignment.Center
	subLbl.ZIndex = 12

	local ver = Instance.new("TextLabel", bg)
	ver.Size = UDim2.new(1, 0, 0, 18)
	ver.Position = UDim2.new(0, 0, 1, -22)
	ver.BackgroundTransparency = 1
	ver.Text = "191 STORE v191  •  Blue Edition"
	ver.Font = Enum.Font.Gotham
	ver.TextSize = 11
	ver.TextColor3 = Color3.fromRGB(60, 65, 90)
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
main.Size = UDim2.new(0, 500, 0, 450)
main.Position = UDim2.new(0.5, -250, 0.5, -225)
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
	titleLbl.Text = "191 STORE"
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
	badgeTxt.Text = "v191"
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
	notify("191 Store", "Script dihentikan.", "error")
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
-- TAB BUTTONS
-- ============================================================
local TabFrame = Instance.new("Frame", main)
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.Position = UDim2.new(0, 0, 0, 46)
TabFrame.BackgroundColor3 = C.surface
TabFrame.BorderSizePixel = 0

local tpTab = Instance.new("TextButton", TabFrame)
tpTab.Size = UDim2.new(0.25, 0, 1, 0)
tpTab.Position = UDim2.new(0, 0, 0, 0)
tpTab.BackgroundColor3 = C.accentDim
tpTab.Text = "TELEPORT"
tpTab.TextColor3 = C.text
tpTab.Font = Enum.Font.GothamBold
tpTab.TextSize = 12
tpTab.BorderSizePixel = 0

local msTab = Instance.new("TextButton", TabFrame)
msTab.Size = UDim2.new(0.25, 0, 1, 0)
msTab.Position = UDim2.new(0.25, 0, 0, 0)
msTab.BackgroundColor3 = C.card
msTab.Text = "AUTO MS"
msTab.TextColor3 = C.textMid
msTab.Font = Enum.Font.GothamBold
msTab.TextSize = 12
msTab.BorderSizePixel = 0

local buyTab = Instance.new("TextButton", TabFrame)
buyTab.Size = UDim2.new(0.25, 0, 1, 0)
buyTab.Position = UDim2.new(0.5, 0, 0, 0)
buyTab.BackgroundColor3 = C.card
buyTab.Text = "AUTO BUY"
buyTab.TextColor3 = C.textMid
buyTab.Font = Enum.Font.GothamBold
buyTab.TextSize = 12
buyTab.BorderSizePixel = 0

local sellTab = Instance.new("TextButton", TabFrame)
sellTab.Size = UDim2.new(0.25, 0, 1, 0)
sellTab.Position = UDim2.new(0.75, 0, 0, 0)
sellTab.BackgroundColor3 = C.card
sellTab.Text = "AUTO SELL"
sellTab.TextColor3 = C.textMid
sellTab.Font = Enum.Font.GothamBold
sellTab.TextSize = 12
sellTab.BorderSizePixel = 0

-- ============================================================
-- CONTENT AREA
-- ============================================================
local Content = Instance.new("Frame", main)
Content.Size = UDim2.new(1, 0, 1, -86)
Content.Position = UDim2.new(0, 0, 0, 86)
Content.BackgroundColor3 = C.panel
Content.BorderSizePixel = 0
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 0)

-- ============================================================
-- TELEPORT PAGE
-- ============================================================
local tpPage = Instance.new("ScrollingFrame", Content)
tpPage.Size = UDim2.new(1, 0, 1, 0)
tpPage.BackgroundTransparency = 1
tpPage.Visible = true
tpPage.ScrollBarThickness = 4
tpPage.ScrollBarImageColor3 = C.accentSoft
tpPage.CanvasSize = UDim2.new(0, 0, 0, 520)

local tpLayout = Instance.new("UIListLayout", tpPage)
tpLayout.Padding = UDim.new(0, 6)
tpLayout.SortOrder = Enum.SortOrder.LayoutOrder

local tpPadding = Instance.new("UIPadding", tpPage)
tpPadding.PaddingLeft = UDim.new(0, 10)
tpPadding.PaddingRight = UDim.new(0, 10)
tpPadding.PaddingTop = UDim.new(0, 10)
tpPadding.PaddingBottom = UDim.new(0, 10)

local LOCATIONS = {
    {name = "🏪 Dealer NPC",      pos = Vector3.new(770.992, 3.71, 433.75)},
    {name = "🍬 NPC Marshmallow", pos = Vector3.new(510.061, 4.476, 600.548)},
    {name = "🏠 Apart 1",         pos = Vector3.new(1137.992, 9.932, 449.753)},
    {name = "🏠 Apart 2",         pos = Vector3.new(1139.174, 9.932, 420.556)},
    {name = "🏠 Apart 3",         pos = Vector3.new(984.856, 9.932, 247.280)},
    {name = "🏠 Apart 4",         pos = Vector3.new(988.311, 9.932, 221.664)},
    {name = "🏠 Apart 5",         pos = Vector3.new(923.954, 9.932, 42.202)},
    {name = "🏠 Apart 6",         pos = Vector3.new(895.721, 9.932, 41.928)},
    {name = "🎰 Casino",          pos = Vector3.new(1166.33, 3.36, -29.77)},
    {name = "🏥 Hospital",        pos = Vector3.new(1065.19, 28.47, 420.76)},
    {name = "⚒️ Material Storage", pos = Vector3.new(521.32, 47.79, 617.25)},
}

for i, loc in ipairs(LOCATIONS) do
	local btn = Instance.new("TextButton", tpPage)
	btn.Size = UDim2.new(1, 0, 0, 45)
	btn.BackgroundColor3 = C.card
	btn.Text = loc.name
	btn.TextColor3 = C.text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.BorderSizePixel = 0
	btn.LayoutOrder = i
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = C.border
	stroke.Thickness = 1
	
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = C.accentDim}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = C.card}):Play()
	end)
	
	btn.MouseButton1Click:Connect(function()
		notify("Teleport", "Menuju "..loc.name.."...", "info")
		showLoading("Menuju " .. loc.name)
		vehicleTeleport(CFrame.new(loc.pos))
		hideLoading()
		notify("Teleport", "Tiba di "..loc.name, "success")
	end)
end

-- ============================================================
-- AUTO MS PAGE
-- ============================================================
local msPage = Instance.new("ScrollingFrame", Content)
msPage.Size = UDim2.new(1, 0, 1, 0)
msPage.BackgroundTransparency = 1
msPage.Visible = false
msPage.ScrollBarThickness = 4
msPage.ScrollBarImageColor3 = C.accentSoft
msPage.CanvasSize = UDim2.new(0, 0, 0, 380)

local msPadding = Instance.new("UIPadding", msPage)
msPadding.PaddingLeft = UDim.new(0, 10)
msPadding.PaddingRight = UDim.new(0, 10)
msPadding.PaddingTop = UDim.new(0, 10)

-- Status Card
local msStatusCard = Instance.new("Frame", msPage)
msStatusCard.Size = UDim2.new(1, 0, 0, 50)
msStatusCard.BackgroundColor3 = C.card
msStatusCard.BorderSizePixel = 0
Instance.new("UICorner", msStatusCard).CornerRadius = UDim.new(0, 8)

local msStatusLbl = Instance.new("TextLabel", msStatusCard)
msStatusLbl.Size = UDim2.new(1, -20, 1, 0)
msStatusLbl.Position = UDim2.new(0, 12, 0, 0)
msStatusLbl.BackgroundTransparency = 1
msStatusLbl.Text = "⏹️ STOPPED"
msStatusLbl.Font = Enum.Font.GothamBold
msStatusLbl.TextSize = 14
msStatusLbl.TextColor3 = C.red
msStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Step Card
local stepCard = Instance.new("Frame", msPage)
stepCard.Size = UDim2.new(1, 0, 0, 36)
stepCard.Position = UDim2.new(0, 0, 0, 60)
stepCard.BackgroundColor3 = C.card
stepCard.BorderSizePixel = 0
Instance.new("UICorner", stepCard).CornerRadius = UDim.new(0, 8)

local stepLbl = Instance.new("TextLabel", stepCard)
stepLbl.Size = UDim2.new(1, -20, 1, 0)
stepLbl.Position = UDim2.new(0, 12, 0, 0)
stepLbl.BackgroundTransparency = 1
stepLbl.Text = "Step: Waiting..."
stepLbl.Font = Enum.Font.Gotham
stepLbl.TextSize = 12
stepLbl.TextColor3 = C.textMid
stepLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Timer Card
local timerCard = Instance.new("Frame", msPage)
timerCard.Size = UDim2.new(1, 0, 0, 36)
timerCard.Position = UDim2.new(0, 0, 0, 104)
timerCard.BackgroundColor3 = C.card
timerCard.BorderSizePixel = 0
Instance.new("UICorner", timerCard).CornerRadius = UDim.new(0, 8)

local timerLbl = Instance.new("TextLabel", timerCard)
timerLbl.Size = UDim2.new(1, -20, 1, 0)
timerLbl.Position = UDim2.new(0, 12, 0, 0)
timerLbl.BackgroundTransparency = 1
timerLbl.Text = "Timer: 0s"
timerLbl.Font = Enum.Font.Gotham
timerLbl.TextSize = 12
timerLbl.TextColor3 = C.textMid
timerLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Tool Card
local toolCard = Instance.new("Frame", msPage)
toolCard.Size = UDim2.new(1, 0, 0, 36)
toolCard.Position = UDim2.new(0, 0, 0, 148)
toolCard.BackgroundColor3 = C.card
toolCard.BorderSizePixel = 0
Instance.new("UICorner", toolCard).CornerRadius = UDim.new(0, 8)

local toolLbl = Instance.new("TextLabel", toolCard)
toolLbl.Size = UDim2.new(1, -20, 1, 0)
toolLbl.Position = UDim2.new(0, 12, 0, 0)
toolLbl.BackgroundTransparency = 1
toolLbl.Text = "Tool: -"
toolLbl.Font = Enum.Font.GothamBold
toolLbl.TextSize = 12
toolLbl.TextColor3 = C.accentGlow
toolLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Inventory Card
local invCard = Instance.new("Frame", msPage)
invCard.Size = UDim2.new(1, 0, 0, 80)
invCard.Position = UDim2.new(0, 0, 0, 192)
invCard.BackgroundColor3 = C.card
invCard.BorderSizePixel = 0
Instance.new("UICorner", invCard).CornerRadius = UDim.new(0, 8)

local invTitle = Instance.new("TextLabel", invCard)
invTitle.Size = UDim2.new(1, -20, 0, 20)
invTitle.Position = UDim2.new(0, 12, 0, 5)
invTitle.BackgroundTransparency = 1
invTitle.Text = "INVENTORY"
invTitle.Font = Enum.Font.GothamBold
invTitle.TextSize = 11
invTitle.TextColor3 = C.textMid
invTitle.TextXAlignment = Enum.TextXAlignment.Left

local waterLbl = Instance.new("TextLabel", invCard)
waterLbl.Size = UDim2.new(1, -20, 0, 18)
waterLbl.Position = UDim2.new(0, 12, 0, 28)
waterLbl.BackgroundTransparency = 1
waterLbl.Text = "💧 Water: 0"
waterLbl.Font = Enum.Font.Gotham
waterLbl.TextSize = 11
waterLbl.TextColor3 = C.text
waterLbl.TextXAlignment = Enum.TextXAlignment.Left

local sugarLbl = Instance.new("TextLabel", invCard)
sugarLbl.Size = UDim2.new(1, -20, 0, 18)
sugarLbl.Position = UDim2.new(0, 12, 0, 46)
sugarLbl.BackgroundTransparency = 1
sugarLbl.Text = "🍚 Sugar: 0"
sugarLbl.Font = Enum.Font.Gotham
sugarLbl.TextSize = 11
sugarLbl.TextColor3 = C.text
sugarLbl.TextXAlignment = Enum.TextXAlignment.Left

local gelatinLbl = Instance.new("TextLabel", invCard)
gelatinLbl.Size = UDim2.new(1, -20, 0, 18)
gelatinLbl.Position = UDim2.new(0, 12, 0, 64)
gelatinLbl.BackgroundTransparency = 1
gelatinLbl.Text = "🧪 Gelatin: 0"
gelatinLbl.Font = Enum.Font.Gotham
gelatinLbl.TextSize = 11
gelatinLbl.TextColor3 = C.text
gelatinLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons
local msStartBtn = Instance.new("TextButton", msPage)
msStartBtn.Size = UDim2.new(0.48, 0, 0, 42)
msStartBtn.Position = UDim2.new(0, 0, 0, 282)
msStartBtn.BackgroundColor3 = C.green
msStartBtn.Text = "▶️ START MS"
msStartBtn.TextColor3 = Color3.fromRGB(255,255,255)
msStartBtn.Font = Enum.Font.GothamBold
msStartBtn.TextSize = 13
msStartBtn.BorderSizePixel = 0
Instance.new("UICorner", msStartBtn).CornerRadius = UDim.new(0, 8)

local msStopBtn = Instance.new("TextButton", msPage)
msStopBtn.Size = UDim2.new(0.48, 0, 0, 42)
msStopBtn.Position = UDim2.new(0.52, 0, 0, 282)
msStopBtn.BackgroundColor3 = C.red
msStopBtn.Text = "⏹️ STOP MS"
msStopBtn.TextColor3 = Color3.fromRGB(255,255,255)
msStopBtn.Font = Enum.Font.GothamBold
msStopBtn.TextSize = 13
msStopBtn.BorderSizePixel = 0
Instance.new("UICorner", msStopBtn).CornerRadius = UDim.new(0, 8)

-- ============================================================
-- AUTO BUY PAGE
-- ============================================================
local buyPage = Instance.new("ScrollingFrame", Content)
buyPage.Size = UDim2.new(1, 0, 1, 0)
buyPage.BackgroundTransparency = 1
buyPage.Visible = false
buyPage.ScrollBarThickness = 4
buyPage.ScrollBarImageColor3 = C.accentSoft
buyPage.CanvasSize = UDim2.new(0, 0, 0, 280)

local buyPadding = Instance.new("UIPadding", buyPage)
buyPadding.PaddingLeft = UDim.new(0, 10)
buyPadding.PaddingRight = UDim.new(0, 10)
buyPadding.PaddingTop = UDim.new(0, 10)

-- Buy Status Card
local buyStatusCard = Instance.new("Frame", buyPage)
buyStatusCard.Size = UDim2.new(1, 0, 0, 50)
buyStatusCard.BackgroundColor3 = C.card
buyStatusCard.BorderSizePixel = 0
Instance.new("UICorner", buyStatusCard).CornerRadius = UDim.new(0, 8)

local buyStatusLbl = Instance.new("TextLabel", buyStatusCard)
buyStatusLbl.Size = UDim2.new(1, -20, 1, 0)
buyStatusLbl.Position = UDim2.new(0, 12, 0, 0)
buyStatusLbl.BackgroundTransparency = 1
buyStatusLbl.Text = "⏹️ STOPPED"
buyStatusLbl.Font = Enum.Font.GothamBold
buyStatusLbl.TextSize = 14
buyStatusLbl.TextColor3 = C.red
buyStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Amount Card
local amountCard = Instance.new("Frame", buyPage)
amountCard.Size = UDim2.new(1, 0, 0, 80)
amountCard.Position = UDim2.new(0, 0, 0, 60)
amountCard.BackgroundColor3 = C.card
amountCard.BorderSizePixel = 0
Instance.new("UICorner", amountCard).CornerRadius = UDim.new(0, 8)

local amountTitle = Instance.new("TextLabel", amountCard)
amountTitle.Size = UDim2.new(1, -20, 0, 20)
amountTitle.Position = UDim2.new(0, 12, 0, 5)
amountTitle.BackgroundTransparency = 1
amountTitle.Text = "JUMLAH BELI PER ITEM"
amountTitle.Font = Enum.Font.GothamBold
amountTitle.TextSize = 11
amountTitle.TextColor3 = C.textMid
amountTitle.TextXAlignment = Enum.TextXAlignment.Left

local amountValue = Instance.new("TextLabel", amountCard)
amountValue.Size = UDim2.new(0.2, 0, 0, 30)
amountValue.Position = UDim2.new(0.8, -10, 0, 45)
amountValue.BackgroundTransparency = 1
amountValue.Text = "10x"
amountValue.Font = Enum.Font.GothamBold
amountValue.TextSize = 16
amountValue.TextColor3 = C.accentGlow
amountValue.TextXAlignment = Enum.TextXAlignment.Right

local sliderBg = Instance.new("Frame", amountCard)
sliderBg.Size = UDim2.new(0.7, 0, 0, 6)
sliderBg.Position = UDim2.new(0.1, 0, 0, 55)
sliderBg.BackgroundColor3 = C.border
sliderBg.BorderSizePixel = 0
Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 3)

local sliderFill = Instance.new("Frame", sliderBg)
sliderFill.Size = UDim2.new(0.18, 0, 1, 0)
sliderFill.BackgroundColor3 = C.accent
sliderFill.BorderSizePixel = 0
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 3)

-- Buy Buttons
local buyStartBtn = Instance.new("TextButton", buyPage)
buyStartBtn.Size = UDim2.new(0.48, 0, 0, 42)
buyStartBtn.Position = UDim2.new(0, 0, 0, 150)
buyStartBtn.BackgroundColor3 = C.green
buyStartBtn.Text = "▶️ START BUY"
buyStartBtn.TextColor3 = Color3.fromRGB(255,255,255)
buyStartBtn.Font = Enum.Font.GothamBold
buyStartBtn.TextSize = 13
buyStartBtn.BorderSizePixel = 0
Instance.new("UICorner", buyStartBtn).CornerRadius = UDim.new(0, 8)

local buyStopBtn = Instance.new("TextButton", buyPage)
buyStopBtn.Size = UDim2.new(0.48, 0, 0, 42)
buyStopBtn.Position = UDim2.new(0.52, 0, 0, 150)
buyStopBtn.BackgroundColor3 = C.red
buyStopBtn.Text = "⏹️ STOP BUY"
buyStopBtn.TextColor3 = Color3.fromRGB(255,255,255)
buyStopBtn.Font = Enum.Font.GothamBold
buyStopBtn.TextSize = 13
buyStopBtn.BorderSizePixel = 0
Instance.new("UICorner", buyStopBtn).CornerRadius = UDim.new(0, 8)

local buyTotalCard = Instance.new("Frame", buyPage)
buyTotalCard.Size = UDim2.new(1, 0, 0, 36)
buyTotalCard.Position = UDim2.new(0, 0, 0, 202)
buyTotalCard.BackgroundColor3 = C.card
buyTotalCard.BorderSizePixel = 0
Instance.new("UICorner", buyTotalCard).CornerRadius = UDim.new(0, 8)

local buyTotalLbl = Instance.new("TextLabel", buyTotalCard)
buyTotalLbl.Size = UDim2.new(1, -20, 1, 0)
buyTotalLbl.Position = UDim2.new(0, 12, 0, 0)
buyTotalLbl.BackgroundTransparency = 1
buyTotalLbl.Text = "Total: 0 item"
buyTotalLbl.Font = Enum.Font.Gotham
buyTotalLbl.TextSize = 12
buyTotalLbl.TextColor3 = C.textMid
buyTotalLbl.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================================
-- AUTO SELL PAGE
-- ============================================================
local sellPage = Instance.new("ScrollingFrame", Content)
sellPage.Size = UDim2.new(1, 0, 1, 0)
sellPage.BackgroundTransparency = 1
sellPage.Visible = false
sellPage.ScrollBarThickness = 4
sellPage.ScrollBarImageColor3 = C.accentSoft
sellPage.CanvasSize = UDim2.new(0, 0, 0, 250)

local sellPadding = Instance.new("UIPadding", sellPage)
sellPadding.PaddingLeft = UDim.new(0, 10)
sellPadding.PaddingRight = UDim.new(0, 10)
sellPadding.PaddingTop = UDim.new(0, 10)

-- Sell Status Card
local sellStatusCard = Instance.new("Frame", sellPage)
sellStatusCard.Size = UDim2.new(1, 0, 0, 50)
sellStatusCard.BackgroundColor3 = C.card
sellStatusCard.BorderSizePixel = 0
Instance.new("UICorner", sellStatusCard).CornerRadius = UDim.new(0, 8)

local sellStatusLbl = Instance.new("TextLabel", sellStatusCard)
sellStatusLbl.Size = UDim2.new(1, -20, 1, 0)
sellStatusLbl.Position = UDim2.new(0, 12, 0, 0)
sellStatusLbl.BackgroundTransparency = 1
sellStatusLbl.Text = "⏹️ STOPPED"
sellStatusLbl.Font = Enum.Font.GothamBold
sellStatusLbl.TextSize = 14
sellStatusLbl.TextColor3 = C.red
sellStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Sell Counter Card
local sellCounterCard = Instance.new("Frame", sellPage)
sellCounterCard.Size = UDim2.new(1, 0, 0, 40)
sellCounterCard.Position = UDim2.new(0, 0, 0, 60)
sellCounterCard.BackgroundColor3 = C.card
sellCounterCard.BorderSizePixel = 0
Instance.new("UICorner", sellCounterCard).CornerRadius = UDim.new(0, 8)

local sellCounterLbl = Instance.new("TextLabel", sellCounterCard)
sellCounterLbl.Size = UDim2.new(1, -20, 1, 0)
sellCounterLbl.Position = UDim2.new(0, 12, 0, 0)
sellCounterLbl.BackgroundTransparency = 1
sellCounterLbl.Text = "Terjual: 0"
sellCounterLbl.Font = Enum.Font.GothamBold
sellCounterLbl.TextSize = 12
sellCounterLbl.TextColor3 = C.accentGlow
sellCounterLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Sell Buttons
local sellStartBtn = Instance.new("TextButton", sellPage)
sellStartBtn.Size = UDim2.new(0.48, 0, 0, 42)
sellStartBtn.Position = UDim2.new(0, 0, 0, 110)
sellStartBtn.BackgroundColor3 = C.green
sellStartBtn.Text = "▶️ START SELL"
sellStartBtn.TextColor3 = Color3.fromRGB(255,255,255)
sellStartBtn.Font = Enum.Font.GothamBold
sellStartBtn.TextSize = 13
sellStartBtn.BorderSizePixel = 0
Instance.new("UICorner", sellStartBtn).CornerRadius = UDim.new(0, 8)

local sellStopBtn = Instance.new("TextButton", sellPage)
sellStopBtn.Size = UDim2.new(0.48, 0, 0, 42)
sellStopBtn.Position = UDim2.new(0.52, 0, 0, 110)
sellStopBtn.BackgroundColor3 = C.red
sellStopBtn.Text = "⏹️ STOP SELL"
sellStopBtn.TextColor3 = Color3.fromRGB(255,255,255)
sellStopBtn.Font = Enum.Font.GothamBold
sellStopBtn.TextSize = 13
sellStopBtn.BorderSizePixel = 0
Instance.new("UICorner", sellStopBtn).CornerRadius = UDim.new(0, 8)

local sellToolsCard = Instance.new("Frame", sellPage)
sellToolsCard.Size = UDim2.new(1, 0, 0, 36)
sellToolsCard.Position = UDim2.new(0, 0, 0, 162)
sellToolsCard.BackgroundColor3 = C.card
sellToolsCard.BorderSizePixel = 0
Instance.new("UICorner", sellToolsCard).CornerRadius = UDim.new(0, 8)

local sellToolsLbl = Instance.new("TextLabel", sellToolsCard)
sellToolsLbl.Size = UDim2.new(1, -20, 1, 0)
sellToolsLbl.Position = UDim2.new(0, 12, 0, 0)
sellToolsLbl.BackgroundTransparency = 1
sellToolsLbl.Text = "Tools: 0"
sellToolsLbl.Font = Enum.Font.Gotham
sellToolsLbl.TextSize = 12
sellToolsLbl.TextColor3 = C.textMid
sellToolsLbl.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================================
-- HP SAFE LOGIC (otomatis saat MS start/stop)
-- ============================================================
local hpMonitoringActive = false
local isInSafeZone = false
local originalPosition = nil
local safeZoneTimerThread = nil
local currentHumanoid = nil
local lastHealthPercent = 100

local SAFE_ZONE_CFRAME = CFrame.new(537.71, 4.59, -537.09) * CFrame.Angles(-1.20, -1.56, -1.20)

local function teleportToSafeZone()
    local character = player.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not hum then return false end
    
    local seatPart = hum.SeatPart
    if seatPart then
        local vehicle = seatPart:FindFirstAncestorOfClass("Model")
        if vehicle then
            if vehicle.PrimaryPart then
                vehicle:SetPrimaryPartCFrame(SAFE_ZONE_CFRAME)
            end
            return true
        end
    else
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
            hrp.CFrame = SAFE_ZONE_CFRAME
            task.wait(0.05)
            hrp.Anchored = false
            return true
        end
    end
    return false
end

local function teleportBackToOriginal()
    if originalPosition then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
            hrp.CFrame = originalPosition
            task.wait(0.05)
            hrp.Anchored = false
        end
        originalPosition = nil
    end
    isInSafeZone = false
end

local function saveOriginalPosition()
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp then
        originalPosition = hrp.CFrame
        return true
    end
    return false
end

local function startSafeZoneTimer()
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
    end
    
    safeZoneTimerThread = task.spawn(function()
        task.wait(8)
        if isInSafeZone and hpMonitoringActive then
            teleportBackToOriginal()
        end
        safeZoneTimerThread = nil
    end)
end

local function onCharacterAdded(character)
    currentHumanoid = character:WaitForChild("Humanoid")
    lastHealthPercent = (currentHumanoid.Health / currentHumanoid.MaxHealth) * 100
    isInSafeZone = false
    originalPosition = nil
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
        safeZoneTimerThread = nil
    end
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

local function checkHealthAndTeleport()
    if not hpMonitoringActive then return end
    if not currentHumanoid or currentHumanoid.Parent == nil then
        local character = player.Character
        if character then
            currentHumanoid = character:FindFirstChildOfClass("Humanoid")
        end
        if not currentHumanoid then return end
    end
    
    local currentHealth = currentHumanoid.Health
    local maxHealth = currentHumanoid.MaxHealth
    
    if maxHealth > 0 then
        local currentPercent = (currentHealth / maxHealth) * 100
        local percentDropped = lastHealthPercent - currentPercent
        
        if percentDropped >= 1 and not isInSafeZone then
            saveOriginalPosition()
            
            if teleportToSafeZone() then
                isInSafeZone = true
                startSafeZoneTimer()
            end
        end
        
        lastHealthPercent = currentPercent
    end
end

local hpMonitorThread = nil
local function startHPMonitoring()
    if hpMonitoringActive then return end
    hpMonitoringActive = true
    isInSafeZone = false
    originalPosition = nil
    
    if currentHumanoid then
        lastHealthPercent = (currentHumanoid.Health / currentHumanoid.MaxHealth) * 100
    else
        lastHealthPercent = 100
    end
    
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
        safeZoneTimerThread = nil
    end
    
    hpMonitorThread = task.spawn(function()
        while hpMonitoringActive do
            checkHealthAndTeleport()
            task.wait(0.3)
        end
    end)
end

local function stopHPMonitoring()
    hpMonitoringActive = false
    
    if safeZoneTimerThread then
        task.cancel(safeZoneTimerThread)
        safeZoneTimerThread = nil
    end
    
    if hpMonitorThread then
        task.cancel(hpMonitorThread)
        hpMonitorThread = nil
    end
    
    if isInSafeZone then
        teleportBackToOriginal()
    end
    
    isInSafeZone = false
    originalPosition = nil
end

-- ============================================================
-- MS LOOP LOGIC (masak semua bahan di inventory)
-- ============================================================
local loopRunning = false

local function pressE2()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function updateInventoryDisplay()
    local waterCount = countItem("Water")
    local sugarCount = countItem("Sugar Block Bag")
    local gelatinCount = countItem("Gelatin")
    
    waterLbl.Text = "💧 Water: " .. waterCount
    sugarLbl.Text = "🍚 Sugar: " .. sugarCount
    gelatinLbl.Text = "🧪 Gelatin: " .. gelatinCount
    
    if waterCount > 0 then waterLbl.TextColor3 = C.accentGlow
    else waterLbl.TextColor3 = C.text end
    
    if sugarCount > 0 then sugarLbl.TextColor3 = C.accentGlow
    else sugarLbl.TextColor3 = C.text end
    
    if gelatinCount > 0 then gelatinLbl.TextColor3 = C.accentGlow
    else gelatinLbl.TextColor3 = C.text end
end

local function startMSLoop()
    if loopRunning then return end
    loopRunning = true
    msStatusLbl.Text = "▶️ RUNNING"
    msStatusLbl.TextColor3 = C.green
    
    -- Aktifkan HP Safe otomatis
    startHPMonitoring()
    
    task.spawn(function()
        while loopRunning do
            updateInventoryDisplay()
            
            -- Masak Water (20 detik)
            local waterTool = findTool("water")
            if waterTool and equip(waterTool.Name) then
                toolLbl.Text = "Tool: WATER"
                stepLbl.Text = "Step: Cooking Water..."
                pressE2()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 20 do
                    local remaining = 20 - (tick() - startTime)
                    timerLbl.Text = string.format("Timer: %d/20s", math.floor(remaining))
                    task.wait(0.1)
                end
            else
                stepLbl.Text = "No Water tool found! Waiting..."
                task.wait(5)
            end
            
            if not loopRunning then break end
            
            -- Masak Sugar (1 detik)
            local sugarTool = findTool("sugar")
            if sugarTool and equip(sugarTool.Name) then
                toolLbl.Text = "Tool: SUGAR"
                stepLbl.Text = "Step: Cooking Sugar..."
                pressE2()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 1 do
                    task.wait(0.1)
                end
                timerLbl.Text = "Timer: 0s"
            else
                stepLbl.Text = "No Sugar tool found! Waiting..."
                task.wait(5)
            end
            
            task.wait(0.5)
            if not loopRunning then break end
            
            -- Masak Gelatin (45 detik)
            local gelatinTool = findTool("gelatin")
            if gelatinTool and equip(gelatinTool.Name) then
                toolLbl.Text = "Tool: GELATIN"
                stepLbl.Text = "Step: Cooking Gelatin..."
                pressE2()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 45 do
                    local remaining = 45 - (tick() - startTime)
                    timerLbl.Text = string.format("Timer: %d/45s", math.floor(remaining))
                    task.wait(0.1)
                end
            else
                stepLbl.Text = "No Gelatin tool found! Waiting..."
                task.wait(5)
            end
            
            task.wait(3)
            if not loopRunning then break end
            
            -- Ambil hasil (Empty Bag)
            local emptyTool = findTool("empty") or findTool("bag")
            if emptyTool and equip(emptyTool.Name) then
                toolLbl.Text = "Tool: EMPTY BAG"
                stepLbl.Text = "Step: Collecting Result..."
                pressE2()
                local startTime = tick()
                while loopRunning and (tick() - startTime) < 2 do
                    local remaining = 2 - (tick() - startTime)
                    timerLbl.Text = string.format("Timer: %d/2s", math.floor(remaining))
                    task.wait(0.1)
                end
            else
                stepLbl.Text = "No Empty Bag found! Waiting..."
                task.wait(5)
            end
            
            updateInventoryDisplay()
            stepLbl.Text = "Loop complete! Restarting..."
            task.wait(2)
        end
        
        loopRunning = false
        msStatusLbl.Text = "⏹️ STOPPED"
        msStatusLbl.TextColor3 = C.red
        stepLbl.Text = "Step: Stopped"
        timerLbl.Text = "Timer: 0s"
        toolLbl.Text = "Tool: -"
        
        -- Matikan HP Safe otomatis saat MS stop
        stopHPMonitoring()
    end)
end

local function stopMSLoop()
    loopRunning = false
    stopHPMonitoring()
end

msStartBtn.MouseButton1Click:Connect(function()
    if not loopRunning then task.spawn(startMSLoop) end
end)

msStopBtn.MouseButton1Click:Connect(function()
    loopRunning = false
end)

-- ============================================================
-- AUTO BUY LOGIC
-- ============================================================
local autoBuyRunning = false
local autoBuyTotalBought = 0

local function setBuyAmount(amount)
    buyAmount = math.clamp(amount, 1, 50)
    amountValue.Text = buyAmount .. "x"
    sliderFill.Size = UDim2.new((buyAmount - 1) / 49, 0, 1, 0)
end

local isDragging = false

sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        local mousePos = input.Position.X
        local sliderPos = sliderBg.AbsolutePosition.X
        local sliderWidth = sliderBg.AbsoluteSize.X
        local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        local newAmount = math.floor(1 + percent * 49)
        setBuyAmount(newAmount)
    end
end)

UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
        local mousePos = input.Position.X
        local sliderPos = sliderBg.AbsolutePosition.X
        local sliderWidth = sliderBg.AbsoluteSize.X
        
        if mousePos >= sliderPos and mousePos <= sliderPos + sliderWidth then
            local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
            local newAmount = math.floor(1 + percent * 49)
            setBuyAmount(newAmount)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

local function startAutoBuy()
    if autoBuyRunning then return end
    if not storePurchaseRE then
        buyStatusLbl.Text = "❌ RemoteEvent Error!"
        buyStatusLbl.TextColor3 = C.red
        task.wait(2)
        buyStatusLbl.Text = "⏹️ STOPPED"
        return
    end
    
    autoBuyRunning = true
    autoBuyTotalBought = 0
    buyStatusLbl.Text = "▶️ RUNNING"
    buyStatusLbl.TextColor3 = C.green
    buyTotalLbl.Text = "Total: 0 item"
    
    local BUY_ITEMS = {"Water", "Sugar Block Bag", "Gelatin"}
    
    task.spawn(function()
        local amount = buyAmount
        
        for _, itemName in ipairs(BUY_ITEMS) do
            if not autoBuyRunning then break end
            
            buyStatusLbl.Text = "🛒 Buying " .. itemName .. " x" .. amount
            buyStatusLbl.TextColor3 = Color3.fromRGB(255,255,100)
            
            for i = 1, amount do
                if not autoBuyRunning then break end
                
                pcall(function()
                    storePurchaseRE:FireServer(itemName, 1)
                end)
                
                autoBuyTotalBought = autoBuyTotalBought + 1
                buyTotalLbl.Text = "Total: " .. autoBuyTotalBought .. " items"
                task.wait(0.5)
            end
            
            task.wait(0.8)
        end
        
        if autoBuyRunning then
            buyStatusLbl.Text = "✅ Complete! " .. autoBuyTotalBought .. " items"
            buyStatusLbl.TextColor3 = C.green
            task.wait(2)
            if autoBuyRunning then
                buyStatusLbl.Text = "⏹️ STOPPED"
                buyStatusLbl.TextColor3 = C.red
                autoBuyRunning = false
            end
        end
        updateInventoryDisplay()
    end)
end

local function stopAutoBuy()
    autoBuyRunning = false
    buyStatusLbl.Text = "⏹️ STOPPED"
    buyStatusLbl.TextColor3 = C.red
end

buyStartBtn.MouseButton1Click:Connect(startAutoBuy)
buyStopBtn.MouseButton1Click:Connect(stopAutoBuy)

-- ============================================================
-- AUTO SELL LOGIC
-- ============================================================
local autoSellRunning = false
local autoSellCount = 0

local SELL_TOOLS = {"Small Marshmallow Bag", "Medium Marshmallow Bag", "Large Marshmallow Bag"}

local function getSellTools()
    local tools = {}
    if player.Character then
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("Tool") then
                for _, toolName in ipairs(SELL_TOOLS) do
                    if child.Name == toolName then table.insert(tools, child) break end
                end
            end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                for _, toolName in ipairs(SELL_TOOLS) do
                    if child.Name == toolName then table.insert(tools, child) break end
                end
            end
        end
    end
    return tools
end

local function startAutoSell()
    if autoSellRunning then return end
    autoSellRunning = true
    autoSellCount = 0
    sellStatusLbl.Text = "▶️ RUNNING"
    sellStatusLbl.TextColor3 = C.green
    
    task.spawn(function()
        while autoSellRunning do
            local tools = getSellTools()
            sellToolsLbl.Text = "Tools: " .. #tools
            
            if #tools > 0 then
                for _, tool in ipairs(tools) do
                    if not autoSellRunning then break end
                    if tool and tool.Parent then
                        if tool.Parent == player:FindFirstChild("Backpack") then
                            local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                            if humanoid then humanoid:EquipTool(tool) task.wait(0.3) end
                        end
                        sellStatusLbl.Text = "▶️ SELLING..."
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        local holdStart = tick()
                        while autoSellRunning and (tick() - holdStart) < 2 do task.wait(0.1) end
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        autoSellCount = autoSellCount + 1
                        sellCounterLbl.Text = "Terjual: " .. autoSellCount
                        sellStatusLbl.Text = "▶️ RUNNING"
                        task.wait(1)
                    end
                end
            else
                task.wait(2)
            end
            task.wait(0.5)
        end
    end)
end

local function stopAutoSell()
    autoSellRunning = false
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    sellStatusLbl.Text = "⏹️ STOPPED"
    sellStatusLbl.TextColor3 = C.red
end

sellStartBtn.MouseButton1Click:Connect(startAutoSell)
sellStopBtn.MouseButton1Click:Connect(stopAutoSell)

-- ============================================================
-- TAB SWITCHING
-- ============================================================
local function switchTab(tab)
    tpPage.Visible = (tab == "tp")
    msPage.Visible = (tab == "ms")
    buyPage.Visible = (tab == "buy")
    sellPage.Visible = (tab == "sell")
    
    tpTab.BackgroundColor3 = (tab == "tp") and C.accentDim or C.card
    msTab.BackgroundColor3 = (tab == "ms") and C.accentDim or C.card
    buyTab.BackgroundColor3 = (tab == "buy") and C.accentDim or C.card
    sellTab.BackgroundColor3 = (tab == "sell") and C.accentDim or C.card
    
    tpTab.TextColor3 = (tab == "tp") and C.text or C.textMid
    msTab.TextColor3 = (tab == "ms") and C.text or C.textMid
    buyTab.TextColor3 = (tab == "buy") and C.text or C.textMid
    sellTab.TextColor3 = (tab == "sell") and C.text or C.textMid
end

tpTab.MouseButton1Click:Connect(function() switchTab("tp") end)
msTab.MouseButton1Click:Connect(function() switchTab("ms") end)
buyTab.MouseButton1Click:Connect(function() switchTab("buy") end)
sellTab.MouseButton1Click:Connect(function() switchTab("sell") end)

-- ============================================================
-- MINIMIZE BUTTON
-- ============================================================
local minimized = false
local openSize = UDim2.new(0, 500, 0, 450)
local closedSize = UDim2.new(0, 500, 0, 50)
local tweenInfo = TweenInfo.new(0.3)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        tpPage.Visible = false
        msPage.Visible = false
        buyPage.Visible = false
        sellPage.Visible = false
        TabFrame.Visible = false
        minBtn.Text = "□"
        TweenService:Create(main, tweenInfo, {Size = closedSize}):Play()
    else
        TweenService:Create(main, tweenInfo, {Size = openSize}):Play()
        task.wait(0.3)
        tpPage.Visible = true
        TabFrame.Visible = true
        minBtn.Text = "−"
    end
end)

-- ============================================================
-- HIDE BUTTON + KEYBIND Z
-- ============================================================
local hideBtn = Instance.new("TextButton", gui)
hideBtn.Size = UDim2.new(0, 42, 0, 42)
hideBtn.Position = UDim2.new(1, -52, 0.5, -21)
hideBtn.Text = "191"
hideBtn.Font = Enum.Font.GothamBlack
hideBtn.TextSize = 12
hideBtn.BackgroundColor3 = C.accent
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Active = true
hideBtn.Draggable = true
hideBtn.BorderSizePixel = 0
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 10)

hideBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

ContextActionService:BindAction("toggleUI_191", function(_, state)
    if state == Enum.UserInputState.Begin then
        main.Visible = not main.Visible
    end
end, false, Enum.KeyCode.Z)

-- ============================================================
-- STARTUP
-- ============================================================
switchTab("tp")
setBuyAmount(10)
task.wait(0.3)
notify("191 STORE", "Script berhasil diload! v191", "success")

-- Auto refresh
task.spawn(function()
    while true do
        task.wait(2)
        if msPage.Visible then
            updateInventoryDisplay()
        end
        if sellPage.Visible then
            sellToolsLbl.Text = "Tools: " .. #getSellTools()
        end
    end
end)
