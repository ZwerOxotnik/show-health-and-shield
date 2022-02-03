CONFIG = require("config")
local modules = {}
modules.show_me_pretty_UI = require("show_me_pretty_UI/control")

local event_handler
if script.active_mods["zk-lib"] then
	-- Same as Factorio "event_handler", but slightly better performance
	event_handler = require("__zk-lib__/static-libs/lualibs/event_handler_vZO.lua")
else
	event_handler = require("event_handler")
end

event_handler.add_libraries(modules)
