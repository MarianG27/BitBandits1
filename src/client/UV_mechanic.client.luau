local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local uvEffect = Lighting:WaitForChild("UVEffect")

local active = false

UIS.InputBegan:Connect(function(input, processed)
	if processed then return end

	if input.KeyCode == Enum.KeyCode.G then 
		active = not active
		uvEffect.Enabled = active

		for _, v in pairs(workspace:GetDescendants()) do
			if v:GetAttribute("IsUV") == true then
				-- Forțăm piesa să fie invizibilă
				if v:IsA("BasePart") then
					v.Transparency = 1
				end

				-- Căutăm SurfaceGui și TextLabel pentru a schimba transparența
				local gui = v:FindFirstChildOfClass("SurfaceGui")
				if gui then
					local label = gui:FindFirstChildOfClass("TextLabel")
					if label then
						label.TextTransparency = active and 0 or 1
						label.Visible = true
					end
				end
			end
		end
	end
end)