-- Cek part teleport
local teleportPart = workspace:FindFirstChild("folders") and workspace.folders:FindFirstChild("teleport") and workspace.folders.teleport:FindFirstChild("part")

if teleportPart then
    print("✅ Part teleport ditemukan:", teleportPart:GetFullName())
    
    -- Cek apakah ada ProximityPrompt di dalam part
    local prompt = teleportPart:FindFirstChildWhichIsA("ProximityPrompt")
    if prompt then
        print("✅ ProximityPrompt ditemukan:", prompt.Name)
        -- Coba fire prompt
        fireproximityprompt(prompt)
        print("🔥 Prompt di-fire!")
    else
        print("❌ Tidak ada ProximityPrompt di dalam part")
        -- Alternatif: coba pake TouchTransmitter
        local tt = teleportPart:FindFirstChild("TouchTransmitter")
        if tt then
            print("✅ TouchTransmitter ditemukan. Coba disentuh...")
            -- Simulasi sentuh (buat part di dekat, lalu sentuh)
            local fakePart = Instance.new("Part")
            fakePart.Size = Vector3.new(1,1,1)
            fakePart.CFrame = teleportPart.CFrame + Vector3.new(0, 3, 0)
            fakePart.Anchored = false
            fakePart.Parent = workspace
            task.wait(0.1)
            fakePart.CFrame = teleportPart.CFrame
            task.wait(0.2)
            fakePart:Destroy()
        end
    end
    
    -- Atau bisa juga cek apakah part punya RemoteEvent
    for _, child in pairs(teleportPart:GetChildren()) do
        if child:IsA("RemoteEvent") then
            print("✅ RemoteEvent ditemukan:", child.Name)
            -- Coba fire remoteevent (tanpa argumen, cari tahu argumennya dulu)
            -- child:FireServer()
        end
    end
else
    print("❌ Part teleport tidak ditemukan. Cek path: workspace.folders.teleport.part")
end
