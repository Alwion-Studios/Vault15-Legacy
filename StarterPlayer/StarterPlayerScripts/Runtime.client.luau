--!nonstrict

--[[
     █████  ██      ██     ██ ██  ██████  ███    ██ 
    ██   ██ ██      ██     ██ ██ ██    ██ ████   ██ 
    ███████ ██      ██  █  ██ ██ ██    ██ ██ ██  ██ 
    ██   ██ ██      ██ ███ ██ ██ ██    ██ ██  ██ ██ 
    ██   ██ ███████  ███ ███  ██  ██████  ██   ████ 

                    ALWION STUDIOS  
                  ALL RIGHTS RESERVED
                        ©️ 2024
]]

--Imports
local RS = game:GetService("ReplicatedStorage")
local Controllers = RS.Controllers

-- Controllers
local render_controller = require(Controllers["Render.Controller"])
local lighting_controller = require(Controllers["Lighting.Controller"])
local notification_controller = require(Controllers["Notification.Controller"])
local rigAnimation_controller = require(Controllers["Animation.Controller"])

-- Initialise Controllers
render_controller:Initialise()
lighting_controller:Initialise()
notification_controller:Initialise()
rigAnimation_controller:Initialise()