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

data:extend({
	{
		type = "int-setting",
		setting_type = "startup",
		name = "SmeB_update_UIs_on_nth_tick",
		minimum_value = 1,
		maximum_value = 600,
		default_value = 20,
	},
	{
		type = "bool-setting",
		name = "is_SmeB_UI_public",
		setting_type = "runtime-global",
		default_value = false
	},
	{
		type = "bool-setting",
		name = "show_SmeB_UIs_only_in_alt_mode",
		setting_type = "runtime-global",
		default_value = false
	},
})

-- Settings for "Spell pack" mod
if data.raw["double-setting"]["osp-spirit-alpha"] then
	data:extend({
		{
			type = "bool-setting",
			name = "is_SmeB_magic_UI_public",
			setting_type = "runtime-global",
			default_value = true
		},
		{
			type = "bool-setting",
			name = "SmeB_UI_spell_pack_switcher",
			setting_type = "runtime-global",
			default_value = true
		}
		-- {
		-- 	type = "string-setting",
		-- 	name = "SmeB_UI_player_mana_mode",
		-- 	setting_type = "runtime-global",
		-- 	default_value = "orb",
		-- 	allowed_values = {"bar", "symbol", "percentage", "amount", "nothing", "arc", "classic_bar", "orb"}
		-- },
		-- {
		-- 	type = "string-setting",
		-- 	name = "SmeB_UI_player_spirit_mode",
		-- 	setting_type = "runtime-global",
		-- 	default_value = "orb",
		-- 	allowed_values = {"bar", "symbol", "percentage", "amount", "nothing", "arc", "classic_bar", "orb"}
		-- }
	})
end