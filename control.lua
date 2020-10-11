CONFIG = require("config")
event_listener = require("__zk-lib__/event-listener/branch-1/stable-version")
local modules = require("modules")

event_listener.add_libraries(modules)
