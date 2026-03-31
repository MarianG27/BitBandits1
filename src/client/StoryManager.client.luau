local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

local remoteEvent = ReplicatedStorage:WaitForChild("StartStoryCutscene")
local player = Players.LocalPlayer

remoteEvent.OnClientEvent:Connect(function()
	local char = player.Character
	if not char then return end

	-- 1. Înghețăm jucătorul pe loc ca să asculte cu atenție
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	if rootPart then 
		rootPart.Anchored = true 
	end

	-- 2. Pornim sunetul
	local sunet = SoundService:FindFirstChild("Poveste")
	if sunet then 
		sunet:Play() 

		-- 3. Așteptăm să se termine sunetul
		sunet.Ended:Wait(15) 
	else
		-- Dacă sunetul nu e găsit, așteptăm o durată fixă ca să nu rămână blocat forever
		task.wait(10)
	end

	-- 4. Îi dăm drumul jucătorului
	if rootPart then 
		rootPart.Anchored = false 
	end

	print("Povestea s-a terminat, jucătorul este liber.")
end)