local correctCode = "1702" -- Codul de pe peretele lui Player 1
local currentCodeValue = script.Parent.Parent.CurrentCode -- Calea către valoare
local usa = workspace.UsaPlayer2 -- Schimbă cu numele ușii tale

script.Parent.ClickDetector.MouseClick:Connect(function()
	if currentCodeValue.Value == correctCode then
		print("Cod Corect!")
		usa.CanCollide = false
		usa.Transparency = 0.8
		-- Opțional: un sunet de succes
	else
		print("Cod Gresit!")
		currentCodeValue.Value = "" -- Resetăm dacă a greșit
	end
end)
