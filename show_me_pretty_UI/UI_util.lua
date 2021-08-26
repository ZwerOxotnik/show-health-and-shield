local UI_util = {}


---@param player table
UI_util.check_character_shield_ratio = function(player)
	local character = player.character
	if character.grid == nil then
		local player_shield_UIs = SmeB_UI.player_shield_UIs
		local player_index = player.index
		local id = player_shield_UIs[player_index]
		if id then
			rendering.destroy(id)
		end
		player_shield_UIs[player_index] = nil
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

---@param vehicle table
UI_util.check_vehicle_shield_ratio = function(vehicle)
	local entity = vehicle.entity
	if entity.grid == nil then
		local vehicles_shield = SmeB_UI.vehicles_shield
		local unit_inumber = vehicle.unit_inumber
		local UI_IDs = vehicles_shield[unit_inumber]
		if UI_IDs then
			for _, id in pairs(UI_IDs) do
				rendering.destroy(id)
			end
		end
		vehicles_shield[unit_inumber] = nil
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
