local module = {
	["Atmosphere"] = {
		["Density"] = 0.6,
		["Offset"] = 0.2,
		["Color"] = Color3.fromRGB(49, 49, 49),
		["Decay"] = Color3.fromRGB(22, 44, 43),
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
		["Brightness"] = 0.1,
		["Contrast"] = 0.321,
		["Saturation"] = 0.1,
		["TintColor"] = Color3.fromRGB(150, 146, 131)
	}
}

return module
