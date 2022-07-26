local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi

return function()
    local icon_font = beautiful.wibar_icon_font_name .. " " .. beautiful.wibar_icon_font_size

    return wibox.widget {
        {
            widget = wibox.widget.textbox,
            forced_width = dpi(20),
            font = icon_font,
            text = "",
            markup = "<span foreground='#ee3212'></span>"
        },
        layout = wibox.layout.align.horizontal
    }
end
