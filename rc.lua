-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library

beautiful.init(gears.filesystem.get_dir("config") .. "/themes/default/theme.lua")

require('error_handler')

require("scripts.set-wallpaper")

require("configs.keys")
require("configs.client.rules")
require("ui.client")
require("configs.tags")
require("configs.layouts")

require("ui")
require('modules.notifications')
require('modules.lockscreen')

