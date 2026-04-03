local player = game.Players.LocalPlayer
local event = game.ReplicatedStorage:WaitForChild("DeschideNota")

local gui = script.Parent
local frame = gui:WaitForChild("Frame")
local titleLabel = frame:WaitForChild("TitleLabel")
local contentLabel = frame:WaitForChild("ContentLabel")
local closeBtn = frame:WaitForChild("CloseButton")

event.OnClientEvent:Connect(function(title, content)
	titleLabel.Text = title
	contentLabel.Text = content
	frame.Visible = true

	-- freeze player
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = 0
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	-- unfreeze player
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = 16
	end
end)