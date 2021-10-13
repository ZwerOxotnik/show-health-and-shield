local UI = {}
local check_character_shield_ratio = require("show_me_pretty_UI/UI_util").check_character_shield_ratio
local check_vehicle_shield_ratio = require("show_me_pretty_UI/UI_util").check_vehicle_shield_ratio


--#region Constants
local abs = math.abs
local draw_circle = rendering.draw_circle
local set_color = rendering.set_color
local set_radius = rendering.set_radius
local set_x_scale = rendering.set_x_scale
local set_y_scale = rendering.set_y_scale
local draw_sprite = rendering.draw_sprite
local destroy_render = rendering.destroy
local PLAYER_HP_OFFSET = {-1.0, -1.0}
local PLAYER_SHIELD_OFFSET = {1.0, -1.0}
local PLAYER_MANA_OFFSET = {-1.0, 1.0}
--#endregion

---@param ratio number
local function get_orb_raduis_by_ratio(ratio)
	return 0.23 + ratio * 0.11
end

---@param player table
---@param health number
---@param color table
local function create_player_hp_UI(player, health, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = draw_circle{
		radius = get_orb_raduis_by_ratio(health),
		filled = true,
		surface = character.surface,
		target = character,
		color = color,
		players = (is_SmeB_UI_public and {player}) or nil,
		target_offset = PLAYER_HP_OFFSET,
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

local function create_player_shield_UI(player, shield_ratio, color)
	local character = player.character
	global.SmeB_UI.player_shield_UIs[player.index] = draw_circle{
		radius = get_orb_raduis_by_ratio(shield_ratio),
		filled = true,
		surface = character.surface,
		target = character,
		color = color,
		players = (is_SmeB_UI_public and {player}) or nil,
		target_offset = PLAYER_SHIELD_OFFSET,
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end


---@param player table
---@param UI_id number
UI.update_player_hp_UI = function(player, UI_id)
	local health = player.character.get_health_ratio()
	if health < 0.98 then
		local color = {1 - health, health, 0, 0.8}
		if UI_id then
			set_radius(UI_id, get_orb_raduis_by_ratio(health))
			set_color(UI_id, color)
		else
			create_player_hp_UI(player, health, color)
		end
	elseif UI_id then
		destroy_render(UI_id)
		global.SmeB_UI.player_HP_UIs[player.index] = nil
	end
end

---@param player table
---@param UI_id number
UI.update_player_shield_UI = function(player, UI_id)
	local shield_ratio = check_character_shield_ratio(player)
	if shield_ratio == nil then return end

	if shield_ratio < 0.95 and shield_ratio > 0.02 then
		shield_ratio = abs(shield_ratio - 1) -- for purple color
		local color = {abs(shield_ratio - 1), 0, 1 - shield_ratio, 0.7}
		if UI_id then
			set_radius(UI_id, get_orb_raduis_by_ratio(shield_ratio))
			set_color(UI_id, color)
		else
			create_player_shield_UI(player, shield_ratio, color)
		end
	elseif UI_id then
		destroy_render(UI_id)
		SmeB_UI.player_shield_UIs[player.index] = nil
	end
end


---@param vehicle table
---@param shield number
---@param color table
local function create_vehicle_shield_UI(vehicle, shield, color)
	local UI_id = draw_circle{
		radius = get_orb_raduis_by_ratio(shield),
		filled = true,
		surface = vehicle.surface,
		target = vehicle,
		color = color,
		target_offset = PLAYER_SHIELD_OFFSET,
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
		local color = {abs(shield_ratio - 1), 0, 1 - shield_ratio, 0.7}
		if vehicle.UI_id then
			set_radius(vehicle.UI_id, get_orb_raduis_by_ratio(shield_ratio))
			set_color(vehicle.UI_id, color)
		else
			create_vehicle_shield_UI(vehicle.entity, shield_ratio, color)
		end
	else
		if vehicle.UI_id then
			destroy_render(vehicle.UI_id)
			SmeB_UI.vehicles_shield[vehicle.entity.unit_number] = nil
		end
	end
end

---@param player table
---@param ratio number
---@param color table
local function create_player_mana_UI(player, ratio, color)
	global.SmeB_UI.player_mana_UIs[player.index] = draw_sprite{
		sprite = "SmeB_white_orb",
		x_scale = ratio,
		y_scale = ratio,
		surface = player.surface,
		target = player.character,
		tint = color,
		players = (is_SmeB_magic_UI_public and {player}) or nil,
		target_offset = PLAYER_MANA_OFFSET,
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

---@param player table
---@param UI_id number
UI.update_player_mana_UI = function(player, UI_id)
	local mana_ratio = remote.call("spell-pack", "getstats", player).pctmana
	if mana_ratio < 0.98 then
		local radius = get_orb_raduis_by_ratio(mana_ratio)
		local color = {1 - mana_ratio, mana_ratio, 0, 0.8}
		if UI_id then
			set_x_scale(UI_id, radius)
			set_y_scale(UI_id, radius)
			set_color(UI_id, color)
		else
			create_player_mana_UI(player, radius, color)
		end
	else
		if UI_id then
			destroy_render(UI_id)
			SmeB_UI.player_mana_UIs[player.index] = nil
		end
	end
end

local function create_player_spirit_UI(player, ratio)
	global.SmeB_UI.player_spirit_UIs[player.index] = draw_sprite{
		sprite = "SmeB_white_orb",
		x_scale = ratio,
		y_scale = ratio,
		surface = player.surface,
		target = player.character,
		players = (is_SmeB_magic_UI_public and {player}) or nil,
		target_offset = PLAYER_SHIELD_OFFSET,
		scale_with_zoom = true,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

---@param player table
---@param UI_id number
UI.update_player_spirit_UI = function(player, UI_id)
	local spirit_ratio = remote.call("spell-pack", "getstats", player).pctspirit
	if spirit_ratio < 0.98 then
		local radius = get_orb_raduis_by_ratio(spirit_ratio)
		if UI_id then
			set_x_scale(UI_id, radius)
			set_y_scale(UI_id, radius)
		else
			create_player_spirit_UI(player, radius)
		end
	else
		if UI_id then
			destroy_render(UI_id)
			SmeB_UI.player_spirit_UIs[player.index] = nil
		end
	end
end


return UI
