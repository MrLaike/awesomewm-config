local awful = require("awful")
local top_panel = require("panel.top")
local right_panel = require("panel.right")

awful.screen.connect_for_each_screen(function(screen)
    --local taglist = require("widgets.taglist")(screen)
    --local tasklist = require("widgets.tasklist")(screen)
    --local layoutbox = require("widgets.panel.layoutbox")(screen)
    --local launcher = require("widgets.panel.menu").launcher

    top_panel(screen)
    screen.right_panel = right_panel(screen)
    -- Wallpaper
    set_wallpaper(screen)

    -- Create a promptbox for each screen
    screen.promptbox = awful.widget.prompt()

    function custom_shape(cr, width, height, radius)
        gears.shape.rounded_rect(cr, 500, height, 10)
    end

    -- Создаем панель
    --[[
    screen.wibox = awful.wibar({
        screen      = screen,
        shape       = custom_shape,
    })

    -- Добавляем виджеты на панель
    screen.wibox:setup {
        {
            layout = wibox.layout.align.horizontal,
            {
                launcher,
                layout = wibox.layout.fixed.horizontal,
                taglist,
                screen.promptbox,
            },
            tasklist,
            {
                layout = wibox.layout.fixed.horizontal,
                layoutbox,
                {
                    top = 5, bottom = 5,
                    layout = wibox.container.margin,
                    {
                        bg = "#ffe321",
                        widget = wibox.container.background
                    },
                },
                wibox.widget.systray(),
            },
        },
        top = 5, bottom = 5, left = 10, right = 10,
        layout = wibox.container.margin,
    }
    ]]--
end)
