local PathfindingService = game:GetService("PathfindingService")
local NPChum = script.Parent.NPC
local body = script.Parent:FindFirstChild("HumanoidRootPart") or script.Parent:FindFirstChild("UpperTorso")

local Monster = script.Parent

function FindPlayer(Position)
	local List = game.Workspace:GetChildren()
	local Torso = nil
	local Distance = 1000
	local HumanoidRootPart = nil
	local Humanoid = nil
	local Player = nil

	for i = 1, #List do
		Player = List[i]
		if (Player.ClassName == "Model") and (Player ~= script.Parent) then
			HumanoidRootPart = Player:FindFirstChild("HumanoidRootPart")
			Humanoid = Player:FindFirstChild("Humanoid")
			if (HumanoidRootPart ~= nil) and (Humanoid ~= nil) and (Humanoid.Health > 0) then
				if (HumanoidRootPart.Position - Position).Magnitude < Distance then
--					anim:Play()
					Torso = HumanoidRootPart
					Distance = (HumanoidRootPart.Position - Position).Magnitude
				else
--					anim:Stop()
				end
			else
--				anim:Stop()
			end
		else
--			anim:Stop()
		end
	end
	return Torso
end

while NPChum ~= nil do
	wait()
	local Target = FindPlayer(script.Parent.HumanoidRootPart.Position)
	if Target ~= nil then
		local path = PathfindingService:CreatePath()
	--	print(_Target)
		path:ComputeAsync(body.Position, Target.Position)
		
		local Waypoints = path:GetWaypoints()
		
		local PathW = 0
		
		for k, Waypoint in pairs(Waypoints) do
			if PathW <= 2 then
				NPChum:MoveTo(Waypoint.Position)
				PathW = PathW + 1
			end
		end
		--script.Parent.NPC:MoveTo(Target.Position, Target)
		script.Parent.NPC.WalkSpeed = 12
	else
		script.Parent.NPC.WalkSpeed = 0
	end
end