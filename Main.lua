local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local StatusLabel = Instance.new("TextLabel")
local TitleLabel = Instance.new("TextLabel")
local Icon = Instance.new("ImageLabel")
local CloseButton = Instance.new("TextButton")
local SelectionFrame = Instance.new("Frame")
local ConfigFrame = Instance.new("Frame")

local parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = parent

local fileName = "NakamuraConfig.txt"
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local config = {
    mode = "",
    serverHopEnabled = false
}

if readfile and isfile and isfile(fileName) then
    pcall(function()
        local decoded = HttpService:JSONDecode(readfile(fileName))
        if type(decoded) == "table" then config = decoded end
    end)
end

local function saveConfig()
    if writefile then
        pcall(function() writefile(fileName, HttpService:JSONEncode(config)) end)
    end
end

Frame.Size = UDim2.new(0, 320, 0, 200)
Frame.Position = UDim2.new(0.5, -160, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.5
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

Icon.Parent = Frame
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0, 10, 0, 10)
Icon.Size = UDim2.new(0, 25, 0, 25) 
Icon.Image = "rbxassetid://17316645495"

TitleLabel.Parent = Frame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 40, 0, 10)
TitleLabel.Size = UDim2.new(0, 200, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "中村診断！"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

StatusLabel.Size = UDim2.new(1, -20, 0, 130)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Code
StatusLabel.RichText = true
StatusLabel.Visible = false
StatusLabel.Parent = Frame

ConfigFrame.Size = UDim2.new(1, 0, 0, 40)
ConfigFrame.Position = UDim2.new(0, 0, 0, 160)
ConfigFrame.BackgroundTransparency = 1
ConfigFrame.Visible = false
ConfigFrame.Parent = Frame

local function createToggle(text, pos, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = config[key] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    btn.Text = text .. (config[key] and ": ON" or ": OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = ConfigFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        config[key] = not config[key]
        btn.BackgroundColor3 = config[key] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        btn.Text = text .. (config[key] and ": ON" or ": OFF")
        saveConfig()
    end)
end

createToggle("Smart Fast-Server Hop", UDim2.new(0.5, -100, 0, 0), "serverHopEnabled")

SelectionFrame.Size = UDim2.new(1, 0, 1, -40)
SelectionFrame.Position = UDim2.new(0, 0, 0, 40)
SelectionFrame.BackgroundTransparency = 1
SelectionFrame.Parent = Frame

local function start(mode)
    config.mode = mode
    saveConfig()
    SelectionFrame.Visible = false
    StatusLabel.Visible = true
    ConfigFrame.Visible = true
end

local function createModeBtn(text, pos, mode)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = SelectionFrame
    btn.MouseButton1Click:Connect(function() start(mode) end)
end

createModeBtn("PC", UDim2.new(0.5, -110, 0.2, 0), "PC")
createModeBtn("スマホ", UDim2.new(0.5, 10, 0.2, 0), "Mobile")

if config.mode ~= "" then start(config.mode) end

CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = Frame
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local function FastHop()
    local placeId = game.PlaceId
    StatusLabel.Text = "<font color='rgb(0,255,255)'>Finding Best Server...</font>"
    
    while true do
        -- 昇順で取得することで比較的空いていて、負荷の低いサーバーを狙う
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        local success, result = pcall(function() return game:HttpGet(url) end)
        
        if success then
            local decoded = HttpService:JSONDecode(result)
            for _, server in pairs(decoded.data) do
                -- プレイヤー数が10人以下など、過密でないサーバーを優先（Blox Fruitは過密だと重いため）
                if server.playing < 11 and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, Players.LocalPlayer)
                    task.wait(2)
                end
            end
        end
        task.wait(1)
    end
end

local Stats = game:GetService("Stats")
local DataPingItem = Stats.Network:WaitForChild("ServerStatsItem"):WaitForChild("Data Ping")
local fps = 0
local startTime = os.time()
game:GetService("RunService").RenderStepped:Connect(function(dt) fps = 1/dt end)

task.spawn(function()
    while task.wait(0.5) do
        if config.mode == "" then continue end
        
        local realPing = DataPingItem:GetValue()
        local fakePing = Players.LocalPlayer:GetNetworkPing() * 1000
        local uptime = os.time() - startTime
        local timeLeft = math.max(0, 10 - uptime)
        
        if config.serverHopEnabled and uptime >= 10 then
            if fakePing >= 50 then
                config.serverHopEnabled = false
                FastHop()
                return 
            end
        end

        local fPColor, fPStatus = "255,255,255", ""
        if fakePing < 30 then fPColor, fPStatus = "0,255,0", "(めちゃいい)"
        elseif fakePing < 50 then fPColor, fPStatus = "255,255,0", "(良)"
        else fPColor, fPStatus = "255,0,0", "(超悪)" end

        local pColor, pStatus = "255,255,255", ""
        if realPing >= 150 then pColor, pStatus = "255,0,0", "(超悪)"
        elseif realPing >= 80 then pColor, pStatus = "255,165,0", "(悪)"
        elseif realPing <= 30 then pColor, pStatus = "0,255,0", "(めちゃいい)"
        else pColor, pStatus = "255,255,0", "(良)" end

        local fColor, fStatus = "255,255,255", ""
        if config.mode == "Mobile" then
            if fps >= 55 then fColor, fStatus = "0,255,0", "(めちゃいい)"
            elseif fps >= 40 then fColor, fStatus = "255,255,0", "(良)"
            else fColor, fStatus = "255,0,0", "(超悪)" end
        else
            if fps >= 70 then fColor, fStatus = "0,255,0", "(めちゃいい)"
            elseif fps >= 50 then fColor, fStatus = "255,255,0", "(良)"
            elseif fps >= 40 then fColor, fStatus = "255,165,0", "(悪)"
            else fColor, fStatus = "255,0,0", "(超悪)" end
        end

        local text = ""
        text = text .. string.format("Fake Ping: <font color='rgb(%s)'>%6.2f ms %-12s</font>\n", fPColor, fakePing, fPStatus)
        text = text .. string.format("Data Ping: <font color='rgb(%s)'>%6.2f ms %-12s</font>\n", pColor, realPing, pStatus)
        text = text .. string.format("FPS      : <font color='rgb(%s)'>%6.1f    %-12s</font>\n", fColor, fps, fStatus)
        text = text .. string.format("Players  : %d\n", #Players:GetPlayers())
        text = text .. string.format("Uptime   : %02ds (Hop check: %02ds)", uptime, timeLeft)
        
        StatusLabel.Text = text
    end
end)
