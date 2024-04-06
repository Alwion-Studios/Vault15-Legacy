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
		["Brightness"] = -0.1,
		["Contrast"] = 0.1,
		["Saturation"] = 0.3,
		["TintColor"] = Color3.fromRGB(188, 255, 152)
	},

	["BloomEffect"] = {
		["Intensity"] = 1,
		["Size"] = 24,
		["Threshold"] = 1,
	},
}

return module
