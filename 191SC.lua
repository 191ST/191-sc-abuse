-- LOAD UI LIBRARY
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/coastified/src.lua"))()
local Window = Lib:Window("Base Plate Tool", "pro haxxx", Enum.KeyCode.RightShift)
local Tab = Window:Tab("Base Plate")

-- Variabel
local basePlatePart = nil
local isBasePlateActive = false

-- Fungsi untuk mendapatkan ground level di posisi player
local function getGroundLevel(position)
    local rayOrigin = position + Vector3.new(0, 100, 0)
    local rayDirection = Vector3.new(0, -250, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if raycastResult then
        return raycastResult.Position.Y
    end
    return position.Y - 5 -- fallback
end

-- Fungsi membuat base plate
local function createBasePlate()
    -- Hapus base plate lama jika ada
    if basePlatePart and basePlatePart.Parent then
        basePlatePart:Destroy()
    end
    
    local player = game.Players.LocalPlayer
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        print("Karakter tidak ditemukan!")
        return false
    end
    
    -- Dapatkan ground level di posisi player
    local groundY = getGroundLevel(hrp.Position)
    local plateY = groundY - 5 -- 5 studs di bawah tanah
    
    -- Ukuran base plate (512x512 seperti baseplate default Roblox)
    local plateSize = 512
    local plateCFrame = CFrame.new(hrp.Position.X, plateY, hrp.Position.Z)
    
    -- Buat part
    local plate = Instance.new("Part")
    plate.Size = Vector3.new(plateSize, 1, plateSize)
    plate.CFrame = plateCFrame
    plate.Anchored = true
    plate.CanCollide = true
    plate.Material = Enum.Material.SmoothPlastic
    plate.Color = Color3.fromRGB(100, 100, 100)
    plate.Name = "UnderGroundBasePlate"
    
    -- Optional: beri transparency
    plate.Transparency = 0.5
    
    -- Tambahkan ke workspace
    plate.Parent = workspace
    
    basePlatePart = plate
    return true
end

-- Fungsi hapus base plate
local function removeBasePlate()
    if basePlatePart and basePlatePart.Parent then
        basePlatePart:Destroy()
        basePlatePart = nil
    end
end

-- Fungsi toggle base plate
local function toggleBasePlate()
    if isBasePlateActive then
        removeBasePlate()
        isBasePlateActive = false
        print("Base Plate dihapus")
    else
        if createBasePlate() then
            isBasePlateActive = true
            print("Base Plate dibuat di Y = " .. (basePlatePart and basePlatePart.Position.Y or "unknown"))
        else
            print("Gagal membuat base plate")
        end
    end
end

-- ========== UI ==========
-- Button BasePlate Trigger
Tab:Button("BASEPLATE TRIGGER", function()
    toggleBasePlate()
end)

-- Opsional: tambahkan slider untuk mengatur ukuran base plate (jika mau)
local sizeSlider = nil
sizeSlider = Tab:Slider("Ukuran Base Plate", 100, 1000, 512, function(value)
    if basePlatePart then
        basePlatePart.Size = Vector3.new(value, 1, value)
        -- Posisi ulang agar tetap center
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            basePlatePart.CFrame = CFrame.new(hrp.Position.X, basePlatePart.Position.Y, hrp.Position.Z)
        end
    end
end)

-- Opsional: checkbox untuk transparency
Tab:Toggle("Transparan", false, function(state)
    if basePlatePart then
        basePlatePart.Transparency = state and 0.7 or 0
    end
end)

-- Info
Tab:Label("Base Plate akan dibuat 5 studs di bawah tanah")
Tab:Label("Ukuran default 512x512")

print("UI Loaded. Tekan RightShift untuk membuka menu.")
print("Klik 'BASEPLATE TRIGGER' untuk membuat/menghapus base plate di bawah tanah.")
