-- Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local UI = {}

local function create_player_hp_UI(player, text, color)
	local character = player.character
	SmeB_UI.player_HP_UIs[player.index] = rendering.draw_text{
		text = text,
		surface = player.surface,
		target = character,
		target_offset = {0, 0.2},
		color = color,
		players = {player},
		alignment = "center",
		scale_with_zoom = true,
		-- visible = is_SmeB_UI_public,
		only_in_alt_mode = show_SmeB_UIs_only_in_alt_mode
	}
end

UI.update_player_hp_UI = function(player, UI_id)
	local character = player.character
	local health = character.get_health_ratio()
	if health < 0.98 then
		local text = math.ceil(character.health)
		local color = {r = 1 - health, g = health, b = 0, a = 1}
		if UI_id then
			rendering.set_color(UI_id, color)
			rendering.set_text(UI_id, text)
		else
			create_player_hp_UI(player, text, color)
		end
	elseif UI_id then
		rendering.destroy(UI_id)
		SmeB_UI.player_HP_UIs[player.index] = nil
	end
end

return UI
