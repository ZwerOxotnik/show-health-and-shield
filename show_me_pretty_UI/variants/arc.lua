-- Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");
local UI = {}

local function get_new_angle(health)
	return health * 3.4
end

local function create_player_hp_UI(player, health, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = rendering.draw_arc{
		surface = character.surface,
		target = character,
		target_offset = {0, -1},
		min_radius = 1,
		max_radius = 1.2,
		start_angle = 3,
		angle = get_new_angle(health),
		color = color,
		players = (is_SmeB_UI_public and {player}),
		alignment = "left",
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

UI.update_player_hp_UI = function(player, UI_id)
	local health = player.character.get_health_ratio()
	if health < 0.98 then
		local color = {r = 1 - health, g = health, b = 0, a = 0.5}
		if UI_id then
			rendering.set_color(UI_id, color)
			rendering.set_angle(UI_id, get_new_angle(health))
		else
			create_player_hp_UI(player, health, color)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		SmeB_UI.player_HP_UIs[player.index] = nil
	end
end

return UI
