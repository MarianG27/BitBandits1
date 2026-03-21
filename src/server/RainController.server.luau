local Part = script.Parent
local A = Part.Rain1
local B = Part.Rain2
local C = Part.Rain3
local D = Part.ParticleEmitter    D.Enabled = false 

local RainSpeed = 200 
local RainDrops = 12500 

---Speed Of Rain---

A.Speed = RainSpeed
B.Speed = RainSpeed
C.Speed = RainSpeed


----Number Of Raindrops----

A.Rate = RainDrops
B.Rate = RainDrops
C.Rate = RainDrops