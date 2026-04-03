while true do

	script.Parent.PointLight.Enabled = true
	wait(math.random(1,2)) -- suggested because of the flickering light speed
	script.Parent.PointLight.Enabled = false
	wait(math.random(1,2))

end