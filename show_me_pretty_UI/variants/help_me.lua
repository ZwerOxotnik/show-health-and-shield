local UI = {}


--#region Constants
local draw_text = rendering.draw_text
local destroy_render = rendering.destroy
local PLAYER_HP_COLOR = {0, 1, 0}
local PLAYER_HP_OFFSET = {0, -2.1}
local PLAYER_HP_TEXT = {"help_me"}
--#endregion

---@param player table
local function create_player_hp_UI(player)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = draw_text{
		text = PLAYER_HP_TEXT,
		scale = 0.85,
		surface = character.surface,
		target = character,
		target_offset = PLAYER_HP_OFFSET,
		color = PLAYER_HP_COLOR,
		forces = {player.force},
		alignment = "center",
		scale_with_zoom = true
	}
end

---@param player table
---@param UI_id number
UI.update_player_hp_UI = function(player, UI_id)
	local health = player.character.get_health_ratio()
	if health < 0.35 then
		if not UI_id then
			create_player_hp_UI(player)
		end
	elseif UI_id then
		destroy_render(UI_id)
		SmeB_UI.player_HP_UIs[player.index] = nil
	end
end


return UI
