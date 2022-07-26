local naughty = require('naughty')
local ruled = require('ruled')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi

naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(100)
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = 'System Notification'
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'

naughty.config.padding = dpi(8)
naughty.config.spacing = dpi(8)
naughty.config.icon_dirs = {
    '/usr/share/icons/Tela',
    '/usr/share/icons/Tela-blue-dark',
    '/usr/share/icons/Papirus/',
    '/usr/share/icons/la-capitaine-icon-theme/',
    '/usr/share/icons/gnome/',
    '/usr/share/icons/hicolor/',
    '/usr/share/pixmaps/'
}
naughty.config.icon_formats = { 'svg', 'png', 'jpg', 'gif' }

ruled.notification.connect_signal(
        'request::rules',
        function()
            ruled.notification.append_rule {
                rule = { urgency = 'critical' },
                properties = {
                    bg = '#ff0000',
                    fg = '#ffffff',
                    margin = dpi(8),
                    position = 'top_right',
                    implicit_timeout = 0
                }
            }
            ruled.notification.append_rule {
                rule = { urgency = 'normal' },
                properties = {
                    widget_template = {
                        {
                            naughty.widget.icon,
                            forced_height = dpi(100),
                            halign = "center",
                            valign = "center",
                            widget = wibox.container.place
                        },
                        margins = dpi(8),
                        widget = wibox.container.margin,
                    },
                    bg = '#333333',
                    fg = '#ffffff',
                    margin = dpi(8),
                    minimum_width = dpi(200),
                    position = 'top_right',
                    implicit_timeout = 5
                }
            }

            ruled.notification.append_rule {
                rule = { urgency = 'low' },
                properties = {
                    widget_template = {
                        {
                            naughty.widget.icon,
                            forced_height = dpi(100),
                            halign = "center",
                            valign = "center",
                            widget = wibox.container.place
                        },
                        margins = dpi(8),
                        widget = wibox.container.margin,
                    },
                    bg = '#333333',
                    fg = '#ffffff',
                    margin = dpi(8),
                    minimum_width = dpi(200),
                    position = 'top_right',
                    implicit_timeout = 5
                }
            }
        end
)

