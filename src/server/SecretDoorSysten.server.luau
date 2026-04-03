debounce = false

script.Parent.ClickDetector.MouseClick:connect(function()
	if debounce  == true then return end
debounce = true
 for i = 1,3 do
    script.Parent.CFrame = script.Parent.CFrame + Vector3.new(0,0,0.2)
     wait()
end
wait(2)
for i = 1,3 do
    script.Parent.CFrame = script.Parent.CFrame + Vector3.new(0,0,-0.2)
     wait()
end
   for i = 1,15 do
     script.Parent.Parent.Parent.Slide.CFrame =   script.Parent.Parent.Parent.Slide.CFrame + Vector3.new(-.4,0,0)
     wait()
	end
wait(4)
for i = 1,15 do
         script.Parent.Parent.Parent.Slide.CFrame =    script.Parent.Parent.Parent.Slide.CFrame + Vector3.new(.4,0,0)
   wait()
end
debounce = false	
end)