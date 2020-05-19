UI_util = {}

UI_util.check_character_shield_ratio = function(player)
    local character = player.character
    if character.grid == nil then
        if UI_id then
            rendering.destroy(UI_id)
            SmeB_UI.player_shield_UIs[player.index] = nil
        end
        return nil
    end

    local shield = 0
    local max_shield = 0
    for _, item in pairs(character.grid.equipment) do
        --if item.max_shield and item.shield then
            shield = shield + item.shield
            max_shield = max_shield + item.max_shield
        --end
    end
    if shield == 0 then
        return 0
    end

    return shield / max_shield
end

UI_util.check_vehicle_shield_ratio = function(vehicle)
	local entity = vehicle.entity
	if entity.grid == nil then
		if vehicle.UI_id then
			rendering.destroy(vehicle.UI_id)
			SmeB_UI.vehicles_shield[entity.unit_number] = nil
		end
		return nil
	end

	local shield = 0
	local max_shield = 0
	for _, item in pairs(entity.grid.equipment) do
		--if item.max_shield and item.shield then
			shield = shield + item.shield
			max_shield = max_shield + item.max_shield
		--end
	end
	if shield == 0 then
		return 0
    end

	return shield / max_shield
end

return UI_util