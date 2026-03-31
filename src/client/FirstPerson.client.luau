repeat wait() until game:GetService("Players").LocalPlayer.Character ~= nil
local runService = game:GetService("RunService")
local input = game:GetService("UserInputService")
local players = game:GetService("Players")

CanToggleMouse = {allowed = true; activationkey = Enum.KeyCode.Q;} -- 🔥 Q ACUM
CanViewBody = true
Sensitivity = 0.2
Smoothness = 0.05
FieldOfView = 90

local cam = game.Workspace.CurrentCamera
local player = players.LocalPlayer
local m = player:GetMouse()
m.Icon = "http://www.roblox.com/asset/?id=569021388"

local character = player.Character or player.CharacterAdded:wait()
local humanoidpart = character:WaitForChild("HumanoidRootPart")
local head = character:WaitForChild("Head")

local CamPos, TargetCamPos = cam.CFrame.Position, cam.CFrame.Position
local AngleX, TargetAngleX = 0, 0
local AngleY, TargetAngleY = 0, 0

local running = true
local freemouse = false

function updatechar()
	for _, v in pairs(character:GetChildren()) do
		if CanViewBody then
			if v.Name == 'Head' then
				v.LocalTransparencyModifier = 1
				v.CanCollide = false
			end
		else
			if v:IsA('Part') or v:IsA('UnionOperation') or v:IsA('MeshPart') then
				v.LocalTransparencyModifier = 1
				v.CanCollide = false
			end
		end

		if v:IsA('Accessory') or v:IsA('Hat') then
			local handle = v:FindFirstChild('Handle')
			if handle then
				handle.LocalTransparencyModifier = 1
				handle.CanCollide = false
			end
		end
	end
end

input.InputChanged:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = Vector2.new(inputObject.Delta.x / Sensitivity, inputObject.Delta.y / Sensitivity) * Smoothness

		local X = TargetAngleX - delta.y
		TargetAngleX = math.clamp(X, -80, 80)
		TargetAngleY = (TargetAngleY - delta.x) % 360
	end
end)

input.InputBegan:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.Keyboard then
		if inputObject.KeyCode == CanToggleMouse.activationkey then
			freemouse = not freemouse
		end
	end
end)

runService.RenderStepped:Connect(function()
	if running then
		updatechar()

		CamPos = CamPos + (TargetCamPos - CamPos) * 0.28
		AngleX = AngleX + (TargetAngleX - AngleX) * 0.35

		local dist = TargetAngleY - AngleY
		dist = math.abs(dist) > 180 and dist - (dist / math.abs(dist)) * 360 or dist
		AngleY = (AngleY + dist * 0.35) % 360

		cam.CameraType = Enum.CameraType.Scriptable

		cam.CFrame =
			CFrame.new(head.Position)
			* CFrame.Angles(0, math.rad(AngleY), 0)
			* CFrame.Angles(math.rad(AngleX), 0, 0)
			* CFrame.new(0, 0.8, 0)

		humanoidpart.CFrame =
			CFrame.new(humanoidpart.Position)
			* CFrame.Angles(0, math.rad(AngleY), 0)

		character.Humanoid.AutoRotate = false
	else
		input.MouseBehavior = Enum.MouseBehavior.Default
		character.Humanoid.AutoRotate = true
	end

	if freemouse then
		input.MouseBehavior = Enum.MouseBehavior.Default
	else
		input.MouseBehavior = Enum.MouseBehavior.LockCenter
	end

	cam.FieldOfView = FieldOfView
end)local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local flashlight
local attachment

local function toggleFlashlight()
	if flashlight then
		flashlight:Destroy()
		attachment:Destroy()
		flashlight = nil
		attachment = nil
	else
		attachment = Instance.new("Attachment")
		attachment.Name = "FlashlightAttachment"
		attachment.Parent = camera

		flashlight = Instance.new("SpotLight")
		flashlight.Name = "Flashlight"
		flashlight.Parent = attachment
		flashlight.Range = 60
		flashlight.Angle = 45
		flashlight.Brightness = 5
		flashlight.Shadows = true
	end
end

UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.F then
		if script:FindFirstChild("FlashLightSound") then
			script.FlashLightSound:Play()
		end
		toggleFlashlight()
	end
end)

RunService.RenderStepped:Connect(function()
	if flashlight and attachment then
		attachment.WorldCFrame = camera.CFrame
	end
end)