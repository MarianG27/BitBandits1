zombie = script.Parent
humanoid = script.Parent:WaitForChild("Humanoid")
root = script.Parent:WaitForChild("HumanoidRootPart")
rig = humanoid.RigType.Value
pfs = game:GetService('PathfindingService')

module = require(zombie:WaitForChild("SETTINGS"))

idleSounds = {}
attackSounds = {}

attackAnimation = Instance.new('Animation',humanoid)
attackAnimation.AnimationId = module.attackAnimation
attackAnimation = humanoid:LoadAnimation(attackAnimation)

for i,s in pairs(module.idleSounds) do
	local sound = Instance.new('Sound',zombie.Head)
	sound.SoundId = "rbxassetid://"..s
	sound.Name = "Idle"..i
	sound.Volume = 1
	table.insert(idleSounds,sound)
end

for i,s in pairs(module.attackSounds) do
	local sound = Instance.new('Sound',zombie.Head)
	sound.SoundId = "rbxassetid://"..s
	sound.Name = "Attack"..i
	sound.Volume = 0.75
	table.insert(attackSounds,sound)
end

target = nil
reachedDestination = false
wpi = 1
waypoints = nil
randomWanderWait = math.random(module.wanderCooldown[1],module.wanderCooldown[2])
lastDamage = -math.huge
lastScan = -math.huge
lastSound = -math.huge
lastWander = -math.huge

if module.respawning then
	local clone = script.Parent:Clone()
	humanoid.HealthChanged:Connect(function()
		if humanoid.Health == 0 then
			task.wait(4)
			clone.Parent = workspace
			clone.Humanoid.Health = clone.Humanoid.MaxHealth
			clone:MakeJoints()
			task.wait(0.5)
			script.Parent:Remove()
		else end
	end)
end

function pathfind(from,to)
	local path = pfs:CreatePath({AgentRadius = 2, AgentHeight = 2, AgentCanJump = true, AgentJumpHeight = humanoid.JumpHeight, AgentWalkableFloorAngle = humanoid.MaxSlopeAngle})
	path:ComputeAsync(from.Position, to.Position)
	return path
end

function attack(targetRoot,range)
	lastDamage = time()
	attackAnimation:Play()
	targetRoot.Velocity = (targetRoot.Position - root.Position).Unit * module.knockback + Vector3.new(0,(module.knockback / 2),0)
	task.spawn(function()
		task.wait(attackAnimation.Length/2)
		if target and (targetRoot.Position - root.Position).Magnitude <= range then
			target:TakeDamage(module.damage)
		end
		attackSounds[math.random(1,#attackSounds)]:Play()
	end)
	task.spawn(function()
		task.wait(attackAnimation.Length)
		if time() - lastDamage >= 0.2 then
			attackAnimation:Stop()
		end
	end)
end

function wander()
	if time() - lastWander >= randomWanderWait and time() - lastDamage >= module.attackCooldown then
		lastWander = time()
		randomWanderWait = math.random(module.wanderCooldown[1],module.wanderCooldown[2])
		humanoid.WalkToPoint = root.Position + Vector3.new(math.random(-module.wanderDistance,module.wanderDistance),0,math.random(-module.wanderDistance,module.wanderDistance))
	end
end

if module.ragdoll then
	humanoid.BreakJointsOnDeath = false
	humanoid.Died:Connect(function()
		root.Velocity = root.CFrame.LookVector * -15
		root.CanCollide = false
		for _,j in pairs(script.Parent:GetDescendants()) do
			if j:IsA('Motor6D') then
				local socket = Instance.new("BallSocketConstraint")
				local a1 = Instance.new("Attachment")
				local a2 = Instance.new("Attachment")
				a1.Parent = j.Part0
				a2.Parent = j.Part1
				socket.Parent = j.Parent
				socket.Attachment0 = a1
				socket.Attachment1 = a2
				a1.CFrame = j.C0
				a2.CFrame = j.C1
				socket.LimitsEnabled = true
				socket.TwistLimitsEnabled = true
				j:Remove()
			end
		end
	end)
end

while task.wait() do
	humanoid.Sit = false
	if time() - lastSound >= module.idleSoundCooldown and time() - lastDamage >= module.attackCooldown then
		lastSound = time()
		idleSounds[math.random(1,#idleSounds)]:Play()
	end
	if time() - lastScan >= module.targetScanCooldown then
		lastScan = time()
		task.spawn(function()
			local closest = {nil,math.huge}
			for _,item in pairs(game.Workspace:GetDescendants()) do
				if item:IsA('Humanoid') and item ~= humanoid then
					if item.Health > 0 then
						local valid = true
						for _,tag in pairs(module.ignore) do
							if item.Parent:FindFirstChild(tag) then
								valid = false
							end
						end
						local distance = math.huge
						if valid then
							local itemRoot = item.Parent:FindFirstChild("HumanoidRootPart")
							if itemRoot then
								distance = (itemRoot.Position - root.Position).Magnitude
								if distance > module.range then
									valid = false
								end
								if distance > closest[2] then
									valid = false
								end
								local path = pathfind(root,itemRoot)
								if path.Status ~= Enum.PathStatus.Success then
									valid = false
								end
							else
								valid = false
							end
						end
						if valid then
							closest = {item,distance}
						end
					end
				end
			end
			target = closest[1]
			if not target then
				wander()
			end
		end)
	end
	if target and humanoid.Health > 0 and target.Health > 0 then
		root:SetNetworkOwner(nil)
		local targetRoot = target.Parent:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			local path = pathfind(root,targetRoot)
			if path.Status == Enum.PathStatus.Success then
				waypoints = path:GetWaypoints()
				if not reachedDestination then
					reachedDestination = humanoid.MoveToFinished:Connect(function(reached)
						if reached and wpi < #waypoints then
							wpi += 1
							humanoid:MoveTo(waypoints[wpi].Position)
						else
							reachedDestination:Disconnect()
						end
					end)
				end
				wpi = 2
				humanoid:MoveTo(waypoints[wpi].Position)
				if (targetRoot.Position - root.Position).Magnitude <= module.attackRange and time() - lastDamage >= module.attackCooldown then
					attack(targetRoot,module.attackRange)
				elseif humanoid.MoveDirection == Vector3.new(0,0,0) then
					if (targetRoot.Position - root.Position).Magnitude <= module.attackRange * 2 and time() - lastDamage >= module.attackCooldown then
						attack(targetRoot,module.attackRange * 2)
					end
				end
			end
		end
	end
end