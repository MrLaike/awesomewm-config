local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local taglist = require("ui.widgets.taglist")
local tasklist = require("ui.widgets.tasklist")
local custom_shape = require("scripts.utils").custom_shape

return function(screen)

    local textclock = wibox.widget.textclock("%a %b %e %l:%M %p")
    local tools_panel_toggle = require("ui.widgets.tools-panel-toggle")
    local volume = require("ui.widgets.volume.block")()
    local offsetx = beautiful.wibar_offsetx or 0
    local layouts = require("ui.panel.main.layouts")
    local battery = require("ui.widgets.battery")()
    local package_updater = require("ui.widgets.package-update")()

    --- Systray
    --- ~~~~~~~
    local function system_tray()
        return wibox.widget({
            layout = wibox.layout.fixed.horizontal,
            {
                {
                    widget = wibox.widget.systray(),
                    base_size = dpi(20),
                },
                layout = wibox.container.place,
                valign = "center",
            },
        })
    end

    -- Кастыль: Отступ сверху
    if (beautiful.wibar_margins) then
        awful.wibar {
            stretch = false,
            screen = screen,
            height = beautiful.wibar_margins,
        }
    end

    local panel = awful.wibar {
        position = "top",
        screen = screen,
        x = screen.geometry.x + offsetx,
        width = screen.geometry.width - dpi(16),
        shape = gears.shape.rounded_rect,
        bg = beautiful.wibar_bg,
    }

    panel:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            tools_panel_toggle(),
            textclock,
            layout = wibox.layout.fixed.horizontal,
        },
        {
            left = 15,
            top = 8,
            bottom = 8,
            layout = wibox.layout.margin,
            {
                bg = beautiful.taglist_bg,
                shape = custom_shape,
                layout = wibox.container.background,
                taglist(screen),
            },
        },
        {
            layout = wibox.layout.margin,
            right = dpi(15),
            {
                layout = wibox.layout.fixed.horizontal,
                tasklist(screen),
                system_tray(),
                battery,
                package_updater,
                volume,
                layouts(screen),
            }
        },
    }

    return panel
end
