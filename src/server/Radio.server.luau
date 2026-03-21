local prompt = script.Parent
local remoteEvent = game.ReplicatedStorage:WaitForChild("StartStoryCutscene")

prompt.Triggered:Connect(function()
	remoteEvent:FireAllClients()
end)
