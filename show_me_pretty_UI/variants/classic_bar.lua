local UI = {}


--#region Constants
local rep = string.rep
local ceil = math.ceil
local draw_text = rendering.draw_text
local set_color = rendering.set_color
local set_text = rendering.set_text
local destroy_render = rendering.destroy
local PLAYER_HP_COLOR = {0, 0, 0, 0.7}
local PLAYER_HP_LEFT_OFFSET = {-2.085, -2}
local PLAYER_HP_RIGHT_OFFSET = {2.085, -2}
--#endregion


---@param player table
---@param number number
---@param color table
local function create_player_hp_UI(player, number, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = {}
	table.insert(SmeB_UI.player_HP_UIs[player.index], draw_text{
		text = rep("■", number),
		scale = 0.9,
		surface = character.surface,
		target = character,
		target_offset = PLAYER_HP_LEFT_OFFSET,
		color = color,
		players = (is_SmeB_UI_public and {player}) or nil,
		alignment = "left",
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	})
	table.insert(SmeB_UI.player_HP_UIs[player.index], draw_text{
		text = rep("■", ceil(11 - number)),
		scale = 0.9,
		surface = character.surface,
		target = character,
		target_offset = PLAYER_HP_RIGHT_OFFSET,
		color = PLAYER_HP_COLOR,
		players = (is_SmeB_UI_public and {player}) or nil,
		alignment = "right",
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	})
end

---@param player table
UI.update_player_hp_UI = function(player)
	local health = player.character.get_health_ratio()
	if health < 0.98 then
		local number = ceil(health * 10)
		local color = {1 - health, health, 0, 0.5}
		local UI_IDs = SmeB_UI.player_HP_UIs[player.index]
		if UI_IDs then
			set_color(UI_IDs[1], color)
			set_text(UI_IDs[1], rep("■", number))
			set_text(UI_IDs[2], rep("■", math.ceil(11 - number)))
		else
			create_player_hp_UI(player, number, color)
		end
	else
		local UI_IDs = SmeB_UI.player_HP_UIs[player.index]
		if UI_IDs then
			destroy_render(UI_IDs[1])
			destroy_render(UI_IDs[2])
			SmeB_UI.player_HP_UIs[player.index] = nil
		end
	end
end


return UI
