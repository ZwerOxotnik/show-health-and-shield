-- Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local UI = {}

local function create_player_hp_UI(player, number, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = {}
	table.insert(SmeB_UI.player_HP_UIs[player.index], rendering.draw_text{
		text = string.rep("■", number),
		scale = 0.9,
		surface = character.surface,
		target = character,
		target_offset = {-2.085, -2},
		color = color,
		players = {target},
		alignment = "left",
		-- visible = is_SmeB_UI_public,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	})
	table.insert(SmeB_UI.player_HP_UIs[player.index], rendering.draw_text{
		text = string.rep("■", math.ceil(11 - number)),
		scale = 0.9,
		surface = character.surface,
		target = character,
		target_offset = {2.085, -2},
		color = {r = 0, g = 0, b = 0, a = 0.7},
		players = {target},
		alignment = "right",
		-- visible = is_SmeB_UI_public,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	})
end

UI.update_player_hp_UI = function(player)
	local health = player.character.get_health_ratio()
	if health < 0.98 then
		local number = math.ceil(health * 10)
		local color = {r = 1 - health, g = health, b = 0, a = 0.5}
		local UI_IDs = SmeB_UI.player_HP_UIs[player.index]
		if UI_IDs then
			rendering.set_color(UI_IDs[1], color)
			rendering.set_text(UI_IDs[1], string.rep("■", number))
			rendering.set_text(UI_IDs[2], string.rep("■", math.ceil(11 - number)))
		else
			create_player_hp_UI(player, number, color)
		end
	else
		local UI_IDs = SmeB_UI.player_HP_UIs[player.index]
		if UI_IDs then
			rendering.destroy(UI_IDs[1])
			rendering.destroy(UI_IDs[2])
			SmeB_UI.player_HP_UIs[player.index] = nil
		end
	end
end

return UI
