local npc = workspace.Noob
local humanoid = npc:WaitForChild("Humanoid")
local root = npc:WaitForChild("HumanoidRootPart")

local WalkSpeed = 10
local RunSpeed = 20

local SightDistance = 50
local StopDistance = 0.5
local AttackDistance = 2
local AttackDamage = 51
local AttackCooldown = 1

local lastAttack = 0
local memoryTime = 2
local lostSightTimer = 0
local lastSeenPlayer = nil

humanoid.AutoRotate = true
humanoid.WalkSpeed = WalkSpeed

local lastPosition = root.Position
local stuckTimer = 0
local stuckThreshold = 0.1

local patrolDirection = Vector3.new(math.random()-0.5,0,math.random()-0.5).Unit
local patrolTimer = 0

while humanoid.Health > 0 do
	wait(0.05)

	local closestPlayer = nil
	local closestDistance = SightDistance

	for _, player in ipairs(game.Players:GetPlayers()) do
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then

			local hrp = char.HumanoidRootPart
			local distance = (root.Position - hrp.Position).Magnitude

			local direction = (hrp.Position - root.Position).Unit

			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = {npc}
			rayParams.FilterType = Enum.RaycastFilterType.Blacklist

			local rayResult = workspace:Raycast(root.Position, direction * distance, rayParams)

			local canSee = rayResult and rayResult.Instance:IsDescendantOf(char)

			if distance <= SightDistance and canSee and distance < closestDistance then
				closestDistance = distance
				closestPlayer = char
			end
		end
	end

	if closestPlayer then
		lastSeenPlayer = closestPlayer
		lostSightTimer = memoryTime
	elseif lastSeenPlayer then
		lostSightTimer = lostSightTimer - 0.05
		if lostSightTimer <= 0 then
			lastSeenPlayer = nil
			patrolDirection = Vector3.new(math.random()-0.5,0,math.random()-0.5).Unit
			patrolTimer = 0
		end
	end

	local target = lastSeenPlayer

	if target then

		local hrp = target.HumanoidRootPart
		local humanoidTarget = target:FindFirstChild("Humanoid")

		local distance = (hrp.Position - root.Position).Magnitude
		local moveDir = (hrp.Position - root.Position).Unit
		local moveVector = Vector3.new(moveDir.X,0,moveDir.Z)

		humanoid.WalkSpeed = RunSpeed

		if (root.Position - lastPosition).Magnitude < stuckThreshold then
			stuckTimer = stuckTimer + 0.05
		else
			stuckTimer = 0
		end

		lastPosition = root.Position

		if distance > StopDistance then

			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = {npc}
			rayParams.FilterType = Enum.RaycastFilterType.Blacklist

			local frontRay = workspace:Raycast(root.Position, moveVector * 3, rayParams)

			local rightDir = (moveVector + root.CFrame.RightVector).Unit
			local leftDir = (moveVector - root.CFrame.RightVector).Unit

			local rightRay = workspace:Raycast(root.Position, rightDir * 3, rayParams)
			local leftRay = workspace:Raycast(root.Position, leftDir * 3, rayParams)

			if (frontRay and frontRay.Instance.CanCollide) or stuckTimer > 0.2 then

				if not rightRay or not rightRay.Instance.CanCollide then
					moveVector = rightDir
				elseif not leftRay or not leftRay.Instance.CanCollide then
					moveVector = leftDir
				else
					moveVector = -moveVector
				end
			end

			humanoid:Move(moveVector)

		else
			humanoid.WalkSpeed = 0
		end

		if distance <= AttackDistance and tick() - lastAttack >= AttackCooldown then
			if humanoidTarget then
				humanoidTarget:TakeDamage(AttackDamage)
			end
			lastAttack = tick()
		end

	else

		humanoid.WalkSpeed = WalkSpeed

		patrolTimer = patrolTimer - 0.05

		if patrolTimer <= 0 then
			patrolDirection = Vector3.new(math.random()-0.5,0,math.random()-0.5).Unit
			patrolTimer = 2
		end

		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {npc}
		rayParams.FilterType = Enum.RaycastFilterType.Blacklist

		local frontRay = workspace:Raycast(root.Position, patrolDirection * 3, rayParams)

		if frontRay and frontRay.Instance.CanCollide then
			patrolDirection = Vector3.new(math.random()-0.5,0,math.random()-0.5).Unit
		end

		humanoid:Move(patrolDirection)

	end
end