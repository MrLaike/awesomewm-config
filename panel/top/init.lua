local wibox     = require("wibox")
local awful     = require("awful")
local naughty = require("naughty")
local gears     = require("gears")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local taglist   = require("widgets.taglist")

local custom_shape = function(cr, width, height, radius)
  radius = beautiful.wibar_radius or radius or 6
  gears.shape.rounded_rect(cr, width, height, radius)
end

local top_panel = function(screen)
  local textclock             = wibox.widget.textclock()
  local tools_panel_toggle    = require("widgets.tools-panel-toggle")
  local volume                = require("widgets.volume-slider")()
  local panel_height_half     = beautiful.wibar_height /2
  local offsetx               = beautiful.panel_offsetx or 0
  local systray               = wibox.widget.systray();
  local battery               = require('widgets.battery')()
  local package_updater       = require('widgets.package-update')()

  -- Кастыль: Отступ сверху
  if(beautiful.wibar_margins) then
    local panel     = awful.wibar {
      stretch = false,
      screen = screen,
      height = beautiful.wibar_margins,
    }
  end

  local panel = awful.wibar {
    position    = "top",
    screen = screen,
    x = screen.geometry.x + offsetx,
    width = screen.geometry.width - dpi(20),
    height = dpi(40),
    shape = gears.shape.rounded_rect,
    bg = "#333333"
  }

  panel:setup {
    layout = wibox.layout.align.horizontal,
    expand = 'none',
    {
      {
        left    = 5,
        right   = 5,
        top     = 5,
        bottom  = 5,
        layout  = wibox.layout.margin,
        volume,
      },
      {
        left    = 5,
        right   = 5,
        top     = 5,
        bottom  = 5,
        layout  = wibox.layout.margin,
        battery,
      },
      package_updater,
      layout = wibox.layout.fixed.horizontal,
            --bg = beautiful.bg_systray,
    },
    {
      left = 15,
      layout = wibox.layout.margin,
      taglist(screen),
    },
    {
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(5),
      textclock,
      tools_panel_toggle()
    },
    margins = {left = dpi(5)}
  }

  return panel
end
return top_panel
