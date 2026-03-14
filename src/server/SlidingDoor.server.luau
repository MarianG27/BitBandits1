 local debounce = false
local slide = script.Parent.Parent.Parent.Slide
local clickDetector = script.Parent.ClickDetector

clickDetector.MouseClick:Connect(function()
	if debounce then
		return
	end

	debounce = true

	-- Slide door open
	for i = 1, 15 do
		slide.CFrame = slide.CFrame + Vector3.new(-0.4, 0, 0)
		wait()
	end

	wait(3)

	-- Slide door close
	for i = 1, 15 do
		slide.CFrame = slide.CFrame + Vector3.new(0.4, 0, 0)
		wait()
	end

	debounce = false
end)