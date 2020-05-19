-- Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local UI = {}

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
		players = {player},
		target_offset = {-1.0, -1.0},
		scale_with_zoom = true,
		-- visible = is_SmeB_UI_public,
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
		players = {player},
		target_offset = {1.0, -1.0},
		scale_with_zoom = true,
		-- visible = is_SmeB_UI_public,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

UI.update_player_shield_UI = function(player, UI_id)
	local shield_ratio = UI_util.check_character_shield_ratio(player)
	if shield_ratio == nil then return end

	if shield_ratio < 0.02 then
		if UI_id then
			rendering.destroy(UI_id)
			SmeB_UI.player_shield_UIs[player.index] = nil
		end
	elseif shield_ratio < 0.95 then
		local abs = math.abs
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
		-- visible = is_SmeB_UI_public,
		only_in_alt_mode = true
	}

	if UI_id then
		SmeB_UI.vehicles_shield[vehicle.unit_number] = {entity = vehicle, tick = game.tick, UI_id = UI_id}
	end
end

UI.update_vehicle_shield_UI = function(vehicle)
	local shield_ratio = check_vehicle_shield_ratio(vehicle)
	if shield_ratio == nil then return end

	if shield < 0.02 then
		if vehicle.UI_id then
			rendering.destroy(vehicle.UI_id)
			SmeB_UI.vehicles_shield[entity.unit_number] = nil
		end
		return
	elseif shield < 0.95 then
		local abs = math.abs
		shield = abs(shield - 1) -- for purple color
		local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.7}
		if vehicle.UI_id then
			rendering.set_raduis(vehicle.UI_id, get_orb_raduis_by_ratio(shield))
			rendering.set_color(vehicle.UI_id, color)
		else
			create_vehicle_shield_UI(entity, shield, color)
		end
	else
		if vehicle.UI_id then
			rendering.destroy(vehicle.UI_id)
			SmeB_UI.vehicles_shield[entity.unit_number] = nil
		end
	end
end

UI.show_mana = function(player, target)
	local mana = remote.call("spell-pack", "getstats", player).pctmana
	if mana < 0.98 then
		local color = {r = 1 - mana, g = mana, b = 0, a = 0.8}
		rendering.draw_circle{
			radius = get_orb_raduis_by_ratio(mana),
			filled = true,
			surface = player.surface,
			target = player.character,
			color = color,
			time_to_live = 2,
			players = {target},
			target_offset = {-1.0, 1.0},
			scale_with_zoom = true
		}
	-- else show animation of sparkles
	end
end

UI.show_spirit = function(player, target)
	local spirit = remote.call("spell-pack", "getstats", player).pctspirit
	if spirit > 0 and spirit < 0.98 then
		local color = {r = 1 - spirit, g = spirit, b = 0, a = 0.8}
		rendering.draw_circle{
			radius = get_orb_raduis_by_ratio(spirit),
			filled = true,
			surface = player.surface,
			target = player.character,
			color = color,
			time_to_live = 2,
			players = {target},
			target_offset = {1.0, -1.0},
			scale_with_zoom = true
		}
	-- else show animation of sparkles
	end
end

return UI
