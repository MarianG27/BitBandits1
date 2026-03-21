local npc = script.Parent.NPC
local cd = false

local function touchNpc(hit)
	local waitValue = false
	
	if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Humanoid.Health > 0 and waitValue == false then
		local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
		plr.Character:WaitForChild("Humanoid").Health -= script.Parent.Damage.Value
	elseif waitValue == true then
		wait(1)
		waitValue = false
	end
end

local function diedNpc()
	for _, v in pairs(script.Parent:GetDescendants()) do
		if v:isA("Motor6D") then
			local Attachment0, Attachment1 = Instance.new("Attachment"),Instance.new("Attachment")
			Attachment0.CFrame = v.C0
			Attachment1.CFrame = v.C1
			Attachment0.Parent = v.Part0
			Attachment1.Parent = v.Part1

			local BallSocketConstraint = Instance.new("BallSocketConstraint")
			BallSocketConstraint.Attachment0 = Attachment0
			BallSocketConstraint.Attachment1 = Attachment1
			BallSocketConstraint.Parent = v.Parent

			v:Destroy()
		end
	end
	wait(3)
	script.Parent:Destroy()
end


--npc.Touched:Connect(touchNpc)
npc.Touched:Connect(function(hit)
	if cd == false then
		cd = true
		touchNpc(hit)
		wait(1)
		cd = false
	end
end)

npc.Died:Connect(diedNpc)