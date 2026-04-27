-- SCAN PROMPT STASIUN
local found = {}
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
        local name = obj.Parent and obj.Parent.Name or "Unknown"
        if string.find(name:lower(), "stasiun") or string.find(name:lower(), "station") or string.find(name:lower(), "tp") then
            table.insert(found, obj)
            print("🔍 PROMPT DITEMUKAN:", obj.Parent:GetFullName())
        end
    end
end

-- Tampilkan semua prompt (termasuk yang gak ada keyword)
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
        print("📌 PROMPT:", obj.Parent:GetFullName())
    end
end

if #found == 0 then
    print("❌ TIDAK ADA PROMPT dengan keyword stasiun/station/tp")
    print("💡 Coba cari manual: buka Explorer di executor dan cari 'ProximityPrompt'")
end
