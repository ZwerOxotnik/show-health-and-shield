-- Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local orb = {}

local function get_orb_raduis_by_ratio(ratio)
	return 0.23 + ratio * 0.11
end

orb.show_hp = function(character, target)
	local health = character.get_health_ratio()
	if health < 0.98 then
		local color = {r = 1 - health, g = health, b = 0, a = 0.8}
		rendering.draw_circle{
			radius = get_orb_raduis_by_ratio(health),
			filled = true,
			surface = character.surface,
			target = character,
			color = color,
			time_to_live = 2,
			players = {target},
			target_offset = {-1.0, -1.0},
			scale_with_zoom = true
		}
	end
end

orb.show_shield = function(character, target)
	if character.grid == nil then return end

	local shield = 0
	local max_shield = 0
	for _, item in pairs(character.grid.equipment) do
		--if item.max_shield and item.shield then
			shield = shield + item.shield
			max_shield = max_shield + item.max_shield
		--end
	end
	if shield == 0 then return end
	shield = shield / max_shield

	if shield < 0.02 then
		return
	elseif shield < 0.95 then
		local abs = math.abs
		shield = abs(shield - 1) -- for purple color
		local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.7}
		rendering.draw_circle{
			radius = get_orb_raduis_by_ratio(shield),
			filled = true,
			surface = character.surface,
			target = character,
			color = color,
			time_to_live = 2,
			players = {target},
			target_offset = {1.0, -1.0},
			scale_with_zoom = true
		}
	end
end

orb.show_shield_for_vehicles = function(vehicle, target)
	local entity = vehicle.entity
	if entity.grid == nil then return end

	local shield = 0
	local max_shield = 0
	for _, item in pairs(entity.grid.equipment) do
		--if item.max_shield and item.shield then
			shield = shield + item.shield
			max_shield = max_shield + item.max_shield
		--end
	end
	if shield == 0 then return end
	shield = shield / max_shield

	if shield < 0.02 then
		return
	elseif shield < 0.95 then
		local abs = math.abs
		shield = abs(shield - 1) -- for purple color
		local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.7}
		rendering.draw_circle{
			radius = get_orb_raduis_by_ratio(shield),
			filled = true,
			surface = entity.surface,
			target = entity,
			color = color,
			time_to_live = 2,
			players = {target},
			target_offset = {1.0, -1.0},
			scale_with_zoom = true
		}
	end
end

orb.show_mana = function(player, target)
	local mana = remote.call("spell-pack", "getstats", player).pctmana
	if mana < 0.98 then
		local color = {r = 1 - mana, g = mana, b = 0, a = 0.8}
		rendering.draw_circle{
			radius = get_orb_raduis_by_ratio(mana),
			filled = true,
			surface = player.surface,
			target = player.character,
			color = color,
			time_to_live = 2,
			players = {target},
			target_offset = {-1.0, 1.0},
			scale_with_zoom = true
		}
	-- else show animation of sparkles
	end
end

orb.show_spirit = function(player, target)
	local spirit = remote.call("spell-pack", "getstats", player).pctspirit
	if spirit > 0 and spirit < 0.98 then
		local color = {r = 1 - spirit, g = spirit, b = 0, a = 0.8}
		rendering.draw_circle{
			radius = get_orb_raduis_by_ratio(spirit),
			filled = true,
			surface = player.surface,
			target = player.character,
			color = color,
			time_to_live = 2,
			players = {target},
			target_offset = {1.0, -1.0},
			scale_with_zoom = true
		}
	-- else show animation of sparkles
	end
end

return orb