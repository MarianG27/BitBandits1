
--> VARIABLES
local Module = script.Parent
local Door = Module:WaitForChild("Door")
local Board = Module:WaitForChild("Board")
local Text = Board:WaitForChild("Informer"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel")
local Code = Module:WaitForChild("Code").Value
local EnteredText = script:WaitForChild("EnteredText")
local OtherButtons = Board:WaitForChild("Other")

--> FUNCTIONS
local function ButtonPress(Button)
	local Sound = script.Click:Clone()
	Sound.Parent = Button
	Sound:Play()
	Button.Size = Vector3.new(0.5, 0.5, .01)
	wait(.2)
	Button.Size = Vector3.new(0.5, 0.5, 0.1)
	Sound:Destroy()
end

local function Clear()
	Text.Text = ""
	EnteredText.Value = Text.Text
end

for i, v in pairs(Board:WaitForChild("Numbers"):getChildren()) do
	v.ClickDetector.MouseClick:Connect(function()
		ButtonPress(v)
		if string.len(Text.Text) < string.len(Code) then
			Text.Text = Text.Text..v.Name
			EnteredText.Value = Text.Text
		else
			Text.Text = v.Name
			EnteredText.Value = Text.Text
		end
	end)
end

OtherButtons.Enter.ClickDetector.MouseClick:Connect(function()
	ButtonPress(OtherButtons.Enter)
	if EnteredText.Value == Code then
		OtherButtons.Enter.Approved:Play()
		Clear()
		for count = 1, 10 do
			Door.Door.Transparency = Door.Door.Transparency + 0.1
			wait()
		end
		Door.Door.CanCollide = false
	else
		OtherButtons.Enter.Denied:Play()
		Clear()
	end
end)

OtherButtons.Clear.ClickDetector.MouseClick:Connect(function()
	ButtonPress(OtherButtons.Clear)
	Clear()
end)