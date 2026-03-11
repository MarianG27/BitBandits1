local TweenService = game:GetService("TweenService")

local doorModel = workspace.NumeleModeluluiUsii 
local targetPos = workspace.NumeleModeluluiUsii.ToGoPos.CFrame
local originPos = doorModel:GetPivot()

local info = TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local doorStatus = "Closed"
local isMoving = false

local function moveDoor(targetCFrame)
    isMoving = true
    
    local cframeValue = Instance.new("CFrameValue")
    cframeValue.Value = doorModel:GetPivot()

    -- Actualizăm poziția ușii la fiecare cadru al animației
    local connection = cframeValue:GetPropertyChangedSignal("Value"):Connect(function()
        doorModel:PivotTo(cframeValue.Value)
    end)

    local tween = TweenService:Create(cframeValue, info, {Value = targetCFrame})
    tween:Play()

    tween.Completed:Wait() -- Așteptăm să se termine fără loop-uri inutile
    
    connection:Disconnect() -- Curățăm memoria
    cframeValue:Destroy()
    isMoving = false
end

-- Eventul de Click
doorModel.MainDoor.ClickDetector.MouseClick:Connect(function()
    if isMoving then return end -- Prevenim bug-urile dacă se dă click rapid

    if doorStatus == "Closed" then
        doorModel.MainDoor.Open:Play()
        moveDoor(targetPos)
        doorStatus = "Opened"
    else
        doorModel.MainDoor.Close:Play()
        moveDoor(originPos)
        doorStatus = "Closed"
    end
end)
