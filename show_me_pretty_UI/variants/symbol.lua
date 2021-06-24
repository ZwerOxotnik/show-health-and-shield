local UI = {}
local check_vehicle_shield_ratio = require("show_me_pretty_UI/UI_util").check_vehicle_shield_ratio
local check_character_shield_ratio = require("show_me_pretty_UI/UI_util").check_character_shield_ratio
local abs = math.abs


---@param player table
---@param color table
local function create_player_hp_UI(player, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = rendering.draw_text{
		text = "♥",
		scale = 0.7,
		surface = character.surface,
		target = character,
		target_offset = {0.1, -1},
		color = color,
		players = {player},
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

---@param player table
---@param UI_id number
UI.update_player_hp_UI = function(player, UI_id)
	local health = player.character.get_health_ratio()
	if health < 0.98 then
		local color = {r = 1 - health, g = health, b = 0, a = 0.7}
		if UI_id then
			rendering.set_color(UI_id, color)
		else
			create_player_hp_UI(player, color)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		SmeB_UI.player_HP_UIs[player.index] = nil
	end
end

---@param player table
---@param color table
local function create_player_shield_UI(player, color)
	local character = player.character
	SmeB_UI.player_shield_UIs[player.index] = rendering.draw_text{
		text = "♦",
		surface = character.surface,
		target = character,
		target_offset = {-0.1, -1},
		color = color,
		players = {player},
		alignment = "center",
		scale_with_zoom = true
	}
end

---@param player table
---@param UI_id number
UI.update_player_shield_UI = function(player, UI_id)
	local shield_ratio = check_character_shield_ratio(player)
	if shield_ratio == nil then return end

	if shield_ratio < 0.95 and shield_ratio > 0.02 then
		shield_ratio = abs(shield_ratio - 1) -- for purple color
		local color = {r = abs(shield_ratio - 1), g = 0, b = 1 - shield_ratio, a = 0.7}
		if UI_id then
			rendering.set_color(UI_id, color)
		else
			create_player_shield_UI(player, color)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		SmeB_UI.player_shield_UIs[player.index] = nil
	end
end

---@param vehicle table
---@param color table
local function create_vehicle_shield_UI(vehicle, color)
	local UI_id = rendering.draw_text{
		text = "♦",
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

---@param vehicle table
UI.update_vehicle_shield_UI = function(vehicle)
	local shield_ratio = check_vehicle_shield_ratio(vehicle)
	if shield_ratio == nil then return end

	if shield_ratio < 0.95 and shield_ratio > 0.02 then
		shield_ratio = abs(shield_ratio - 1) -- for purple color
		local color = {r = abs(shield_ratio - 1), g = 0, b = 1 - shield_ratio, a = 0.7}
		if vehicle.UI_id then
			rendering.set_color(vehicle.UI_id, color)
		else
			create_vehicle_shield_UI(vehicle.entity, color)
		end
	else
		if vehicle.UI_id then
			rendering.destroy(vehicle.UI_id)
			SmeB_UI.vehicles_shield[vehicle.entity.unit_number] = nil
		end
	end
end


return UI
