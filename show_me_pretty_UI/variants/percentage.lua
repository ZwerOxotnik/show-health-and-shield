-- Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local UI = {}
local abs = math.abs

local function create_player_hp_UI(player, text, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = rendering.draw_text{
		text = text,
		scale = 0.9,
		surface = character.surface,
		target = character,
		color = color,
		players = {target},
		alignment = "center",
		scale_with_zoom = true,
		-- visible = is_SmeB_UI_public,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

UI.update_player_hp_UI = function(player, UI_id)
	local health = player.character.get_health_ratio()
	if health < 0.98 then
		local text = (math.ceil(health * 100) .. "%")
		local color = {r = 1 - health, g = health, b = 0, a = 0.8}
		if UI_id then
			rendering.set_color(UI_id, color)
			rendering.set_text(UI_id, text)
		else
			create_player_hp_UI(player, text, color)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		SmeB_UI.player_HP_UIs[player.index] = nil
	end
end

local function create_player_shield_UI(player, text, color)
	local character = player.character
	SmeB_UI.player_shield_UIs[player.index] = rendering.draw_text{
		text = text,
		scale = 0.9,
		surface = character.surface,
		target = character,
		target_offset = {0, 0.3},
		color = color,
		players = {target},
		alignment = "center",
		scale_with_zoom = true,
		-- visible = is_SmeB_UI_public,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

UI.update_player_shield_UI = function(player, UI_id)
	local shield_ratio = UI_util.check_character_shield_ratio(player)
	if shield_ratio == nil then return end

	if shield_ratio < 0.95 and shield_ratio > 0.02 then
		shield = abs(shield - 1) -- for purple color
		local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.7}
		local text = math.ceil(shield * 100) .. "%"
		if UI_id then
			rendering.set_text(UI_id, text)
			rendering.set_color(UI_id, color)
		else
			create_player_shield_UI(player, text, color)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		SmeB_UI.player_shield_UIs[player.index] = nil
	end
end

local function create_vehicle_shield_UI(vehicle, text, color)
	local UI_id = rendering.draw_text{
		text = text,
		surface = vehicle.surface,
		target = vehicle,
		color = color,
		alignment = "center",
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

	if shield_ratio < 0.02 then
		if vehicle.UI_id then
			rendering.destroy(vehicle.UI_id)
			SmeB_UI.vehicles_shield[entity.unit_number] = nil
		end
		return
	elseif shield_ratio < 0.95 then
		shield = abs(shield - 1) -- for purple color
		local text = math.ceil(shield * 100) .. "%"
		local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.7}
		if vehicle.UI_id then
			rendering.set_text(vehicle.UI_id, text)
			rendering.set_color(vehicle.UI_id, color)
		else
			create_vehicle_shield_UI(entity, text, color)
		end
	else
		if vehicle.UI_id then
			rendering.destroy(vehicle.UI_id)
			SmeB_UI.vehicles_shield[entity.unit_number] = nil
		end
	end
end

return UI
