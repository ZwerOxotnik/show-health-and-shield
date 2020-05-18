local template = {}

template.init = function(character, target)

end

template.update = function(character, target)

end

template.remove = function(character, target)

end

template.show_hp = function(character, target)
    local health = character.get_health_ratio()
end

template.show_shield = function(character, target)
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
    --
end

template.show_shield_for_vehicles = function(vehicle, target)
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
    --
end

template.show_mana = function(player, target)
	local mana = remote.call("spell-pack", "getstats", player).pctmana
end

template.show_spirit = function(player, target)
	local spirit = remote.call("spell-pack", "getstats", player).pctspirit
end

return template
