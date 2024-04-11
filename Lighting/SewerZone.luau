local module = {
	["Atmosphere"] = {
		["Density"] = 0.5,
		["Offset"] = 0,
		["Color"] = Color3.fromRGB(43, 43, 43),
		["Decay"] = Color3.fromRGB(8, 8, 8),
		["Glare"] = 1,
		["Haze"] = 2
	},
	
	["Sky"] = {
		["SkyboxBk"] = "rbxassetid://600830446",
		["SkyboxDn"] = "rbxassetid://600831635",
		["SkyboxFt"] = "rbxassetid://600832720",
		["SkyboxLf"] = "rbxassetid://600886090",
		["SkyboxRt"] = "rbxassetid://600833862",
		["SkyboxUp"] = "rbxassetid://600835177",
	},
	
	["ColorCorrectionEffect"] = {
		["Brightness"] = -0.15,
		["Contrast"] = 0.05,
		["Saturation"] = -0.6,
		["TintColor"] = Color3.fromRGB(255, 255, 255)
	},
	
	["BloomEffect"] = {
		["Intensity"] = 1,
		["Size"] = 56,
		["Threshold"] = 1,
	},
}

return module
