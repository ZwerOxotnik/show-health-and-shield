local UI = {}


--#region Constants
local ceil = math.ceil
local draw_text = rendering.draw_text
local set_color = rendering.set_color
local set_text = rendering.set_text
local destroy_render = rendering.destroy
local is_render_valid = rendering.is_valid
local PLAYER_HP_OFFSET = {0, 0.2}
--#endregion


---@param player table
---@param text string
---@param color table
local function create_player_hp_UI(player, text, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = draw_text{
		text = text,
		surface = player.surface,
		target = character,
		target_offset = PLAYER_HP_OFFSET,
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
	local character = player.character
	local health = character.get_health_ratio()
	if health < 0.98 then
		local text = ceil(character.health)
		local color = {1 - health, health, 0, 1}
		if UI_id then
			if is_render_valid(UI_id) then
				set_color(UI_id, color)
				set_text(UI_id, text)
			else
				SmeB_UI.player_HP_UIs[player.index] = nil
				create_player_hp_UI(player, text, color)
			end
		else
			create_player_hp_UI(player, text, color)
		end
	elseif UI_id then
		destroy_render(UI_id)
		SmeB_UI.player_HP_UIs[player.index] = nil
	end
end


return UI
