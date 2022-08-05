local function pre_action() end

local function post_action() end

---
-- Lua Setup and Plugins
---
pre_action()
require("plugin_loader").startup()
post_action()
