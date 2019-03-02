local amount = {}

amount.show_hp = function(character, target)
  local health = character.get_health_ratio()
  if health < 0.98 then
    local surface = character.surface
    local color = {r = 1 - health, g = health, b = 0, a = 1}
    rendering.draw_text{
      text = math.ceil(character.health),
      surface = surface,
      target = character,
      target_offset = {0, 0.2},
      color = color,
      time_to_live = 2,
      players = {target},
      alignment = "center",
      scale_with_zoom = true
    }
  end
end

return amount
