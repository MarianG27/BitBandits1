local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

-- Settings
local walkSpeed = 16
local sprintSpeed = 24
local defaultFOV = 70
local sprintFOV = 80
local maxEnergy = 100
local regenSpeed = 10
local walkRegenSpeed = 5
local depleteSpeed = 10
local currentStamina = maxEnergy

local isSprinting = false
local regenCooldown = 0
local cooldownDuration = 0.5
local canSprint = true
local minStaminaToSprint = 50

-- UI Setup
local energyBar = script.Parent.MainBar
local staminaFrame = energyBar:WaitForChild("Stamina")
local numberText = energyBar:WaitForChild("Numbers")

-- Mobile Button Setup
local sprintButton
if UserInputService.TouchEnabled then
	sprintButton = Instance.new("TextButton")
	sprintButton.Name = "SprintButton"
	sprintButton.Size = UDim2.new(0, 130, 0, 60)
	sprintButton.Position = UDim2.new(0.05, 0, 0.78, 0)
	sprintButton.AnchorPoint = Vector2.new(0, 0)
	sprintButton.Text = "Hold to Sprint"
	sprintButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	sprintButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	sprintButton.TextScaled = true
	sprintButton.BackgroundTransparency = 0.3
	sprintButton.BorderSizePixel = 2
	sprintButton.Parent = player:WaitForChild("PlayerGui"):FindFirstChild("ScreenGui")

	sprintButton.MouseButton1Down:Connect(function()
		startSprint()
	end)

	sprintButton.MouseButton1Up:Connect(function()
		stopSprint()
	end)
end

-- Functions
local function updateStaminaBar()
	staminaFrame.Size = UDim2.new(currentStamina / maxEnergy, 0, 1, 0)

	-- Bara color gradient
	if currentStamina <= maxEnergy * 0.25 then
		staminaFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- roșu sub 25%
	elseif currentStamina <= maxEnergy * 0.5 then
		staminaFrame.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- portocaliu sub 50%
	else
		staminaFrame.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- albastru normal
	end
end

local function updateFOV(targetFOV)
	camera.FieldOfView = camera.FieldOfView + (targetFOV - camera.FieldOfView) * 0.1
end

function startSprint()
	if not canSprint then return end
	if currentStamina > 0 and humanoid.MoveDirection.Magnitude > 0 then
		isSprinting = true
		regenCooldown = cooldownDuration
		humanoid.WalkSpeed = sprintSpeed
	end
end

function stopSprint()
	isSprinting = false
	humanoid.WalkSpeed = walkSpeed
end

-- MAIN LOOP
RunService.RenderStepped:Connect(function(deltaTime)
	-- blocare sprint la 0 stamina
	if currentStamina <= 0 then
		canSprint = false
		isSprinting = false
	end

	-- deblocare la 50 stamina
	if currentStamina >= minStaminaToSprint then
		canSprint = true
	end

	-- Sprint logic
	if isSprinting and currentStamina > 0 and humanoid.MoveDirection.Magnitude > 0 then
		currentStamina = math.max(currentStamina - depleteSpeed * deltaTime, 0)
		if currentStamina == 0 then
			stopSprint()
		end
		updateFOV(sprintFOV)
	else
		updateFOV(defaultFOV)
		if not isSprinting and regenCooldown <= 0 then
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				return
			end
			if humanoid.MoveDirection.Magnitude == 0 then
				currentStamina = math.min(currentStamina + regenSpeed * deltaTime, maxEnergy)
			else
				currentStamina = math.min(currentStamina + walkRegenSpeed * deltaTime, maxEnergy)
			end
		else
			regenCooldown = regenCooldown - deltaTime
		end
	end

	-- Mobile button feedback
	if sprintButton then
		if currentStamina < minStaminaToSprint then
			sprintButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
		else
			sprintButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		end
	end

	-- Update stamina bar & text
	updateStaminaBar()
	if currentStamina < minStaminaToSprint then
		numberText.TextColor3 = Color3.fromRGB(255, 0, 0) -- roșu când nu poți sprinta
	else
		numberText.TextColor3 = Color3.fromRGB(255, 255, 255) -- alb normal
	end
	numberText.Text = math.floor(currentStamina) .. "/" .. maxEnergy
end)

-- Sprint Binding for PC
ContextActionService:BindAction("Sprint", function(_, inputState)
	if inputState == Enum.UserInputState.Begin then
		startSprint()
	elseif inputState == Enum.UserInputState.End then
		stopSprint()
	end
end, true, Enum.KeyCode.LeftShift)