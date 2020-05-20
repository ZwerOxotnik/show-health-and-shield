-- Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local UI = {}
local abs = math.abs

local function get_orb_raduis_by_ratio(ratio)
	return 0.23 + ratio * 0.11
end

local function create_player_hp_UI(player, health, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = rendering.draw_circle{
		radius = get_orb_raduis_by_ratio(health),
		filled = true,
		surface = character.surface,
		target = character,
		color = color,
		players = (is_SmeB_UI_public and {player}) or nil,
		target_offset = {-1.0, -1.0},
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

UI.update_player_hp_UI = function(player, UI_id)
	local health = player.character.get_health_ratio()
	if health < 0.98 then
		local color = {r = 1 - health, g = health, b = 0, a = 0.8}
		if UI_id then
			rendering.set_radius(UI_id, get_orb_raduis_by_ratio(health))
			rendering.set_color(UI_id, color)
		else
			create_player_hp_UI(player, health, color)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		global.SmeB_UI.player_HP_UIs[player.index] = nil
	end
end

local function create_player_shield_UI(player, shield_ratio)
	local character = player.character
	global.SmeB_UI.player_shield_UIs[player.index] = rendering.draw_circle{
		radius = get_orb_raduis_by_ratio(shield_ratio),
		filled = true,
		surface = character.surface,
		target = character,
		color = color,
		players = (is_SmeB_UI_public and {player}) or nil,
		target_offset = {1.0, -1.0},
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

UI.update_player_shield_UI = function(player, UI_id)
	local shield_ratio = UI_util.check_character_shield_ratio(player)
	if shield_ratio == nil then return end

	if shield_ratio < 0.95 and shield_ratio > 0.02 then
		shield_ratio = abs(shield_ratio - 1) -- for purple color
		local color = {r = abs(shield_ratio - 1), g = 0, b = 1 - shield_ratio, a = 0.7}
		if UI_id then
			rendering.set_radius(UI_id, get_orb_raduis_by_ratio(shield_ratio))
			rendering.set_color(UI_id, color)
		else
			create_player_shield_UI(player, shield_ratio, color)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		SmeB_UI.player_shield_UIs[player.index] = nil
	end
end

local function create_vehicle_shield_UI(vehicle, shield, color)
	local UI_id = rendering.draw_circle{
		radius = get_orb_raduis_by_ratio(shield),
		filled = true,
		surface = vehicle.surface,
		target = vehicle,
		color = color,
		target_offset = {1.0, -1.0},
		scale_with_zoom = true,
		only_in_alt_mode = true
	}

	if UI_id then
		SmeB_UI.vehicles_shield[vehicle.unit_number] = {entity = vehicle, tick = game.tick, UI_id = UI_id}
	end
end

UI.update_vehicle_shield_UI = function(vehicle)
	local shield_ratio = check_vehicle_shield_ratio(vehicle)
	if shield_ratio == nil then return end

	if shield_ratio < 0.95 and shield_ratio > 0.02 then
		shield_ratio = abs(shield_ratio - 1) -- for purple color
		local color = {r = abs(shield_ratio - 1), g = 0, b = 1 - shield_ratio, a = 0.7}
		if vehicle.UI_id then
			rendering.set_raduis(vehicle.UI_id, get_orb_raduis_by_ratio(shield_ratio))
			rendering.set_color(vehicle.UI_id, color)
		else
			create_vehicle_shield_UI(entity, shield_ratio, color)
		end
	else
		if vehicle.UI_id then
			rendering.destroy(vehicle.UI_id)
			SmeB_UI.vehicles_shield[entity.unit_number] = nil
		end
	end
end

local function create_player_mana_UI(player, ratio, color)
	global.SmeB_UI.player_mana_UIs[player.index] = rendering.draw_sprite{
		sprite = "SmeB_white_orb",
		x_scale = ratio,
		y_scale = ratio,
		surface = player.surface,
		target = player.character,
		tint = color,
		players = (is_SmeB_magic_UI_public and {player}) or nil,
		target_offset = {-1.0, 1.0},
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

UI.update_player_mana_UI = function(player, UI_id)
	local mana_ratio = remote.call("spell-pack", "getstats", player).pctmana
	if mana_ratio < 0.98 then
		local radius = get_orb_raduis_by_ratio(mana_ratio)
		local color = {r = 1 - mana_ratio, g = mana_ratio, b = 0, a = 0.8}
		if UI_id then
			rendering.set_x_scale(UI_id, radius)
			rendering.set_y_scale(UI_id, radius)
			rendering.set_color(UI_id, color)
		else
			create_player_mana_UI(player, radius, color)
		end
	else
		if UI_id then
			rendering.destroy(UI_id)
			SmeB_UI.player_mana_UIs[player.index] = nil
		end
	end
end

local function create_player_spirit_UI(player, ratio)
	global.SmeB_UI.player_spirit_UIs[player.index] = rendering.draw_sprite{
		sprite = "SmeB_white_orb",
		x_scale = ratio,
		y_scale = ratio,
		surface = player.surface,
		target = player.character,
		players = (is_SmeB_magic_UI_public and {player}) or nil,
		target_offset = {1.0, -1.0},
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

UI.update_player_spirit_UI = function(player, UI_id)
	local spirit_ratio = remote.call("spell-pack", "getstats", player).pctspirit
	if spirit_ratio < 0.98 then
		local radius = get_orb_raduis_by_ratio(spirit_ratio)
		if UI_id then
			rendering.set_x_scale(UI_id, radius)
			rendering.set_y_scale(UI_id, radius)
		else
			create_player_spirit_UI(player, radius)
		end
	else
		if UI_id then
			rendering.destroy(UI_id)
			SmeB_UI.player_spirit_UIs[player.index] = nil
		end
	end
end

return UI
