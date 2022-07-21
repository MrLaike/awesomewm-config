local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi
local watch = awful.widget.watch
local clickable_container = require('widgets.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local icon_dir = config_dir .. 'widget/battery/icons/'

local battery = function ()
  local imagebox = wibox.widget {
    nil,
    {
      id = 'icon',
      -- image = icon_dir
      widget = wibox.widget.imagebox
    },
    nil,
    layout = wibox.layout.align.horizontal
  }
  
  local percent_text = wibox.widget {
    id = 'percent_text',
    text = '100%',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  local widget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    -- imagebox,
    percent_text,
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
          awful.spawn('kitty') 
        end
      )
    )
  )
  

  -- Всплывающая подсказка
  local tooltip = awful.tooltip {
    objects = { button },
    align = 'right',
    text = 'Empty',
  }
  local get_info = function ()
    awful.spawn.easy_async_with_shell(
      'upower -i $(upower -e | grep BAT)',
      function (stdout)
        tooltip:set_text(stdout:sub(1, -2))
      end
    )
  end

  widget:connect_signal(
    'mouse::enter',
    function() 
      get_info()
    end
  )

  local show_warning = function (percent)
    naughty.notification ({
      -- icon = ''
      app_name = 'System notification',
      title = 'Battery',
      message = 'battery ' .. percent .. '%'
    })
  end

  local update = function (status)
    awful.spawn.easy_async_with_shell(
      "upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}' | tr -d '\n%'",
      function (stdout)
        -- В выхлоп поподает процент заряда батарейки
        local percentage = tonumber(stdout)


        -- Если низкий заряд батареи то выводим предупреждение
        if (percentage > 0 and percentage < 60) and (status == 'discharging') then
          show_warning(percentage)
        end

        widget.spacing = dpi(5)
        percent_text.visible = true
        percent_text:set_text(percentage .. '%')

        --imagebox.icon:set_image()

      end
    )
  end

  watch(
    "upower -i $(upower -e | grep BAT) | grep state | awk '{print $2}' | tr -d '\n'",
    5,
    function (widget, stdout)
      status = stdout:gsub('%\n', '')
      update(status)
    end
  )

  return button
end

return battery
