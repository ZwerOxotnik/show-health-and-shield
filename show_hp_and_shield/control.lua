--[[
Show health and shield
Copyright (c) 2018-2019 ZwerOxotnik <zweroxotnik@gmail.com>
License: The MIT License (MIT)
Author: ZwerOxotnik
Version: 2.1.0 (2019.03.01)
Description: shows a health/shield player and a shield vehicle in the game.
             Shows after leaving a vehicle temporarily its shield.
             When you cursor hover over a transport will show its shield.
             Several types of display.
Source: https://gitlab.com/ZwerOxotnik/show-health-and-shield
Mod portal: https://mods.factorio.com/mod/show-health-and-shield
Homepage: https://forums.factorio.com/viewtopic.php?f=190&t=64619
]]--

local TICKS_FOR_VEHICLE = require("show_hp_and_shield.config").TICKS_FOR_VEHICLE * 3
local module = {}
module.version = "2.1.0"

local variants = {}
variants.bar = require("show_hp_and_shield/variants/bar")
variants.amount = require("show_hp_and_shield/variants/amount")
variants.percentage = require("show_hp_and_shield/variants/percentage")
variants.symbol = require("show_hp_and_shield/variants/symbol")
variants.help_me = require("show_hp_and_shield/variants/help_me")
variants.nothing = require("show_hp_and_shield/variants/nothing")

local show_hp = variants[settings.global["shas_hp_player_mode"].value].show_hp
local show_shield = variants[settings.global["shas_shield_player_mode"].value].show_shield
local show_shield_for_vehicles = variants[settings.global["shas_vehicle_shield_mode"].value].show_shield_for_vehicles

local function on_init()
  global.show_health_and_shield = global.show_health_and_shield or {}
	global.show_health_and_shield.vehicles_shield = global.show_health_and_shield.vehicles_shield or {}
end


local function on_tick()
  for _, player in pairs(game.connected_players) do
    if player.character ~= nil then
      local character = player.character
      if character.health ~= nil then
        if not character.vehicle then
          show_hp(character)
          show_shield(character)
        end
      end
    end
  end

  for index, vehicle in pairs(global.show_health_and_shield.vehicles_shield) do
    if vehicle.entity.valid then
      show_shield_for_vehicles(vehicle)
    else
      global.show_health_and_shield.vehicles_shield[index] = nil
    end
  end
end

local function on_player_driving_changed_state(event)
  local vehicle = event.entity
  if vehicle and vehicle.valid then
    if vehicle.grid then
			local index = tostring(vehicle.unit_number)
			local show_health_and_shield = global.show_health_and_shield
      if show_health_and_shield.vehicles_shield[index] == nil then
        show_health_and_shield.vehicles_shield[index] = {entity = vehicle, tick = event.tick}
      else
        show_health_and_shield.vehicles_shield[index].tick = event.tick
      end
    end
  end
end

module.check_vehicles = function()
	local show_health_and_shield = global.show_health_and_shield
  for index, vehicle in pairs(show_health_and_shield.vehicles_shield) do
    if vehicle.entity.valid then
      if vehicle.tick + TICKS_FOR_VEHICLE < game.tick then
        local entity = vehicle.entity
        if vehicle.type == "car" then
          local passenger = entity.get_passenger()
          local driver = entity.get_driver()
          if passenger or driver then
            vehicle.tick = game.tick
          else
            entity.surface.create_entity{name = "flying-text", color = {r = 1, g = 1, b = 1, a = 1}, text = ".", position = entity.position}
            show_health_and_shield.vehicles_shield[index] = nil
          end
        else
          local driver = entity.get_driver()
          if driver then
            vehicle.tick = game.tick
          else
            entity.surface.create_entity{name = "flying-text", color = {r = 1, g = 1, b = 1, a = 1}, text = ".", position = entity.position}
            show_health_and_shield.vehicles_shield[index] = nil
          end
        end
      end
    else
      show_health_and_shield.vehicles_shield[index] = nil
    end
  end
end

local function on_player_mined_entity(event)
  local entity = event.entity
  if entity.grid then
    global.show_health_and_shield.vehicles_shield[tostring(entity.unit_number)] = nil
  end
end

local function on_selected_entity_changed(event)
  local entity = game.players[event.player_index].selected
  if entity == nil then return end
  if entity.type == "player" then return end
  if not entity.grid then return end

	local index = tostring(entity.unit_number)
	local show_health_and_shield = global.show_health_and_shield
  if show_health_and_shield.vehicles_shield[index] == nil then
		show_health_and_shield.vehicles_shield[index] = {entity = entity, tick = event.tick}
  else
    show_health_and_shield.vehicles_shield[index].tick = event.tick
  end
end

local function on_runtime_mod_setting_changed(event)
  if event.setting_type ~= "runtime-global" then return end

  if event.setting == "shas_hp_player_mode" then
    show_hp = variants[settings.global[event.setting].value].show_hp
  elseif event.setting == "shas_shield_player_mode" then
    show_shield = variants[settings.global[event.setting].value].show_shield
  elseif event.setting == "shas_vehicle_shield_mode" then
    show_shield_for_vehicles = variants[settings.global[event.setting].value].show_shield_for_vehicles
  end
end

module.events = {
  on_tick = on_tick,
  on_player_driving_changed_state = on_player_driving_changed_state,
	on_init = on_init,
  on_configuration_changed = on_init,
  on_runtime_mod_setting_changed = on_runtime_mod_setting_changed,
  on_selected_entity_changed = on_selected_entity_changed,
  on_player_mined_entity = on_player_mined_entity
}

return module
