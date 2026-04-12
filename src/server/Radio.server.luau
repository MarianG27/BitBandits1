local prompt = script.Parent
local remoteEvent = game.ReplicatedStorage:WaitForChild("RadioSound")

local radioSound = Instance.new("Sound")
radioSound.Name = "RadioAudio"
radioSound.SoundId = "rbxassetid://85096164955383"
radioSound.Parent = script.Parent.Parent 
radioSound.RollOffMaxDistance = 50 

prompt.Triggered:Connect(function()
	radioSound:Play()

	remoteEvent:FireAllClients()
end)
