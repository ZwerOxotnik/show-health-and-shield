local UI = {}


--#region Constants
local set_color = rendering.set_color
local set_angle = rendering.set_angle
local draw_arc = rendering.draw_arc
local destroy_render = rendering.destroy
local is_render_valid = rendering.is_valid
local PLAYER_HP_OFFSET = {0, -1}
--#endregion


---@param health number
---@return number #health * 3.4
local function get_new_angle(health)
	return health * 3.4
end

---@param player table
---@param health number
---@param color table
local function create_player_hp_UI(player, health, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = draw_arc{
		surface = character.surface,
		target = character,
		target_offset = PLAYER_HP_OFFSET,
		min_radius = 1,
		max_radius = 1.2,
		start_angle = 3,
		angle = get_new_angle(health),
		color = color,
		players = (is_SmeB_UI_public and {player}) or nil,
		alignment = "left",
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end


---@param player table
---@param UI_id number
UI.update_player_hp_UI = function(player, UI_id)
	local health = player.character.get_health_ratio()
	if health < 0.98 then
		local color = {1 - health, health, 0, 0.5}
		if UI_id then
			if is_render_valid(UI_id) then
				set_color(UI_id, color)
				set_angle(UI_id, get_new_angle(health))
			else
				SmeB_UI.player_HP_UIs[player.index] = nil
				create_player_hp_UI(player, health, color)
			end
		else
			create_player_hp_UI(player, health, color)
		end
	elseif UI_id then
		destroy_render(UI_id)
		SmeB_UI.player_HP_UIs[player.index] = nil
	end
end


return UI
