--[[
Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
Author: ZwerOxotnik

You can write and receive any information on the links below.
Source: https://gitlab.com/ZwerOxotnik/show-health-and-shield
Mod portal: https://mods.factorio.com/mod/show-health-and-shield
Homepage: https://forums.factorio.com/viewtopic.php?f=190&t=64619

]]--

local module = {}
module.events = {}

local variants = require("show_me_pretty_UI/variants/list")

local SmeB_UI_vehicle_shield_mode = settings.global["SmeB_UI_vehicle_shield_mode"].value
local show_shield_for_vehicles = variants[SmeB_UI_vehicle_shield_mode].show_shield_for_vehicles
local SmeB_UI_player_hp_mode = settings.global["SmeB_UI_player_hp_mode"].value
local update_hp_UI = variants[SmeB_UI_player_hp_mode].update_hp_UI
local init_hp_UI_to_player = variants[SmeB_UI_player_hp_mode].init_hp_UI_to_player
local SmeB_UI_player_shield_mode = settings.global["SmeB_UI_player_shield_mode"].value
local init_shield_UI_to_players = variants[SmeB_UI_player_shield_mode].init_shield_UI_to_players
local update_shield = variants[SmeB_UI_player_shield_mode].update_shield

local function update_global_data()
	global.SmeB_UI = global.SmeB_UI or {}
	local SmeB_UI = global.SmeB_UI
	SmeB_UI.vehicles_shield = SmeB_UI.vehicles_shield or {}
	SmeB_UI.target_characters = SmeB_UI.target_characters or {}
	SmeB_UI.player_HP_UIs = SmeB_UI.player_HP_UIs or {}
	SmeB_UI.player_shield_UIs = SmeB_UI.player_shield_UIs or {}
	SmeB_UI.vehcile_shield_UIs = SmeB_UI.vehcile_shield_UIs or {}
end

local function remove_UIs(variable)
	for _, id in pairs(SmeB_UI[variable]) do
		rendering.destroy(id)
		SmeB_UI[variable][id] = nil
	end
end

local function update_UIs()
	local SmeB_UI = global.SmeB_UI
	for player_index, _ in pairs(SmeB_UI.target_characters) do
		local player = game.connected_players[player_index]
		local character = player.character
		if character then
			update_hp_UI(player, SmeB_UI.player_HP_UIs[player_index])
			-- update_shield(character)
		else
			SmeB_UI.target_characters[player_index] = nil
		end
	end

	-- for vehicle_index, vehicle in pairs(SmeB_UI.vehicles_shield) do
	-- 	if vehicle.entity.valid then
	-- 		for _, player in pairs(vehicle.entity.force.connected_players) do
	-- 			show_shield_for_vehicles(vehicle, player)
	-- 		end
	-- 	else
	-- 		SmeB_UI.vehicles_shield[vehicle_index] = nil
	-- 	end
	-- end
end

local function check_player(player)
	if not player.valid then return end

	local SmeB_UI = global.SmeB_UI
	local character = player.character
	if character and character.health ~= nil and not character.vehicle then
		SmeB_UI.target_characters[player.index] = true
		if not SmeB_UI.player_HP_UIs[player.index] then
			init_hp_UI_to_player(player)
		end
		if not SmeB_UI.player_shield_UIs[player.index] then
			-- init_shield_UI_to_player(player)
		end
	else
		SmeB_UI.target_characters[player.index] = nil
		local ID = SmeB_UI.player_HP_UIs[player.index]
		if ID then
			rendering.destroy(ID)
			SmeB_UI.player_HP_UIs[player.index] = nil
		end
		local ID = SmeB_UI.player_shield_UIs[player.index]
		if ID then
			rendering.destroy(ID)
			SmeB_UI.player_HP_UIs[player.index] = nil
		end
	end
end

local function check_players()
	for _, player in pairs(game.connected_players) do
		check_player(player)
	end
end

local function check_player_on_event(event)
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end

	check_player(player)
end

local function remove_character_data(event)
	SmeB_UI.target_characters[event.player_index] = nil
	remove_UIs("player_HP_UIs")
	remove_UIs("player_shield_UIs")
end

local function on_player_driving_changed_state(event)
	local vehicle = event.entity
	if not (vehicle and vehicle.valid and vehicle.grid) then return end
	local player = game.players[event.player_index]
	check_player(player)
	if player.force ~= vehicle.force then return end

	local data = global.SmeB_UI.vehicles_shield
	if data[vehicle.unit_number] == nil then
		data[vehicle.unit_number] = {entity = vehicle, tick = event.tick}
	else
		data[vehicle.unit_number].tick = event.tick
	end
end

module.check_vehicles = function()
	local data = global.SmeB_UI
	for index, vehicle in pairs(data.vehicles_shield) do
		if vehicle.entity.valid then
			if vehicle.tick + CONFIG.TICKS_FOR_VEHICLE < game.tick then
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
						data.vehicles_shield[index] = nil
					end
				end
			end
		else
			data.vehicles_shield[index] = nil
		end
	end
end

local function on_player_mined_entity(event)
	local entity = event.entity
	if not entity.grid then return end

	global.SmeB_UI.vehicles_shield[tostring(entity.unit_number)] = nil
end

local function on_selected_entity_changed(event)
	-- Validation of data
	local player = game.players[event.player_index]
	local entity = player.selected
	if not (entity and entity.grid) then return end
	if player.force ~= entity.force then return end
	if entity.type == "character" then return end

	local data = global.SmeB_UI
	if data.vehicles_shield[entity.unit_number] == nil then
		data.vehicles_shield[entity.unit_number] = {entity = entity, tick = event.tick} -- TODO: test it
	else
		data.vehicles_shield[entity.unit_number].tick = event.tick
	end
end

local function on_runtime_mod_setting_changed(event)
	if event.setting_type ~= "runtime-global" then return end

	if event.setting == "SmeB_UI_vehicle_shield_mode" then
		local value = settings.global[event.setting].value
		SmeB_UI_vehicle_shield_mode = value
		show_shield_for_vehicles = variants[value].show_shield_for_vehicles
		init_shield_UI_to_vehicles = variants[value].init_shield_UI_to_vehicles
		-- recreate_UIs
		init_shield_UI_to_vehicles()
	elseif event.setting == "SmeB_UI_player_hp_mode" then
		local value = settings.global[event.setting].value
		SmeB_UI_player_hp_mode = value
		update_hp_UI = variants[value].update_hp_UI
		init_hp_UI_to_players = variants[value].init_hp_UI_to_players
		-- recreate_UIs
		init_hp_UI_to_players()
	elseif event.setting == "SmeB_UI_player_shield_mode" then
		local value = settings.global[event.setting].value
		SmeB_UI_player_shield_mode = value
		update_shield = variants[value].update_shield
		init_shield_UI_to_players = variants[value].init_shield_UI_to_players
		-- recreate_UIs
		init_shield_UI_to_players()
	end
end

module.on_init = update_global_data
module.on_configuration_changed = update_global_data
module.events = {
	[defines.events.on_player_driving_changed_state] = on_player_driving_changed_state,
	[defines.events.on_selected_entity_changed] = on_selected_entity_changed,
	[defines.events.on_player_mined_entity] = on_player_mined_entity,
	-- [defines.events.on_player_changed_force] = on_player_changed_force,
	-- [defines.events.on_player_changed_surface] = on_player_changed_surface,
	[defines.events.on_player_removed] = remove_character_data,
	[defines.events.on_player_respawned] = check_player_on_event,
	[defines.events.on_player_died] = remove_character_data,
	[defines.events.on_pre_player_left_game] = remove_character_data,
	[defines.events.on_player_joined_game] = check_player_on_event,
	[defines.events.on_player_created] = check_player_on_event,
	[defines.events.on_player_toggled_map_editor] = check_player_on_event,
	-- [defines.events.on_player_toggled_alt_mode] = on_player_toggled_alt_mode,
	[defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed,
}
module.on_nth_tick = {
	[settings.startup["SmeB_update_UIs_on_nth_tick"].value] = update_UIs,
	[CONFIG.CHECK_VEHICLES_ON_Nth_TICK] = module.check_vehicles,
	[CONFIG.TICKS_FOR_CHEKING_OF_CHARACTERS] = module.check_players
}

return module
