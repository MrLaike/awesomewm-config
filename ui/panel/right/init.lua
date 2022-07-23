local wibox = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi

local custom_shape = function(cr, width, height, radius)
    radius = beautiful.wibar_radius or radius or 6
    gears.shape.rounded_rect(cr, width, height, 0)
end

local right_panel = function(screen)
    local panel_width = dpi(600)
    local panel_x = screen.geometry.x + screen.geometry.width - panel_width
    local offsety = beautiful.wibar_height * 2;

    local panel = wibox {
        ontop = true,
        screen = screen,
        visible = false,
        type = 'dock',
        width = panel_width,
        shape = custom_shape,
        height = screen.geometry.height - offsety,
        x = panel_x - dpi(10),
        y = screen.geometry.y + (offsety / 2) + ((offsety / 2) / 2),
        bg = "#00000022",
        fg = beautiful.fg_normal
    }

    panel.opened = false

    local open_panel = function()
        local focused = awful.screen.focused()
        panel_visible = true

        focused.right_panel.visible = true

        panel:emit_signal('opened')
    end

    local close_panel = function()
        local focused = awful.screen.focused()
        panel_visible = false

        focused.right_panel.visible = false

        panel:emit_signal('closed')
    end

    function panel:toggle()
        self.opened = not self.opened
        if self.opened then
            open_panel()
        else
            close_panel()
        end
    end

    local separator = wibox.widget {
        orientation = 'horizontal',
        opacity = 0.0,
        forced_height = 15,
        widget = wibox.widget.separator,
    }

    local line_separator = wibox.widget {
        orientation = 'horizontal',
        forced_height = dpi(1),
        span_ratio = 1.0,
        color = beautiful.groups_title_bg,
        widget = wibox.widget.separator
    }
    local volume = require("ui.widgets.volume-slider")

    panel : setup {
        {
            expand = 'none',
            layout = wibox.layout.fixed.vertical,
            {
                layout = wibox.layout.align.horizontal,
                expand = 'none',
                nil,
                nil,
                nil
            },
            separator,
            line_separator,
            separator,
            {
                layout = wibox.layout.stack,
                -- Today Pane
                {
                    id = 'pane_id',
                    visible = true,
                    layout = wibox.layout.fixed.vertical,
                    {
                        layout = wibox.layout.fixed.vertical,
                        spacing = dpi(7),
                        require("ui.widgets.volume-slider")(),
                        --require('widget.user-profile'),
                        --require('widget.weather'),
                        --require('widget.email'),
                        --require('widget.social-media'),
                        --require('widget.calculator')
                    },

                },
                -- Notification Center
                {
                    id = 'notif_id',
                    visible = false,
                    text = 'hux',
                    widget = wibox.widget.textbox,
                    --require('widget.notif-center')(s),
                    layout = wibox.layout.fixed.vertical,
                }
            },
        },
        margins = dpi(16),
        widget = wibox.container.margin
    }
    return panel
end

return right_panel
