local wibox = require("wibox")

local rounded_corners = require("scripts.rounded_corners")


local add_button = wibox.widget {
    {
        {
            text    = "+",
            widget  = wibox.widget.textbox
        },
        top     = 8,
        left    = 8,
        right   = 8,
        bottom  = 8,
        layout  = wibox.container.margin
    },
    shape   = rounded_corners,
    widget  = wibox.container.background
}

