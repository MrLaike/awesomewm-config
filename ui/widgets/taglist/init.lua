local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

return function(screen)
    local taglist_buttons = gears.table.join(
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

     return awful.widget.taglist {
        screen  = screen,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout   = {
            spacing_widget = {
                spacing = 12,
            },
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id = 'text_role',
                            widget = wibox.widget.textbox,
                        },
                        left = 8,
                        right = 8,
                        widget = wibox.container.margin,
                    },
                    valign = 'center',
                    halign = 'center',
                    widget = wibox.container.place,
                },
                widget = wibox.container.background
            },
            layout = wibox.layout.fixed.horizontal,
        },
     }
end
