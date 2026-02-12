local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local StatusLabel = Instance.new("TextLabel")
local TitleLabel = Instance.new("TextLabel")
local Icon = Instance.new("ImageLabel")
local CloseButton = Instance.new("TextButton")
local SelectionFrame = Instance.new("Frame")

local parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = parent

local fileName = "NakamuraConfig.txt"

Frame.Size = UDim2.new(0, 320, 0, 140)
Frame.Position = UDim2.new(0.5, -160, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.5
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

Icon.Name = "Icon"
Icon.Parent = Frame
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0, 10, 0, 10)
Icon.Size = UDim2.new(0, 25, 0, 25) 
Icon.Image = "rbxassetid://17316645495"

TitleLabel.Name = "Title"
TitleLabel.Parent = Frame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 40, 0, 10)
TitleLabel.Size = UDim2.new(0, 200, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "中村診断！"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

StatusLabel.Size = UDim2.new(1, -20, 0, 90)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Code
StatusLabel.RichText = true
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Visible = false
StatusLabel.Parent = Frame

SelectionFrame.Size = UDim2.new(1, 0, 1, -40)
SelectionFrame.Position = UDim2.new(0, 0, 0, 40)
SelectionFrame.BackgroundTransparency = 1
SelectionFrame.Parent = Frame

local isMobile = false
local selected = false

local function startDiagnostic(mode)
    isMobile = (mode == "Mobile")
    if writefile then
        pcall(function() writefile(fileName, mode) end)
    end
    SelectionFrame.Visible = false
    StatusLabel.Visible = true
    selected = true
end

local function createButton(text, pos, mode)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = SelectionFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(function() startDiagnostic(mode) end)
end

createButton("PC", UDim2.new(0.5, -110, 0.2, 0), "PC")
createButton("スマホ", UDim2.new(0.5, 10, 0.2, 0), "Mobile")

if readfile and isfile and isfile(fileName) then
    local savedMode = readfile(fileName)
    if savedMode == "PC" or savedMode == "Mobile" then
        startDiagnostic(savedMode)
    end
end

CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = Frame
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Stats = game:GetService("Stats")
local DataPingItem = Stats.Network:WaitForChild("ServerStatsItem"):WaitForChild("Data Ping")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local fps = 0
local startTime = os.time()

RunService.RenderStepped:Connect(function(dt) fps = 1 / dt end)

task.spawn(function()
    while task.wait(0.5) do
        if not selected then continue end
        local rawPing = DataPingItem:GetValue()
        local currentFps = fps
        local playerCount = #Players:GetPlayers()
        local uptime = os.time() - startTime
        local h, m, s = math.floor(uptime/3600), math.floor((uptime%3600)/60), uptime%60

        local pColor, pStatus = "255,255,255", ""
        if rawPing >= 150 then
            pColor, pStatus = "255,0,0", "(超悪)"
        elseif rawPing >= 80 then
            pColor, pStatus = "255,165,0", "(悪)"
        elseif rawPing <= 30 then
            pColor, pStatus = "0,255,0", "(めちゃいい)"
        else
            -- 30超〜80未満を黄色(良)に設定
            pColor, pStatus = "255,255,0", "(良)"
        end

        local fColor, fStatus = "255,255,255", ""
        if isMobile then
            if currentFps >= 55 then
                fColor, fStatus = "0,255,0", "(めちゃいい)"
            elseif currentFps >= 40 then
                fColor, fStatus = "255,255,0", "(良)"
            else
                fColor, fStatus = "255,0,0", "(超悪)"
            end
        else
            if currentFps >= 70 then
                fColor, fStatus = "0,255,0", "(めちゃいい)"
            elseif currentFps >= 50 then
                fColor, fStatus = "255,255,0", "(良)"
            elseif currentFps >= 40 then
                fColor, fStatus = "255,165,0", "(悪)"
            else
                fColor, fStatus = "255,0,0", "(超悪)"
            end
        end

        StatusLabel.Text = string.format(
            "Data Ping: <font color='rgb(%s)'>%6.2f ms %-12s</font>\n" ..
            "FPS      : <font color='rgb(%s)'>%6.1f    %-12s</font>\n" ..
            "Players  : %d\n" ..
            "Uptime   : %02d:%02d:%02d",
            pColor, rawPing, pStatus, fColor, currentFps, fStatus, playerCount, h, m, s
        )
    end
end)
