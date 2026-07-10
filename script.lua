-- ==========================================
--               XYLOR PREMIUM v1
--          [ Developed by Xylo ]
-- ==========================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Xylor Premium v1",
   LoadingTitle = "Loading Xylor System v1...",
   LoadingSubtitle = "Developed by Xylo",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "XylorV1Configs",
      FileName = "XylorHubV1"
   },
   KeySystem = false
})

-- Global Variables
local GroupId = 12345678 -- <<--- Put your Roblox Group ID here!
local AimbotEnabled = false
local AimPart = "Head"
local AimSmoothness = 0.25 
local AimbotKey = Enum.KeyCode.E 
local ESPEnabled = false
local FlyEnabled = false
local FlySpeed = 50
local SelectedTargetPlayer = "" 
local SelectedFriendPlayer = "" 
local WhitelistedFriends = {}
local NoclipEnabled = false
local StreamerModeEnabled = false

-- ==========================================
-- FUNCTIONS: UTILITIES & AUTOMATIC WHITELIST
-- ==========================================
local function WhitelistPlayer(player)
    if player:IsInGroup(GroupId) then
        local nameLower = player.Name:lower()
        if not WhitelistedFriends[nameLower] then
            WhitelistedFriends[nameLower] = true
            
            Rayfield:Notify({
                Title = "Xylor Group Whitelist v1", 
                Content = player.Name .. " is in your Group! Auto-Whitelisted.", 
                Duration = 4
            })
            
            task.spawn(function()
                local char = player.Character or player.CharacterAdded:Wait()
                local head = char:WaitForChild("Head", 5)
                if head and not head:FindFirstChild("XylorGroupTag") then
                    local bbg = Instance.new("BillboardGui")
                    bbg.Name = "XylorGroupTag"
                    bbg.Size = UDim2.new(0, 200, 0, 50)
                    bbg.StudsOffset = Vector3.new(0, 3, 0)
                    bbg.AlwaysOnTop = true
                    
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Text = "[ Xylo Group Member ]"
                    tl.TextColor3 = Color3.fromRGB(0, 255, 128)
                    tl.TextSize = 14
                    tl.Font = Enum.Font.SourceSansBold
                    
                    tl.Parent = bbg
                    bbg.Parent = head
                end
            end)
        end
    end
end

local function GetPlayerNames()
    local names = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

for _, player in pairs(game:GetService("Players"):GetPlayers()) do
    WhitelistPlayer(player)
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    task.wait(2)
    WhitelistPlayer(player)
end)

-- Noclip Loop
game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ==========================================
-- TABS CREATION (Full English Layout)
-- ==========================================
local CombatTab = Window:CreateTab("Combat & ESP", 4483362458)
local TrollTab = Window:CreateTab("Troll & Mechanics", 4483362458)
local TargetTab = Window:CreateTab("Target Player", 4483362458)
local FriendsTab = Window:CreateTab("Friends List", 4483362458)
local SettingsTab = Window:CreateTab("Settings & Configs", 4483362458)

-- ==========================================
-- COMBAT & ESP TAB
-- ==========================================

CombatTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Flag = "AimToggle",
   Callback = function(Value)
      AimbotEnabled = Value
   end,
})

CombatTab:CreateKeybind({
   Name = "Aimbot Keybind",
   CurrentKeybind = "E",
   HoldToInteract = false,
   Flag = "AimKeybind",
   Callback = function(Keybind)
      AimbotEnabled = not AimbotEnabled
      Rayfield.Flags.AimToggle:Set(AimbotEnabled)
      Rayfield:Notify({
          Title = "Aimbot Status",
          Content = AimbotEnabled and "Aimbot Activated!" or "Aimbot Deactivated.",
          Duration = 2
      })
   end,
})

CombatTab:CreateSlider({
   Name = "Aimbot Smoothness",
   Range = {1, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 25,
   Flag = "AimSmooth",
   Callback = function(Value)
      AimSmoothness = Value / 100
   end,
})

CombatTab:CreateDropdown({
   Name = "Aimbot Target Part",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "AimTarget",
   Callback = function(Option)
      AimPart = Option[1]
   end,
})

CombatTab:CreateToggle({
   Name = "Enable ESP & Names (Wallhack)",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      ESPEnabled = Value
      while ESPEnabled do
          for _, player in pairs(game:GetService("Players"):GetPlayers()) do
              if player ~= game.Players.LocalPlayer and player.Character then
                  if not player.Character:FindFirstChild("XylorESP") then
                      local Highlight = Instance.new("Highlight")
                      Highlight.Name = "XylorESP"
                      Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                      Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                      Highlight.FillTransparency = 0.5
                      Highlight.Adornee = player.Character
                      Highlight.Parent = player.Character
                  end
                  
                  local head = player.Character:FindFirstChild("Head")
                  if head and not head:FindFirstChild("XylorNameTag") then
                      local bbg = Instance.new("BillboardGui")
                      bbg.Name = "XylorNameTag"
                      bbg.Size = UDim2.new(0, 250, 0, 60)
                      bbg.StudsOffset = Vector3.new(0, 2.5, 0)
                      bbg.AlwaysOnTop = true
                      
                      local tl = Instance.new("TextLabel")
                      tl.Size = UDim2.new(1, 0, 1, 0)
                      tl.BackgroundTransparency = 1
                      
                      if player.DisplayName ~= player.Name then
                          tl.Text = player.DisplayName .. " (@" .. player.Name .. ")"
                      else
                          tl.Text = player.Name
                      end
                      
                      tl.TextColor3 = Color3.fromRGB(255, 255, 0)
                      tl.TextSize = 13
                      tl.Font = Enum.Font.SourceSansBold
                      tl.TextOutlineTransparency = 0
                      
                      tl.Parent = bbg
                      bbg.Parent = head
                  end
              end
          end
          task.wait(1)
      end
      
      if not ESPEnabled then
          for _, player in pairs(game:GetService("Players"):GetPlayers()) do
              if player.Character then
                  if player.Character:FindFirstChild("XylorESP") then
                      player.Character.XylorESP:Destroy()
                  end
                  local head = player.Character:FindFirstChild("Head")
                  if head and head:FindFirstChild("XylorNameTag") then
                      head.XylorNameTag:Destroy()
                  end
              end
          end
      end
   end,
})

-- ADVANCED LIGHTWEIGHT & POWERFUL AIMBOT LOOP
task.spawn(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local UserInputService = game:GetService("UserInputService")

    game:GetService("RunService").RenderStepped:Connect(function()
        if AimbotEnabled then
            local ClosestPlayer = nil
            local ShortestDistance = math.huge

            for _, player in pairs(Players:GetPlayers()) do
                if WhitelistedFriends[player.Name:lower()] then continue end

                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(player.Character[AimPart].Position)
                    if OnScreen then
                        local MousePos = UserInputService:GetMouseLocation()
                        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                        if Distance < ShortestDistance then
                            ClosestPlayer = player
                            ShortestDistance = Distance
                        end
                    end
                end
            end

            if ClosestPlayer then
                local TargetPos, OnScreen = Camera:WorldToViewportPoint(ClosestPlayer.Character[AimPart].Position)
                if OnScreen then
                    local MousePos = UserInputService:GetMouseLocation()
                    local MainX = (TargetPos.X - MousePos.X) * (1 - AimSmoothness)
                    local MainY = (TargetPos.Y - MousePos.Y) * (1 - AimSmoothness)
                    mousemoverel(MainX, MainY)
                end
            end
        end
    end)
end)

-- ==========================================
-- TROLL & MECHANICS TAB (CORRECTED R6 FLY)
-- ==========================================

TrollTab:CreateToggle({
   Name = "R6 Fly Mode",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      FlyEnabled = Value
      local Players = game:GetService("Players")
      local RunService = game:GetService("RunService")
      local UserInputService = game:GetService("UserInputService")
      
      local lplayer = Players.LocalPlayer
      local Character = lplayer.Character or lplayer.CharacterAdded:Wait()
      local HRP = Character:WaitForChild("HumanoidRootPart")
      local Humanoid = Character:WaitForChild("Humanoid")
      local Camera = workspace.CurrentCamera
      
      local flyConnection
      
      if FlyEnabled then
          Rayfield:Notify({Title = "Xylor Mechanics v1", Content = "R6 Fly Mode Activated!", Duration = 2})
          
          Humanoid.PlatformStand = true
          
          flyConnection = RunService.RenderStepped:Connect(function()
              if not FlyEnabled or not Character or not HRP then 
                  if flyConnection then flyConnection:Disconnect() end
                  return 
              end
              
              local LookVector = Camera.CFrame.LookVector
              local RightVector = Camera.CFrame.RightVector
              local MoveDirection = Vector3.new(0, 0, 0)
              
              if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                  MoveDirection = MoveDirection + LookVector
              end
              if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                  MoveDirection = MoveDirection - LookVector
              end
              if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                  MoveDirection = MoveDirection - RightVector
              end
              if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                  MoveDirection = MoveDirection + RightVector
              end
              if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                  MoveDirection = MoveDirection + Vector3.new(0, 1, 0)
              end
              if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                  MoveDirection = MoveDirection - Vector3.new(0, 1, 0)
              end
              
              if MoveDirection.Magnitude > 0 then
                  HRP.CFrame = HRP.CFrame + (MoveDirection.Unit * (FlySpeed / 50))
              end
              
              HRP.Velocity = Vector3.new(0, 0, 0)
          end)
      else
          if flyConnection then flyConnection:Disconnect() end
          Humanoid.PlatformStand = false
          Rayfield:Notify({Title = "Xylor Mechanics v1", Content = "R6 Fly Mode Deactivated.", Duration = 2})
      end
      
      Humanoid.Died:Connect(function()
          if flyConnection then flyConnection:Disconnect() end
          FlyEnabled = false
      end)
   end,
})

TrollTab:CreateButton({
   Name = "Become Invisible",
   Callback = function()
       local Player = game.Players.LocalPlayer
       local Character = Player.Character
       if Character and Character:FindFirstChild("HumanoidRootPart") then
           for _, part in pairs(Character:GetDescendants()) do
               if part:IsA("BasePart") or part:IsA("Decal") then
                   if part.Name ~= "HumanoidRootPart" then part.Transparency = 1 end
               end
           end
           Rayfield:Notify({Title = "Xylor Troll v1", Content = "You are now fully invisible!", Duration = 3})
       end
   end,
})

-- ==========================================
-- TARGET PLAYER TAB (SUPER POWERFUL FLING)
-- ==========================================

local PlayerDropdown = TargetTab:CreateDropdown({
   Name = "Select Target Player",
   Options = GetPlayerNames(),
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "TargetDropdown",
   Callback = function(Option)
      SelectedTargetPlayer = Option[1]
   end,
})

TargetTab:CreateButton({
   Name = "Refresh Player List",
   Callback = function()
       PlayerDropdown:Refresh(GetPlayerNames())
       Rayfield:Notify({Title = "Xylor Hub v1", Content = "Player list successfully updated!", Duration = 2})
   end,
})

TargetTab:CreateButton({
   Name = "Fling Target Player",
   Callback = function()
       local LocalPlayer = game.Players.LocalPlayer
       local TargetPlayer = game.Players:FindFirstChild(SelectedTargetPlayer)
       
       if TargetPlayer and TargetPlayer ~= LocalPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
           local MyChar = LocalPlayer.Character
           local MyHRP = MyChar and MyChar:FindFirstChild("HumanoidRootPart")
           local TargetHRP = TargetPlayer.Character.HumanoidRootPart
           
           if MyHRP and MyChar:FindFirstChild("Humanoid") then
               Rayfield:Notify({Title = "Xylor Fling v1", Content = "Executing Max Power Fling...", Duration = 3})
               
               local OldCFrame = MyHRP.CFrame
               
               local noclipConnection
               noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                   for _, part in pairs(MyChar:GetDescendants()) do
                       if part:IsA("BasePart") then part.CanCollide = false end
                   end
               end)
               
               local BamV = Instance.new("BodyThrust")
               BamV.Parent = MyHRP
               BamV.Force = Vector3.new(99999, 99999, 99999)
               BamV.Location = MyHRP.Position
               
               local StartTime = tick()
               while tick() - StartTime < 0.8 do 
                   if TargetHRP then
                       MyHRP.CFrame = TargetHRP.CFrame * CFrame.new(math.random(-1,1)/5, 0, math.random(-1,1)/5) * CFrame.Angles(math.rad(math.random(0,360)), math.rad(math.random(0,360)), math.rad(math.random(0,360)))
                       MyHRP.Velocity = Vector3.new(0, 9999, 0)
                   else
                       break
                   end
                   game:GetService("RunService").Heartbeat:Wait()
               end
               
               BamV:Destroy()
               noclipConnection:Disconnect()
               MyHRP.Velocity = Vector3.new(0, 0, 0)
               MyHRP.RotVelocity = Vector3.new(0, 0, 0)
               
               task.wait(0.05)
               MyHRP.CFrame = OldCFrame
               Rayfield:Notify({Title = "Xylor Target v1", Content = "Target successfully flung away!", Duration = 2})
           end
       else
           Rayfield:Notify({Title = "Xylor Error v1", Content = "Please select a valid player from the dropdown first!", Duration = 3})
       end
   end,
})

-- ==========================================
-- FRIENDS LIST TAB (DYNAMIC DROPDOWN FOR AIM BYPASS)
-- ==========================================

local FriendDropdown = FriendsTab:CreateDropdown({
   Name = "Select Friend to Whitelist",
   Options = GetPlayerNames(),
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "FriendDropdown",
   Callback = function(Option)
      SelectedFriendPlayer = Option[1]
   end,
})

FriendsTab:CreateButton({
   Name = "Refresh Server Player List",
   Callback = function()
       FriendDropdown:Refresh(GetPlayerNames())
       Rayfield:Notify({Title = "Xylor Friends v1", Content = "Server list updated!", Duration = 2})
   end,
})

FriendsTab:CreateButton({
   Name = "Add Selected Friend to Whitelist",
   Callback = function()
      if SelectedFriendPlayer ~= "" then
          WhitelistedFriends[SelectedFriendPlayer:lower()] = true
          Rayfield:Notify({
              Title = "Xylor Whitelist v1", 
              Content = SelectedFriendPlayer .. " won't be targeted by Aimbot!", 
              Duration = 4
          })
      else
          Rayfield:Notify({Title = "Xylor Error v1", Content = "Please select a player from the dropdown!", Duration = 3})
      end
   end,
})

FriendsTab:CreateButton({
   Name = "Clear All Whitelisted Friends",
   Callback = function()
      WhitelistedFriends = {}
      Rayfield:Notify({Title = "Xylor Whitelist v1", Content = "Whitelist cleared successfully!", Duration = 3})
   end,
})

-- ==========================================
-- SETTINGS & CONFIGS TAB
-- ==========================================

SettingsTab:CreateToggle({
   Name = "Enable Noclip (Walk Through Walls)",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      NoclipEnabled = Value
      if NoclipEnabled then
          Rayfield:Notify({Title = "Xylor Mechanics v1", Content = "Noclip Activated!", Duration = 3})
      else
          Rayfield:Notify({Title = "Xylor Mechanics v1", Content = "Noclip Deactivated.", Duration = 3})
      end
   end,
})

SettingsTab:CreateToggle({
   Name = "Streamer Mode (Hide Hub Info)",
   CurrentValue = false,
   Flag = "StreamerToggle",
   Callback = function(Value)
      StreamerModeEnabled = Value
      if StreamerModeEnabled then
          Window.Name = "Xylor Premium v1 [ STREAMER MODE ]"
          Rayfield:Notify({Title = "Streamer Mode v1", Content = "Personal information hidden!", Duration = 3})
      else
          Window.Name = "Xylor Premium v1"
          Rayfield:Notify({Title = "Streamer Mode v1", Content = "Streamer Mode Deactivated.", Duration = 3})
      end
   end,
})

SettingsTab:CreateSlider({
   Name = "WalkSpeed Modification",
   Range = {16, 150},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
          game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

Rayfield:Notify({
    Title = "Xylor v1 Loaded", 
    Content = "Welcome to Xylor Premium v1! Created by Xylo", 
    Duration = 5
})
