local modules = {}
modules.show_hp_and_shield = require("show_hp_and_shield/control")
modules.show_magic = require("show_hp_and_shield/magic-extension")

local TICKS_FOR_VEHICLE = require("show_hp_and_shield.config").TICKS_FOR_VEHICLE
script.on_nth_tick(TICKS_FOR_VEHICLE, modules.show_hp_and_shield.check_vehicles)

return modules
