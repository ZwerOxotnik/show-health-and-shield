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

UI_util = require("show_me_pretty_UI/UI_util")
local UI_variants = require("show_me_pretty_UI/variants/list")

local player_hp_mode = settings.global["SmeB_UI_player_hp_mode"].value
local update_player_hp_UI = UI_variants[player_hp_mode].update_player_hp_UI
local player_shield_mode = settings.global["SmeB_UI_player_shield_mode"].value
local update_player_shield_UI = UI_variants[player_shield_mode].update_player_shield_UI
local vehicle_shield_mode = settings.global["SmeB_UI_vehicle_shield_mode"].value
local update_vehicle_shield_UI = UI_variants[vehicle_shield_mode].update_vehicle_shield_UI
local player_mana_mode = (settings.global["SmeB_UI_player_mana_mode"] and settings.global["SmeB_UI_player_mana_mode"].value) or "nothing"
local update_player_mana_UI = UI_variants[player_mana_mode].update_player_mana_UI
local player_spirit_mode = (settings.global["SmeB_UI_player_spirit_mode"] and settings.global["SmeB_UI_player_spirit_mode"].value) or "nothing"
local update_player_spirit_UI = UI_variants[player_spirit_mode].update_player_spirit_UI
show_SmeB_UIs_only_in_alt_mode = settings.global["show_SmeB_UIs_only_in_alt_mode"].value
is_SmeB_UI_public = settings.global["is_SmeB_UI_public"].value
is_SmeB_magic_UI_public = settings.global["is_SmeB_magic_UI_public"].value

local function check_spell_pack_mod()
	local interface_name = "spell-pack"

	if not (remote.interfaces[interface_name] and remote.interfaces[interface_name]["getstats"]) then
		return
	else
		-- WIP
		remote.call("spell-pack", "togglebars", "show-health-and-shield", false)
	end
end

local function update_global_data()
	global.SmeB_UI = global.SmeB_UI or {}
	SmeB_UI = global.SmeB_UI
	SmeB_UI.vehicles_shield = SmeB_UI.vehicles_shield or {}
	SmeB_UI.target_characters = SmeB_UI.target_characters or {}
	SmeB_UI.player_HP_UIs = SmeB_UI.player_HP_UIs or {}
	SmeB_UI.player_shield_UIs = SmeB_UI.player_shield_UIs or {}
	SmeB_UI.vehcile_shield_UIs = SmeB_UI.vehcile_shield_UIs or {}
	SmeB_UI.player_mana_UIs = SmeB_UI.player_mana_UIs or {}
	SmeB_UI.player_spirit_UIs = SmeB_UI.player_spirit_UIs or {}
	check_spell_pack_mod()
end

local function destroy_player_HP_UIs(player_index)
	local IDs = SmeB_UI.player_HP_UIs[player_index]
	if IDs then
		if type(IDs) == "table" then
			for _, id in pairs(IDs) do
                rendering.destroy(id)
            end
		else
			rendering.destroy(IDs)
		end
		SmeB_UI.player_HP_UIs[player_index] = nil
	end
end

local function destroy_player_shield_UIs(player_index)
	local IDs = SmeB_UI.player_shield_UIs[player_index]
	if IDs then
		if type(IDs) == "table" then
			for _, id in pairs(IDs) do
                rendering.destroy(id)
            end
		else
			rendering.destroy(IDs)
		end
		SmeB_UI.player_shield_UIs[player_index] = nil
	end
end

local function destroy_vehicles_shield_UIs(player_index)
	local IDs = SmeB_UI.vehicles_shield[player_index]
	if IDs then
		if type(IDs) == "table" then
			for _, id in pairs(IDs) do
                rendering.destroy(id)
            end
		else
			rendering.destroy(IDs)
		end
		SmeB_UI.vehicles_shield[player_index] = nil
	end
end

local function destroy_player_mana_UIs(player_index)
	local IDs = SmeB_UI.player_mana_UIs[player_index]
	if IDs then
		if type(IDs) == "table" then
			for _, id in pairs(IDs) do
                rendering.destroy(id)
            end
		else
			rendering.destroy(IDs)
		end
		SmeB_UI.player_mana_UIs[player_index] = nil
	end
end

local function destroy_player_spirit_UIs(player_index)
	local IDs = SmeB_UI.player_spirit_UIs[player_index]
	if IDs then
		if type(IDs) == "table" then
			for _, id in pairs(IDs) do
                rendering.destroy(id)
            end
		else
			rendering.destroy(IDs)
		end
		SmeB_UI.player_spirit_UIs[player_index] = nil
	end
end

local function remove_character_data(player_index)
	SmeB_UI.target_characters[player_index] = nil
	destroy_player_HP_UIs(player_index)
	destroy_player_shield_UIs(player_index)
	destroy_player_mana_UIs(player_index)
	destroy_player_spirit_UIs(player_index)
end

local function update_UIs()
	for player_index, _ in pairs(SmeB_UI.target_characters) do
		local player = game.players[player_index]
		if player and player.valid and player.character then
			update_player_hp_UI(player, SmeB_UI.player_HP_UIs[player_index])
			update_player_shield_UI(player, SmeB_UI.player_mana_UIs[player_index])
			update_player_mana_UI(player, SmeB_UI.player_mana_UIs[player_index])
			update_player_spirit_UI(player, SmeB_UI.player_spirit_UIs[player_index])
		else
			remove_character_data(player_index)
		end
	end

	for vehicle_index, vehicle in pairs(SmeB_UI.vehicles_shield) do
		if vehicle.entity.valid then
			update_vehicle_shield_UI(vehicle)
		else
			SmeB_UI.vehicles_shield[vehicle_index] = nil
		end
	end
end

local function check_player(player)
	if not player.valid or not player.connected then
		remove_character_data(player.index)
		return
	end

	local character = player.character
	if character and character.health ~= nil and not player.vehicle then
		SmeB_UI.target_characters[player.index] = true
		update_player_hp_UI(player, SmeB_UI.player_HP_UIs[player.index])
		update_player_shield_UI(player, SmeB_UI.player_shield_UIs[player.index])
		update_player_mana_UI(player, SmeB_UI.player_mana_UIs[player_index])
		update_player_spirit_UI(player, SmeB_UI.player_spirit_UIs[player_index])
	else
		remove_character_data(player.index)
	end
end

local function check_players()
	for _, player in pairs(game.connected_players) do
		check_player(player)
	end
end

local function on_load()
	SmeB_UI = global.SmeB_UI
	check_spell_pack_mod()
end

local function check_player_on_event(event)
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end

	if player.character then
		SmeB_UI.target_characters[event.player_index] = true
		update_player_hp_UI(player, SmeB_UI.player_HP_UIs[event.player_index])
		update_player_shield_UI(player, SmeB_UI.player_shield_UIs[event.player_index])
		update_player_mana_UI(player, SmeB_UI.player_mana_UIs[player_index])
		update_player_spirit_UI(player, SmeB_UI.player_spirit_UIs[player_index])
	else
		remove_character_data(event.player_index)
	end
end

local function on_player_created(event)
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end

	if player.character then
		SmeB_UI.target_characters[event.player_index] = true
		update_player_hp_UI(player, SmeB_UI.player_HP_UIs[event.player_index])
		update_player_shield_UI(player, SmeB_UI.player_shield_UIs[event.player_index])
	else
		remove_character_data(event.player_index)
	end
end
local function on_player_joined_game(event)
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end

	if player.character and not player.vehicle then
		SmeB_UI.target_characters[event.player_index] = true
		update_player_hp_UI(player, SmeB_UI.player_HP_UIs[event.player_index])
		update_player_shield_UI(player, SmeB_UI.player_shield_UIs[event.player_index])
		update_player_mana_UI(player, SmeB_UI.player_mana_UIs[player_index])
		update_player_spirit_UI(player, SmeB_UI.player_spirit_UIs[player_index])
	else
		remove_character_data(event.player_index)
	end
end

local function on_player_driving_changed_state(event)
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end

	if player.character and not player.vehicle then
		SmeB_UI.target_characters[player.index] = true
		update_player_hp_UI(player, SmeB_UI.player_HP_UIs[player_index])
		update_player_shield_UI(player, SmeB_UI.player_mana_UIs[player_index])
		update_player_mana_UI(player, SmeB_UI.player_mana_UIs[player_index])
		update_player_spirit_UI(player, SmeB_UI.player_spirit_UIs[player_index])
	else
		remove_character_data(event.player_index)
	end

	local vehicle = event.entity
	if not (vehicle and vehicle.valid and vehicle.grid) then return end
	if player.force ~= vehicle.force then return end

	local data = SmeB_UI.vehicles_shield
	if data[vehicle.unit_number] == nil then
		update_vehicle_shield_UI({entity = vehicle})
	else
		data[vehicle.unit_number].tick = event.tick
	end
end

module.check_vehicles = function()
	for index, vehicle in pairs(SmeB_UI.vehicles_shield) do
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
						SmeB_UI.vehicles_shield[index] = nil
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
						SmeB_UI.vehicles_shield[index] = nil
					end
				end
			end
		else
			SmeB_UI.vehicles_shield[index] = nil
		end
	end
end

local function on_player_mined_entity(event)
	local entity = event.entity
	if not entity.grid then return end

	SmeB_UI.vehicles_shield[tostring(entity.unit_number)] = nil
end

local function on_selected_entity_changed(event)
	-- Validation of data
	local player = game.players[event.player_index]
	local entity = player.selected
	if not (entity and entity.grid) then return end
	if player.force ~= entity.force then return end
	if entity.type == "character" then return end

	if SmeB_UI.vehicles_shield[entity.unit_number] == nil then
		update_vehicle_shield_UI({entity = entity})
	else
		SmeB_UI.vehicles_shield[entity.unit_number].tick = event.tick
	end
end

local function on_runtime_mod_setting_changed(event)
	if event.setting_type ~= "runtime-global" then return end

	if event.setting == "SmeB_UI_vehicle_shield_mode" then
		local value = settings.global[event.setting].value
		vehicle_shield_mode = value
		update_vehicle_shield_UI = UI_variants[value].update_vehicle_shield_UI
		for player_index, _ in pairs(SmeB_UI.vehicles_shield) do
			destroy_vehicles_shield_UIs(player_index)
		end
		check_players()
	elseif event.setting == "SmeB_UI_player_hp_mode" then
		local value = settings.global[event.setting].value
		player_hp_mode = value
		update_player_hp_UI = UI_variants[value].update_player_hp_UI
		for player_index, _ in pairs(SmeB_UI.player_HP_UIs) do
			destroy_player_HP_UIs(player_index)
		end
		check_players()
	elseif event.setting == "SmeB_UI_player_shield_mode" then
		local value = settings.global[event.setting].value
		player_shield_mode = value
		update_player_shield_UI = UI_variants[value].update_player_shield_UI
		for player_index, _ in pairs(SmeB_UI.player_shield_UIs) do
			destroy_player_shield_UIs(player_index)
		end
		check_players()
	elseif event.setting == "show_SmeB_UIs_only_in_alt_mode" then
		show_SmeB_UIs_only_in_alt_mode = settings.global[event.setting].value
		for player_index, _ in pairs(SmeB_UI.player_HP_UIs) do
			destroy_player_HP_UIs(player_index)
		end
		for player_index, _ in pairs(SmeB_UI.player_shield_UIs) do
			destroy_player_shield_UIs(player_index)
		end
		check_players()
	elseif event.setting == "is_SmeB_UI_public" then
		is_SmeB_UI_public = settings.global[event.setting].value
		for player_index, _ in pairs(SmeB_UI.player_HP_UIs) do
			destroy_player_HP_UIs(player_index)
		end
		for player_index, _ in pairs(SmeB_UI.player_shield_UIs) do
			destroy_player_shield_UIs(player_index)
		end
		check_players()
	elseif event.setting == "SmeB_UI_player_mana_mode" then
		player_mana_mode = settings.global[event.setting].value
		for player_index, _ in pairs(SmeB_UI.player_mana_UIs) do
			destroy_player_shield_UIs(player_index)
		end
		if player_mana_mode ~= "nothing" and player_spirit_mode ~= "nothing" then
			check_players()
			remote.call("spell-pack", "togglebars", "show-health-and-shield", true)
		else
			remote.call("spell-pack", "togglebars", "show-health-and-shield", false)
		end
	elseif event.setting == "SmeB_UI_player_spirit_mode" then
		player_spirit_mode = settings.global[event.setting].value
		for player_index, _ in pairs(SmeB_UI.player_spirit_UIs) do
			destroy_player_shield_UIs(player_index)
		end
		if player_mana_mode ~= "nothing" and player_spirit_mode ~= "nothing" then
			check_players()
			remote.call("spell-pack", "togglebars", "show-health-and-shield", true)
		else
			remote.call("spell-pack", "togglebars", "show-health-and-shield", false)
		end
	end
end

local function on_player_changed_surface(event)
	remove_character_data(event.player_index)
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end

	-- TODO: check vehicle
	if player.character and not player.vehicle then
		SmeB_UI.target_characters[event.player_index] = true
		update_player_hp_UI(player, SmeB_UI.player_HP_UIs[event.player_index])
		update_player_shield_UI(player, SmeB_UI.player_shield_UIs[event.player_index])
		update_player_mana_UI(player, SmeB_UI.player_mana_UIs[player_index])
		update_player_spirit_UI(player, SmeB_UI.player_spirit_UIs[player_index])
	end
end

local function remove_character_data_on_event(event)
	remove_character_data(event.player_index)
end

module.on_init = update_global_data
module.on_load = on_load
module.on_configuration_changed = update_global_data
module.events = {
	[defines.events.on_player_driving_changed_state] = on_player_driving_changed_state,
	[defines.events.on_selected_entity_changed] = on_selected_entity_changed,
	[defines.events.on_player_mined_entity] = on_player_mined_entity,
	[defines.events.on_player_changed_surface] = on_player_changed_surface,
	[defines.events.on_player_removed] = remove_character_data_on_event,
	[defines.events.on_player_respawned] = check_player_on_event,
	[defines.events.on_player_died] = remove_character_data_on_event,
	[defines.events.on_pre_player_left_game] = remove_character_data_on_event,
	[defines.events.on_player_joined_game] = on_player_joined_game,
	[defines.events.on_player_created] = on_player_created,
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
