local UI = {}
local check_character_shield_ratio = require("show_me_pretty_UI/UI_util").check_character_shield_ratio
local check_vehicle_shield_ratio = require("show_me_pretty_UI/UI_util").check_vehicle_shield_ratio


--#region Constants
local ceil = math.ceil
local draw_text = rendering.draw_text
local set_color = rendering.set_color
local set_text = rendering.set_text
local destroy_render = rendering.destroy
local PLAYER_SHIELD_OFFSET = {0, 0.3}
--#endregion


---@param player table
---@param text string
---@param color table
local function create_player_hp_UI(player, text, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = draw_text{
		text = text,
		scale = 0.9,
		surface = character.surface,
		target = character,
		color = color,
		players = (is_SmeB_UI_public and {player}) or nil,
		alignment = "center",
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

---@param player table
---@param UI_id number
UI.update_player_hp_UI = function(player, UI_id)
	local health = player.character.get_health_ratio()
	if health < 0.98 then
		local text = (ceil(health * 100) .. "%")
		local color = {1 - health, health, 0, 0.8}
		if UI_id then
			set_color(UI_id, color)
			set_text(UI_id, text)
		else
			create_player_hp_UI(player, text, color)
		end
	elseif UI_id then
		destroy_render(UI_id)
		SmeB_UI.player_HP_UIs[player.index] = nil
	end
end

---@param player table
---@param text string
---@param color table
local function create_player_shield_UI(player, text, color)
	local character = player.character
	SmeB_UI.player_shield_UIs[player.index] = draw_text{
		text = text,
		scale = 0.9,
		surface = character.surface,
		target = character,
		target_offset = PLAYER_SHIELD_OFFSET,
		color = color,
		players = (is_SmeB_UI_public and {player}) or nil,
		alignment = "center",
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

---@param player table
---@param UI_id number
UI.update_player_shield_UI = function(player, UI_id)
	local shield_ratio = check_character_shield_ratio(player)
	if shield_ratio == nil then return end

	if shield_ratio < 0.95 and shield_ratio > 0.02 then
		local color = {shield_ratio, 0, 1 - shield_ratio, 0.7}
		local text = ceil(shield_ratio * 100) .. "%"
		if UI_id then
			set_text(UI_id, text)
			set_color(UI_id, color)
		else
			create_player_shield_UI(player, text, color)
		end
	elseif UI_id then
		destroy_render(UI_id)
		SmeB_UI.player_shield_UIs[player.index] = nil
	end
end

---@param vehicle table
---@param text string
---@param color table
local function create_vehicle_shield_UI(vehicle, text, color)
	local UI_id = draw_text{
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

---@param vehicle table
UI.update_vehicle_shield_UI = function(vehicle)
	local shield_ratio = check_vehicle_shield_ratio(vehicle)
	if shield_ratio == nil then return end

	if shield_ratio < 0.95 and shield_ratio > 0.02 then
		local text = ceil(shield_ratio * 100) .. "%"
		local color = {shield_ratio, 0, 1 - shield_ratio, 0.7}
		if vehicle.UI_id then
			set_text(vehicle.UI_id, text)
			set_color(vehicle.UI_id, color)
		else
			create_vehicle_shield_UI(vehicle.entity, text, color)
		end
	else
		if vehicle.UI_id then
			destroy_render(vehicle.UI_id)
			SmeB_UI.vehicles_shield[vehicle.entity.unit_number] = nil
		end
	end
end


return UI
