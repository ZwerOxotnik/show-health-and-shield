local CONFIG = {}

CONFIG.TICKS_FOR_CHEKING_OF_CHARACTERS = 60 * 60 * 1.5
CONFIG.TICKS_FOR_VEHICLE = 60 * 60 * 1.5
CONFIG.CHECK_VEHICLES_ON_Nth_TICK = CONFIG.TICKS_FOR_VEHICLE / 3
CONFIG.UI_SETTINGS = {
	{
		name = "symbol",
		default_value = "bar",
		allowed_values = {"bar", "symbol", "percentage", "amount", "help_me", "nothing", "arc", "classic_bar", "orb"}
	},
	{
		name = "symbol",
		default_value = "bar",
		allowed_values = {"bar", "symbol", "percentage", "nothing", "orb"}
	},
	{
		name = "symbol",
		default_value = "nothing",
		allowed_values = {"bar", "symbol", "percentage", "nothing", "orb"}
	},
}

return CONFIG
