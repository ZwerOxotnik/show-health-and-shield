-- Copyright (C) 2018-2019 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

data:extend({
  {
    type = "string-setting",
    name = "shas_player_hp_mode",
    setting_type = "runtime-per-user",
    default_value = "bar",
    allowed_values = {"bar", "symbol", "percentage", "amount", "help_me", "nothing", "arc", "test_bar", "orb"}
  },
  {
    type = "string-setting",
    name = "shas_player_shield_mode",
    setting_type = "runtime-per-user",
    default_value = "bar",
    allowed_values = {"bar", "symbol", "percentage", "nothing", "orb"}
  },
  {
    type = "string-setting",
    name = "shas_vehicle_shield_mode",
    setting_type = "runtime-per-user",
    default_value = "percentage",
    allowed_values = {"bar", "symbol", "percentage", "nothing", "orb"}
  }
})

-- Settings for "Spell pack" mod
data:extend({
  {
    type = "bool-setting",
    name = "shas_spell_pack_switcher",
    setting_type = "runtime-global",
    default_value = true
  },
  {
    type = "string-setting",
    name = "shas_player_mana_mode",
    setting_type = "runtime-per-user",
    default_value = "orb",
    allowed_values = {"bar", "symbol", "percentage", "amount", "nothing", "arc", "test_bar", "orb"}
  },
  {
    type = "string-setting",
    name = "shas_player_spirit_mode",
    setting_type = "runtime-per-user",
    default_value = "orb",
    allowed_values = {"bar", "symbol", "percentage", "amount", "nothing", "arc", "test_bar", "orb"}
  }
})
