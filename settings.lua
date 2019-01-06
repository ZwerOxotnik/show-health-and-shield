data:extend({
  {
    type = "string-setting",
    name = "shas_hp_player_mode",
    setting_type = "runtime-global",
    default_value = "bar",
    allowed_values = {"bar", "symbol", "percentage", "amount", "help_me", "nothing"}
  },
  {
    type = "string-setting",
    name = "shas_shield_player_mode",
    setting_type = "runtime-global",
    default_value = "bar",
    allowed_values = {"bar", "symbol", "percentage", "nothing"}
  },
  {
    type = "string-setting",
    name = "shas_vehicle_shield_mode",
    setting_type = "runtime-global",
    default_value = "percentage",
    allowed_values = {"bar", "symbol", "percentage", "nothing"}
  }
})
