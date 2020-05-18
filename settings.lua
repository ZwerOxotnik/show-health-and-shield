local CONFIG = require("config")

local function create_UI_settings(settings)
  local new_settings = {}

  for _, setting in ipairs(settings) do
    table.insert(new_settings, {
      type = "string-setting",
      name = "SmeB_UI_" .. setting.name .. "_mode",
      setting_type = "runtime-global",
      default_value = setting.default_value,
      allowed_values = setting.allowed_values
    })
  end

  data:extend(new_settings)
end
create_UI_settings(CONFIG.UI_SETTINGS)

-- Do show in alt mode?

-- Settings for "Spell pack" mod
data:extend({
  {
    type = "int-setting",
    setting_type = "startup",
    name = "SmeB_update_UIs_on_nth_tick",
    minimum_value = 1,
    maximum_value = 600,
    default_value = 60,
  },
  {
    type = "bool-setting",
    name = "SmeB_UI_spell_pack_switcher",
    setting_type = "runtime-global",
    default_value = true
  },
  {
    type = "string-setting",
    name = "SmeB_UI_player_mana_mode",
    setting_type = "runtime-per-user",
    default_value = "orb",
    allowed_values = {"bar", "symbol", "percentage", "amount", "nothing", "arc", "test_bar", "orb"}
  },
  {
    type = "string-setting",
    name = "SmeB_UI_player_spirit_mode",
    setting_type = "runtime-per-user",
    default_value = "orb",
    allowed_values = {"bar", "symbol", "percentage", "amount", "nothing", "arc", "test_bar", "orb"}
  }
})
