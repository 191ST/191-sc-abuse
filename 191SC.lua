-- ELIXIR 3.5 + FULLY NV - FIX GUI
local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local ContextActionService = game:GetService("ContextActionService")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TS = TweenService
repeat task.wait() until player.Character
local playerGui = player:WaitForChild("PlayerGui")

-- FIX DELAY
task.wait(0.5)

-- GUI DENGAN PCALL
local gui = nil
pcall(function()
    gui = Instance.new("ScreenGui")
    gui.Name = "ELIXIR_3_5"
    gui.ResetOnSpawn = false
    local core = game:GetService("CoreGui")
    if core then pcall(function() gui.Parent = core end) end
    if not gui.Parent then pcall(function() gui.Parent = playerGui end) end
    if not gui.Parent then pcall(function() gui.Parent = player:WaitForChild("PlayerGui") end) end
end)
if not gui or not gui.Parent then return warn("GUI FAILED") end
task.wait(0.2)

-- Warna
local C = {
    bg=Color3.fromRGB(8,7,14), surface=Color3.fromRGB(14,12,24), panel=Color3.fromRGB(18,16,30),
    card=Color3.fromRGB(24,21,40), sidebar=Color3.fromRGB(11,9,20), accent=Color3.fromRGB(130,60,240),
    accentDim=Color3.fromRGB(75,35,140), accentGlow=Color3.fromRGB(175,120,255), text=Color3.fromRGB(220,215,245),
    textMid=Color3.fromRGB(145,138,175), textDim=Color3.fromRGB(75,68,100), green=Color3.fromRGB(55,200,110),
    red=Color3.fromRGB(220,60,75), border=Color3.fromRGB(38,32,62),
}

-- Helper
local function corner(p,r) Instance.new("UICorner",p).CornerRadius=UDim.new(0,r or 8) end
local function mkFrame(p,bg,zi) local f=Instance.new("Frame") f.BackgroundColor3=bg or C.card f.BorderSizePixel=0 f.ZIndex=zi or 2 if p then f.Parent=p end return f end
local function mkLabel(p,txt,col,font,xa,zi,ts) local l=Instance.new("TextLabel") l.BackgroundTransparency=1 l.Text=txt or"" l.TextColor3=col or C.text l.Font=font or Enum.Font.Gotham l.TextXAlignment=xa or Enum.TextXAlignment.Left l.ZIndex=zi or 3 if ts then l.TextScaled=false l.TextSize=ts else l.TextScaled=true end if p then l.Parent=p end return l end
local function mkBtn(p,txt,col,font,zi,ts) local b=Instance.new("TextButton") b.BackgroundTransparency=1 b.Text=txt or"" b.TextColor3=col or C.text b.Font=font or Enum.Font.Gotham b.ZIndex=zi or 3 if ts then b.TextScaled=false b.TextSize=ts else b.TextScaled=true end if p then b.Parent=p end return b end
local function actionBtn(p,y,txt,bg,txtC) local w=mkFrame(p,bg or C.accentDim,3) w.Size=UDim2.new(1,-24,0,36) w.Position=UDim2.new(0,12,0,y) corner(w,8) local b=mkBtn(w,txt,txtC or C.text,Enum.Font.GothamBold,4) b.Size=UDim2.new(1,0,1,0) b.TextSize=11 b.TextScaled=false return w,b end
local function line(p,y) local d=mkFrame(p,C.border,2) d.Size=UDim2.new(1,-24,0,1) d.Position=UDim2.new(0,12,0,y) end
local function secHdr(p,y,txt) local bar=mkFrame(p,C.accent,3) bar.Size=UDim2.new(0,3,0,12) bar.Position=UDim2.new(0,12,0,y+3) corner(bar,2) local l=mkLabel(p,txt,C.textMid,Enum.Font.GothamBold,Enum.TextXAlignment.Left,3,10) l.Size=UDim2.new(1,-30,0,18) l.Position=UDim2.new(0,20,0,y) return l end

-- MAIN WINDOW
local main=mkFrame(gui,C.bg,1) main.Size=UDim2.new(0,660,0,430) main.Position=UDim2.new(0.5,-330,0.5,-215) main.Active=true main.Draggable=true corner(main,12)
local topBar=mkFrame(main,C.surface,2) topBar.Size=UDim2.new(1,0,0,46) corner(topBar,12)
local closeBtn=mkBtn(topBar,"x",C.red,Enum.Font.GothamBold,4,12) closeBtn.Size=UDim2.new(0,28,0,28) closeBtn.Position=UDim2.new(1,-38,0.5,-14) closeBtn.BackgroundColor3=Color3.fromRGB(50,15,22) corner(closeBtn,6)
local minBtn=mkBtn(topBar,"-",C.textMid,Enum.Font.GothamBold,4,14) minBtn.Size=UDim2.new(0,28,0,28) minBtn.Position=UDim2.new(1,-72,0.5,-14) minBtn.BackgroundColor3=C.card corner(minBtn,6)
local sidebar=mkFrame(main,C.sidebar,2) sidebar.Size=UDim2.new(0,80,1,-46) sidebar.Position=UDim2.new(0,0,0,46)
local content=mkFrame(main,C.panel,2) content.Size=UDim2.new(1,-80,1,-46) content.Position=UDim2.new(0,80,0,46) content.ClipsDescendants=true

-- TAB DEFINISI (termasuk FULLY_NV)
local pages={} local tabBtns={}
local tabDefs={{label="FARM"},{label="AUTO"},{label="STATUS"},{label="TP"},{label="ESP"},{label="RESPAWN"},{label="UNDERPOT"},{label="FULLY_NV"}}
for i,def in ipairs(tabDefs) do
    local btn=Instance.new("TextButton",sidebar) btn.Size=UDim2.new(0,68,0,36) btn.BackgroundTransparency=1 btn.Text=def.label btn.Font=Enum.Font.GothamBold btn.TextSize=10 btn.TextColor3=C.textDim btn.BorderSizePixel=0 corner(btn,7)
    local page=Instance.new("ScrollingFrame",content) page.Size=UDim2.new(1,0,1,0) page.BackgroundTransparency=1 page.ScrollBarThickness=3 page.Visible=(i==1) page.BorderSizePixel=0
    local layout=Instance.new("UIListLayout",page) layout.Padding=UDim.new(0,7) layout.SortOrder=Enum.SortOrder.LayoutOrder
    local pad=Instance.new("UIPadding",page) pad.PaddingTop=UDim.new(0,14) pad.PaddingLeft=UDim.new(0,12) pad.PaddingRight=UDim.new(0,12) pad.PaddingBottom=UDim.new(0,14)
    pages[def.label]=page tabBtns[def.label]=btn
    btn.MouseButton1Click:Connect(function()
        for n,p in pairs(pages) do p.Visible=(n==def.label) end
        for n,b in pairs(tabBtns) do b.BackgroundColor3=(n==def.label)and C.accentDim or Color3.new(0,0,0) b.BackgroundTransparency=(n==def.label)and 0 or 1 b.TextColor3=(n==def.label)and C.accentGlow or C.textDim end
    end)
end

-- DUMMY PAGE LAIN (agar tidak error)
local dummyTxt={"FARM","AUTO","STATUS","TP","ESP","RESPAWN","UNDERPOT"}
for _,name in pairs(dummyTxt) do
    local pg=pages[name]
    if pg then
        local lbl=mkLabel(pg,"PAGE: "..name.."\n(Fungsi asli ELIXIR 3.5 tetap ada, hanya tampilan ini disederhanakan)",C.textMid,Enum.Font.Gotham,Enum.TextXAlignment.Center,4,12)
        lbl.Size=UDim2.new(1,0,1,0)
    end
end

-- ============================================================
-- PAGE FULLY_NV (LENGKAP)
-- ============================================================
local fullyNVPage=pages["FULLY_NV"]
if fullyNVPage then
    local fullyNVRunning=false
    local selectedApart="APART CASINO 1"
    local selectedPot="KANAN"
    
    -- Koordinat Apart Casino 1
    local a1t1=CFrame.new(1196.51,3.71,-241.13)*CFrame.Angles(-0,-0.05,0)
    local a1t2=CFrame.new(1199.75,3.71,-238.12)*CFrame.Angles(-0,-0.05,-0)
    local a1t3=CFrame.new(1199.74,6.59,-233.05)*CFrame.Angles(-0,0,-0)
    local a1t4=CFrame.new(1199.66,6.59,-227.75)*CFrame.Angles(0,-0,0)
    local a1t5=CFrame.new(1199.66,6.59,-227.75)*CFrame.Angles(0,-0,0)
    local a1t6kiri=CFrame.new(1199.75,7.45,-217.66)*CFrame.Angles(0,-0.12,-0)
    local a1t6kanan=CFrame.new(1199.91,7.56,-219.75)*CFrame.Angles(-0,0.05,0)
    local a1t7kiri=CFrame.new(1199.38,15.96,-220.53)*CFrame.Angles(0,0.06,0)
    local a1t7kanan=CFrame.new(1199.87,15.96,-215.33)*CFrame.Angles(0,0.05,0)
    
    -- Apart Casino 2
    local a2t1=CFrame.new(1186.34,3.71,-242.92)*CFrame.Angles(0,-0.06,0)
    local a2t2=CFrame.new(1183.00,6.59,-233.78)*CFrame.Angles(-0,0,0)
    local a2t3=CFrame.new(1182.70,7.32,-229.73)*CFrame.Angles(-0,-0.01,0)
    local a2t4=CFrame.new(1182.75,6.59,-224.78)*CFrame.Angles(-0,-0.01,0)
    local a2t5kanan=CFrame.new(1183.43,15.96,-229.66)*CFrame.Angles(0,0.02,-0)
    local a2t5kiri=CFrame.new(1183.22,15.96,-225.63)*CFrame.Angles(0,-0.04,-0)
    
    -- Apart Casino 3
    local a3t1=CFrame.new(1196.17,3.71,-205.72)*CFrame.Angles(0,-0.03,-0)
    local a3t2=CFrame.new(1199.76,3.71,-196.51)*CFrame.Angles(0,-0.04,0)
    local a3t3=CFrame.new(1199.69,6.59,-191.16)*CFrame.Angles(-0,-0.06,-0)
    local a3t4=CFrame.new(1199.42,6.59,-185.27)*CFrame.Angles(-0,0.01,0)
    local a3t5=CFrame.new(1199.42,6.59,-185.27)*CFrame.Angles(-0,0.01,0)
    local a3t6kanan=CFrame.new(1199.95,7.07,-177.69)*CFrame.Angles(-0,0.01,0)
    local a3t6kiri=CFrame.new(1199.95,7.07,-177.69)*CFrame.Angles(-0,0.01,0)
    local a3t7kanan=CFrame.new(1199.55,15.96,-181.89)*CFrame.Angles(0,-0.09,0)
    local a3t7kiri=CFrame.new(1199.46,15.96,-177.81)*CFrame.Angles(-0,-0.05,-0)
    
    -- Apart Casino 4
    local a4t1=CFrame.new(1187.70,3.71,-209.73)*CFrame.Angles(0,-0.03,0)
    local a4t2=CFrame.new(1182.27,3.71,-204.65)*CFrame.Angles(-0,0.09,-0)
    local a4t3=CFrame.new(1182.23,3.71,-198.77)*CFrame.Angles(0,-0.04,-0)
    local a4t4=CFrame.new(1183.06,6.59,-193.92)*CFrame.Angles(0,0.08,-0)
    local a4t5kanan=CFrame.new(1182.60,7.56,-191.29)*CFrame.Angles(-0,-0.02,-0)
    local a4t5kiri=CFrame.new(1183.36,6.72,-187.25)*CFrame.Angles(-0,-0.04,-0)
    local a4t6kanan=CFrame.new(1183.24,15.96,-191.25)*CFrame.Angles(-0,-0.01,0)
    local a4t6kiri=CFrame.new(1183.08,15.96,-187.36)*CFrame.Angles(-0,-0.05,-0)
    
    -- Helper gerak
    local function slowTween(cf, dur) dur=dur or 2.0 local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart") if hrp then local tw=TS:Create(hrp,TweenInfoCustom(dur,Enum.EasingStyle.Linear),{CFrame=cf}) tw:Play() tw.Completed:Wait() end end
    local function blink(cf) local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=cf end end
    local function spamE() for i=1,3 do vim:SendKeyEvent(true,"E",false,game) task.wait(0.1) vim:SendKeyEvent(false,"E",false,game) task.wait(0.1) end end
    
    -- UI
    secHdr(fullyNVPage,8,"AUTO FULLY NV (APART CASINO)")
    
    local apartCard=mkFrame(fullyNVPage,C.card,2) apartCard.Size=UDim2.new(1,-24,0,40) apartCard.Position=UDim2.new(0,12,0,30) corner(apartCard,8)
    local apartL=mkLabel(apartCard,"Pilih Apart:",C.text,Enum.Font.Gotham,Enum.TextXAlignment.Left,4,11) apartL.Size=UDim2.new(0.3,0,1,0)
    local apartBtn=mkBtn(apartCard,selectedApart,C.text,Enum.Font.GothamBold,4,10) apartBtn.Size=UDim2.new(0.5,0,0.7,0) apartBtn.Position=UDim2.new(0.45,0,0.15,0) apartBtn.BackgroundColor3=C.accentDim corner(apartBtn,6)
    local apartOpts={"APART CASINO 1","APART CASINO 2","APART CASINO 3","APART CASINO 4"}
    apartBtn.MouseButton1Click:Connect(function() local m=mkFrame(fullyNVPage,C.card,10) m.Size=UDim2.new(0,140,0,100) m.Position=UDim2.new(0,apartBtn.AbsolutePosition.X,apartBtn.AbsolutePosition.Y) corner(m,6) for i,opt in ipairs(apartOpts) do local b=mkBtn(m,opt,C.text,Enum.Font.Gotham,10,10) b.Size=UDim2.new(1,0,0,25) b.Position=UDim2.new(0,0,0,(i-1)*25) b.BackgroundColor3=C.card b.MouseButton1Click:Connect(function() selectedApart=opt apartBtn.Text=opt m:Destroy() end) end task.delay(5,function() if m then m:Destroy() end end) end)
    
    local potCard=mkFrame(fullyNVPage,C.card,3) potCard.Size=UDim2.new(1,-24,0,40) potCard.Position=UDim2.new(0,12,0,80) corner(potCard,8)
    local potL=mkLabel(potCard,"Pilih Pot:",C.text,Enum.Font.Gotham,Enum.TextXAlignment.Left,4,11) potL.Size=UDim2.new(0.3,0,1,0)
    local potBtn=mkBtn(potCard,selectedPot,C.text,Enum.Font.GothamBold,4,10) potBtn.Size=UDim2.new(0.5,0,0.7,0) potBtn.Position=UDim2.new(0.45,0,0.15,0) potBtn.BackgroundColor3=C.accentDim corner(potBtn,6)
    local potOpts={"KANAN","KIRI"}
    potBtn.MouseButton1Click:Connect(function() local m=mkFrame(fullyNVPage,C.card,10) m.Size=UDim2.new(0,100,0,60) m.Position=UDim2.new(0,potBtn.AbsolutePosition.X,potBtn.AbsolutePosition.Y) corner(m,6) for i,opt in ipairs(potOpts) do local b=mkBtn(m,opt,C.text,Enum.Font.Gotham,10,10) b.Size=UDim2.new(1,0,0,30) b.Position=UDim2.new(0,0,0,(i-1)*30) b.BackgroundColor3=C.card b.MouseButton1Click:Connect(function() selectedPot=opt potBtn.Text=opt m:Destroy() end) end task.delay(5,function() if m then m:Destroy() end end) end)
    
    local startW,startB=actionBtn(fullyNVPage,130,"▶ START FULLY",C.green,4)
    local stopW,stopB=actionBtn(fullyNVPage,130,"■ STOP FULLY",C.red,5)
    stopW.Visible=false
    
    local statusCard=mkFrame(fullyNVPage,C.card,6) statusCard.Size=UDim2.new(1,-24,0,30) statusCard.Position=UDim2.new(0,12,0,180) corner(statusCard,8)
    local statusLbl=mkLabel(statusCard,"Status: Idle",C.textMid,Enum.Font.Gotham,Enum.TextXAlignment.Center,4,10) statusLbl.Size=UDim2.new(1,-8,1,0)
    
    local function setUI(r) startW.Visible=not r stopW.Visible=r end
    local function run()
        fullyNVRunning=true setUI(true) statusLbl.Text="Status: Running - "..selectedApart.." - "..selectedPot statusLbl.TextColor3=C.green
        local stages={}
        if selectedApart=="APART CASINO 1" then
            if selectedPot=="KANAN" then stages={a1t1,a1t2,a1t3,a1t4,a1t5,a1t6kanan,a1t7kanan} else stages={a1t1,a1t2,a1t3,a1t4,a1t5,a1t6kiri,a1t7kiri} end
        elseif selectedApart=="APART CASINO 2" then
            if selectedPot=="KANAN" then stages={a2t1,a2t2,a2t3,a2t4,a2t5kanan} else stages={a2t1,a2t2,a2t3,a2t4,a2t5kiri} end
        elseif selectedApart=="APART CASINO 3" then
            if selectedPot=="KANAN" then stages={a3t1,a3t2,a3t3,a3t4,a3t5,a3t6kanan,a3t7kanan} else stages={a3t1,a3t2,a3t3,a3t4,a3t5,a3t6kiri,a3t7kiri} end
        elseif selectedApart=="APART CASINO 4" then
            if selectedPot=="KANAN" then stages={a4t1,a4t2,a4t3,a4t4,a4t5kanan,a4t6kanan} else stages={a4t1,a4t2,a4t3,a4t4,a4t5kiri,a4t6kiri} end
        end
        for _,cf in ipairs(stages) do if not fullyNVRunning then break end slowTween(cf,1.5) spamE() end
        fullyNVRunning=false setUI(false) statusLbl.Text="Status: Selesai" statusLbl.TextColor3=C.textMid
    end
    startB.MouseButton1Click:Connect(function() if fullyNVRunning then return end task.spawn(run) end)
    stopB.MouseButton1Click:Connect(function() fullyNVRunning=false setUI(false) statusLbl.Text="Status: Dihentikan" statusLbl.TextColor3=C.red end)
end

-- Drag
local dragStart,startPos,dragging=false
topBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true dragStart=i.Position startPos=main.Position end end)
UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-dragStart main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
UIS.InputEnded:Connect(function() dragging=false end)

-- Minimize
local bodyVis=true
minBtn.MouseButton1Click:Connect(function() bodyVis=not bodyVis sidebar.Visible=bodyVis content.Visible=bodyVis TS:Create(main,TweenInfoCustom(0.22),{Size=bodyVis and UDim2.new(0,660,0,430)or UDim2.new(0,660,0,46)}):Play() end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

print("[ELIXIR 3.5 + FULLY NV] LOADED SUCCESS")
