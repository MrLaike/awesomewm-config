local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

return function(screen)
    return wibox.widget({
        layout = wibox.layout.fixed.horizontal,
        {
            {
                widget = awful.widget.layoutbox {
                    screen = screen,
                    buttons = {
                        awful.button({ }, 1, function()
                            awful.layout.inc(1)
                        end),
                        awful.button({ }, 3, function()
                            awful.layout.inc(-1)
                        end),
                        awful.button({ }, 4, function()
                            awful.layout.inc(1)
                        end),
                        awful.button({ }, 5, function()
                            awful.layout.inc(-1)
                        end)
                    }
                },
                forced_width = dpi(20),
            },
            layout = wibox.container.place,
            valign = "center",
        },
    })
end
