
local UIS = game:GetService("UserInputService")
local RunSpeed = 27
local Player = game.Players.LocalPlayer
local Stamina = script.Parent:WaitForChild("CurrentStamina")
local IsSprinting = script.Parent:WaitForChild("IsSprinting")

local Character = workspace:WaitForChild(Player.Name)
local Humanoid = Character:WaitForChild('Humanoid')

local RunAnimation = Instance.new('Animation')
RunAnimation.AnimationId = 'rbxassetid://6496403274'
RAnimation = Humanoid:LoadAnimation(RunAnimation)

local SoundFX = script.RunSound

UIS.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.LeftShift then
		if Stamina.Value > 5 then
			Player.Character.Humanoid.WalkSpeed = RunSpeed
			IsSprinting.Value = true
			RAnimation:Play()
			SoundFX:Play()
		end
	end
end)
UIS.InputEnded:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.LeftShift then
		IsSprinting.Value = false
		Player.Character.Humanoid.WalkSpeed = 16
		RAnimation:Stop()
		SoundFX:Stop()
	end
end)