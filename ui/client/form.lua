local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

client.connect_signal("manage", function(client)
    if awesome.startup
            and not client.size_hints.user_position
            and not client.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(client)
    end
end)

client.connect_signal("mouse::enter", function(client)
    client:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(client)
    client.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(client)
    client.border_color = beautiful.border_normal
end)

if beautiful.rounded_corners then
    client.connect_signal("property::geometry", function(client)
        if not client.fullscreen then
            gears.timer.delayed_call(function()
                gears.surface.apply_shape_bounding(client, gears.shape.rounded_rect, 10)
            end)
        end
    end)
end