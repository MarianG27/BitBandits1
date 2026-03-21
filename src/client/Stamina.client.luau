--[ Variables ]--
local Outer = script.Parent
	local Inner = Outer:WaitForChild("Inner")
	--local Display = Outer:WaitForChild("Display")
	local Detector = Outer:WaitForChild("Detector")
	local N = Outer:WaitForChild("N")
	local IsSprinting = Outer:WaitForChild("IsSprinting")
	local CurrentStamina = Outer:WaitForChild("CurrentStamina")
--[ Functions ]--
local function UpdateStamina()
	if CurrentStamina.Value > 100 then
		CurrentStamina.Value = 100
		Inner:TweenSize(UDim2.new(CurrentStamina.Value/100, 0, 1, 0), "InOut", "Quad", 0.5)
		--Display.Text = CurrentStamina.Value.."/100"
	else
		Inner:TweenSize(UDim2.new(CurrentStamina.Value/100, 0, 1, 0), "InOut", "Quad", 0.5)
		--Display.Text = CurrentStamina.Value.."/100"
	end
	if CurrentStamina.Value == 100 then
		script.Parent.Parent.Stamina.BackgroundTransparency = 1
		script.Parent.Parent.Stamina.UIStroke.Transparency = 1
		script.Parent.Inner.BackgroundTransparency = 1
		script.Parent.Icon.BackgroundTransparency = 1
		script.Parent.Icon.IconPic.ImageTransparency = 1
		--Display.TextTransparency = 1
	else
		script.Parent.Parent.Stamina.BackgroundTransparency = 0.35
		script.Parent.Parent.Stamina.UIStroke.Transparency = 0		
		script.Parent.Inner.BackgroundTransparency = 0
		script.Parent.Icon.IconPic.ImageTransparency = 0
		--Display.TextTransparency = 0
	end
end
--[ Events ]--
spawn(UpdateStamina)
CurrentStamina.Changed:Connect(UpdateStamina)
Detector.MouseEnter:Connect(function()
	N:TweenPosition(UDim2.new(-0.775, 0, 0, 0), "Out", "Quad", .25)
end)
Detector.MouseLeave:Connect(function()
	N:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", .25)
end)
Detector.MouseMoved:Connect(function()
	if N.Position == UDim2.new(0,0,0,0) then
		N:TweenPosition(UDim2.new(-0.775, 0, 0, 0), "Out", "Quad", .25)
	else
		N:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", .25)
	end
end)
IsSprinting.Changed:Connect(function()
	if IsSprinting.Value == false then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
		--Display.TextTransparency = 1
	else
		--Display.TextTransparency = 0
	end
end)
while true do 
	if IsSprinting.Value == true then
		if CurrentStamina.Value < 5 then
			IsSprinting.Value = false
		else			
			CurrentStamina.Value = CurrentStamina.Value - 5
		end
	end
	if CurrentStamina.Value < 100 then
		CurrentStamina.Value = CurrentStamina.Value + 1.5
	end
	if CurrentStamina.Value == 100 then
		Inner:TweenSize(UDim2.new(1, 0, 1, 0), "InOut", "Quad", 0.5)
	end
	wait(.25)
end