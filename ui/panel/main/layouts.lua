local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

return function(screen)
    local widget = wibox.widget({
        {
            widget = awful.widget.layoutbox(screen),
        },
        layout  = wibox.layout.margin,
        margin = 10,
    })

    widget:buttons(gears.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    return widget
end
