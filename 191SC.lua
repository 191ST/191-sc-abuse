local recordMode = false
local recordMethod = 1 -- 1 = InputBegan, 2 = HopperBin (alternatif)
local recordedPositions = {
    water = nil,
    sugar = nil,
    gelatin = nil
}

-- Method 1: InputBegan (untuk klik di luar GUI)
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if recordMode and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UIS:GetMouseLocation()
        local x = math.floor(mousePos.X)
        local y = math.floor(mousePos.Y)
        
        print("📍 METHOD 1 - Klik di X:" .. x .. " Y:" .. y)
        processRecord(x, y)
    end
end)

-- Method 2: Hook ke semua tombol (alternatif)
local function hookAllButtons()
    local function scanGui(instance)
        if instance:IsA("TextButton") or instance:IsA("ImageButton") then
            local connection
            connection = instance.MouseButton1Click:Connect(function()
                if recordMode then
                    local mousePos = UIS:GetMouseLocation()
                    local x = math.floor(mousePos.X)
                    local y = math.floor(mousePos.Y)
                    print("📍 METHOD 2 - Tombol diklik: " .. instance.Name .. " di X:" .. x .. " Y:" .. y)
                    processRecord(x, y)
                end
            end)
            -- Simpan connection kalo perlu (tapi kita skip dulu)
        end
        
        for _, child in pairs(instance:GetChildren()) do
            scanGui(child)
        end
    end
    
    -- Scan PlayerGui
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            scanGui(gui)
        end
    end
end

-- Jalankan hook
task.spawn(function()
    task.wait(2)
    hookAllButtons()
    print("🔌 Hook tombol aktif")
end)

-- Proses record
function processRecord(x, y)
    if not recordMode then return end
    
    if not recordedPositions.water then
        recordedPositions.water = {x = x, y = y}
        updateRecordList()
        RecordStatus.Text = "🔴 RECORDING... Klik AREA SUGAR"
        AutoBuyStatus.Text = "✅ WATER saved! Klik SUGAR"
        AutoBuyStatus.TextColor3 = Color3.fromRGB(100,255,100)
        print("✅ WATER TERSIMPAN!")
    elseif not recordedPositions.sugar then
        recordedPositions.sugar = {x = x, y = y}
        updateRecordList()
        RecordStatus.Text = "🔴 RECORDING... Klik AREA GELATIN"
        AutoBuyStatus.Text = "✅ SUGAR saved! Klik GELATIN"
        AutoBuyStatus.TextColor3 = Color3.fromRGB(100,255,100)
        print("✅ SUGAR TERSIMPAN!")
    elseif not recordedPositions.gelatin then
        recordedPositions.gelatin = {x = x, y = y}
        updateRecordList()
        RecordStatus.Text = "✅ RECORD SELESAI!"
        RecordStatus.TextColor3 = Color3.fromRGB(100,255,100)
        AutoBuyStatus.Text = "✅ Record selesai! Klik START"
        AutoBuyStatus.TextColor3 = Color3.fromRGB(100,255,100)
        recordMode = false
        print("✅ GELATIN TERSIMPAN! RECORD SELESAI!")
    end
end

-- Update tampilan
function updateRecordList()
    local text = ""
    if recordedPositions.water then
        text = text .. "✅ WATER (X:" .. recordedPositions.water.x .. " Y:" .. recordedPositions.water.y .. ")\n"
    else
        text = text .. "⬜ WATER (area belum)\n"
    end
    
    if recordedPositions.sugar then
        text = text .. "✅ SUGAR (X:" .. recordedPositions.sugar.x .. " Y:" .. recordedPositions.sugar.y .. ")\n"
    else
        text = text .. "⬜ SUGAR (area belum)\n"
    end
    
    if recordedPositions.gelatin then
        text = text .. "✅ GELATIN (X:" .. recordedPositions.gelatin.x .. " Y:" .. recordedPositions.gelatin.y .. ")"
    else
        text = text .. "⬜ GELATIN (area belum)"
    end
    
    RecordList.Text = text
end
