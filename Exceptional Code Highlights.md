This document highlights the advanced technical implementations that ensure a stable and engaging cooperative experience.

1. Advanced Pathfinding & AI Behavior (The Beast)

To create a real sense of danger in the forest and the labyrinth, we developed a custom AI for "The Beast." This script ensures the monster intelligently tracks players while maintaining performance.

Pathfinding Logic: Uses PathfindingService to compute dynamic routes, allowing the monster to navigate complex environments like the labyrinth.

Networking Optimization: We used root:SetNetworkOwner(nil) to ensure the server handles the monster's physics. This prevents "teleporting" or laggy movement, providing a smooth experience for both players.

Asymmetric Interaction: The monster's scan logic specifically excludes certain targets based on tags, allowing us to integrate lore-based mechanics (like hiding under stones).

-- Fragment: Dynamic Pathfinding and Networking
if target and humanoid.Health > 0 and target.Health > 0 then
    root:SetNetworkOwner(nil) -- Crucial for multiplayer stability
    local targetRoot = target.Parent:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        local path = pathfind(root, targetRoot)
        if path.Status == Enum.PathStatus.Success then
            waypoints = path:GetWaypoints()
            -- Moves to the next waypoint to ensure smooth navigation
            humanoid:MoveTo(waypoints[2].Position)
        end
    end
end

2. Dynamic Ragdoll & Physics System
To enhance immersion and feedback (Sound & Visual Cohesion), the monster features a procedural ragdoll system upon "death" or certain interactions.

Implementation: Instead of simply disappearing, the script replaces Motor6D joints with BallSocketConstraints in real-time, creating a realistic physical reaction in the shared game world.

3. Cooperative Hiding Mechanics
The AI script is designed to work with our "Hide under stones" mechanic. By using a target scanning cooldown (targetScanCooldown), we allow players a window of opportunity to use their telekinetic powers and hide, breaking the monster's line of sight and pathfinding.

4. Telekinetic Interaction & Guide System
This mechanic allows Player 2 to lead the escape. It combines visual guidance with a high-stakes survival loop.

Visual Guidance: The Scanner highlights the next stone objective through walls, allowing the telekinetic player to guide their partner.

Auto-Close Tension: Using task.delay and tick() validation, stones stay lifted for only 5 seconds. This creates a "Move or Die" scenario that forces players to coordinate their movements perfectly.

Lua
-- Telekinetic Interaction & Auto-Close Logic
UIS.InputBegan:Connect(function(input, processed)
    -- Gate: Only Player 2 can interact with stones
    if processed or player.Team.Name ~= "Player2" then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local target = player:GetMouse().Target
        if target and target.Name:find("Stones") then
            activeTimers[target.Name] = tick() -- Unique ID to prevent race conditions
            local currentClickID = activeTimers[target.Name]

            if not stoneStates[target.Name] then
                stoneStates[target.Name] = true
                moveStone(target, true) -- Lifts the stone

                -- AUTO-CLOSE: Players must pass quickly!
                task.delay(5, function()
                    if stoneStates[target.Name] == true and activeTimers[target.Name] == currentClickID then
                        stoneStates[target.Name] = false
                        moveStone(target, false)
                    end
                end)
            end
        end
    end
end)