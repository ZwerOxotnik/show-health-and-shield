local help_me = {}

help_me.show_hp = function(character)
  local health = character.get_health_ratio()
  if health < 0.35 then
    local color = {r = 0, g = 1, b = 0}
    rendering.draw_text{
      text = {"help_me"},
      scale = 0.85,
      surface = character.surface,
      target = character,
      target_offset = {0, -2.1},
      color = color,
      time_to_live = 2,
      visible = true,
      alignment = "center",
      scale_with_zoom = true
    }
  end
end

return help_me
