local wibox = require("wibox")
local clickable_container = require("widgets.clickable-container")
local awful = require("awful")
local gears = require("gears")
panel_visible = false

local button = function()
    local widget_button = wibox.widget {
        {
            {
                text = 'tools',
                widget = wibox.widget.textbox
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

return button