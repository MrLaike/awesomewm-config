local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local spawn = require("awful.spawn")
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local apps = require("configs.apps")

local volume = function ()
    local trim = require('scripts.utils').trim;
    local icon_font = beautiful.wibar_icon_font_name .. " " .. beautiful.wibar_icon_font_size
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

    local update = function ()
        local get_active_sink_line = "pacmd list-sinks | awk '/index:/{i++} /* index:/{print i; exit}'"
        awful.spawn.easy_async_with_shell(get_active_sink_line, function(line)
            local line_number = trim(line);
            local muted = "pacmd list-sinks | awk '/^\\smuted:/{i++} i==\"" .. line_number .. "\" {print $2; exit}'"

            awful.spawn.easy_async_with_shell(muted, function (status)
                if trim(status) == "yes" then
                    slider_icon.text= "婢"
                    slider_volume.text = ""
                else
                    local get_volume = "pacmd list-sinks | awk '/^\\svolume:/{i++} i==\"" .. line_number .. "\" {print $5; exit}'"

                    awful.spawn.easy_async_with_shell(get_volume, function (output)

                        slider_icon.text= "墳"
                        slider_volume.text = output

                    end)
                end
            end)
        end)
    end

    update()

    -- Добавляем событие на пракрутку колесика мышки(увел/умен громкость)
    slider:buttons(
            gears.table.join(
                    awful.button(
                            {},
                            4,
                            nil,
                            function ()
                                awful.spawn(apps.pactl.volume .. ' +10%')
                                update()
                            end
                    ),
                    awful.button(
                            {},
                            5,
                            nil,
                            function ()
                                awful.spawn(apps.pactl.volume .. ' -10%')
                                update()
                            end
                    )
            )
    )



    -- Нужет для обновление значение громкости
    awesome.connect_signal(
            'widget::volume',
            function ()
                update()
            end
    )

    return slider
end

return volume
