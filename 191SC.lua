local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.Name = "TP_Hub_191"
ScreenGui.ResetOnSpawn = false

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,400,0,600)
Frame.Position = UDim2.new(0.5,-200,0.5,-300)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true

-- Rounded Corners
local Corner = Instance.new("UICorner")
Corner.Parent = Frame
Corner.CornerRadius = UDim.new(0,10)

-- Stroke
local Stroke = Instance.new("UIStroke")
Stroke.Parent = Frame
Stroke.Color = Color3.fromRGB(45,45,55)
Stroke.Thickness = 2

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = Frame
TitleBar.Size = UDim2.new(1,0,0,60)
TitleBar.BackgroundColor3 = Color3.fromRGB(35,35,45)
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = TitleBar
TitleCorner.CornerRadius = UDim.new(0,10)

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1,-40,0,30)
Title.Position = UDim2.new(0,10,0,5)
Title.BackgroundTransparency = 1
Title.Text = "! 191 STORE !"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Billboard Text
local BillboardText = Instance.new("TextLabel")
BillboardText.Parent = TitleBar
BillboardText.Size = UDim2.new(1,-40,0,20)
BillboardText.Position = UDim2.new(0,10,0,30)
BillboardText.BackgroundTransparency = 1
BillboardText.Text = "Mau join 191 store? https://discord.gg/h5CWN2sP4y"
BillboardText.TextColor3 = Color3.fromRGB(100,200,255)
BillboardText.TextXAlignment = Enum.TextXAlignment.Left
BillboardText.Font = Enum.Font.Gotham
BillboardText.TextSize = 12
BillboardText.TextWrapped = true

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TitleBar
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-35,0,15)
MinBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold

local MinCorner = Instance.new("UICorner")
MinCorner.Parent = MinBtn
MinCorner.CornerRadius = UDim.new(0,8)

-- Billboard changer
local billboardMessages = {
    {text = "Mau join 191 store? https://discord.gg/h5CWN2sP4y", color = Color3.fromRGB(100,200,255)},
    {text = "Mau Kasih saran? ke dc ajaa", color = Color3.fromRGB(255,255,100)},
    {text = "ada bug? lapor di dc", color = Color3.fromRGB(255,150,200)}
}
local currentBillboard = 1

task.spawn(function()
    while true do
        task.wait(60)
        currentBillboard = (currentBillboard % #billboardMessages) + 1
        BillboardText.Text = billboardMessages[currentBillboard].text
        BillboardText.TextColor3 = billboardMessages[currentBillboard].color
    end
end)

-- Tab Buttons - SEKARANG 4 TAB (TP, MS AUTO, AUTO BUY, MS SAFETY)
local TabFrame = Instance.new("Frame")
TabFrame.Parent = Frame
TabFrame.Size = UDim2.new(1,0,0,40)
TabFrame.Position = UDim2.new(0,0,0,60)
TabFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
TabFrame.BorderSizePixel = 0

-- TP Tab Button
local TPTabBtn = Instance.new("TextButton")
TPTabBtn.Parent = TabFrame
TPTabBtn.Size = UDim2.new(0.25,-2,1,-8)
TPTabBtn.Position = UDim2.new(0,4,0,4)
TPTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
TPTabBtn.Text = "🚀 TP"
TPTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
TPTabBtn.Font = Enum.Font.GothamBold
TPTabBtn.TextSize = 14

local TPTabCorner = Instance.new("UICorner")
TPTabCorner.Parent = TPTabBtn
TPTabCorner.CornerRadius = UDim.new(0,8)

-- MS Loop Tab Button
local MSLoopTabBtn = Instance.new("TextButton")
MSLoopTabBtn.Parent = TabFrame
MSLoopTabBtn.Size = UDim2.new(0.25,-2,1,-8)
MSLoopTabBtn.Position = UDim2.new(0.25,0,0,4)
MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
MSLoopTabBtn.Text = "🔄 MS AUTO"
MSLoopTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
MSLoopTabBtn.Font = Enum.Font.GothamBold
MSLoopTabBtn.TextSize = 14

local MSLoopTabCorner = Instance.new("UICorner")
MSLoopTabCorner.Parent = MSLoopTabBtn
MSLoopTabCorner.CornerRadius = UDim.new(0,8)

-- Auto Buy Tab Button
local AutoBuyTabBtn = Instance.new("TextButton")
AutoBuyTabBtn.Parent = TabFrame
AutoBuyTabBtn.Size = UDim2.new(0.25,-2,1,-8)
AutoBuyTabBtn.Position = UDim2.new(0.5,0,0,4)
AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
AutoBuyTabBtn.Text = "💰 AUTO BUY"
AutoBuyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
AutoBuyTabBtn.Font = Enum.Font.GothamBold
AutoBuyTabBtn.TextSize = 14

local AutoBuyTabCorner = Instance.new("UICorner")
AutoBuyTabCorner.Parent = AutoBuyTabBtn
AutoBuyTabCorner.CornerRadius = UDim.new(0,8)

-- ========== [DYRON] TAB MS SAFETY BARU ==========
local MSSafetyTabBtn = Instance.new("TextButton")
MSSafetyTabBtn.Parent = TabFrame
MSSafetyTabBtn.Size = UDim2.new(0.25,-2,1,-8)
MSSafetyTabBtn.Position = UDim2.new(0.75,0,0,4)
MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
MSSafetyTabBtn.Text = "🛡️ MS SAFETY"
MSSafetyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
MSSafetyTabBtn.Font = Enum.Font.GothamBold
MSSafetyTabBtn.TextSize = 14

local MSSafetyTabCorner = Instance.new("UICorner")
MSSafetyTabCorner.Parent = MSSafetyTabBtn
MSSafetyTabCorner.CornerRadius = UDim.new(0,8)

-- Content Container
local Content = Instance.new("Frame")
Content.Parent = Frame
Content.Size = UDim2.new(1,0,1,-100)
Content.Position = UDim2.new(0,0,0,100)
Content.BackgroundColor3 = Color3.fromRGB(25,25,35)
Content.BorderSizePixel = 0
Content.BackgroundTransparency = 0.1

local ContentCorner = Instance.new("UICorner")
ContentCorner.Parent = Content
ContentCorner.CornerRadius = UDim.new(0,10)

-- TP Tab Content
local TPContent = Instance.new("ScrollingFrame")
TPContent.Parent = Content
TPContent.Size = UDim2.new(1,0,1,0)
TPContent.BackgroundTransparency = 1
TPContent.Visible = true
TPContent.ScrollBarThickness = 6
TPContent.CanvasSize = UDim2.new(0,0,0,200)

-- MS Loop Tab Content
local MSLoopContent = Instance.new("ScrollingFrame")
MSLoopContent.Parent = Content
MSLoopContent.Size = UDim2.new(1,0,1,0)
MSLoopContent.BackgroundTransparency = 1
MSLoopContent.Visible = false
MSLoopContent.ScrollBarThickness = 6
MSLoopContent.CanvasSize = UDim2.new(0,0,0,400)

-- Auto Buy Tab Content
local AutoBuyContent = Instance.new("ScrollingFrame")
AutoBuyContent.Parent = Content
AutoBuyContent.Size = UDim2.new(1,0,1,0)
AutoBuyContent.BackgroundTransparency = 1
AutoBuyContent.Visible = false
AutoBuyContent.ScrollBarThickness = 6
AutoBuyContent.CanvasSize = UDim2.new(0,0,0,550)

-- ========== [DYRON] MS SAFETY TAB CONTENT ==========
local MSSafetyContent = Instance.new("ScrollingFrame")
MSSafetyContent.Parent = Content
MSSafetyContent.Size = UDim2.new(1,0,1,0)
MSSafetyContent.BackgroundTransparency = 1
MSSafetyContent.Visible = false
MSSafetyContent.ScrollBarThickness = 6
MSSafetyContent.CanvasSize = UDim2.new(0,0,0,400)

-- Title MS Safety
local MSSafetyTitle = Instance.new("TextLabel")
MSSafetyTitle.Parent = MSSafetyContent
MSSafetyTitle.Size = UDim2.new(1,-20,0,40)
MSSafetyTitle.Position = UDim2.new(0,10,0,20)
MSSafetyTitle.BackgroundTransparency = 1
MSSafetyTitle.Text = "🛡️ MS SAFETY DARI RK"
MSSafetyTitle.TextColor3 = Color3.fromRGB(100,200,255)
MSSafetyTitle.TextXAlignment = Enum.TextXAlignment.Left
MSSafetyTitle.Font = Enum.Font.GothamBold
MSSafetyTitle.TextSize = 24

-- Description
local MSSafetyDesc = Instance.new("TextLabel")
MSSafetyDesc.Parent = MSSafetyContent
MSSafetyDesc.Size = UDim2.new(1,-20,0,30)
MSSafetyDesc.Position = UDim2.new(0,10,0,60)
MSSafetyDesc.BackgroundTransparency = 1
MSSafetyDesc.Text = "Blink Masuk Meja"
MSSafetyDesc.TextColor3 = Color3.fromRGB(200,200,200)
MSSafetyDesc.TextXAlignment = Enum.TextXAlignment.Left
MSSafetyDesc.Font = Enum.Font.Gotham
MSSafetyDesc.TextSize = 14

-- ===== BLINK KE BAWAH =====
local BlinkDownFrame = Instance.new("Frame")
BlinkDownFrame.Parent = MSSafetyContent
BlinkDownFrame.Size = UDim2.new(1,-20,0,80)
BlinkDownFrame.Position = UDim2.new(0,10,0,100)
BlinkDownFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
BlinkDownFrame.BorderSizePixel = 0

local BlinkDownCorner = Instance.new("UICorner")
BlinkDownCorner.Parent = BlinkDownFrame
BlinkDownCorner.CornerRadius = UDim.new(0,10)

-- Icon
local BlinkDownIcon = Instance.new("TextLabel")
BlinkDownIcon.Parent = BlinkDownFrame
BlinkDownIcon.Size = UDim2.new(0,50,1,0)
BlinkDownIcon.Position = UDim2.new(0,10,0,0)
BlinkDownIcon.BackgroundTransparency = 1
BlinkDownIcon.Text = "⬇️"
BlinkDownIcon.TextSize = 40
BlinkDownIcon.Font = Enum.Font.GothamBold
BlinkDownIcon.TextColor3 = Color3.fromRGB(255,255,255)

-- Title
local BlinkDownTitle = Instance.new("TextLabel")
BlinkDownTitle.Parent = BlinkDownFrame
BlinkDownTitle.Size = UDim2.new(1,-120,0,30)
BlinkDownTitle.Position = UDim2.new(0,70,0,10)
BlinkDownTitle.BackgroundTransparency = 1
BlinkDownTitle.Text = "BLINK KE BAWAH"
BlinkDownTitle.TextColor3 = Color3.fromRGB(255,255,255)
BlinkDownTitle.TextXAlignment = Enum.TextXAlignment.Left
BlinkDownTitle.Font = Enum.Font.GothamBold
BlinkDownTitle.TextSize = 18

-- Description (4 STUDS)
local BlinkDownDesc = Instance.new("TextLabel")
BlinkDownDesc.Parent = BlinkDownFrame
BlinkDownDesc.Size = UDim2.new(1,-120,0,20)
BlinkDownDesc.Position = UDim2.new(0,70,0,40)
BlinkDownDesc.BackgroundTransparency = 1
BlinkDownDesc.Text = "Turun 4 studs"
BlinkDownDesc.TextColor3 = Color3.fromRGB(180,180,180)
BlinkDownDesc.TextXAlignment = Enum.TextXAlignment.Left
BlinkDownDesc.Font = Enum.Font.Gotham
BlinkDownDesc.TextSize = 12

-- Button Blink Down
local BlinkDownBtn = Instance.new("TextButton")
BlinkDownBtn.Parent = BlinkDownFrame
BlinkDownBtn.Size = UDim2.new(0,40,0,40)
BlinkDownBtn.Position = UDim2.new(1,-50,0.5,-20)
BlinkDownBtn.BackgroundColor3 = Color3.fromRGB(0,150,200)
BlinkDownBtn.Text = "▶️"
BlinkDownBtn.TextColor3 = Color3.fromRGB(255,255,255)
BlinkDownBtn.TextSize = 20
BlinkDownBtn.Font = Enum.Font.GothamBold

local BlinkDownBtnCorner = Instance.new("UICorner")
BlinkDownBtnCorner.Parent = BlinkDownBtn
BlinkDownBtnCorner.CornerRadius = UDim.new(0,8)

-- ===== BLINK MAJU (DEPAN) =====
local BlinkMajuFrame = Instance.new("Frame")
BlinkMajuFrame.Parent = MSSafetyContent
BlinkMajuFrame.Size = UDim2.new(1,-20,0,80)
BlinkMajuFrame.Position = UDim2.new(0,10,0,190)
BlinkMajuFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
BlinkMajuFrame.BorderSizePixel = 0

local BlinkMajuCorner = Instance.new("UICorner")
BlinkMajuCorner.Parent = BlinkMajuFrame
BlinkMajuCorner.CornerRadius = UDim.new(0,10)

-- Icon
local BlinkMajuIcon = Instance.new("TextLabel")
BlinkMajuIcon.Parent = BlinkMajuFrame
BlinkMajuIcon.Size = UDim2.new(0,50,1,0)
BlinkMajuIcon.Position = UDim2.new(0,10,0,0)
BlinkMajuIcon.BackgroundTransparency = 1
BlinkMajuIcon.Text = "⬆️"
BlinkMajuIcon.TextSize = 40
BlinkMajuIcon.Font = Enum.Font.GothamBold
BlinkMajuIcon.TextColor3 = Color3.fromRGB(255,255,255)

-- Title
local BlinkMajuTitle = Instance.new("TextLabel")
BlinkMajuTitle.Parent = BlinkMajuFrame
BlinkMajuTitle.Size = UDim2.new(1,-120,0,30)
BlinkMajuTitle.Position = UDim2.new(0,70,0,10)
BlinkMajuTitle.BackgroundTransparency = 1
BlinkMajuTitle.Text = "BLINK MAJU"
BlinkMajuTitle.TextColor3 = Color3.fromRGB(255,255,255)
BlinkMajuTitle.TextXAlignment = Enum.TextXAlignment.Left
BlinkMajuTitle.Font = Enum.Font.GothamBold
BlinkMajuTitle.TextSize = 18

-- Description
local BlinkMajuDesc = Instance.new("TextLabel")
BlinkMajuDesc.Parent = BlinkMajuFrame
BlinkMajuDesc.Size = UDim2.new(1,-120,0,20)
BlinkMajuDesc.Position = UDim2.new(0,70,0,40)
BlinkMajuDesc.BackgroundTransparency = 1
BlinkMajuDesc.Text = "Maju 5 studs"
BlinkMajuDesc.TextColor3 = Color3.fromRGB(180,180,180)
BlinkMajuDesc.TextXAlignment = Enum.TextXAlignment.Left
BlinkMajuDesc.Font = Enum.Font.Gotham
BlinkMajuDesc.TextSize = 12

-- Button Blink Maju
local BlinkMajuBtn = Instance.new("TextButton")
BlinkMajuBtn.Parent = BlinkMajuFrame
BlinkMajuBtn.Size = UDim2.new(0,40,0,40)
BlinkMajuBtn.Position = UDim2.new(1,-50,0.5,-20)
BlinkMajuBtn.BackgroundColor3 = Color3.fromRGB(0,200,100)
BlinkMajuBtn.Text = "▶️"
BlinkMajuBtn.TextColor3 = Color3.fromRGB(255,255,255)
BlinkMajuBtn.TextSize = 20
BlinkMajuBtn.Font = Enum.Font.GothamBold

local BlinkMajuBtnCorner = Instance.new("UICorner")
BlinkMajuBtnCorner.Parent = BlinkMajuBtn
BlinkMajuBtnCorner.CornerRadius = UDim.new(0,8)

-- ===== BLINK MUNDUR (BELAKANG) =====
local BlinkMundurFrame = Instance.new("Frame")
BlinkMundurFrame.Parent = MSSafetyContent
BlinkMundurFrame.Size = UDim2.new(1,-20,0,80)
BlinkMundurFrame.Position = UDim2.new(0,10,0,280)
BlinkMundurFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
BlinkMundurFrame.BorderSizePixel = 0

local BlinkMundurCorner = Instance.new("UICorner")
BlinkMundurCorner.Parent = BlinkMundurFrame
BlinkMundurCorner.CornerRadius = UDim.new(0,10)

-- Icon
local BlinkMundurIcon = Instance.new("TextLabel")
BlinkMundurIcon.Parent = BlinkMundurFrame
BlinkMundurIcon.Size = UDim2.new(0,50,1,0)
BlinkMundurIcon.Position = UDim2.new(0,10,0,0)
BlinkMundurIcon.BackgroundTransparency = 1
BlinkMundurIcon.Text = "⬇️"
BlinkMundurIcon.TextSize = 40
BlinkMundurIcon.Font = Enum.Font.GothamBold
BlinkMundurIcon.TextColor3 = Color3.fromRGB(255,255,255)

-- Title
local BlinkMundurTitle = Instance.new("TextLabel")
BlinkMundurTitle.Parent = BlinkMundurFrame
BlinkMundurTitle.Size = UDim2.new(1,-120,0,30)
BlinkMundurTitle.Position = UDim2.new(0,70,0,10)
BlinkMundurTitle.BackgroundTransparency = 1
BlinkMundurTitle.Text = "BLINK MUNDUR"
BlinkMundurTitle.TextColor3 = Color3.fromRGB(255,255,255)
BlinkMundurTitle.TextXAlignment = Enum.TextXAlignment.Left
BlinkMundurTitle.Font = Enum.Font.GothamBold
BlinkMundurTitle.TextSize = 18

-- Description
local BlinkMundurDesc = Instance.new("TextLabel")
BlinkMundurDesc.Parent = BlinkMundurFrame
BlinkMundurDesc.Size = UDim2.new(1,-120,0,20)
BlinkMundurDesc.Position = UDim2.new(0,70,0,40)
BlinkMundurDesc.BackgroundTransparency = 1
BlinkMundurDesc.Text = "Mundur 5 studs"
BlinkMundurDesc.TextColor3 = Color3.fromRGB(180,180,180)
BlinkMundurDesc.TextXAlignment = Enum.TextXAlignment.Left
BlinkMundurDesc.Font = Enum.Font.Gotham
BlinkMundurDesc.TextSize = 12

-- Button Blink Mundur
local BlinkMundurBtn = Instance.new("TextButton")
BlinkMundurBtn.Parent = BlinkMundurFrame
BlinkMundurBtn.Size = UDim2.new(0,40,0,40)
BlinkMundurBtn.Position = UDim2.new(1,-50,0.5,-20)
BlinkMundurBtn.BackgroundColor3 = Color3.fromRGB(200,100,0)
BlinkMundurBtn.Text = "▶️"
BlinkMundurBtn.TextColor3 = Color3.fromRGB(255,255,255)
BlinkMundurBtn.TextSize = 20
BlinkMundurBtn.Font = Enum.Font.GothamBold

local BlinkMundurBtnCorner = Instance.new("UICorner")
BlinkMundurBtnCorner.Parent = BlinkMundurBtn
BlinkMundurBtnCorner.CornerRadius = UDim.new(0,8)

-- Status Label
local BlinkStatus = Instance.new("TextLabel")
BlinkStatus.Parent = MSSafetyContent
BlinkStatus.Size = UDim2.new(1,-20,0,30)
BlinkStatus.Position = UDim2.new(0,10,0,370)
BlinkStatus.BackgroundColor3 = Color3.fromRGB(40,40,50)
BlinkStatus.Text = "✅ Siap blink (turun 4, maju/mundur 5)"
BlinkStatus.TextColor3 = Color3.fromRGB(100,255,100)
BlinkStatus.Font = Enum.Font.GothamBold
BlinkStatus.TextSize = 14

local BlinkStatusCorner = Instance.new("UICorner")
BlinkStatusCorner.Parent = BlinkStatus
BlinkStatusCorner.CornerRadius = UDim.new(0,8)

-- ====================================================

-- TP Buttons
local BtnBahan = Instance.new("TextButton")
BtnBahan.Parent = TPContent
BtnBahan.Size = UDim2.new(1,-20,0,70)
BtnBahan.Position = UDim2.new(0,10,0,20)
BtnBahan.BackgroundColor3 = Color3.fromRGB(50,50,70)
BtnBahan.Text = ""
BtnBahan.BorderSizePixel = 0

local BtnBahanCorner = Instance.new("UICorner")
BtnBahanCorner.Parent = BtnBahan
BtnBahanCorner.CornerRadius = UDim.new(0,8)

local BahanIcon = Instance.new("TextLabel")
BahanIcon.Parent = BtnBahan
BahanIcon.Size = UDim2.new(0,40,1,0)
BahanIcon.Position = UDim2.new(0,10,0,0)
BahanIcon.BackgroundTransparency = 1
BahanIcon.Text = "⚒️"
BahanIcon.TextSize = 30
BahanIcon.Font = Enum.Font.GothamBold
BahanIcon.TextColor3 = Color3.fromRGB(255,255,255)

local BahanText = Instance.new("TextLabel")
BahanText.Parent = BtnBahan
BahanText.Size = UDim2.new(1,-60,0,30)
BahanText.Position = UDim2.new(0,50,0,10)
BahanText.BackgroundTransparency = 1
BahanText.Text = "TP MS BAHAN"
BahanText.TextColor3 = Color3.fromRGB(255,255,255)
BahanText.TextXAlignment = Enum.TextXAlignment.Left
BahanText.Font = Enum.Font.GothamBold
BahanText.TextSize = 16

local BahanDesc = Instance.new("TextLabel")
BahanDesc.Parent = BtnBahan
BahanDesc.Size = UDim2.new(1,-60,0,20)
BahanDesc.Position = UDim2.new(0,50,0,35)
BahanDesc.BackgroundTransparency = 1
BahanDesc.Text = "Material Storage"
BahanDesc.TextColor3 = Color3.fromRGB(180,180,180)
BahanDesc.TextXAlignment = Enum.TextXAlignment.Left
BahanDesc.Font = Enum.Font.Gotham
BahanDesc.TextSize = 12

local BtnRS = Instance.new("TextButton")
BtnRS.Parent = TPContent
BtnRS.Size = UDim2.new(1,-20,0,70)
BtnRS.Position = UDim2.new(0,10,0,100)
BtnRS.BackgroundColor3 = Color3.fromRGB(70,50,50)
BtnRS.Text = ""
BtnRS.BorderSizePixel = 0

local BtnRSCorner = Instance.new("UICorner")
BtnRSCorner.Parent = BtnRS
BtnRSCorner.CornerRadius = UDim.new(0,8)

local RSIcon = Instance.new("TextLabel")
RSIcon.Parent = BtnRS
RSIcon.Size = UDim2.new(0,40,1,0)
RSIcon.Position = UDim2.new(0,10,0,0)
RSIcon.BackgroundTransparency = 1
RSIcon.Text = "🏥"
RSIcon.TextSize = 30
RSIcon.Font = Enum.Font.GothamBold
RSIcon.TextColor3 = Color3.fromRGB(255,255,255)

local RSText = Instance.new("TextLabel")
RSText.Parent = BtnRS
RSText.Size = UDim2.new(1,-60,0,30)
RSText.Position = UDim2.new(0,50,0,10)
RSText.BackgroundTransparency = 1
RSText.Text = "TP RS"
RSText.TextColor3 = Color3.fromRGB(255,255,255)
RSText.TextXAlignment = Enum.TextXAlignment.Left
RSText.Font = Enum.Font.GothamBold
RSText.TextSize = 16

local RSDesc = Instance.new("TextLabel")
RSDesc.Parent = BtnRS
RSDesc.Size = UDim2.new(1,-60,0,20)
RSDesc.Position = UDim2.new(0,50,0,35)
RSDesc.BackgroundTransparency = 1
RSDesc.Text = "Hospital"
RSDesc.TextColor3 = Color3.fromRGB(180,180,180)
RSDesc.TextXAlignment = Enum.TextXAlignment.Left
RSDesc.Font = Enum.Font.Gotham
RSDesc.TextSize = 12

-- MS LOOP CONTENT
local MSLoopTitle = Instance.new("TextLabel")
MSLoopTitle.Parent = MSLoopContent
MSLoopTitle.Size = UDim2.new(1,-20,0,30)
MSLoopTitle.Position = UDim2.new(0,10,0,10)
MSLoopTitle.BackgroundTransparency = 1
MSLoopTitle.Text = "🔄 MS LOOP (AUTO TOOLS)"
MSLoopTitle.TextColor3 = Color3.fromRGB(100,255,100)
MSLoopTitle.TextXAlignment = Enum.TextXAlignment.Left
MSLoopTitle.Font = Enum.Font.GothamBold
MSLoopTitle.TextSize = 16

local MSLoopStatus = Instance.new("TextLabel")
MSLoopStatus.Parent = MSLoopContent
MSLoopStatus.Size = UDim2.new(1,-20,0,40)
MSLoopStatus.Position = UDim2.new(0,10,0,45)
MSLoopStatus.BackgroundColor3 = Color3.fromRGB(40,40,50)
MSLoopStatus.Text = "⏹️ LOOP STOPPED"
MSLoopStatus.TextColor3 = Color3.fromRGB(255,100,100)
MSLoopStatus.Font = Enum.Font.GothamBold
MSLoopStatus.TextSize = 16

local MSLoopStatusCorner = Instance.new("UICorner")
MSLoopStatusCorner.Parent = MSLoopStatus
MSLoopStatusCorner.CornerRadius = UDim.new(0,8)

local MSLoopStepLabel = Instance.new("TextLabel")
MSLoopStepLabel.Parent = MSLoopContent
MSLoopStepLabel.Size = UDim2.new(1,-20,0,25)
MSLoopStepLabel.Position = UDim2.new(0,10,0,95)
MSLoopStepLabel.BackgroundTransparency = 1
MSLoopStepLabel.Text = "Step: Waiting..."
MSLoopStepLabel.TextColor3 = Color3.fromRGB(200,200,200)
MSLoopStepLabel.TextXAlignment = Enum.TextXAlignment.Left
MSLoopStepLabel.Font = Enum.Font.Gotham
MSLoopStepLabel.TextSize = 14

local MSLoopTimer = Instance.new("TextLabel")
MSLoopTimer.Parent = MSLoopContent
MSLoopTimer.Size = UDim2.new(1,-20,0,25)
MSLoopTimer.Position = UDim2.new(0,10,0,120)
MSLoopTimer.BackgroundTransparency = 1
MSLoopTimer.Text = "Timer: 0s"
MSLoopTimer.TextColor3 = Color3.fromRGB(200,200,200)
MSLoopTimer.TextXAlignment = Enum.TextXAlignment.Left
MSLoopTimer.Font = Enum.Font.Gotham
MSLoopTimer.TextSize = 14

-- Tool Status
local ToolStatus = Instance.new("TextLabel")
ToolStatus.Parent = MSLoopContent
ToolStatus.Size = UDim2.new(1,-20,0,25)
ToolStatus.Position = UDim2.new(0,10,0,150)
ToolStatus.BackgroundTransparency = 1
ToolStatus.Text = "Tool: -"
ToolStatus.TextColor3 = Color3.fromRGB(200,200,200)
ToolStatus.TextXAlignment = Enum.TextXAlignment.Left
ToolStatus.Font = Enum.Font.GothamBold
ToolStatus.TextSize = 14

-- Informasi Jeda
local JedaInfo = Instance.new("TextLabel")
JedaInfo.Parent = MSLoopContent
JedaInfo.Size = UDim2.new(1,-20,0,20)
JedaInfo.Position = UDim2.new(0,10,0,175)
JedaInfo.BackgroundTransparency = 1
JedaInfo.Text = "⏱️ Jeda 3 detik setelah WATER & GELATIN"
JedaInfo.TextColor3 = Color3.fromRGB(255,255,100)
JedaInfo.TextXAlignment = Enum.TextXAlignment.Left
JedaInfo.Font = Enum.Font.Gotham
JedaInfo.TextSize = 12

local MSLoopStartBtn = Instance.new("TextButton")
MSLoopStartBtn.Parent = MSLoopContent
MSLoopStartBtn.Size = UDim2.new(0.5,-15,0,45)
MSLoopStartBtn.Position = UDim2.new(0,10,0,205)
MSLoopStartBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
MSLoopStartBtn.Text = "▶️ START LOOP"
MSLoopStartBtn.TextColor3 = Color3.fromRGB(255,255,255)
MSLoopStartBtn.Font = Enum.Font.GothamBold
MSLoopStartBtn.TextSize = 16

local MSLoopStartCorner = Instance.new("UICorner")
MSLoopStartCorner.Parent = MSLoopStartBtn
MSLoopStartCorner.CornerRadius = UDim.new(0,8)

local MSLoopStopBtn = Instance.new("TextButton")
MSLoopStopBtn.Parent = MSLoopContent
MSLoopStopBtn.Size = UDim2.new(0.5,-15,0,45)
MSLoopStopBtn.Position = UDim2.new(0.5,5,0,205)
MSLoopStopBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
MSLoopStopBtn.Text = "⏹️ STOP LOOP"
MSLoopStopBtn.TextColor3 = Color3.fromRGB(255,255,255)
MSLoopStopBtn.Font = Enum.Font.GothamBold
MSLoopStopBtn.TextSize = 16

local MSLoopStopCorner = Instance.new("UICorner")
MSLoopStopCorner.Parent = MSLoopStopBtn
MSLoopStopCorner.CornerRadius = UDim.new(0,8)

-- AUTO BUY CONTENT
local AutoBuyTitle = Instance.new("TextLabel")
AutoBuyTitle.Parent = AutoBuyContent
AutoBuyTitle.Size = UDim2.new(1,-20,0,30)
AutoBuyTitle.Position = UDim2.new(0,10,0,10)
AutoBuyTitle.BackgroundTransparency = 1
AutoBuyTitle.Text = "💰 AUTO BUY (RECORD MANUAL)"
AutoBuyTitle.TextColor3 = Color3.fromRGB(255,200,100)
AutoBuyTitle.TextXAlignment = Enum.TextXAlignment.Left
AutoBuyTitle.Font = Enum.Font.GothamBold
AutoBuyTitle.TextSize = 16

-- Info
local AutoBuyInfo = Instance.new("TextLabel")
AutoBuyInfo.Parent = AutoBuyContent
AutoBuyInfo.Size = UDim2.new(1,-20,0,30)
AutoBuyInfo.Position = UDim2.new(0,10,0,45)
AutoBuyInfo.BackgroundColor3 = Color3.fromRGB(50,50,60)
AutoBuyInfo.Text = "📌 Klik RECORD lalu klik tombol di shop"
AutoBuyInfo.TextColor3 = Color3.fromRGB(255,255,255)
AutoBuyInfo.Font = Enum.Font.Gotham
AutoBuyInfo.TextSize = 12
AutoBuyInfo.TextWrapped = true

local AutoBuyInfoCorner = Instance.new("UICorner")
AutoBuyInfoCorner.Parent = AutoBuyInfo
AutoBuyInfoCorner.CornerRadius = UDim.new(0,6)

-- Status
local AutoBuyStatus = Instance.new("TextLabel")
AutoBuyStatus.Parent = AutoBuyContent
AutoBuyStatus.Size = UDim2.new(1,-20,0,30)
AutoBuyStatus.Position = UDim2.new(0,10,0,80)
AutoBuyStatus.BackgroundColor3 = Color3.fromRGB(40,40,50)
AutoBuyStatus.Text = "⏹️ STOPPED"
AutoBuyStatus.TextColor3 = Color3.fromRGB(255,100,100)
AutoBuyStatus.Font = Enum.Font.GothamBold
AutoBuyStatus.TextSize = 14

local AutoBuyStatusCorner = Instance.new("UICorner")
AutoBuyStatusCorner.Parent = AutoBuyStatus
AutoBuyStatusCorner.CornerRadius = UDim.new(0,6)

-- Slider Background
local SliderBg = Instance.new("Frame")
SliderBg.Parent = AutoBuyContent
SliderBg.Size = UDim2.new(1,-40,0,50)
SliderBg.Position = UDim2.new(0,20,0,120)
SliderBg.BackgroundColor3 = Color3.fromRGB(40,40,50)
SliderBg.BorderSizePixel = 0

local SliderBgCorner = Instance.new("UICorner")
SliderBgCorner.Parent = SliderBg
SliderBgCorner.CornerRadius = UDim.new(0,8)

-- Slider Fill (PUTIH)
local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderBg
SliderFill.Size = UDim2.new(0.5,0,1,0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
SliderFill.BorderSizePixel = 0

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.Parent = SliderFill
SliderFillCorner.CornerRadius = UDim.new(0,8)

-- Slider Button (PUTIH)
local SliderButton = Instance.new("TextButton")
SliderButton.Parent = SliderBg
SliderButton.Size = UDim2.new(0,20,0,20)
SliderButton.Position = UDim2.new(0.5,-10,0.5,-10)
SliderButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
SliderButton.Text = ""
SliderButton.ZIndex = 2

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.Parent = SliderButton
SliderButtonCorner.CornerRadius = UDim.new(1,0)

-- Slider Value
local SliderValue = Instance.new("TextLabel")
SliderValue.Parent = AutoBuyContent
SliderValue.Size = UDim2.new(1,-40,0,25)
SliderValue.Position = UDim2.new(0,20,0,175)
SliderValue.BackgroundTransparency = 1
SliderValue.Text = "Target: 50 (Total 150 items)"
SliderValue.TextColor3 = Color3.fromRGB(255,255,255)
SliderValue.TextXAlignment = Enum.TextXAlignment.Left
SliderValue.Font = Enum.Font.GothamBold
SliderValue.TextSize = 14

-- Progress Labels
local WaterProgress = Instance.new("TextLabel")
WaterProgress.Parent = AutoBuyContent
WaterProgress.Size = UDim2.new(0.3,-10,0,25)
WaterProgress.Position = UDim2.new(0,15,0,210)
WaterProgress.BackgroundColor3 = Color3.fromRGB(0,150,150)
WaterProgress.Text = "💧 WATER: 0"
WaterProgress.TextColor3 = Color3.fromRGB(255,255,255)
WaterProgress.Font = Enum.Font.GothamBold
WaterProgress.TextSize = 12

local WaterCorner = Instance.new("UICorner")
WaterCorner.Parent = WaterProgress
WaterCorner.CornerRadius = UDim.new(0,6)

local SugarProgress = Instance.new("TextLabel")
SugarProgress.Parent = AutoBuyContent
SugarProgress.Size = UDim2.new(0.3,-10,0,25)
SugarProgress.Position = UDim2.new(0.35,0,0,210)
SugarProgress.BackgroundColor3 = Color3.fromRGB(0,150,150)
SugarProgress.Text = "🍬 SUGAR: 0"
SugarProgress.TextColor3 = Color3.fromRGB(255,255,255)
SugarProgress.Font = Enum.Font.GothamBold
SugarProgress.TextSize = 12

local SugarCorner = Instance.new("UICorner")
SugarCorner.Parent = SugarProgress
SugarCorner.CornerRadius = UDim.new(0,6)

local GelatinProgress = Instance.new("TextLabel")
GelatinProgress.Parent = AutoBuyContent
GelatinProgress.Size = UDim2.new(0.3,-10,0,25)
GelatinProgress.Position = UDim2.new(0.7,0,0,210)
GelatinProgress.BackgroundColor3 = Color3.fromRGB(0,150,150)
GelatinProgress.Text = "🧪 GELATIN: 0"
GelatinProgress.TextColor3 = Color3.fromRGB(255,255,255)
GelatinProgress.Font = Enum.Font.GothamBold
GelatinProgress.TextSize = 12

local GelatinCorner = Instance.new("UICorner")
GelatinCorner.Parent = GelatinProgress
GelatinCorner.CornerRadius = UDim.new(0,6)

-- Total Progress
local TotalProgress = Instance.new("TextLabel")
TotalProgress.Parent = AutoBuyContent
TotalProgress.Size = UDim2.new(1,-20,0,25)
TotalProgress.Position = UDim2.new(0,10,0,245)
TotalProgress.BackgroundColor3 = Color3.fromRGB(40,40,50)
TotalProgress.Text = "Total: 0/150 items (0%)"
TotalProgress.TextColor3 = Color3.fromRGB(200,200,200)
TotalProgress.Font = Enum.Font.GothamBold
TotalProgress.TextSize = 13

local TotalProgressCorner = Instance.new("UICorner")
TotalProgressCorner.Parent = TotalProgress
TotalProgressCorner.CornerRadius = UDim.new(0,6)

-- Buttons Frame
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Parent = AutoBuyContent
ButtonFrame.Size = UDim2.new(1,-20,0,45)
ButtonFrame.Position = UDim2.new(0,10,0,280)
ButtonFrame.BackgroundTransparency = 1

-- Start Button
local AutoBuyBtn = Instance.new("TextButton")
AutoBuyBtn.Parent = ButtonFrame
AutoBuyBtn.Size = UDim2.new(0.45,-5,1,0)
AutoBuyBtn.Position = UDim2.new(0,0,0,0)
AutoBuyBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
AutoBuyBtn.Text = "💰 START AUTO BUY"
AutoBuyBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoBuyBtn.Font = Enum.Font.GothamBold
AutoBuyBtn.TextSize = 14

local AutoBuyBtnCorner = Instance.new("UICorner")
AutoBuyBtnCorner.Parent = AutoBuyBtn
AutoBuyBtnCorner.CornerRadius = UDim.new(0,8)

-- Stop Button
local StopBuyBtn = Instance.new("TextButton")
StopBuyBtn.Parent = ButtonFrame
StopBuyBtn.Size = UDim2.new(0.45,-5,1,0)
StopBuyBtn.Position = UDim2.new(0.55,0,0,0)
StopBuyBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
StopBuyBtn.Text = "⏹️ STOP"
StopBuyBtn.TextColor3 = Color3.fromRGB(255,255,255)
StopBuyBtn.Font = Enum.Font.GothamBold
StopBuyBtn.TextSize = 14

local StopBuyBtnCorner = Instance.new("UICorner")
StopBuyBtnCorner.Parent = StopBuyBtn
StopBuyBtnCorner.CornerRadius = UDim.new(0,8)

-- ========== [DYRON] RECORD MANUAL BUTTONS ==========
local RecordFrame = Instance.new("Frame")
RecordFrame.Parent = AutoBuyContent
RecordFrame.Size = UDim2.new(1,-20,0,100)
RecordFrame.Position = UDim2.new(0,10,0,330)
RecordFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
RecordFrame.BorderSizePixel = 0

local RecordCorner = Instance.new("UICorner")
RecordCorner.Parent = RecordFrame
RecordCorner.CornerRadius = UDim.new(0,10)

-- Title Record
local RecordTitle = Instance.new("TextLabel")
RecordTitle.Parent = RecordFrame
RecordTitle.Size = UDim2.new(1,0,0,25)
RecordTitle.Position = UDim2.new(0,10,0,5)
RecordTitle.BackgroundTransparency = 1
RecordTitle.Text = "📹 RECORD MANUAL"
RecordTitle.TextColor3 = Color3.fromRGB(255,200,100)
RecordTitle.TextXAlignment = Enum.TextXAlignment.Left
RecordTitle.Font = Enum.Font.GothamBold
RecordTitle.TextSize = 16

-- Status Record
local RecordStatus = Instance.new("TextLabel")
RecordStatus.Parent = RecordFrame
RecordStatus.Size = UDim2.new(1,0,0,20)
RecordStatus.Position = UDim2.new(0,10,0,30)
RecordStatus.BackgroundTransparency = 1
RecordStatus.Text = "Belum record"
RecordStatus.TextColor3 = Color3.fromRGB(180,180,180)
RecordStatus.TextXAlignment = Enum.TextXAlignment.Left
RecordStatus.Font = Enum.Font.Gotham
RecordStatus.TextSize = 12

-- Tombol Record
local RecordBtn = Instance.new("TextButton")
RecordBtn.Parent = RecordFrame
RecordBtn.Size = UDim2.new(0.7,-20,0,30)
RecordBtn.Position = UDim2.new(0,10,0,55)
RecordBtn.BackgroundColor3 = Color3.fromRGB(200,100,0)
RecordBtn.Text = "🔴 MULAI RECORD"
RecordBtn.TextColor3 = Color3.fromRGB(255,255,255)
RecordBtn.Font = Enum.Font.GothamBold
RecordBtn.TextSize = 12

local RecordBtnCorner = Instance.new("UICorner")
RecordBtnCorner.Parent = RecordBtn
RecordBtnCorner.CornerRadius = UDim.new(0,8)

-- Tombol Reset Record
local ResetRecordBtn = Instance.new("TextButton")
ResetRecordBtn.Parent = RecordFrame
ResetRecordBtn.Size = UDim2.new(0.25,-10,0,30)
ResetRecordBtn.Position = UDim2.new(0.75,0,0,55)
ResetRecordBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
ResetRecordBtn.Text = "↺"
ResetRecordBtn.TextColor3 = Color3.fromRGB(255,255,255)
ResetRecordBtn.Font = Enum.Font.GothamBold
ResetRecordBtn.TextSize = 20

local ResetRecordCorner = Instance.new("UICorner")
ResetRecordCorner.Parent = ResetRecordBtn
ResetRecordCorner.CornerRadius = UDim.new(0,8)

-- ========== [DYRON] LOGIC RECORD ==========
local recordMode = false
local recordedPositions = {
    water = nil,
    sugar = nil,
    gelatin = nil
}

-- Fungsi klik di posisi
function clickAtPosition(x, y)
    VirtualInputManager:SendMouseMoveEvent(x, y, game)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

-- Mulai record
RecordBtn.MouseButton1Click:Connect(function()
    recordMode = true
    recordedPositions = {water = nil, sugar = nil, gelatin = nil}
    RecordStatus.Text = "📹 Klik tombol WATER di shop..."
    RecordStatus.TextColor3 = Color3.fromRGB(255,255,0)
    AutoBuyStatus.Text = "🎥 Mode record: Klik WATER"
    AutoBuyStatus.TextColor3 = Color3.fromRGB(255,255,0)
end)

-- Reset record
ResetRecordBtn.MouseButton1Click:Connect(function()
    recordMode = false
    recordedPositions = {water = nil, sugar = nil, gelatin = nil}
    RecordStatus.Text = "Record direset"
    RecordStatus.TextColor3 = Color3.fromRGB(180,180,180)
    AutoBuyStatus.Text = "⏹️ STOPPED"
    AutoBuyStatus.TextColor3 = Color3.fromRGB(255,100,100)
end)

-- Deteksi klik saat record mode
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if recordMode and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UIS:GetMouseLocation()
        local x = math.floor(mousePos.X)
        local y = math.floor(mousePos.Y)
        
        if not recordedPositions.water then
            recordedPositions.water = {x = x, y = y}
            RecordStatus.Text = "✅ WATER tersimpan! Klik SUGAR..."
            AutoBuyStatus.Text = "✅ WATER saved. Klik SUGAR"
            RecordStatus.TextColor3 = Color3.fromRGB(100,255,100)
        elseif not recordedPositions.sugar then
            recordedPositions.sugar = {x = x, y = y}
            RecordStatus.Text = "✅ SUGAR tersimpan! Klik GELATIN..."
            AutoBuyStatus.Text = "✅ SUGAR saved. Klik GELATIN"
            RecordStatus.TextColor3 = Color3.fromRGB(100,255,100)
        elseif not recordedPositions.gelatin then
            recordedPositions.gelatin = {x = x, y = y}
            RecordStatus.Text = "✅ SEMUA TERSIMPAN! Siap auto buy"
            AutoBuyStatus.Text = "✅ Record selesai! Klik START"
            RecordStatus.TextColor3 = Color3.fromRGB(100,255,100)
            recordMode = false
        end
    end
end)

-- START AUTO BUY (pake record)
function startAutoBuyRecord()
    if autoBuyRunning then 
        AutoBuyStatus.Text = "⚠️ Auto Buy sudah berjalan!"
        return 
    end
    
    -- Cek apakah semua posisi sudah direcord
    if not recordedPositions.water or not recordedPositions.sugar or not recordedPositions.gelatin then
        AutoBuyStatus.Text = "❌ Record belum lengkap!"
        return
    end
    
    -- Reset counter
    waterCount = 0
    sugarCount = 0
    gelatinCount = 0
    updateProgress()
    
    autoBuyRunning = true
    AutoBuyStatus.Text = "💰 AUTO BUY RUNNING"
    AutoBuyStatus.TextColor3 = Color3.fromRGB(100,255,100)
    
    -- Loop beli
    while autoBuyRunning and (waterCount < targetAmount or sugarCount < targetAmount or gelatinCount < targetAmount) do
        -- WATER
        if autoBuyRunning and waterCount < targetAmount then
            AutoBuyStatus.Text = "💧 WATER " .. (waterCount + 1) .. "/" .. targetAmount
            clickAtPosition(recordedPositions.water.x, recordedPositions.water.y)
            waterCount = waterCount + 1
            updateProgress()
            task.wait(0.4)
        end
        
        if not autoBuyRunning then break end
        
        -- SUGAR
        if autoBuyRunning and sugarCount < targetAmount then
            AutoBuyStatus.Text = "🍬 SUGAR " .. (sugarCount + 1) .. "/" .. targetAmount
            clickAtPosition(recordedPositions.sugar.x, recordedPositions.sugar.y)
            sugarCount = sugarCount + 1
            updateProgress()
            task.wait(0.4)
        end
        
        if not autoBuyRunning then break end
        
        -- GELATIN
        if autoBuyRunning and gelatinCount < targetAmount then
            AutoBuyStatus.Text = "🧪 GELATIN " .. (gelatinCount + 1) .. "/" .. targetAmount
            clickAtPosition(recordedPositions.gelatin.x, recordedPositions.gelatin.y)
            gelatinCount = gelatinCount + 1
            updateProgress()
            task.wait(0.4)
        end
    end
    
    autoBuyRunning = false
    
    if waterCount >= targetAmount and sugarCount >= targetAmount and gelatinCount >= targetAmount then
        AutoBuyStatus.Text = "✅ SELESAI! Semua target tercapai!"
        AutoBuyStatus.TextColor3 = Color3.fromRGB(100,255,100)
    else
        AutoBuyStatus.Text = "⏹️ STOPPED"
        AutoBuyStatus.TextColor3 = Color3.fromRGB(255,100,100)
    end
end

-- Ganti koneksi tombol START ke fungsi record
AutoBuyBtn.MouseButton1Click:Connect(function() 
    if not autoBuyRunning then 
        task.spawn(startAutoBuyRecord) 
    end
end)
-- ============================================================

function updateProgress()
    WaterProgress.Text = "💧 WATER: " .. waterCount
    SugarProgress.Text = "🍬 SUGAR: " .. sugarCount
    GelatinProgress.Text = "🧪 GELATIN: " .. gelatinCount
    local total = waterCount + sugarCount + gelatinCount
    local totalTarget = targetAmount * 3
    local percent = math.floor((total / totalTarget) * 100)
    TotalProgress.Text = string.format("Total: %d/%d items (%d%%)", total, totalTarget, percent)
    SliderFill.Size = UDim2.new(total / totalTarget, 0, 1, 0)
end

function resetCounters()
    waterCount = 0
    sugarCount = 0
    gelatinCount = 0
    updateProgress()
end

-- MS LOOP
function startMSLoop()
    if loopRunning then return end
    
    loopRunning = true
    MSLoopStatus.Text = "▶️ LOOP RUNNING"
    MSLoopStatus.TextColor3 = Color3.fromRGB(100,255,100)
    
    while loopRunning do
        -- WATER
        if not loopRunning then break end
        local waterTool = findTool("water")
        if waterTool and equipTool(waterTool) then
            ToolStatus.Text = "Tool: WATER"
            MSLoopStepLabel.Text = "Step 1: WATER - 20 seconds"
            pressE()
            local startTime = tick()
            while loopRunning and (tick() - startTime) < 20 do
                local remaining = 20 - (tick() - startTime)
                MSLoopTimer.Text = string.format("Timer: %d/20s - WATER", math.floor(20 - remaining))
                task.wait(0.1)
            end
        else
            MSLoopStepLabel.Text = "ERROR: Water tool not found!"
            break
        end
        
        -- JEDA 3 DETIK
        if loopRunning then
            MSLoopStepLabel.Text = "Jeda 3 detik setelah WATER..."
            local jedaStart = tick()
            while loopRunning and (tick() - jedaStart) < 3 do
                local remaining = 3 - (tick() - jedaStart)
                MSLoopTimer.Text = string.format("Jeda: %d/3s", math.floor(3 - remaining))
                task.wait(0.1)
            end
        end
        
        if not loopRunning then break end
        
        -- SUGAR
        local sugarTool = findTool("sugar")
        if sugarTool and equipTool(sugarTool) then
            ToolStatus.Text = "Tool: SUGAR"
            MSLoopStepLabel.Text = "Step 2: SUGAR - 2 seconds"
            pressE()
            local startTime = tick()
            while loopRunning and (tick() - startTime) < 2 do
                local remaining = 2 - (tick() - startTime)
                MSLoopTimer.Text = string.format("Timer: %d/2s - SUGAR", math.floor(2 - remaining))
                task.wait(0.1)
            end
        else
            MSLoopStepLabel.Text = "ERROR: Sugar tool not found!"
            break
        end
        
        task.wait(0.2)
        if not loopRunning then break end
        
        -- GELATIN
        local gelatinTool = findTool("gelatin")
        if gelatinTool and equipTool(gelatinTool) then
            ToolStatus.Text = "Tool: GELATIN"
            MSLoopStepLabel.Text = "Step 3: GELATIN - 45 seconds"
            pressE()
            local startTime = tick()
            while loopRunning and (tick() - startTime) < 45 do
                local remaining = 45 - (tick() - startTime)
                MSLoopTimer.Text = string.format("Timer: %d/45s - GELATIN", math.floor(45 - remaining))
                task.wait(0.1)
            end
        else
            MSLoopStepLabel.Text = "ERROR: Gelatin tool not found!"
            break
        end
        
        -- JEDA 3 DETIK
        if loopRunning then
            MSLoopStepLabel.Text = "Jeda 3 detik setelah GELATIN..."
            local jedaStart = tick()
            while loopRunning and (tick() - jedaStart) < 3 do
                local remaining = 3 - (tick() - jedaStart)
                MSLoopTimer.Text = string.format("Jeda: %d/3s", math.floor(3 - remaining))
                task.wait(0.1)
            end
        end
        
        if not loopRunning then break end
        
        -- EMPTY BAG
        local emptyTool = findTool("empty") or findTool("bag")
        if emptyTool and equipTool(emptyTool) then
            ToolStatus.Text = "Tool: EMPTY BAG"
            MSLoopStepLabel.Text = "Step 4: EMPTY BAG - 2 seconds (HASIL)"
            pressE()
            local startTime = tick()
            while loopRunning and (tick() - startTime) < 2 do
                local remaining = 2 - (tick() - startTime)
                MSLoopTimer.Text = string.format("Timer: %d/2s - HASIL", math.floor(2 - remaining))
                task.wait(0.1)
            end
        else
            MSLoopStepLabel.Text = "ERROR: Empty Bag tool not found!"
            break
        end
        
        task.wait(0.2)
        if not loopRunning then break end
        
        if loopRunning then
            MSLoopStepLabel.Text = "Loop complete! Restarting from WATER..."
            task.wait(1)
        end
    end
    
    loopRunning = false
    MSLoopStatus.Text = "⏹️ LOOP STOPPED"
    MSLoopStatus.TextColor3 = Color3.fromRGB(255,100,100)
    MSLoopStepLabel.Text = "Step: Stopped"
    MSLoopTimer.Text = "Timer: 0s"
    ToolStatus.Text = "Tool: -"
end

-- Tool functions
function findTool(toolName)
    if not player.Character then return nil end
    for _, child in pairs(player.Character:GetChildren()) do
        if child:IsA("Tool") and string.find(string.lower(child.Name), string.lower(toolName)) then
            return child
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

function equipTool(tool)
    if not tool or not player.Character then return false end
    if tool.Parent == player.Character then return true end
    if tool.Parent == player:FindFirstChild("Backpack") then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:EquipTool(tool)
            task.wait(0.2)
            return tool.Parent == player.Character
        end
    end
    return false
end

function pressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

function stopAutoBuy()
    if autoBuyRunning then
        autoBuyRunning = false
        AutoBuyStatus.Text = "⏹️ Menghentikan..."
        AutoBuyStatus.TextColor3 = Color3.fromRGB(255,255,0)
    end
end

-- TP Functions
function TP_MS_BAHAN()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(521.32,47.79,617.25)
    end
end

function TP_RS()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(1065.19,28.47,420.76)
    end
end

-- Button Connections
BtnBahan.MouseButton1Click:Connect(TP_MS_BAHAN)
BtnRS.MouseButton1Click:Connect(TP_RS)

MSLoopStartBtn.MouseButton1Click:Connect(function()
    if not loopRunning then
        task.spawn(startMSLoop)
    end
end)

MSLoopStopBtn.MouseButton1Click:Connect(function()
    loopRunning = false
end)

StopBuyBtn.MouseButton1Click:Connect(stopAutoBuy)

-- ========== [DYRON] CONNECT BUTTONS MS SAFETY ==========
BlinkDownBtn.MouseButton1Click:Connect(blinkDown)
BlinkMajuBtn.MouseButton1Click:Connect(blinkMaju)
BlinkMundurBtn.MouseButton1Click:Connect(blinkMundur)
-- ========================================================

-- Slider
local dragging = false
SliderButton.MouseButton1Down:Connect(function() dragging = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local sliderPos = SliderBg.AbsolutePosition
        local sliderSize = SliderBg.AbsoluteSize
        local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
        local percent = relativeX / sliderSize.X
        targetAmount = math.floor(percent * 99) + 1
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
        SliderValue.Text = string.format("Target: %d (Total %d items)", targetAmount, targetAmount * 3)
    end
end)

-- Tab Switching (SEKARANG 4 TAB)
TPTabBtn.MouseButton1Click:Connect(function()
    TPContent.Visible = true; MSLoopContent.Visible = false; AutoBuyContent.Visible = false; MSSafetyContent.Visible = false
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    TPTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    MSLoopTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoBuyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSSafetyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
end)

MSLoopTabBtn.MouseButton1Click:Connect(function()
    TPContent.Visible = false; MSLoopContent.Visible = true; AutoBuyContent.Visible = false; MSSafetyContent.Visible = false
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    TPTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSLoopTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AutoBuyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSSafetyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
end)

AutoBuyTabBtn.MouseButton1Click:Connect(function()
    TPContent.Visible = false; MSLoopContent.Visible = false; AutoBuyContent.Visible = true; MSSafetyContent.Visible = false
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    TPTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSLoopTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoBuyTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    MSSafetyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
end)

MSSafetyTabBtn.MouseButton1Click:Connect(function()
    TPContent.Visible = false; MSLoopContent.Visible = false; AutoBuyContent.Visible = false; MSSafetyContent.Visible = true
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSLoopTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    AutoBuyTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    MSSafetyTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    TPTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSLoopTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    AutoBuyTabBtn.TextColor3 = Color3.fromRGB(200,200,200)
    MSSafetyTabBtn.TextColor3 = Color3.fromRGB(255,255,255)
end)

-- Minimize
local minimized = false
local openSize = UDim2.new(0,400,0,600)
local closedSize = UDim2.new(0,400,0,60)
local tweenInfo = TweenInfo.new(0.3)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TPContent.Visible = false; MSLoopContent.Visible = false; AutoBuyContent.Visible = false; MSSafetyContent.Visible = false
        TabFrame.Visible = false
        MinBtn.Text = "□"
        TweenService:Create(Frame, tweenInfo, {Size = closedSize}):Play()
    else
        TweenService:Create(Frame, tweenInfo, {Size = openSize}):Play()
        task.wait(0.3)
        TPContent.Visible = true; TabFrame.Visible = true
        MinBtn.Text = "−"
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Z then
        minimized = not minimized
        if minimized then
            TPContent.Visible = false; MSLoopContent.Visible = false; AutoBuyContent.Visible = false; MSSafetyContent.Visible = false
            TabFrame.Visible = false
            MinBtn.Text = "□"
            TweenService:Create(Frame, tweenInfo, {Size = closedSize}):Play()
        else
            TweenService:Create(Frame, tweenInfo, {Size = openSize}):Play()
            task.wait(0.3)
            TPContent.Visible = true; TabFrame.Visible = true
            MinBtn.Text = "−"
        end
    end
end)

-- Initial Animation
Frame.Size = UDim2.new(0,0,0,0)
task.wait(0.1)
TweenService:Create(Frame, tweenInfo, {Size = openSize}):Play()
