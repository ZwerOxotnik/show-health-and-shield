-- Copyright (C) 2018-2019 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local arc = {}

arc.show_hp = function(character, target)
  local health = character.get_health_ratio()
  if health < 0.98 then
    local color = {r = 1 - health, g = health, b = 0, a = 0.5}
    rendering.draw_arc{
      surface = character.surface,
      target = character,
      target_offset = {0, -1},
      min_radius = 1,
      max_radius = 1.2,
      start_angle = 3,
      angle = health * 3.4,
      color = color,
      time_to_live = 2,
      players = {target},
      alignment = "left"
    }
  end
end

return arc
