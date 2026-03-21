script.Parent.HumanoidRootPart.Touched:Connect(function(hit)
	if hit and hit.Parent then
		local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
		if plr then
			local jumpscare = script.BaldiGui:Clone()
			jumpscare.Parent = plr.PlayerGui
		end
	end
end)
