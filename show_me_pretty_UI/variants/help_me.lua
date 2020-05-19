-- Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local UI = {}

local function create_player_hp_UI(player)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = rendering.draw_text{
		text = {"help_me"},
		scale = 0.85,
		surface = character.surface,
		target = character,
		target_offset = {0, -2.1},
		color = {r = 0, g = 1, b = 0},
		forces = {player.force},
		alignment = "center",
		scale_with_zoom = true
	}
end

UI.update_player_hp_UI = function(player, UI_id)
	local health = player.character.get_health_ratio()
	if health < 0.35 then
		if not UI_id then
			create_player_hp_UI(player)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		SmeB_UI.player_HP_UIs[player.index] = nil
	end
end

return UI
