local NormalWalkSpeed = 16
local CrouchSpeed = 10

local NormalHipHeight = 2
local CrouchHipHeight = 0.6

local AnimID = "rbxassetid://122632465973527"

local cas = game:GetService("ContextActionService")
local CKey = Enum.KeyCode.C

local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local Humanoid = char:WaitForChild("Humanoid")

local CrouchAnim = Instance.new("Animation")
CrouchAnim.AnimationId = AnimID
local CAnim = Humanoid:LoadAnimation(CrouchAnim)

local UIS = game:GetService("UserInputService")

-- verifica daca exista tavan
local function CanStand()

	local head = char:WaitForChild("Head")

	local rayOrigin = head.Position
	local rayDirection = Vector3.new(0,3,0)

	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {char}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(rayOrigin, rayDirection, rayParams)

	if result then
		return false
	end

	return true
end

-- CROUCH
UIS.InputBegan:Connect(function(key, gameProcessed)

	if gameProcessed then return end

	if key.KeyCode == CKey then

		Humanoid.WalkSpeed = CrouchSpeed
		Humanoid.JumpPower = 0
		Humanoid.JumpHeight = 0

		Humanoid.HipHeight = CrouchHipHeight

		CAnim:Play()

	end

end)

-- UNCROUCH
UIS.InputEnded:Connect(function(key, gameProcessed)

	if gameProcessed then return end

	if key.KeyCode == CKey then

		if not CanStand() then
			return
		end

		Humanoid.WalkSpeed = NormalWalkSpeed
		Humanoid.JumpPower = 50
		Humanoid.JumpHeight = 7.2

		Humanoid.HipHeight = NormalHipHeight

		CAnim:Stop()

	end

end)

---------------------------------------------------
-- Mobile Button

local function handleContext(name, state)

	if state == Enum.UserInputState.Begin then

		Humanoid.WalkSpeed = CrouchSpeed
		Humanoid.HipHeight = CrouchHipHeight

		CAnim:Play()

	else

		if not CanStand() then
			return
		end

		Humanoid.WalkSpeed = NormalWalkSpeed
		Humanoid.HipHeight = NormalHipHeight

		CAnim:Stop()

	end

end

cas:BindAction("Crouch", handleContext, true, CKey)

cas:SetPosition("Crouch", UDim2.new(.2,0,.5,0))
cas:SetTitle("Crouch","Crouch")

cas:GetButton("Crouch").Size = UDim2.new(.3,0,.3,0)