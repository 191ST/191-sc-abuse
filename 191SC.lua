-- ============================================================
-- DANGER TP PAGE (atau tambahan di page TP)
-- ============================================================
do
    -- Gunakan page "TP" yang sudah ada, atau buat page baru "DTP"
    local dtpPage = pages["DTP"] or pages["TP"]
    
    -- Cari ScrollingFrame di page tersebut
    local dtpScroll = nil
    for _, child in ipairs(dtpPage:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            dtpScroll = child
            break
        end
    end
    
    if not dtpScroll then
        dtpScroll = Instance.new("ScrollingFrame", dtpPage)
        dtpScroll.Size = UDim2.new(1, 0, 1, 0)
        dtpScroll.BackgroundTransparency = 1
        dtpScroll.BorderSizePixel = 0
        dtpScroll.ScrollBarThickness = 3
        dtpScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
        
        local layout = Instance.new("UIListLayout", dtpScroll)
        layout.Padding = UDim.new(0, 5)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local pad = Instance.new("UIPadding", dtpScroll)
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 12)
        pad.PaddingRight = UDim.new(0, 12)
    end
    
    -- Header section
    local header = Instance.new("Frame", dtpScroll)
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(30, 8, 8)
    header.BorderSizePixel = 0
    header.LayoutOrder = 1
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)
    local headerStroke = Instance.new("UIStroke", header)
    headerStroke.Color = C.red
    headerStroke.Thickness = 1.5
    
    local headerTitle = Instance.new("TextLabel", header)
    headerTitle.Size = UDim2.new(1, -16, 1, 0)
    headerTitle.Position = UDim2.new(0, 8, 0, 0)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = "⚠️ DANGER TP — LUKAI DIRI ⚠️"
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextSize = 13
    headerTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
    headerTitle.TextXAlignment = Enum.TextXAlignment.Center
    headerTitle.TextWrapped = true
    
    -- Info kecil
    local infoLbl = Instance.new("TextLabel", header)
    infoLbl.Size = UDim2.new(1, -16, 0, 18)
    infoLbl.Position = UDim2.new(0, 8, 1, -20)
    infoLbl.BackgroundTransparency = 1
    infoLbl.Text = "Health → 1% → langsung TP | 100ms response"
    infoLbl.Font = Enum.Font.Gotham
    infoLbl.TextSize = 9
    infoLbl.TextColor3 = C.textDim
    infoLbl.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Status bar
    local statusFrame = Instance.new("Frame", dtpScroll)
    statusFrame.Size = UDim2.new(1, 0, 0, 28)
    statusFrame.BackgroundColor3 = C.card
    statusFrame.BorderSizePixel = 0
    statusFrame.LayoutOrder = 2
    Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 6)
    
    local statusLbl = Instance.new("TextLabel", statusFrame)
    statusLbl.Size = UDim2.new(1, -16, 1, 0)
    statusLbl.Position = UDim2.new(0, 8, 0, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "✅ Siap"
    statusLbl.Font = Enum.Font.Gotham
    statusLbl.TextSize = 11
    statusLbl.TextColor3 = C.green
    statusLbl.TextXAlignment = Enum.TextXAlignment.Center
    
    -- ============================================================
    -- DANGER TP FUNCTION
    -- ============================================================
    local isDangerTPBusy = false
    
    local function dangerTeleport(targetPos)
        if isDangerTPBusy then
            statusLbl.Text = "⏳ Sedang proses, tunggu..."
            statusLbl.TextColor3 = C.orange
            return
        end
        
        isDangerTPBusy = true
        statusLbl.Text = "💀 Melukai diri..."
        statusLbl.TextColor3 = C.red
        
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if not hum then
            statusLbl.Text = "❌ Tidak ada karakter"
            statusLbl.TextColor3 = C.red
            isDangerTPBusy = false
            return
        end
        
        local maxHealth = hum.MaxHealth
        local targetHealth = maxHealth * 0.01  -- 1% health
        
        -- Method 1: Pukul diri sendiri berulang kali dengan sangat cepat
        local success = false
        local startTime = tick()
        
        -- Coba method damage via Humanoid:TakeDamage
        local damagePerHit = math.max(5, maxHealth * 0.15)
        local attempts = 0
        
        while hum.Health > targetHealth and tick() - startTime < 0.5 do
            pcall(function()
                hum:TakeDamage(damagePerHit)
            end)
            attempts += 1
            task.wait(0.005)  -- 5ms interval, super cepat
        end
        
        -- Jika masih belum turun, coba method alternatif
        if hum.Health > targetHealth then
            -- Force health rendah via Humanoid.Health langsung (jika memungkinkan)
            pcall(function()
                hum.Health = targetHealth + 1
            end)
            task.wait(0.01)
        end
        
        -- Pastikan tidak mati (health minimal 1)
        if hum.Health <= 0 then
            pcall(function()
                hum.Health = 1
            end)
        end
        
        statusLbl.Text = string.format("💉 Health: %.1f%% → TP dalam 100ms", (hum.Health / maxHealth) * 100)
        statusLbl.TextColor3 = Color3.fromRGB(255, 160, 40)
        
        -- Cooldown 100ms
        task.wait(0.1)
        
        -- Teleport
        statusLbl.Text = "🌀 Teleporting..."
        statusLbl.TextColor3 = C.blue
        
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
            end)
        else
            -- Fallback: vehicle teleport
            vehicleTeleport(CFrame.new(targetPos))
        end
        
        task.wait(0.05)
        statusLbl.Text = "✅ Selesai!"
        statusLbl.TextColor3 = C.green
        task.wait(0.5)
        statusLbl.Text = "✅ Siap"
        statusLbl.TextColor3 = C.green
        
        isDangerTPBusy = false
    end
    
    -- ============================================================
    -- DAFTAR LOKASI DANGER TP
    -- ============================================================
    local dangerLocations = {
        {name = "🏪 Dealer NPC",    pos = Vector3.new(510.7628, 3.5872, 600.7915)},
        {name = "🍬 MS NPC",        pos = Vector3.new(510.061, 4.476, 600.548)},
        {name = "🏠 Apart 1",       pos = Vector3.new(1137.99, 9.93, 449.75)},
        {name = "🏠 Apart 2",       pos = Vector3.new(1139.17, 9.93, 420.56)},
        {name = "🏠 Apart 3",       pos = Vector3.new(984.86, 9.93, 247.28)},
        {name = "🏠 Apart 4",       pos = Vector3.new(988.31, 9.93, 221.66)},
        {name = "🏠 Apart 5",       pos = Vector3.new(923.95, 9.93, 42.20)},
        {name = "🏠 Apart 6",       pos = Vector3.new(895.72, 9.93, 41.93)},
        {name = "🎰 Casino",        pos = Vector3.new(1166.33, 3.36, -29.77)},
        {name = "⛽ GS UJUNG",      pos = Vector3.new(-466.53, 3.86, 357.66)},
        {name = "⛽ GS MID",        pos = Vector3.new(218.43, 3.74, -176.98)},
        {name = "🚔 Penjara",       pos = Vector3.new(551.35, 3.66, -564.90)},
    }
    
    -- Buat tombol-tombol
    local btnOrder = 3
    for _, loc in ipairs(dangerLocations) do
        local btnFrame = Instance.new("Frame", dtpScroll)
        btnFrame.Size = UDim2.new(1, 0, 0, 38)
        btnFrame.BackgroundColor3 = C.card
        btnFrame.BorderSizePixel = 0
        btnFrame.LayoutOrder = btnOrder
        btnOrder += 1
        Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)
        
        local nameLbl = Instance.new("TextLabel", btnFrame)
        nameLbl.Size = UDim2.new(0.65, 0, 1, 0)
        nameLbl.Position = UDim2.new(0, 12, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = loc.name
        nameLbl.Font = Enum.Font.Gotham
        nameLbl.TextSize = 11
        nameLbl.TextColor3 = C.text
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        
        local tpBtn = Instance.new("TextButton", btnFrame)
        tpBtn.Size = UDim2.new(0, 90, 0, 28)
        tpBtn.Position = UDim2.new(1, -102, 0.5, -14)
        tpBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        tpBtn.Text = "🔥 DANGER TP"
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.TextSize = 10
        tpBtn.TextColor3 = C.text
        tpBtn.BorderSizePixel = 0
        Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
        
        local targetPos = loc.pos
        tpBtn.MouseButton1Click:Connect(function()
            dangerTeleport(targetPos)
        end)
        
        -- Hover effect
        tpBtn.MouseEnter:Connect(function()
            TweenService:Create(tpBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
        end)
        tpBtn.MouseLeave:Connect(function()
            TweenService:Create(tpBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(180, 40, 40)}):Play()
        end)
    end
    
    -- Update canvas size
    local function updateCanvas()
        task.wait()
        local totalHeight = 0
        for _, child in ipairs(dtpScroll:GetChildren()) do
            if child:IsA("Frame") and child.Visible then
                totalHeight = totalHeight + child.Size.Y.Offset + 5
            end
        end
        dtpScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
    end
    
    -- Tunggu layout selesai
    task.wait(0.1)
    updateCanvas()
    
    -- Listener untuk update canvas
    local layout2 = dtpScroll:FindFirstChildOfClass("UIListLayout")
    if layout2 then
        layout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    end
end
