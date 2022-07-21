local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

local taglist = function(screen)
    local taglist_buttons = gears.table.join(
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),
            awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

     local taglist_widget = awful.widget.taglist {
        screen  = screen,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style   = {
            shape = gears.shape.powerline
        },
        layout   = {
            spacing_widget = {
                spacing = 12,
                color = '#32e23f',
                shape = gears.shape.powerline,
                widget = wibox.widget.separator,
            },
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    id = 'index_role',
                    widget = wibox.widget.textbox,
                    left = 10,
                    bg = "#222222",
                    layout = wibox.container.margin,
                },
                {
                    id     = 'icon_role',
                    widget = wibox.widget.imagebox,
                },
                {
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    valign = 'center',
                    halign = 'center',
                    widget = wibox.container.place,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            widget = wibox.container.background,
        }
     }

    return taglist_widget
end

return taglist
