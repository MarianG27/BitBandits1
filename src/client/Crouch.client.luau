local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local char = script.Parent
local humanoid = char:WaitForChild("Humanoid")

-- Încărcăm animațiile o singură dată
local animIdle = humanoid:LoadAnimation(script:WaitForChild("CrouchIdle"))
local animMoving = humanoid:LoadAnimation(script:WaitForChild("CrouchMoving"))

local crouching = false

uis.InputBegan:Connect(function(inp, processed)
	if processed then return end
	
	if inp.KeyCode == Enum.KeyCode.C then
		crouching = not crouching
		
		if crouching then
			humanoid.WalkSpeed = 10
			animIdle:Play()
		else
			humanoid.WalkSpeed = 16
			animIdle:Stop()
			animMoving:Stop()
		end
	end
end)

runService.Heartbeat:Connect(function()
	if crouching then
		-- Verificăm dacă ne mișcăm pentru a schimba animația
		if humanoid.MoveDirection.Magnitude > 0 then
			if not animMoving.IsPlaying then 
				animMoving:Play() 
				animIdle:Stop() -- Oprim Idle când mergem
			end
		else
			if animMoving.IsPlaying then 
				animMoving:Stop() 
				animIdle:Play() -- Pornim Idle când stăm
			end
		end
	end
end)