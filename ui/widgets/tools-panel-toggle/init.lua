local wibox = require("wibox")
local clickable_container = require("ui.widgets.clickable-container")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
panel_visible = false

return function()
    local icon_font = beautiful.wibar_icon_font_name .. " " .. beautiful.wibar_icon_font_size
    local widget_button = wibox.widget {
        {
            {
                text = '',
                forced_width = dpi(20),
                font = icon_font,
                widget = wibox.widget.textbox,
            },
            margins = 8,
            widget = wibox.container.margin
        },
        widget = clickable_container
    }

    widget_button:buttons(
        gears.table.join(
            awful.button({}, 1, nil, function() awful.screen.focused().right_panel:toggle() end)
        )
    )

    return widget_button

end
