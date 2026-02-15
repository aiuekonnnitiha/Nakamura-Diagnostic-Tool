local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local StatusLabel = Instance.new("TextLabel")
local TitleLabel = Instance.new("TextLabel")
local Icon = Instance.new("ImageLabel")
local CloseButton = Instance.new("TextButton")
local SelectionFrame = Instance.new("Frame")
local ConfigFrame = Instance.new("Frame")

-- 親をPlayerGuiにすることで、より確実に表示
local player = game:GetService("Players").LocalPlayer
local parent = player:WaitForChild("PlayerGui")
ScreenGui.Name = "NakamuraDiagnostic"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parent

local fileName = "NakamuraConfig.txt"
local logFile = "NakamuraAutoLog.txt"
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local config = {
    mode = "",
    serverHopEnabled = false
}

-- 【設定読み込み：エラー回避強化】
pcall(function()
    if isfile(fileName) then
        local data = readfile(fileName)
        if data and data ~= "" then
            local decoded = HttpService:JSONDecode(data)
            if type(decoded) == "table" then
                config = decoded
            end
        end
    end
end)

local function saveConfig()
    pcall(function()
        writefile(fileName, HttpService:JSONEncode(config))
    end)
end

local function saveToLog(realPing, fakePing, currentFps)
    local serverId = game.JobId
    local entry = string.format("ID: %s | Real: %.2fms | Fake: %.2fms | FPS: %.1f | Players: %d\n", 
        serverId, realPing, fakePing, currentFps, #Players:GetPlayers())
    local current = ""
    pcall(function()
        if isfile(logFile) then current = readfile(logFile) end
    end)
    if not string.find(current, serverId) then
        writefile(logFile, (current == "" and "--- Nakamura Log ---\n" or current) .. entry)
    end
end

-- UI Setup
Frame.Size = UDim2.new(0, 320, 0, 220)
Frame.Position = UDim2.new(0.5, -160, 0.4, -110) -- 中央付近に出るように調整
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.4
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

StatusLabel.Size = UDim2.new(1, -20, 0, 120)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Code
StatusLabel.RichText = true
StatusLabel.Visible = false
StatusLabel.Parent = Frame

ConfigFrame.Size = UDim2.new(1, 0, 0, 40)
ConfigFrame.Position = UDim2.new(0, 0, 0, 175)
ConfigFrame.BackgroundTransparency = 1
ConfigFrame.Visible = false
ConfigFrame.Parent = Frame

-- Smart Hop & Copy Buttons
local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(0, 175, 0, 30)
hopBtn.Position = UDim2.new(0, 10, 0, 0)
hopBtn.BackgroundColor3 = config.serverHopEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
hopBtn.Text = "Smart Hop: " .. (config.serverHopEnabled and "ON" or "OFF")
hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextSize = 11
hopBtn.Parent = ConfigFrame
Instance.new("UICorner", hopBtn).CornerRadius = UDim.new(0, 6)

hopBtn.MouseButton1Click:Connect(function()
    config.serverHopEnabled = not config.serverHopEnabled
    hopBtn.BackgroundColor3 = config.serverHopEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    hopBtn.Text = "Smart Hop: " .. (config.serverHopEnabled and "ON" or "OFF")
    saveConfig()
end)

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 115, 0, 30)
copyBtn.Position = UDim2.new(0, 195, 0, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 150)
copyBtn.Text = "Copy Logs"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 11
copyBtn.Parent = ConfigFrame
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)

copyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if isfile(logFile) then setclipboard(readfile(logFile)) end
    end)
end)

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
    btn.Size = UDim2.new(0, 110, 0, 50)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = SelectionFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(function() start(mode) end)
end

createModeBtn("PC", UDim2.new(0.5, -120, 0.2, 0), "PC")
createModeBtn("スマホ", UDim2.new(0.5, 10, 0.2, 0), "Mobile")

CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = Frame
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- 神ホップ（強化版）
local function FastHop()
    local GodIds = {"5", "3", "e"}
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function() return game:HttpGet(url) end)
    if success then
        local decoded = HttpService:JSONDecode(result)
        local candidates = {}
        for _, s in pairs(decoded.data) do
            if s.playing < 8 and s.id ~= game.JobId then -- 8人以下の空いてるサーバー
                local priority = table.find(GodIds, string.sub(s.id, 1, 1)) and 1 or 2
                table.insert(candidates, {id = s.id, priority = priority})
            end
        end
        table.sort(candidates, function(a, b) return a.priority < b.priority end)
        if candidates[1] then TeleportService:TeleportToPlaceInstance(game.PlaceId, candidates[1].id, Players.LocalPlayer) end
    end
end

local Stats = game:GetService("Stats")
local DataPingItem = Stats.Network:WaitForChild("ServerStatsItem"):WaitForChild("Data Ping")
local fps = 0
local startTime = os.time()
local recorded = false
game:GetService("RunService").RenderStepped:Connect(function(dt) fps = 1/dt end)

-- すでに設定があれば自動スタート
if config.mode and config.mode ~= "" then start(config.mode) end

task.spawn(function()
    while task.wait(0.5) do
        if not ConfigFrame.Visible then continue end
        local realPing = DataPingItem:GetValue()
        local fakePing = Players.LocalPlayer:GetNetworkPing() * 1000
        local uptime = os.time() - startTime
        
        if uptime >= 10 and not recorded then
            saveToLog(realPing, fakePing, fps)
            recorded = true
        end

        if config.serverHopEnabled and uptime >= 10 then
            if realPing >= 45 or fakePing >= 55 then
                saveConfig()
                FastHop()
                return 
            end
        end

        local function getStatus(val, isFps)
            if isFps then
                local threshold = (config.mode == "Mobile") and 55 or 70
                if val >= threshold then return "0,255,0", "(めちゃいい)"
                elseif val >= 40 then return "255,255,0", "(良)"
                else return "255,0,0", "(超悪)" end
            else
                if val >= 150 then return "255,0,0", "(超悪)"
                elseif val >= 80 then return "255,165,0", "(悪)"
                elseif val <= 35 then return "0,255,0", "(めちゃいい)"
                else return "255,255,0", "(良)" end
            end
        end

        local fPCol, fPStat = getStatus(fakePing, false)
        local rPCol, rPStat = getStatus(realPing, false)
        local fCol, fStat = getStatus(fps, true)

        StatusLabel.Text = string.format(
            "Fake Ping: <font color='rgb(%s)'>%.2f ms %s</font>\n" ..
            "Data Ping: <font color='rgb(%s)'>%.2f ms %s</font>\n" ..
            "FPS      : <font color='rgb(%s)'>%.1f    %s</font>\n" ..
            "Players  : %d\n" ..
            "Log      : %s\n" ..
            "Uptime   : %ds (Hop in: %ds)",
            fPCol, fakePing, fPStat, rPCol, realPing, rPStat, fCol, fps, fStat, 
            #Players:GetPlayers(), (recorded and "<font color='rgb(0,255,0)'>SAVED</font>" or "WAITING"), 
            uptime, math.max(0, 10-uptime)
        )
    end
end)
