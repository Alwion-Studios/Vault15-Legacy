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
local shop_controller = require(Controllers["Shop.Controller"])
local lighting_controller = require(Controllers["Lighting.Controller"])
local notification_controller = require(Controllers["Notification.Controller"])
local rigAnimation_controller = require(Controllers["Animation.Controller"])
local zone_controller = require(Controllers["Zones.Controller"])
local shopGui_controller = require(Controllers["ShopGui.Controller"])
local ui_controller = require(Controllers["UI.Controller"])
local playerGui_controller = require(Controllers["PlayerGui.Controller"])

-- Initialise Controllers
shopGui_controller:Initialise()
ui_controller:Initialise()
playerGui_controller:Initialise()
render_controller:Initialise()
lighting_controller:Initialise()
rigAnimation_controller:Initialise()
zone_controller:Initialise()
notification_controller:Initialise()
shop_controller:Initialise()