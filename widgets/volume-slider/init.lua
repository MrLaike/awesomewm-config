local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local spawn = require("awful.spawn")
local awful = require("awful")
local dpi = require('beautiful').xresources.apply_dpi

local volume = function ()
  local step = 5
  local slider = wibox.widget {
    nil,
    {
      id = 'volume',
      bar_shape = gears.shape.rounded_rect,
      bar_height = dpi(12),
      forced_width = dpi(100),
      bar_color = '#ffffff20',
      bar_active_color= '#f2f2f2EE',
      handle_color = '#ffffff',
      handle_shape = gears.shape.circle,
      handle_width = dpi(12),
      handle_border_color = '#00000012',
      handle_border_width = dpi(0),
      maximum = 100,
      widget = wibox.widget.slider
    },
    nil,
    expand = 'none',
    layout = wibox.layout.align.vertical
  }

  -- Получаем внутренний виджет по id
  local slider_volume = slider.volume

  -- При изменении значения слайдера вызываем функцию
  slider_volume:connect_signal(
    'property::value',
    function ()
      local value = slider_volume:get_value()

      awful.spawn('pactl set-sink-volume 0 ' .. value .. '%', false)
    end
  )

  -- Добавляем событие на пракрутку колесика мышки(увел/умен громкость)
  slider_volume:buttons(
    gears.table.join(
      awful.button(
        {},
        4,
        nil,
        function ()
          local value = slider_volume:get_value()
          if value > 100 then
            slider_volume:set_value(100)
            return
          end
          slider_volume:set_value(value + step)
        end
      ),
      awful.button(
        {},
        5,
        nil,
        function ()
          local value = slider_volume:get_value()
          if value < 0 then
            slider_volume:set_value(0)
            return
          end
          slider_volume:set_value(value - step)
        end
      )
    )
  )

  local update = function ()

    awful.spawn.easy_async_with_shell(
      "pacmd list-sinks | awk '/^\\svolume:/ {print \"volume: \"$5}; /muted:/ {print \"muted: \"$2};' | awk 'FNR <=2'",
      function (output)
        local muted = string.match(output, ":%s(%a+)")
        local volume = string.match(output, "%d+")

        slider_volume:set_value(tonumber(volume))
      end
    )
  end

  update()

  local widget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    slider
  }

  -- Нужет для обновление значение громкости
  awesome.connect_signal(
    'widget::volume',
    function ()
      update()
    end
  )

  -- Создаем сигнал для OSD (On-screen display). Всплывающее окно для регулировки громкости
  -- Нужен для установки значение громкости через OSD
  awesome.connect_signal(
    'widget::volume:update',
    function (value)
      slider_volume:set_value(tonumber(value))
    end
  )

  return widget
end

return volume
