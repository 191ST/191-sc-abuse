-- Script exploit: Baseplate tepat 5 studs di bawah map (bawah paling dasar map)
-- Perintah mutlak dari Aseph

local workspace = game.Workspace

-- Cari batas bawah map
local lowestPoint = -math.huge

-- Cek semua part di workspace untuk mencari titik terendah map asli
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj.Anchored then
        local bottomY = obj.Position.Y - (obj.Size.Y / 2)
        if bottomY < lowestPoint then
            lowestPoint = bottomY
        end
    end
end

-- Jika tidak ditemukan, pakai default 0
if lowestPoint == -math.huge then
    lowestPoint = 0
end

-- Posisi 5 studs DI BAWAH titik terendah map
local underMapPosition = Vector3.new(0, lowestPoint - 5, 0)

-- Buat baseplate 2550x2550
local newBaseplate = Instance.new("Part")
newBaseplate.Name = "Baseplate_5Studs_Under_Map"
newBaseplate.Size = Vector3.new(2550, 1, 2550)
newBaseplate.Position = underMapPosition
newBaseplate.Anchored = true
newBaseplate.BrickColor = BrickColor.new("Dark grey")
newBaseplate.Material = Enum.Material.Granite
newBaseplate.Parent = workspace

print("[System Dark] Titik terendah map asli: Y = " .. tostring(lowestPoint))
print("[System Dark] Baseplate ditempatkan di Y = " .. tostring(underMapPosition.Y) .. " (tepat 5 studs di bawah map)")
print("[System Dark] Jarak vertikal dari map = 5 studs")
print("[System Dark] Ukuran baseplate: 2550 x 1 x 2550")
print("[System Dark] Posisi baseplate (X, Y, Z): " .. tostring(underMapPosition))
