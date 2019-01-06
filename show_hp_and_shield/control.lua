-- Show health and shield
-- Copyright (c) 2018-2019 ZwerOxotnik <zweroxotnik@gmail.com>
-- License: MIT
-- Version: 2.0.0 (2019.01.06)
-- Description: shows a health/shield player and a shield vehicle in the game.
-- Source: https://gitlab.com/ZwerOxotnik/show-health-and-shield
-- Homepage: https://mods.factorio.com/mod/show-health-and-shield

local show_hp_and_shield = {}

ticks_for_vehicle = 60 * 60 * 1.5

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

show_hp_and_shield.init = function()
  global.vehicles_shield = global.vehicles_shield or {}
end

show_hp_and_shield.on_configuration_changed = function()
  show_hp_and_shield.init()
end

show_hp_and_shield.check = function()
  for _, player in pairs(game.connected_players) do
    if player.character ~= nil then 
      local character = player.character
      if character.health ~= nil then 
        local vehicle = character.vehicle
        if not vehicle then
          show_hp(character)
          show_shield(character)
        end
      end
    end
  end
  for index, vehicle in pairs(global.vehicles_shield) do
    if vehicle.entity.valid then
      show_shield_for_vehicles(vehicle)
    else
      global.vehicles_shield[index] = nil
    end
  end
end

show_hp_and_shield.on_player_driving_changed_state = function(event)
  local vehicle = event.entity
  if vehicle and vehicle.valid then
    if vehicle.grid then
      local index = tostring(vehicle.unit_number)
      if global.vehicles_shield[index] == nil then
        global.vehicles_shield[index] = {entity = vehicle, tick = event.tick}
      else
        global.vehicles_shield[index].tick = event.tick
      end
    end
  end
end

show_hp_and_shield.check_vehicles = function()
  for index, vehicle in pairs(global.vehicles_shield) do
    if vehicle.entity.valid then
      if vehicle.tick + ticks_for_vehicle < game.tick then
        local entity = vehicle.entity
        if vehicle.type == "car" then
          local passenger = entity.get_passenger()
          local driver = entity.get_driver()
          if passenger or driver then
            vehicle.tick = game.tick
          else
            entity.surface.create_entity{name = "flying-text", color = {r = 1, g = 1, b = 1, a = 1}, text = ".", position = entity.position}
            global.vehicles_shield[index] = nil
          end
        else
          local driver = entity.get_driver()
          if driver then
            vehicle.tick = game.tick
          else
            entity.surface.create_entity{name = "flying-text", color = {r = 1, g = 1, b = 1, a = 1}, text = ".", position = entity.position}
            global.vehicles_shield[index] = nil
          end
        end
      end
    else
      global.vehicles_shield[index] = nil
    end
  end
end

show_hp_and_shield.on_player_mined_entity = function(event)
  local entity = event.entity
  if entity.grid then
    global.vehicles_shield[tostring(entity.unit_number)] = nil
  end
end

show_hp_and_shield.on_selected_entity_changed = function(event)
  local player = game.players[event.player_index]
  local entity = player.selected
  if entity == nil then return end
  if entity.type == "player" then return end
  if not entity.grid then return end

  local index = tostring(entity.unit_number)
  if global.vehicles_shield[index] == nil then
    global.vehicles_shield[index] = {entity = entity, tick = event.tick}
  else
    global.vehicles_shield[index].tick = event.tick
  end
end

show_hp_and_shield.on_runtime_mod_setting_changed = function(event)
  if event.setting_type ~= "runtime-global" then return end

  if event.setting == "shas_hp_player_mode" then
    show_hp = variants[settings.global[event.setting].value].show_hp
  elseif event.setting == "shas_shield_player_mode" then
    show_shield = variants[settings.global[event.setting].value].show_shield
  elseif event.setting == "shas_vehicle_shield_mode" then
    show_shield_for_vehicles = variants[settings.global[event.setting].value].show_shield_for_vehicles
  end
end

return show_hp_and_shield
