local light = game.Lighting
local terra = workspace.Terrain

script.Atmosphere:Clone().Parent = light
script.Sky:Clone().Parent = light
script.Blur:Clone().Parent = light
script.DepthOfField:Clone().Parent = light
script.SunRays:Clone().Parent = light
script.Clouds:Clone().Parent = terra
light.Brightness = 4
terra.WaterReflectance = 1
terra.WaterTransparency = 1
light.ShadowSoftness = 0
light.EnvironmentDiffuseScale = .202
light.EnvironmentSpecularScale = .202
light.Ambient = Color3.fromRGB(64, 72, 79)
light.OutdoorAmbient = Color3.fromRGB(64, 72, 79)
light.GlobalShadows = true