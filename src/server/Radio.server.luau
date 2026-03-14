local remoteEvent = game.ReplicatedStorage:WaitForChild("StartStoryCutscene")
local prompt = script.Parent:WaitForChild("ProximityPrompt")

prompt.Triggered:Connect(function()
    remoteEvent:FireAllClients()
    prompt.Enabled = false
end)