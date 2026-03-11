local active = true
local usaObiect = workspace.UsaCuCheie 

function onTouched(hit)
    if active == true then
        if hit.Parent.Name == usaObiect.ToolRequired.Value then
            active = false
            usaObiect.Unlock:Play()
            usaObiect.Parent.Display.Anchored = false
            task.wait(1)
            usaObiect.Parent.BlockedDoor:Destroy()
            usaObiect.Parent.Hitbox:Destroy()
        end
    end
end
