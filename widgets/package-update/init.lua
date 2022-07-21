local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi
local watch = awful.widget.watch
local clickable_container = require('widgets.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local icon_dir = config_dir .. 'widget/battery/icons/'

local update_available = false

local package_updater = function ()
  local widget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    {
      id = 'icon',
      -- image = icon_dir
      widget = wibox.widget.textbox,
      text = 'Update not found'
      --resize = true
    },
  }

  local button = wibox.widget {
    {
      widget,
      margin = dpi(5),
      widget = wibox.container.margin
    },
    widget = clickable_container 
  } 

  button:buttons(
    gears.table.join(
      awful.button(
        {}, 1, nil, 
        function () 
          awful.spawn('alacritty') 
        end
      )
    )
  )

  -- Всплывающая подсказка
  local tooltip = awful.tooltip {
    objects = { button },
    align = 'right',
    margin_leftright = dpi(8),
    margin_topbottom = dpi(8),
    timer_function = function ()
      if update_available then
        return packages:gsub('\n$', '')
      else
        return 'Updated'
      end
    end
  }

  local show_warning = function (percent)
    naughty.notification ({
      -- icon = ''
      app_name = 'System notification',
      title = 'Battery',
      message = 'battery ' .. percent .. '%'
    })
  end

  watch(
    'checkupdates',
    10,
    function (_, stdout)
      packages = stdout
      local text = nil
      if packages ~= nil then
        update_available = true
        --icon_name = 'package-up'
        text = 'Update found'
      else
        update_available = false
        --icon_name = 'package'
        text = 'Update not found'
      end
      --widget.icon:set_image(widget_icon_dir .. icon_name .. '.svg')
      widget.icon:set_text(text)
    end
  )

  return button
end

return package_updater
