CONFIG = require("config")
event_listener = require("__zk-lib__/event-listener/branch-1/stable-version")
local modules = {}
modules.show_me_pretty_UI = require("show_me_pretty_UI/control")

event_listener.add_libraries(modules)
