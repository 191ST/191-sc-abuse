-- ELIXSTORE KEY + HWID SYSTEM

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local KEYS_URL = "https://raw.githubusercontent.com/elixir60s/elixirstore/main/keys.json"
local SCRIPT_URL = "https://raw.githubusercontent.com/elixir60s/elixirstore/refs/heads/main/elixirstore.lua"

local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,150)
frame.Position = UDim2.new(0.5,-150,0.5,-75)
frame.BackgroundColor3 = Color3.fromRGB(30,0,70)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "ELIXSTORE LOGIN"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local box = Instance.new("TextBox",frame)
box.Size = UDim2.new(0.8,0,0,30)
box.Position = UDim2.new(0.1,0,0.4,0)
box.PlaceholderText = "Enter Key..."
box.BackgroundColor3 = Color3.fromRGB(50,0,100)
box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",box)

local button = Instance.new("TextButton",frame)
button.Size = UDim2.new(0.5,0,0,30)
button.Position = UDim2.new(0.25,0,0.7,0)
button.Text = "LOGIN"
button.BackgroundColor3 = Color3.fromRGB(120,0,200)
button.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",button)

local status = Instance.new("TextLabel",frame)
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,1,-20)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255,200,255)
status.Text = ""

button.MouseButton1Click:Connect(function()

    local key = box.Text

    local success, response = pcall(function()
        return game:HttpGet(KEYS_URL)
    end)

    if not success then
        status.Text = "Server Error"
        return
    end

    local data = HttpService:JSONDecode(response)

    if data[key] then

        local saved = data[key].hwid

        if saved == "" or saved == hwid then

            status.Text = "Login Success"
            gui:Destroy()

            loadstring(game:HttpGet(SCRIPT_URL))()

        else

            status.Text = "Key already used"

        end

    else

        status.Text = "Invalid Key"

    end

end)
