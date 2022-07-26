local awful = require("awful")
local beautiful = require("beautiful")
--local clientkeys = require("configs.client.keys")
--local clientbutton = require("configs.client.buttons")

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            --keys = clientkeys,
            --buttons = clientbutton,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
                "org.gnome.Nautilus",
            },
            class = {
                "Thunar",
                "Blueman-manager",
                "Gpick",
                "MessageWin",
                "Sxiv",
                "mpv",
                "Tor Browser",
                "pavucontrol",
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow",
                "ConfigManager",
                "pop-up",
            }
        },
        properties = { floating = true }
    },


    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true }
    },

    -- disable titelbar for client
    {
        rule_any = {
            instance = {
                "copyq",
                "nautilus",
                "org.gnome.Nautilus",
                'kitty'
            },
            class = {
                'URxvt',
                'UXterm',
                'Alacritty',
                'TelegramDesktop',
                'obsidian',
                "mpv",
                "Sxiv",
                "firefox",
                "Files",
                "Zathura"
            },
        },
        properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    {
        rule = { class = "Firefox" },
        properties = { screen = 1, tag = "2" }
    },
}
