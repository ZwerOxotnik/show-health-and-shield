-- Copyright (C) 2018-2019 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local bar = {}

bar.show_hp = function(character, target)
  local health = character.get_health_ratio()
  if health < 0.98 then
    local text = string.rep("●", math.ceil(health * 10 + 0.1))
    local color = {r = 1 - health, g = health, b = 0, a = 0.7}
    rendering.draw_text{
      text = text,
      surface = character.surface,
      target = character,
      color = color,
      time_to_live = 2,
      players = {target},
      alignment = "center"
    }
  end
end

bar.show_shield = function(character, target)
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
    local text = string.rep("●", math.ceil(shield * 10 + 0.1))
    shield = abs(shield - 1) -- for purple color
    local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.7}
    rendering.draw_text{
      text = text,
      surface = character.surface,
      target_offset = {0, 0.3},
      target = character,
      color = color,
      time_to_live = 2,
      players = {target},
      alignment = "center"
    }
  end
end

bar.show_shield_for_vehicles = function(vehicle, target)
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
    local text = string.rep("●", math.ceil(shield * 10 + 0.1))
    shield = abs(shield - 1) -- for purple color
    local color = {r = abs(shield - 1), g = 0, b = 1 - shield, a = 0.7}
    rendering.draw_text{
      text = text,
      surface = vehicle.surface,
      target = vehicle,
      color = color,
      time_to_live = 2,
      players = {target},
      alignment = "center",
      scale_with_zoom = true
    }
  end
end

return bar
