local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local apps = require("configs.apps")

return function ()
    local trim = require('scripts.utils').trim;
    local icon_font = beautiful.wibar_icon_font_name .. " " .. beautiful.wibar_icon_font_size
    local step = 5
    local step_percent = tostring(step) .. "%"
    local slider = wibox.widget {
        {
            id = "icon",
            widget = wibox.widget.textbox,
            forced_width = dpi(20),
            font = icon_font,
            text = "墳",
        },
        {
            id = "volume",
            widget = wibox.widget.textbox,
            text = "0%",
        },
        layout = wibox.layout.align.horizontal
    }

    -- Получаем внутренний виджет по id
    local slider_volume = slider.volume
    local slider_icon = slider.icon

    local mute_volume = function()
        awful.spawn(apps.pactl.mute .. ' toggle')
        local get_active_sink_line = "pacmd list-sinks | awk '/index:/{i++} /* index:/{print i; exit}'"

        awful.spawn.easy_async_with_shell(get_active_sink_line, function(line)
            local line_number = trim(line);
            local muted = "pacmd list-sinks | awk '/^\\smuted:/{i++} i==\"" .. line_number .. "\" {print $2; exit}'"

            awful.spawn.easy_async_with_shell(muted, function (status)
                slider_icon.text= "婢"
                slider_volume.text = ""
            end)
        end)

        end

    local change_volume = function(value)
        -- -10% or +10%
        awful.spawn(apps.pactl.volume .. ' ' .. value)
        local get_active_sink_line = "pacmd list-sinks | awk '/index:/{i++} /* index:/{print i; exit}'"

        awful.spawn.easy_async_with_shell(get_active_sink_line, function(line)
            local line_number = trim(line);
            local get_volume = "pacmd list-sinks | awk '/^\\svolume:/{i++} i==\"" .. line_number .. "\" {print $5; exit}'"

            awful.spawn.easy_async_with_shell(get_volume, function (value)
                slider_icon.text= "墳"
                slider_volume.text = value
            end)
        end)
    end


    -- Добавляем событие на пракрутку колесика мышки(увел/умен громкость)
    slider:buttons(
            gears.table.join(
                    awful.button(
                            {},
                            4,
                            nil,
                            function ()
                                change_volume("+" .. step_percent)
                            end
                    ),
                    awful.button(
                            {},
                            5,
                            nil,
                            function ()
                                change_volume("-" .. step_percent)
                            end
                    )
            )
    )
    -- Нужет для обновление значение громкости
    awesome.connect_signal(
            'widget::volume.up',
            function ()
                change_volume("+" .. step_percent)
            end
    )

    -- Нужет для обновление значение громкости
    awesome.connect_signal(
            'widget::volume.mute',
            function ()
                mute_volume()
            end
    )

    -- Нужет для обновление значение громкости
    awesome.connect_signal(
            'widget::volume.down',
            function ()
                change_volume("-" .. step_percent)
            end
    )

    return slider
end

