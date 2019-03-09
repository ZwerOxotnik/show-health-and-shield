-- Copyright (C) 2018-2019 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local percentage = {}

percentage.show_hp = function(character, target)
  local health = character.get_health_ratio()
  if health < 0.98 then
    local surface = character.surface
    local position = character.position
    local color = {r = 1 - health, g = health, b = 0, a = 0.8}
    rendering.draw_text{
      text = (math.ceil(health * 100) .. "%"),
      scale = 0.9,
      surface = character.surface,
      target = character,
      color = color,
      time_to_live = 2,
      players = {target},
      alignment = "center",
      scale_with_zoom = true
    }
  end
end

percentage.show_shield = function(character, target)
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
  local text = math.ceil(shield * 100) .. "%"
  if shield < 0.02 then
    return
  elseif shield < 0.95 then
    local abs = math.abs
    shield = abs(shield - 1) -- for purple color
    local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.7}
    rendering.draw_text{
      text = text,
      scale = 0.9,
      surface = character.surface,
      target = character,
      target_offset = {0, 0.3},
      color = color,
      time_to_live = 2,
      players = {target},
      alignment = "center",
      scale_with_zoom = true
    }
  end
end

percentage.show_shield_for_vehicles = function(vehicle, target)
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
  local text = math.ceil(shield * 100) .. "%"
  if shield < 0.02 then
    return
  elseif shield < 0.95 then
    local abs = math.abs
    shield = abs(shield - 1) -- for purple color
    local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.7}
    rendering.draw_text{
      text = text,
      surface = entity.surface,
      target = entity,
      color = color,
      time_to_live = 2,
      players = {target},
      alignment = "center",
      scale_with_zoom = true
    }
  end
end

return percentage
