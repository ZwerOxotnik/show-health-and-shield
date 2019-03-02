local bar = {}

bar.show_hp = function(character)
  local health = character.get_health_ratio()
  if health < 0.98 then
    local surface = character.surface
    local position = character.position
    local text = string.rep("●", math.ceil(health * 10 + 0.1))
    local color = {r = 1 - health, g = health, b = 0, a = 0.5}
    surface.create_entity{name="hp-shield", color = color, text = text, position = {position.x - 2, position.y - 2.1}}
  end
end

bar.show_shield = function(character)
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
    local surface = character.surface
    local position = character.position
    local color = {r = 0, g = shield, b = shield, a = 0.5}
    local abs = math.abs
    local text = string.rep("●", math.ceil(shield * 10 + 0.1))
    local shield = abs(shield - 1) -- for purple color
    local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.5}
    surface.create_entity{name = "hp-shield", color = color, text = text, position = {position.x - 2, position.y - 2.6}}
  end
end

bar.show_shield_for_vehicles = function(vehicle)
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
    local surface = entity.surface
    local position = entity.position
    local color = {r = 0, g = shield, b = shield, a = 0.5}
    local abs = math.abs
    local text = string.rep("●", math.ceil(shield * 10 + 0.1))
    local shield = abs(shield - 1) -- for purple color
    local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.5}
    global.vehicles_shield[tostring(entity.unit_number)].text = surface.create_entity{name = "hp-shield", color = color, text = text, position = {position.x - 2, position.y - 2.6}}
  end
end

return bar
