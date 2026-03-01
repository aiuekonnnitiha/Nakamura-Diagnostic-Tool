local _0xA=game:GetService("Players")repeat task.wait() until _0xA.LocalPlayer
local _0xB=game:GetService("HttpService")local _0xC=game:GetService("TeleportService")local _0xD=game:GetService("Stats")local _0xE=game:GetService("RunService")local _0xT=game:GetService("TweenService")
local _0xF=_0xA.LocalPlayer local _0xG=_0xF:WaitForChild("PlayerGui")
if _0xG:FindFirstChild("NakamuraDiagnostic") then _0xG.NakamuraDiagnostic:Destroy() end
local _0xH=Instance.new("ScreenGui")_0xH.Name="NakamuraDiagnostic" _0xH.ResetOnSpawn=false _0xH.Parent=_0xG
local _0xI="NakamuraConfig.txt" local _0xJ="NakamuraAutoLog.txt" local _0xK={mode="",serverHopEnabled=false}
pcall(function() if isfile(_0xI) then _0xK=_0xB:JSONDecode(readfile(_0xI)) end end)
local function _0xL() pcall(function() writefile(_0xI,_0xB:JSONEncode(_0xK)) end) end
local _0xM=Instance.new("Frame")_0xM.Size=UDim2.new(0,320,0,220)_0xM.Position=UDim2.new(0.5,-160,0.4,-110)_0xM.BackgroundColor3=Color3.fromRGB(0,0,0)_0xM.BackgroundTransparency=0.4 _0xM.Active=true _0xM.Draggable=true _0xM.Parent=_0xH
Instance.new("UICorner",_0xM).CornerRadius=UDim.new(0,8)
local _0xN=Instance.new("ImageLabel")_0xN.BackgroundTransparency=1 _0xN.Position=UDim2.new(0,10,0,10)_0xN.Size=UDim2.new(0,25,0,25)_0xN.Image="rbxassetid://17316645495" _0xN.Parent=_0xM
local _0xO=Instance.new("TextLabel")_0xO.Size=UDim2.new(1,-40,0,30)_0xO.Position=UDim2.new(0,40,0,10)_0xO.BackgroundTransparency=1 _0xO.Text="Nakamura Diagnostic" _0xO.TextColor3=Color3.fromRGB(255,255,0)_0xO.TextSize=18 _0xO.Font=Enum.Font.GothamBold _0xO.TextXAlignment=Enum.TextXAlignment.Left _0xO.Parent=_0xM
local _0xP=Instance.new("TextLabel")_0xP.Size=UDim2.new(1,-20,0,110)_0xP.Position=UDim2.new(0,10,0,45)_0xP.BackgroundTransparency=1 _0xP.TextColor3=Color3.fromRGB(255,255,255)_0xP.TextSize=13 _0xP.Font=Enum.Font.Code _0xP.RichText=true _0xP.Parent=_0xM
local _0xQ=Instance.new("Frame")_0xQ.Size=UDim2.new(1,0,0,40)_0xQ.Position=UDim2.new(0,0,1,-45)_0xQ.BackgroundTransparency=1 _0xQ.Visible=false _0xQ.Parent=_0xM
local _0xR=Instance.new("TextButton")_0xR.Size=UDim2.new(0,170,0,30)_0xR.Position=UDim2.new(0,10,0,5)_0xR.BackgroundColor3=_0xK.serverHopEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
_0xR.Text="Smart Hop: "..(_0xK.serverHopEnabled and "ON" or "OFF")_0xR.TextColor3=Color3.new(1,1,1)_0xR.Font=Enum.Font.GothamBold _0xR.Parent=_0xQ
Instance.new("UICorner",_0xR).CornerRadius=UDim.new(0,6)
_0xR.MouseButton1Click:Connect(function() _0xK.serverHopEnabled=not _0xK.serverHopEnabled _0xR.BackgroundColor3=_0xK.serverHopEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0) _0xR.Text="Smart Hop: "..(_0xK.serverHopEnabled and "ON" or "OFF") _0xL() end)
local _0xS=Instance.new("TextButton")_0xS.Size=UDim2.new(0,120,0,30)_0xS.Position=UDim2.new(0,190,0,5)_0xS.BackgroundColor3=Color3.fromRGB(60,60,150)_0xS.Text="Copy Logs" _0xS.TextColor3=Color3.new(1,1,1)_0xS.Parent=_0xQ
Instance.new("UICorner",_0xS).CornerRadius=UDim.new(0,6)
_0xS.MouseButton1Click:Connect(function() if isfile(_0xJ) then setclipboard(readfile(_0xJ)) _0xS.Text="Copied!" task.wait(1) _0xS.Text="Copy Logs" end end)
local _0xU=Instance.new("Frame")_0xU.Size=UDim2.new(1,0,0,100)_0xU.Position=UDim2.new(0,0,0,70)_0xU.BackgroundTransparency=1 _0xU.Parent=_0xM
local function _0xV(m) _0xK.mode=m _0xL() _0xU.Visible=false _0xQ.Visible=true end
local function _0xW(t,p,m)
local b=Instance.new("TextButton")b.Size=UDim2.new(0,110,0,50)b.Position=p b.Text=t b.BackgroundColor3=Color3.fromRGB(70,70,70)b.TextColor3=Color3.new(1,1,1)b.Font=Enum.Font.GothamBold b.Parent=_0xU
Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)b.MouseButton1Click:Connect(function() _0xV(m) end)
end
_0xW("PC",UDim2.new(0.5,-120,0,0),"PC")_0xW("Mobile",UDim2.new(0.5,10,0,0),"Mobile")
if _0xK.mode~="" then _0xV(_0xK.mode) end
local _0xX=Instance.new("TextButton")_0xX.Size=UDim2.new(0,20,0,20)_0xX.Position=UDim2.new(1,-25,0,5)_0xX.Text="X" _0xX.TextColor3=Color3.new(1,0,0)_0xX.BackgroundTransparency=1 _0xX.Parent=_0xM
_0xX.MouseButton1Click:Connect(function() _0xH:Destroy() end)
local _0xY=_0xD.Network:WaitForChild("ServerStatsItem"):WaitForChild("Data Ping")local _0xZ=60 local _0x1=os.time()local _0x2=false
_0xE.RenderStepped:Connect(function(dt) _0xZ=1/dt end)
local _0xBS=Instance.new("Sound",_0xM)_0xBS.SoundId="rbxasset://sounds/action_jump.mp3"_0xBS.Volume=0.5 pcall(function() _0xBS:Play() end)
task.spawn(function()
while task.wait(0.5) do
if not _0xQ.Visible then continue end
local rp=_0xY:GetValue()local fp=_0xF:GetNetworkPing()*1000 local ut=os.time()-_0x1
if ut>=10 and not _0x2 then
pcall(function() local e=string.format("ID: %s | Real: %.2f | Fake: %.2f | FPS: %.1f | Players: %d\n",game.JobId,rp,fp,_0xZ,#_0xA:GetPlayers()) local c=isfile(_0xJ) and readfile(_0xJ) or "--- Nakamura Log ---\n" writefile(_0xJ,c..e) end)
_0x2=true end
if _0xK.serverHopEnabled and ut>=10 then
if rp>=60 or fp>=70 then _0xL()
local s,r=pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100") end)
if s then local d=_0xB:JSONDecode(r) for _,v in pairs(d.data) do if v.playing<8 and v.id~=game.JobId then _0xC:TeleportToPlaceInstance(game.PlaceId,v.id,_0xF) break end end end end end
local function gc(v,b) return (v>=b and "255,0,0") or (v>=b*0.6 and "255,255,0") or "0,255,0" end
local function gs(v,b) return (v>=b and "(Bad)") or (v>=b*0.6 and "(OK)") or "(Good)" end
_0xP.Text=string.format("Fake Ping: <font color='rgb(%s)'>%.2f ms %s</font>\nData Ping: <font color='rgb(%s)'>%.2f ms %s</font>\nFPS : %.1f\nLog : %s\nUptime : %ds (Check: %ds)",gc(fp,70),fp,gs(fp,70),gc(rp,60),rp,gs(rp,60),_0xZ,(_0x2 and "<font color='rgb(0,255,0)'>SAVED</font>" or "WAITING"),ut,math.max(0,10-ut))
end end)
