sp = script.Parent
run = game:GetService("RunService")
run.RenderStepped:Connect(function()
	sp.Rotation = sp.Rotation + 1
end)