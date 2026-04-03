-------------------------------------------
--| SYSTEM INTEGRATED - UV & SCANNER      |
-------------------------------------------

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- Setări Pietre (Scanner)
local currentStoneIndex = 1
local maxStones = 6
local timpAsteptare = 5
local originalCFrames = {} 
local stoneStates = {} 
local activeTimers = {}

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PowerGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local function createButton(text, position)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 140, 0, 60)
	btn.Position = position
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.TextScaled = true
	btn.BackgroundTransparency = 0.3
	btn.Parent = screenGui
	return btn
end

-------------------------------------------------

-- PLAYER1 → UV POWER

-------------------------------------------------

local uvEffect = Lighting:WaitForChild("UVEffect")

local uvActive = false



local function toggleUV()

	uvActive = not uvActive

	uvEffect.Enabled = uvActive



	for _, v in pairs(workspace:GetDescendants()) do

		if v:GetAttribute("IsUV") == true then

			if v:IsA("BasePart") then

				v.Transparency = 1

			end

			local gui = v:FindFirstChildOfClass("SurfaceGui")

			if gui then

				local label = gui:FindFirstChildOfClass("TextLabel")

				if label then

					label.TextTransparency = uvActive and 0 or 1

					label.Visible = true 

				end

			end

		end

	end

end	
-------------------------------------------------
--  LOGICĂ PLAYER 2 (SCANNER & STONES)
-------------------------------------------------
local scannerActive = false

local function applyScannerVisuals(state)
	for i = 1, maxStones do
		local s = workspace:FindFirstChild("Stones" .. i)
		if s then
			if s:FindFirstChild("ScannerHighlight") then s.ScannerHighlight:Destroy() end
			if s:FindFirstChild("ScannerArrow") then s.ScannerArrow:Destroy() end
		end
	end

	if state == true and currentStoneIndex <= maxStones then
		local stone = workspace:FindFirstChild("Stones" .. currentStoneIndex)
		if stone then
			local hl = Instance.new("Highlight", stone)
			hl.Name = "ScannerHighlight"
			hl.FillColor = Color3.fromRGB(0, 255, 0)
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

			local bg = Instance.new("BillboardGui", stone)
			bg.Name = "ScannerArrow"
			bg.Size = UDim2.new(0, 60, 0, 60)
			bg.AlwaysOnTop = true
			bg.StudsOffset = Vector3.new(0, 6, 0)

			local img = Instance.new("ImageLabel", bg)
			img.Size = UDim2.new(1, 0, 1, 0)
			img.Image = "rbxassetid://6034289542"
			img.ImageColor3 = Color3.fromRGB(0, 255, 0)
			img.BackgroundTransparency = 1
		end
	end
end

local function moveStone(stone, state)
	if not originalCFrames[stone.Name] then originalCFrames[stone.Name] = stone.CFrame end
	local targetCFrame = state and (originalCFrames[stone.Name] * CFrame.new(0, 12, 0)) or originalCFrames[stone.Name]
	local info = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	tweenService:Create(stone, info, {CFrame = targetCFrame}):Play()
end

local function toggleScanner()
	scannerActive = not scannerActive

	if scannerActive then
		-- Închide pietrele deschise când pornești scanerul
		for stoneName, state in pairs(stoneStates) do
			if state == true then
				local s = workspace:FindFirstChild(stoneName)
				if s then stoneStates[stoneName] = false; moveStone(s, false) end
			end
		end
		-- Efect brațe
		local h = Instance.new("Highlight", char)
		h.Name = "ScannerHandEffect"
		h.FillTransparency = 1
		h.OutlineColor = Color3.fromRGB(0, 255, 0)
	else
		local h = char:FindFirstChild("ScannerHandEffect")
		if h then h:Destroy() end
	end
	applyScannerVisuals(scannerActive)
end

-- Interacțiunea cu Mouse-ul pentru Pietre (Doar pentru Player 2)
UIS.InputBegan:Connect(function(input, processed)
	if processed or player.Team.Name ~= "Player2" then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local target = player:GetMouse().Target
		if target and target.Name:find("Stones") then
			local stoneNumber = tonumber(target.Name:match("%d+"))
			if stoneNumber and stoneNumber <= currentStoneIndex then
				activeTimers[target.Name] = tick()
				local currentClickID = activeTimers[target.Name]

				if not stoneStates[target.Name] then
					stoneStates[target.Name] = true
					moveStone(target, true)

					if stoneNumber == currentStoneIndex then
						currentStoneIndex = currentStoneIndex + 1
						scannerActive = false
						local h = char:FindFirstChild("ScannerHandEffect")
						if h then h:Destroy() end
						applyScannerVisuals(false)
						-- Update buton text dacă e vizibil
						local btn = screenGui:FindFirstChildOfClass("TextButton")
						if btn then btn.Text = "SCANNER" end
					end

					task.delay(timpAsteptare, function()
						if stoneStates[target.Name] == true and activeTimers[target.Name] == currentClickID then
							stoneStates[target.Name] = false
							moveStone(target, false)
						end
					end)
				else
					stoneStates[target.Name] = false
					moveStone(target, false)
				end
			end
		end
	end
end)

-------------------------------------------------
-- 🎮 TEAM SYSTEM & BUTOANE
-------------------------------------------------
local function setupButtons()
	screenGui:ClearAllChildren()
	if not player.Team then return end

	if player.Team.Name == "Player1" then
		local btn = createButton("UV POWER", UDim2.new(0.5, -70, 0.75, 0))
		btn.MouseButton1Click:Connect(function()
			toggleUV()
			btn.Text = uvActive and "UV ON" or "UV OFF"
		end)
	elseif player.Team.Name == "Player2" then
		local btn = createButton("SCANNER", UDim2.new(0.5, -70, 0.75, 0))
		btn.MouseButton1Click:Connect(function()
			toggleScanner()
			btn.Text = scannerActive and "SCAN ON" or "SCAN OFF"
		end)
	end
end

setupButtons()
player:GetPropertyChangedSignal("Team"):Connect(setupButtons)
player.CharacterAdded:Connect(function(newChar) char = newChar end)