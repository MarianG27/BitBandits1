local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

-- Ensure the RemoteEvent exists for the cutscene
local StartEvent = ReplicatedStorage:FindFirstChild("StartCutscene") or Instance.new("RemoteEvent", ReplicatedStorage)
StartEvent.Name = "StartCutscene"

local rig1 = workspace:WaitForChild("RigP1")
local rig2 = workspace:WaitForChild("RigP2")

-- Table to track players who have already seen the cutscene
local hasSeenCutscene = {}

-- Function to apply the player's avatar to the Rig
local function applySkin(player, rig)
	local success, description = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(player.UserId)
	end)
	
	if success and description then
		rig.Humanoid:ApplyDescription(description)
		-- Freeze the rig in place
		rig.Humanoid.WalkSpeed = 0
		rig.Humanoid.JumpPower = 0
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		
		-- Check if the player has already viewed the cutscene during this session
		if hasSeenCutscene[player.UserId] then 
			return -- Exit the function so the cutscene doesn't play again after respawn
		end

		-- Small delay to ensure the player is fully loaded and assigned to a team
		task.wait(1) 

		-- Team-based logic
		if player.Team == Teams:FindFirstChild("Player1") then
			-- Mark as seen
			hasSeenCutscene[player.UserId] = true
			
			applySkin(player, rig1)
			StartEvent:FireClient(player)
			print("Cutscene started for " .. player.Name .. " in Team Player1")

		elseif player.Team == Teams:FindFirstChild("Player2") then
			-- Mark as seen
			hasSeenCutscene[player.UserId] = true
			
			applySkin(player, rig2)
			StartEvent:FireClient(player)
			print("Cutscene started for " .. player.Name .. " in Team Player2")
		end
	end)
end)

-- Clean up the table when a player leaves to prevent memory leaks
Players.PlayerRemoving:Connect(function(player)
	hasSeenCutscene[player.UserId] = nil
end)
