local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local vertical_bar = require("modules.titlebar").vertical_bar
local horizontal_bar = require("modules.titlebar").horizontal_bar
local in_array = require('scripts.utils').in_array

client.connect_signal("manage", function (c)
    if awesome.startup
            and not c.size_hints.user_position
            and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)


client.connect_signal("request::titlebars", function(c)
    local client_with_hide_titlebar = {
        'URxvt',
        'UXterm',
        'TelegramDesktop',
        'obsidian'
    }
    local bg = beautiful.bg_titlebar or "#00000088"
    if c.type == 'normal' then
        if in_array(c.class, client_with_hide_titlebar) then
            vertical_bar(c, "left", bg, 30, true)
        else
            vertical_bar(c, "left", bg, 30, false)
        end
    elseif c.type == 'dialog' then
        horizontal_bar(c, "top", bg, 30, false)
    end
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

if beautiful.rounded_corners then
    client.connect_signal("property::geometry", function (c)
        if not c.fullscreen then
            gears.timer.delayed_call(function()
                gears.surface.apply_shape_bounding(c, gears.shape.rounded_rect, 10)
            end)
        end
    end)
end