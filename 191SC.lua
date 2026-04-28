-- LOAD UI LIBRARY
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/coastified/src.lua"))()
local Window = Lib:Window("Base Plate Tool", "pro haxxx", Enum.KeyCode.RightShift)
local Tab = Window:Tab("Base Plate")

-- Variabel
local basePlatePart = nil
local isBasePlateActive = false

-- Fungsi membuat base plate (pasti muncul)
local function createBasePlate()
    -- Hapus base plate lama
    if basePlatePart and basePlatePart.Parent then
        basePlatePart:Destroy()
        basePlatePart = nil
    end
    
    local player = game.Players.LocalPlayer
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if not hrp then
        warn("Karakter tidak ditemukan, coba lagi nanti")
        return false
    end
    
    -- Posisi base plate: 5 studs di bawah player
    local plateY = hrp.Position.Y - 5
    local plateCFrame = CFrame.new(hrp.Position.X, plateY, hrp.Position.Z)
    
    -- Buat part dengan ukuran super besar
    local plate = Instance.new("Part")
    plate.Size = Vector3.new(1000, 1, 1000)  -- Lebar 1000 x 1000
    plate.CFrame = plateCFrame
    plate.Anchored = true
    plate.CanCollide = true
    plate.Material = Enum.Material.Neon  -- Biar terang dan kelihatan
    plate.Color = Color3.fromRGB(255, 0, 0)  -- Merah terang
    plate.Transparency = 0  -- Tidak transparan
    plate.Name = "UnderGroundBasePlate"
    
    -- Tambahkan ke workspace
    plate.Parent = workspace
    
    basePlatePart = plate
    print("Base Plate berhasil dibuat di Y = " .. plateY)
    print("Posisi player Y = " .. hrp.Position.Y)
    
    return true
end

-- Fungsi hapus base plate
local function removeBasePlate()
    if basePlatePart and basePlatePart.Parent then
        basePlatePart:Destroy()
        basePlatePart = nil
        print("Base Plate dihapus")
    end
end

-- Fungsi toggle base plate
local function toggleBasePlate()
    if isBasePlateActive then
        removeBasePlate()
        isBasePlateActive = false
    else
        if createBasePlate() then
            isBasePlateActive = true
        else
            warn("Gagal membuat base plate")
        end
    end
end

-- ========== UI ==========
-- Button BasePlate Trigger
Tab:Button("BASEPLATE TRIGGER", function()
    toggleBasePlate()
end)

-- Slider ukuran base plate
local sizeSlider = Tab:Slider("Ukuran Base Plate", 50, 2000, 1000, function(value)
    if basePlatePart then
        basePlatePart.Size = Vector3.new(value, 1, value)
        print("Ukuran base plate diubah menjadi " .. value)
    end
end)

-- Slider warna (opsional)
local colorPicker = Tab:Colorpicker("Warna Base Plate", Color3.fromRGB(255, 0, 0), function(color)
    if basePlatePart then
        basePlatePart.Color = color
    end
end)

-- Checkbox transparansi
Tab:Toggle("Transparan", false, function(state)
    if basePlatePart then
        basePlatePart.Transparency = state and 0.7 or 0
    end
end)

-- Informasi
Tab:Label("Base Plate dibuat 5 studs di BAWAH player")
Tab:Label("Ukuran default: 1000 x 1000 (sangat besar)")
Tab:Label("Material Neon + Warna Merah = pasti kelihatan")

print("✅ UI Loaded. Tekan RightShift untuk membuka menu.")
print("✅ Klik 'BASEPLATE TRIGGER' untuk membuat base plate di bawah tanah.")
