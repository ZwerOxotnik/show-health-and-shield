--[[
Copyright (C) 2018-2019 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
Author: ZwerOxotnik
Version: 2.4.2 (2019.03.09)
Description: shows a health/shield player and a shield vehicle in the game.
             Shows after leaving a vehicle temporarily its shield.
             When you cursor hover over a transport will show its shield.
             Several types of individual display.

You can write and receive any information on the links below.
Source: https://gitlab.com/ZwerOxotnik/show-health-and-shield
Mod portal: https://mods.factorio.com/mod/show-health-and-shield
Homepage: https://forums.factorio.com/viewtopic.php?f=190&t=64619

]]--

local TICKS_FOR_VEHICLE = require("show_hp_and_shield.config").TICKS_FOR_VEHICLE * 3
local module = {}
module.version = "2.4.2"

local variants = {}
variants.bar = require("show_hp_and_shield/variants/bar")
variants.amount = require("show_hp_and_shield/variants/amount")
variants.percentage = require("show_hp_and_shield/variants/percentage")
variants.symbol = require("show_hp_and_shield/variants/symbol")
variants.help_me = require("show_hp_and_shield/variants/help_me")
variants.nothing = require("show_hp_and_shield/variants/nothing")
variants.arc = require("show_hp_and_shield/variants/arc")
variants.test_bar = require("show_hp_and_shield/variants/test_bar")

local function on_init()
  global.show_health_and_shield = global.show_health_and_shield or {}
	global.show_health_and_shield.vehicles_shield = global.show_health_and_shield.vehicles_shield or {}
end

local function on_tick()
  for _, player in pairs(game.connected_players) do
    local character = player.character
    if character and character.health ~= nil and not character.vehicle then
      variants[settings.get_player_settings(player)["shas_hp_player_mode"].value].show_hp(character, player)
      for _, target in pairs(player.force.connected_players) do
        variants[settings.get_player_settings(target)["shas_shield_player_mode"].value].show_shield(character, target)
      end
    end
  end

  for index, vehicle in pairs(global.show_health_and_shield.vehicles_shield) do
    if vehicle.entity.valid then
      for _, target in pairs(vehicle.entity.force.connected_players) do
        variants[settings.get_player_settings(target)["shas_vehicle_shield_mode"].value].show_shield_for_vehicles(vehicle, target)
      end
    else
      global.show_health_and_shield.vehicles_shield[index] = nil
    end
  end
end

local function on_player_driving_changed_state(event)
  local vehicle = event.entity
  if not (vehicle and vehicle.valid and vehicle.grid) then return end
  local player = game.players[event.player_index]
  if player.force ~= vehicle.force then return end

  local data = global.show_health_and_shield
  if data.vehicles_shield[vehicle.unit_number] == nil then
    data.vehicles_shield[vehicle.unit_number] = {entity = vehicle, tick = event.tick}
  else
    data.vehicles_shield[vehicle.unit_number].tick = event.tick
  end
end

module.check_vehicles = function()
	local data = global.show_health_and_shield
  for index, vehicle in pairs(data.vehicles_shield) do
    if vehicle.entity.valid then
      if vehicle.tick + TICKS_FOR_VEHICLE < game.tick then
        local entity = vehicle.entity
        if vehicle.type == "car" then
          local passenger = entity.get_passenger()
          local driver = entity.get_driver()
          if passenger or driver then
            vehicle.tick = game.tick
          else
            rendering.draw_text{
              text = ".",
              surface = entity.surface,
              target = entity,
              color = {r = 1, g = 1, b = 1, a = 1},
              time_to_live = 20,
              forces = {entity.force},
              visible = true,
              alignment = "center",
              scale_with_zoom = true
            }
            data.vehicles_shield[index] = nil
          end
        else
          local driver = entity.get_driver()
          if driver then
            vehicle.tick = game.tick
          else
            rendering.draw_text{
              text = ".",
              surface = entity.surface,
              target = entity,
              color = {r = 1, g = 1, b = 1, a = 1},
              time_to_live = 20,
              forces = {entity.force},
              alignment = "center",
              scale_with_zoom = true
            }
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
  if not entity.grid then return end
  global.show_health_and_shield.vehicles_shield[tostring(entity.unit_number)] = nil
end

local function on_selected_entity_changed(event)
  -- Validation of data
  local player = game.players[event.player_index]
  local entity = player.selected
  if entity == nil then return end
  if entity.type == "player" then return end
  if not entity.grid then return end
  if player.force ~= entity.force then return end

	local data = global.show_health_and_shield
  if data.vehicles_shield[entity.unit_number] == nil then
		data.vehicles_shield[entity.unit_number] = {entity = entity, tick = event.tick}
  else
    data.vehicles_shield[entity.unit_number].tick = event.tick
  end
end

module.events = {
  on_tick = on_tick,
  on_player_driving_changed_state = on_player_driving_changed_state,
	on_init = on_init,
  on_configuration_changed = on_init,
  on_selected_entity_changed = on_selected_entity_changed,
  on_player_mined_entity = on_player_mined_entity
}

return module
