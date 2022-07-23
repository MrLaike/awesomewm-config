local awful = require("awful")
local wibox = require("wibox")


local tasklist = function(screen)
    local tasklist_buttons = gears.table.join(
            awful.button({ }, 1, function (c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal(
                            "request::activate",
                            "tasklist",
                            {raise = true}
                    )
                end
            end),
            awful.button({ }, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
            awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
            awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
    )

    -- создаем виджет списка открытых программ
    local tasklist_widget = awful.widget.tasklist {
        screen  = screen,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = {

        },
        layout   = {
            spacing_widget = {
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = 10,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 1,
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = 5,
                widget  = wibox.container.margin
            },
            nil,
            create_callback = function(self, c, index, objects) self:get_children_by_id('clienticon')[1].client = c end,
            layout = wibox.layout.align.vertical,
        },
    }

    return tasklist_widget
end

return tasklist