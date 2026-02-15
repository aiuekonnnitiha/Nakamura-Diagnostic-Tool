local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- 二重起動防止
if pgui:FindFirstChild("NakamuraDiagnostic") then
    pgui.NakamuraDiagnostic:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NakamuraDiagnostic"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = pgui

local fileName = "NakamuraConfig.txt"
local logFile = "NakamuraAutoLog.txt"
local config = { mode = "", serverHopEnabled = false }

-- 設定読み込み
pcall(function()
    if isfile(fileName) then
        config = HttpService:JSONDecode(readfile(fileName))
    end
end)

local function saveConfig()
    pcall(function() writefile(fileName, HttpService:JSONEncode(config)) end)
end

-- メイン枠
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 220)
Frame.Position = UDim2.new(0.5, -160, 0.4, -110)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.4
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

-- 【画像（アイコン）復活】
local Icon = Instance.new("ImageLabel")
Icon.Parent = Frame
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0, 10, 0, 10)
Icon.Size = UDim2.new(0, 25, 0, 25) 
Icon.Image = "rbxassetid://17316645495" -- 中村さん指定のID

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Position = UDim2.new(0, 40, 0, 10) -- 画像の横に調整
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "中村診断！"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 110)
StatusLabel.Position = UDim2.new(0, 10, 0, 45)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Code
StatusLabel.RichText = true
StatusLabel.Parent = Frame

local ConfigFrame = Instance.new("Frame")
ConfigFrame.Size = UDim2.new(1, 0, 0, 40)
ConfigFrame.Position = UDim2.new(0, 0, 1, -45)
ConfigFrame.BackgroundTransparency = 1
ConfigFrame.Visible = false
ConfigFrame.Parent = Frame

-- Smart Hop ボタン
local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(0, 170, 0, 30)
hopBtn.Position = UDim2.new(0, 10, 0, 5)
hopBtn.BackgroundColor3 = config.serverHopEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
hopBtn.Text = "Smart Hop: " .. (config.serverHopEnabled and "ON" or "OFF")
hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopBtn.Font = Enum.Font.GothamBold
hopBtn.Parent = ConfigFrame
Instance.new("UICorner", hopBtn).CornerRadius = UDim.new(0, 6)

hopBtn.MouseButton1Click:Connect(function()
    config.serverHopEnabled = not config.serverHopEnabled
    hopBtn.BackgroundColor3 = config.serverHopEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    hopBtn.Text = "Smart Hop: " .. (config.serverHopEnabled and "ON" or "OFF")
    saveConfig()
end)

-- Copy Logs ボタン
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 120, 0, 30)
copyBtn.Position = UDim2.new(0, 190, 0, 5)
copyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 150)
copyBtn.Text = "Copy Logs"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Parent = ConfigFrame
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)

copyBtn.MouseButton1Click:Connect(function()
    if isfile(logFile) then 
        setclipboard(readfile(logFile)) 
        copyBtn.Text = "Copied!" 
        task.wait(1) 
        copyBtn.Text = "Copy Logs" 
    end
end)

-- モード選択画面
local SelectionFrame = Instance.new("Frame")
SelectionFrame.Size = UDim2.new(1, 0, 0, 100)
SelectionFrame.Position = UDim2.new(0, 0, 0, 70)
SelectionFrame.BackgroundTransparency = 1
SelectionFrame.Parent = Frame

local function start(mode)
    config.mode = mode
    saveConfig()
    SelectionFrame.Visible = false
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

createModeBtn("PC", UDim2.new(0.5, -120, 0, 0), "PC")
createModeBtn("スマホ", UDim2.new(0.5, 10, 0, 0), "Mobile")

if config.mode ~= "" then start(config.mode) end

-- 閉じるボタン
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = Frame
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- 診断ロジック
local DataPingItem = Stats.Network:WaitForChild("ServerStatsItem"):WaitForChild("Data Ping")
local fps = 60
local startTime = os.time()
local recorded = false

RunService.RenderStepped:Connect(function(dt) fps = 1/dt end)

task.spawn(function()
    while task.wait(0.5) do
        if not ConfigFrame.Visible then continue end
        local realPing = DataPingItem:GetValue()
        local fakePing = player:GetNetworkPing() * 1000
        local uptime = os.time() - startTime

        -- 10秒自動記録
        if uptime >= 10 and not recorded then
            pcall(function()
                local entry = string.format("ID: %s | Real: %.2f | Fake: %.2f | FPS: %.1f | Players: %d\n", game.JobId, realPing, fakePing, fps, #Players:GetPlayers())
                local cur = isfile(logFile) and readfile(logFile) or "--- Nakamura Log ---\n"
                writefile(logFile, cur .. entry)
            end)
            recorded = true
        end

        -- ホップ判定
        if config.serverHopEnabled and uptime >= 10 then
            if realPing >= 60 or fakePing >= 70 then
                saveConfig()
                -- 神ホップ（ID: 5, 3, e 優先）
                local success, result = pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100") end)
                if success then
                    local decoded = HttpService:JSONDecode(result)
                    for _, s in pairs(decoded.data) do
                        if s.playing < 8 and s.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                            break
                        end
                    end
                end
                return
            end
        end

        -- 色とテキスト表示
        local function getCol(val, bad) return (val >= bad and "255,0,0") or (val >= bad*0.6 and "255,255,0") or "0,255,0" end
        local function getStat(val, bad) return (val >= bad and "(超悪)") or (val >= bad*0.6 and "(良)") or "(めちゃいい)" end

        StatusLabel.Text = string.format(
            "Fake Ping: <font color='rgb(%s)'>%.2f ms %s</font>\n" ..
            "Data Ping: <font color='rgb(%s)'>%.2f ms %s</font>\n" ..
            "FPS      : %.1f\n" ..
            "Log      : %s\n" ..
            "Uptime   : %ds (Check: %ds)",
            getCol(fakePing, 70), fakePing, getStat(fakePing, 70),
            getCol(realPing, 60), realPing, getStat(realPing, 60),
            fps, (recorded and "<font color='rgb(0,255,0)'>SAVED</font>" or "WAITING"), 
            uptime, math.max(0, 10-uptime)
        )
    end
end)
