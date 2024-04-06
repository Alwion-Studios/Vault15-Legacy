local module = {
	["Atmosphere"] = {
		["Density"] = 0,
		["Offset"] = 0,
		["Color"] = Color3.fromRGB(124, 123, 123),
		["Decay"] = Color3.fromRGB(45, 92, 90),
		["Glare"] = 0,
		["Haze"] = 2.12
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
		["Brightness"] = 0.2,
		["Contrast"] = 0.5,
		["Saturation"] = 0,
		["TintColor"] = Color3.fromRGB(211, 213, 195)
	},
	
	["BloomEffect"] = {
		["Intensity"] = 1,
		["Size"] = 32,
		["Threshold"] = 2.2,
	},
}

return module
