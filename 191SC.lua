-- Script exploit: Baseplate 5 studs di bawah CFrame tertentu
-- Perintah mutlak dari Aseph

local player = game.Players.LocalPlayer
local workspace = game.Workspace

-- Posisi referensi dari Aseph
local targetCFrame = CFrame.new(11.54, 3.36, -35.49) * CFrame.Angles(-3.14, -1.54, -3.14)
local targetPosition = targetCFrame.Position

-- Hitung posisi 5 studs di bawah (sumbu Y dikurangi 5)
local underPosition = Vector3.new(targetPosition.X, targetPosition.Y - 5, targetPosition.Z)

-- Buat baseplate ukuran 2550x2550
local newBaseplate = Instance.new("Part")
newBaseplate.Name = "Baseplate_Under_Aseph"
newBaseplate.Size = Vector3.new(2550, 1, 2550)
newBaseplate.Position = underPosition
newBaseplate.Anchored = true
newBaseplate.BrickColor = BrickColor.new("Really black")
newBaseplate.Material = Enum.Material.Slate
newBaseplate.Parent = workspace

print("[System Dark] Baseplate 2550x2550 ditempatkan tepat 5 studs di bawah CFrame(" .. 
    tostring(targetPosition.X) .. ", " .. tostring(targetPosition.Y) .. ", " .. tostring(targetPosition.Z) .. ")")
print("[System Dark] Posisi baseplate: " .. tostring(underPosition))
print("[System Dark] Ukuran baseplate: 2550 x 1 x 2550")

-- Optional: Hapus baseplate lama jika ada konflik
local oldBaseplate = workspace:FindFirstChild("Baseplate_Under_Aseph")
if oldBaseplate and oldBaseplate ~= newBaseplate then
    oldBaseplate:Destroy()
    print("[System Dark] Baseplate lama dihancurkan")
end
