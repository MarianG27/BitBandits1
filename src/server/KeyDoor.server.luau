active = true

function onTouched(hit)
	if active == true then
	if hit.Parent.Name == script.Parent.ToolRequired.Value then
		active = false
			script.Parent.Unlock:Play()
			script.Parent.Parent.Display.Anchored = false
			wait(1)
			script.Parent.Parent.BlockedDoor:Destroy()
			script.Parent.Parent.Hitbox:Destroy()
	end
end
end
script.Parent.Touched:connect(onTouched)

function onClicked(player)
	if active == true then
	if player.Backpack:FindFirstChild(script.Parent.ToolRequired.Value) then
		active = false
			script.Parent.Unlock:Play()
			script.Parent.Parent.Display.Anchored = false
			wait(1)
			script.Parent.Parent.BlockedDoor:Destroy()
			script.Parent.Parent.Hitbox:Destroy()
	end
end
end
script.Parent.ClickDetector.MouseClick:connect(onClicked)
