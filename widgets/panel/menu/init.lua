local hotkeys_popup = require("awful.hotkeys_popup")
local awful = require("awful")
local apps = require("configs.apps")
local beautiful = require("beautiful")
local menubar = require("menubar")
local terminal = require("configs.apps").terminal
-- Enable hotkeys help widgets for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local menu = {}

menu['awesomemenu'] = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", apps.terminal .. " -e man awesome" },
    { "edit config", apps.editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

menu['mainmenu'] = awful.menu({
    items = {
        { "awesome", menu.awesomemenu, beautiful.awesome_icon },
        { "open terminal", apps.terminal },
        { "menu", apps.terminal }
    }
})

menu["launcher"] = awful.widget.launcher({ image = beautiful.awesome_icon, menu = menu.mainmenu })

menubar.utils.terminal = terminal

return menu