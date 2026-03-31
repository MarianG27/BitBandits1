local Players = game:GetService("Players")

-- 1. PUNEM NUMELE EXACT AL RIG-ULUI DE DINCOLO
local numeRig = "sitting" -- SCHIMBĂ AICI DACĂ ARE ALT NUME ÎN EXPLORER

-- 2. ID-UL TĂU
local idAnimatie = "rbxassetid://118394618872950"

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(2) -- Așteptăm puțin să se încarce tot skin-ul tău

		local rig = workspace:FindFirstChild(numeRig)
		if rig then
			local humanoidRig = rig:FindFirstChildOfClass("Humanoid")
			local animator = humanoidRig:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoidRig)

			print("Am găsit Rig-ul, încerc să pun skin-ul lui " .. player.Name)

			-- METODA FORȚATĂ: Îi dăm Rig-ului hainele tale direct
			local desc = Players:GetHumanoidDescriptionFromUserId(player.UserId)
			local success, err = pcall(function()
				humanoidRig:ApplyDescription(desc)
			end)

			if not success then 
				warn("Eroare la skin: " .. err) 
			end

			-- PORNIRE ANIMAȚIE
			local animObj = Instance.new("Animation")
			animObj.AnimationId = idAnimatie

			local track = animator:LoadAnimation(animObj)
			track.Looped = true
			track.Priority = Enum.AnimationPriority.Action -- Îi dăm prioritate maximă
			track:Play()

			print("Animația ar trebui să meargă acum!")
		else
			warn("NU AM GĂSIT RIG-UL ÎN WORKSPACE! Verifică numele!")
		end
	end)
end)
