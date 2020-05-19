-- Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local bar = {}

local function create_hp_UI(player, text, color)
	local character = player.character
	global.SmeB_UI.player_HP_UIs[player.index] = rendering.draw_text{
		surface = character.surface,
		target = character,
		players = {player},
		color = color,
		text = text,
		alignment = "center",
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

bar.update_hp_UI = function(player, UI_id)
	local character = player.character
	local health = character.get_health_ratio()
	if health < 0.98 then
		local text = string.rep("●", math.ceil(health * 10 + 0.1))
		local color = {r = 1 - health, g = health, b = 0, a = 0.7}
		if UI_id then
			rendering.set_text(UI_id, text)
			rendering.set_color(UI_id, color)
		else
			create_hp_UI(player, text, color)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		global.SmeB_UI.player_HP_UIs[player.index] = nil
	end
end

local function create_shield_UI(player, text, color)
	local character = player.character
	global.SmeB_UI.player_shield_UIs[player.index] = rendering.draw_text{
		text = text,
		surface = character.surface,
		target_offset = {0, 0.3},
		target = character,
		color = color,
		players = {player},
		alignment = "center",
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

bar.update_shield_UI = function(player, UI_id)
	local character = player.character
	if character.grid == nil then
		if UI_id then
			rendering.destroy(UI_id)
			SmeB_UI.player_shield_UIs[player.index] = nil
		end
		return
	end

	local shield = 0
	local max_shield = 0
	for _, item in pairs(character.grid.equipment) do
		--if item.max_shield and item.shield then
			shield = shield + item.shield
			max_shield = max_shield + item.max_shield
		--end
	end
	if shield == 0 then
		if UI_id then
			rendering.destroy(UI_id)
			SmeB_UI.player_shield_UIs[player.index] = nil
		end
		return
	end

	shield = shield / max_shield
	if shield < 0.02 then
		if UI_id then
			rendering.destroy(UI_id)
			SmeB_UI.player_shield_UIs[player.index] = nil
		end
	elseif shield < 0.95 then
		local abs = math.abs
		local text = string.rep("●", math.ceil(shield * 10 + 0.1))
		shield = abs(shield - 1) -- for purple color
		local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.7}
		if UI_id then
			rendering.set_text(UI_id, text)
			rendering.set_color(UI_id, color)
		else
			create_hp_UI(player, text, color)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		global.SmeB_UI.player_shield_UIs[player.index] = nil
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
		only_in_alt_mode = true
	}

	if UI_id then
		SmeB_UI.vehicles_shield[vehicle.unit_number] = {entity = vehicle, tick = game.tick, UI_id = UI_id}
	end
end

bar.update_vehicle_shield_UI = function(vehicle)
	local entity = vehicle.entity
	if entity.grid == nil then
		if vehicle.UI_id then
			rendering.destroy(vehicle.UI_id)
			SmeB_UI.vehicles_shield[entity.unit_number] = nil
		end
		return
	end

	local shield = 0
	local max_shield = 0
	for _, item in pairs(entity.grid.equipment) do
		--if item.max_shield and item.shield then
			shield = shield + item.shield
			max_shield = max_shield + item.max_shield
		--end
	end
	if shield == 0 then
		if vehicle.UI_id then
			rendering.destroy(vehicle.UI_id)
			SmeB_UI.vehicles_shield[entity.unit_number] = nil
		end
		return
	end
	shield = shield / max_shield

	if shield < 0.02 then
		if vehicle.UI_id then
			rendering.destroy(vehicle.UI_id)
			SmeB_UI.vehicles_shield[entity.unit_number] = nil
		end
		return
	elseif shield < 0.95 then
		local abs = math.abs
		local text = string.rep("●", math.ceil(shield * 10 + 0.1))
		shield = abs(shield - 1) -- for purple color
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

return bar
