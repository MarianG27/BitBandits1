player = game.Players.LocalPlayer
tool = script.Parent

repeat wait() until player

tool.Equipped:connect(function(mouse)
	mouse.Button1Down:connect(function()
		tool.Handle.SpotLight.Enabled = not tool.Handle.SpotLight.Enabled
		tool.Handle.Sound:Play()
	end)
end)