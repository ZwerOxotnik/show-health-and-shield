local help_me = {}

help_me.show_hp = function(character)
  local health = character.get_health_ratio()
  if health < 0.35 then
    local surface = character.surface
    local position = character.position
    local color = {r = 0, g = 1, b = 0}
    surface.create_entity{name="hp-shield", color = color, text = {"help_me"}, position = {position.x + 0.1, position.y - 1}}
  end
end

return help_me
