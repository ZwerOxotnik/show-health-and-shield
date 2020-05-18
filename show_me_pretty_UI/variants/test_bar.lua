-- Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local test_bar = {}

test_bar.show_hp = function(character, target)
	local health = character.get_health_ratio()
	if health < 0.98 then
		local number = math.ceil(health * 10.1)
		local color = {r = 1 - health, g = health, b = 0, a = 0.5}
		rendering.draw_text{
			text = string.rep("■", number),
			scale = 0.9,
			surface = character.surface,
			target = character,
			target_offset = {-2.085, -2},
			color = color,
			time_to_live = 2,
			players = {target},
			alignment = "left"
		}
		rendering.draw_text{
			text = string.rep("■", math.ceil(10 - number)),
			scale = 0.9,
			surface = character.surface,
			target = character,
			target_offset = {2.085, -2},
			color = {r = 0, g = 0, b = 0, a = 0.7},
			time_to_live = 2,
			players = {target},
			alignment = "right"
		}
	end
end

return test_bar
