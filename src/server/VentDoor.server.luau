local TweenService = game:GetService("TweenService")
local Info = TweenInfo.new(.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local event = Instance.new("BindableEvent")
local Door = script.Parent.Door
local OrigPos = Door.Center.CFrame
local TGP = script.Parent.ToGoPos.CFrame
local DoorMain = Door.MainDoor
local TweenedCompleted = "N/A"
local DoorStatus = "Closed"
local Debounce = false

local function TweenModel(Model, CFrame)
    local CFrameValue = Instance.new("CFrameValue")
    CFrameValue.Value = Model:GetPrimaryPartCFrame()

    CFrameValue:GetPropertyChangedSignal("Value"):connect(function()
        Model:SetPrimaryPartCFrame(CFrameValue.Value)
    end)

    local Tween = TweenService:Create(CFrameValue, Info, {Value = CFrame})
    Tween:Play()

    Tween.Completed:connect(function()
        CFrameValue:Destroy()
		TweenedCompleted = "Yes"
    end)
	while TweenedCompleted == "N/A" do
		wait(0.1)
	end
	TweenedCompleted = "N/A"
end

--//Toggle event//--
script.Parent.Door.MainDoor.ClickDetector.MouseClick:Connect(function()
	if DoorStatus == "Closed" and Debounce == false then
		Debounce = true
		DoorMain.Open:Play()
		TweenModel(script.Parent.Door, TGP)
		DoorStatus = "Opened"
		Debounce = false
	elseif DoorStatus == "Opened" and Debounce == false then
		Debounce = true
		DoorMain.Close:Play()
		TweenModel(script.Parent.Door, OrigPos)
		DoorStatus = "Closed"
		Debounce = false
	end
	end)