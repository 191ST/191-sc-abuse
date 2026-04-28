-- LOAD UI LIBRARY
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/coastified/src.lua"))()
local Window = Lib:Window("Base Plate Tool", "pro haxxx", Enum.KeyCode.RightShift)
local Tab = Window:Tab("Base Plate")

-- ========== VARIABEL ==========
local basePlatePart = nil
local isBasePlateActive = false
local selectedRoadPart = nil
local plateSize = 500
local plateColor = Color3.fromRGB(255, 0, 0)
local plateTransparent = false

-- ========== FUNGSI MENCARI ROAD PART ==========
local ROAD_KEYWORDS = {
    "road", "street", "sidewalk", "pavement", "asphalt",
    "ground", "floor", "path", "lane", "crossing",
    "jalan", "trotoar", "jalanan"
}

local function isRoadPart(part)
    if not part:IsA("BasePart") and not part:IsA("UnionOperation") then return false end
    local nameLower = part.Name:lower()
    for _, kw in pairs(ROAD_KEYWORDS) do
        if nameLower:find(kw) then return true end
    end
    if part.Parent then
        local parentName = part.Parent.Name:lower()
        for _, kw in pairs(ROAD_KEYWORDS) do
            if parentName:find(kw) then return true end
        end
    end
    return false
end

local function getAllRoadParts()
    local parts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if isRoadPart(obj) then
            table.insert(parts, obj)
        end
    end
    return parts
end

-- ========== FUNGSI MEMBUAT BASEPLATE DARI CLONE ROAD ==========
local function createBasePlateFromRoad()
    -- Hapus baseplate lama
    if basePlatePart and basePlatePart.Parent then
        basePlatePart:Destroy()
        basePlatePart = nil
    end
    
    -- Cari road part (pilih dari dropdown atau cari sendiri)
    local sourcePart = selectedRoadPart
    if not sourcePart then
        local allRoads = getAllRoadParts()
        if #allRoads == 0 then
            warn("Tidak ada road part ditemukan di map!")
            return false
        end
        sourcePart = allRoads[1]
        print("Menggunakan road part: " .. sourcePart.Name)
    end
    
    -- Clone road part
    local clone = sourcePart:Clone()
    clone.Name = "BasePlate_Clone"
    
    -- Resize
    clone.Size = Vector3.new(plateSize, 1, plateSize)
    
    -- Posisi di bawah tanah (5 studs di bawah player)
    local player = game.Players.LocalPlayer
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("Karakter tidak ditemukan!")
        clone:Destroy()
        return false
    end
    
    local targetY = hrp.Position.Y - 5
    clone.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
    
    -- Properties
    clone.Anchored = true
    clone.CanCollide = true
    clone.Material = Enum.Material.Neon
    clone.Color = plateColor
    clone.Transparency = plateTransparent and 0.5 or 0
    
    -- Masukkan ke workspace
    clone.Parent = workspace
    basePlatePart = clone
    
    print("✅ Baseplate berhasil dibuat!")
    print("Posisi Y = " .. targetY)
    print("Ukuran = " .. plateSize .. " x 1 x " .. plateSize)
    return true
end

local function removeBasePlate()
    if basePlatePart and basePlatePart.Parent then
        basePlatePart:Destroy()
        basePlatePart = nil
        print("Baseplate dihapus")
    end
end

local function toggleBasePlate()
    if isBasePlateActive then
        removeBasePlate()
        isBasePlateActive = false
    else
        if createBasePlateFromRoad() then
            isBasePlateActive = true
        end
    end
end

-- ========== UPDATE DROPDOWN LIST ==========
local function updateDropdownList()
    local allRoads = getAllRoadParts()
    local roadNames = {}
    for i, part in ipairs(allRoads) do
        local name = part.Name
        if #name > 20 then name = name:sub(1, 17) .. "..." end
        table.insert(roadNames, name .. " (" .. part.ClassName .. ")")
    end
    if #roadNames == 0 then
        table.insert(roadNames, "Tidak ada road part")
    end
    return roadNames, allRoads
end

-- ========== UI ==========
-- Button utama
Tab:Button("BASEPLATE TRIGGER", function()
    toggleBasePlate()
end)

-- Dropdown pilih road part (opsional)
local roadPartsList = {}
local dropdownOptions, roadPartsRef = updateDropdownList()
local dropdown = Tab:Dropdown("Pilih Road Part (Opsional)", dropdownOptions, function(value)
    -- Cari part yang sesuai
    local allRoads = getAllRoadParts()
    for i, part in ipairs(allRoads) do
        local name = part.Name
        if #name > 20 then name = name:sub(1, 17) .. "..." end
        local display = name .. " (" .. part.ClassName .. ")"
        if display == value then
            selectedRoadPart = part
            print("Memilih: " .. part.Name)
            break
        end
    end
end)

-- Slider ukuran baseplate
Tab:Slider("Ukuran Base Plate", 50, 2000, 500, function(value)
    plateSize = value
    if basePlatePart then
        basePlatePart.Size = Vector3.new(plateSize, 1, plateSize)
        -- Posisi ulang agar tetap center di bawah player
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            basePlatePart.CFrame = CFrame.new(hrp.Position.X, basePlatePart.Position.Y, hrp.Position.Z)
        end
    end
end)

-- Colorpicker
Tab:Colorpicker("Warna Base Plate", Color3.fromRGB(255, 0, 0), function(color)
    plateColor = color
    if basePlatePart then
        basePlatePart.Color = plateColor
    end
end)

-- Checkbox transparan
Tab:Toggle("Transparan", false, function(state)
    plateTransparent = state
    if basePlatePart then
        basePlatePart.Transparency = state and 0.5 or 0
    end
end)

-- Informasi
Tab:Label(" ")
Tab:Label("📌 INFORMASI:")
Tab:Label("• Baseplate akan di-clone dari road part yang dipilih")
Tab:Label("• Jika tidak memilih, akan menggunakan road part pertama")
Tab:Label("• Posisi: 5 studs DI BAWAH player")
Tab:Label("• Material: Neon, bisa diubah warna & transparansi")
Tab:Label(" ")
Tab:Label("⚠️ Pastikan ada road part di map!")

-- Refresh dropdown (jika road part berubah)
task.spawn(function()
    while true do
        task.wait(5)
        local newOptions, newRefs = updateDropdownList()
        if #newOptions ~= #dropdownOptions then
            dropdownOptions = newOptions
            roadPartsRef = newRefs
            -- Update dropdown (library mungkin support, tapi kita rebuild sederhana)
            print("📡 Road part list di-refresh (" .. #newOptions .. " ditemukan)")
        end
    end
end)

print("✅ UI Loaded. Tekan RightShift untuk membuka menu.")
print("✅ Klik 'BASEPLATE TRIGGER' untuk membuat baseplate dari clone road.")
