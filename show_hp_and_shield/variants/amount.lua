local amount = {}

amount.show_hp = function(character)
  local max_health = (character.character_health_bonus + game.entity_prototypes[character.name].max_health)
  local health = character.health / max_health
  if health < 0.98 then
    local surface = character.surface
    local position = character.position
    local color = {r = 1 - health, g = health, b = 0, a = 0.5}
    surface.create_entity{name="hp-shield", color = color, text = math.ceil(character.health), position = {position.x - 2.1, position.y - 2.1}}
  end
end

return amount
