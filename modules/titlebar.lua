local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

local double_click_event_handler = function(double_click_event)
    if double_click_timer then
        double_click_timer:stop()
        double_click_timer = nil
        double_click_event()
        return
    end
    double_click_timer = gears.timer.start_new(
        0.20,
        function()
            double_click_timer = nil
            return false
        end
    )
end

local click_events = function(c)
    local buttons = gears.table.join(
        awful.button({}, 1,
            function()
                double_click_event_handler(function()
                    if c.floating then
                        c.floating = false
                        return
                    end
                    c.maximized = not c.maximized
                    c:raise()
                    return
                end)
                c:emit_signal("request::activate", "titlebar", {raise = true})
                awful.mouse.client.move(c)
            end
        ),
        awful.button({}, 3,
            function()
                c:emit_signal("request::activate", "titlebar", {raise = true})
                awful.mouse.client.resize(c)
            end
        )
    )
    return buttons
end


local vertical_bar = function(c, position, bg, size, hide)
    local hide = hide or false
    if hide == true then
        awful.titlebar(c, { bg = bg, size = 2 })
    else
        awful.titlebar(c, {position = position, bg = bg, size = size}) : setup {
            {
                {
                    awful.titlebar.widget.closebutton(c),
                    awful.titlebar.widget.maximizedbutton(c),
                    awful.titlebar.widget.minimizebutton(c),
                    spacing = dpi(7),
                    layout  = wibox.layout.fixed.vertical
                },
                margins = dpi(10),
                widget = wibox.container.margin
            },
            {
                {
                    text = c.class,
                    widget = wibox.widget.textbox,
                },
                buttons = click_events(c),
                layout = wibox.layout.flex.vertical
            },
            {
                {
                    awful.titlebar.widget.floatingbutton(c),
                    spacing = dpi(7),
                    layout  = wibox.layout.fixed.vertical
                },
                margins = dpi(10),
                widget = wibox.container.margin
            },
            layout = wibox.layout.align.vertical
        }
    end
end

local horizontal_bar = function(c, position, bg, size, hide)
    hide = hide or false
    if position == 'left' or position == 'right' then position = 'top' end

    if hide == true then
        awful.titlebar(c, { bg = bg, size = 2 })
    else
        awful.titlebar(c, {position = position, bg = bg, size = size}) : setup {
            {
                {
                    awful.titlebar.widget.closebutton(c),
                    spacing = dpi(7),
                    layout  = wibox.layout.fixed.horizontal
                },
                margins = dpi(10),
                widget = wibox.container.margin
            },
            {
                buttons = click_events(c),
                layout = wibox.layout.flex.horizontal
            },
            {
                awful.titlebar.widget.minimizebutton(c),
                spacing = dpi(7),
                layout  = wibox.layout.fixed.horizontal
            },
            layout = wibox.layout.align.horizontal
        }
    end
end

return {
    vertical_bar = vertical_bar,
    horizontal_bar = horizontal_bar
}