-- Всплывающая модалка со слайдером для регулировки громкости
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local slider = wibox.widget {
    nil,
    {
        id 					= 'vol_osd_slider',
        bar_shape           = gears.shape.rounded_rect,
        bar_height          = dpi(24),
        bar_color           = '#ffffff20',
        bar_active_color	= '#f2f2f2EE',
        handle_color        = '#ffffff',
        handle_shape        = gears.shape.circle,
        handle_width        = dpi(24),
        handle_border_color = '#00000012',
        handle_border_width = dpi(1),
        maximum				= 100,
        widget              = wibox.widget.slider
    },
    nil,
    expand = 'none',
    layout = wibox.layout.align.vertical
}
