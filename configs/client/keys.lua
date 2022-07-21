local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local vertical_bar = require("modules.titlebar").vertical_bar
local dpi = require("beautiful.xresources").apply_dpi
local bling = require('modules.bling')

local modkey    = "Mod4"
local ctrlkey   = "Control"
local shiftkey  = "Shift"

local resize_client = function(client, direction)
    if client.floating == true then
        local temp = function ()
            if(direction == "down") then
                return { w = 0, h = dpi(20) }
            elseif (direction == 'up') then
                return { w = 0, h = dpi(20) }
            elseif (direction == 'left') then
                return { w = dpi(-20), h = 0 }
            elseif (direction == 'right') then
                return { w = dpi(20), h = 0 }
            end
        end
        client:relative_move(0,  0, temp().w, temp().h)
    else

        if(direction == 'down' and direction== 'up') then
            awful.tag.incmwfact(-0.05)
        else
            awful.tag.incmwfact(-0.05)
        end
    end
end

local move_client = function (client, direction)
    if (client.floating == true) then
        local temp = function ()
            if(direction == "down") then
                return { x = 0, y = 10 }
            elseif (direction == 'up') then
                return { x = 0, y = -10 }
            elseif (direction == 'left') then
                return { x = -10, y = 0 }
            elseif (direction == 'right') then
                return { x = 10, y = 0 }
            end
        end
        client:relative_move(temp().x, temp().y, 0, 0)
    else
        awful.client.swap.bydirection(direction);
    end
end


local clientkeys = gears.table.join(
        awful.key({ modkey,         }, "f", function (c) c.fullscreen = not c.fullscreen end, {description = "Переключать полноэкранный режим окон",  group = "client"}),
        awful.key({ modkey,         }, "q", function (c) c:kill() end,                        {description = "Закрыть программу",                     group = "client"}),
        awful.key({ modkey,         }, "space", awful.client.floating.toggle,                 {description = "Переключать плавающий режим окон",      group = "client"}),
        awful.key({ modkey,         }, "o", function (c) c:move_to_screen() end,              {description = "Перенести окно на другой экран",        group = "client"}),

        awful.key({ modkey,         }, "n", function (c) c.minimized = true end ,             {description = "Свернуть окно",                         group = "client"}),


        -- Управление слоями и клиентами
        awful.key({ modkey,           }, "j", function() awful.client.focus.bydirection("down")  bling_flush(client.focus) end,   {description = "Фокус на нижнее окно",              group = "client"}),
        awful.key({ modkey,           }, "h", function() awful.client.focus.bydirection("left")  bling_flush(client.focus) end,   {description = "Фокус на левое окно",               group = "client"}),
        awful.key({ modkey,           }, "l", function() awful.client.focus.bydirection("right") bling_flush(client.focus) end,   {description = "Фокус на правое окно",              group = "client"}),
        awful.key({ modkey,           }, "k", function() awful.client.focus.bydirection("up")    bling_flush(client.focus) end,   {description = "Фокус на верхнее окно",             group = "client"}),
        awful.key({ modkey,           }, "b", function() lock_screen_show()    end,   {description = "Фокус на верхнее окно",             group = "client"}),

        awful.key({ modkey, shiftkey  }, "j", function (c) move_client(c, 'down') end,    {description = "Переместить окно вниз",             group = "client"}),
        awful.key({ modkey, shiftkey  }, "h", function (c) move_client(c, 'left') end,    {description = "Переместить окно влево",            group = "client"}),
        awful.key({ modkey, shiftkey  }, "l", function (c) move_client(c, 'right') end,   {description = "Переместить окно вправо",           group = "client"}),
        awful.key({ modkey, shiftkey  }, "k", function (c) move_client(c, 'up') end,      {description = "Переместить окно вверх",            group = "client"}),

        awful.key({ modkey, ctrlkey   }, "h", function () awful.screen.focus_relative( 1) end,          {description = "Переключиться на другой экран",     group = "screen"}),
        awful.key({ modkey, ctrlkey   }, "l", function () awful.screen.focus_relative(-1) end,          {description = "focus the previous screen",         group = "screen"}),
        --awful.key({ modkey, shiftkey  }, "Tab", function () awful.layout.inc(-1) end,                   {description = "Предыдущее окно",                   group = "client"}),

        awful.key({ modkey, shiftkey }, "w", function (c)
            if c.floating then
                c.ontop=true
                c.sticky=true
                c.width=533
                c.height=300
                awful.placement.bottom_right(c.focus)
            end
        end, {description = "Прикрепляем плавающее окно поверх всех столов, в правом нижнем углу", group = "client"}),

        awful.key({ modkey, ctrlkey }, "n",
                function ()
                    local c = awful.client.restore()
                    if c then
                        c:emit_signal("request::activate", "key.unminimize", {raise = true})
                    end
                end,                                                                          {description = "Развернуть окно",                       group = "client"}),

        awful.key({ modkey, ctrlkey, shiftkey }, "h", function(c)
            if c.floating == true then
                c:relative_move(  0,  0, dpi(-20), 0)
            else
                awful.tag.incmwfact(0.05)
            end
        end,                                                                                  {description = "Уменьшаем окно(слева)",                 group = "client" }),

        awful.key({ modkey, ctrlkey, shiftkey }, "l", function(c)
            if c.floating == true then
                c:relative_move(  0,  0, dpi(20), 0)
            else
                awful.tag.incmwfact(0.05)
            end
        end,                                                                                  {description = "Увеличить окно(слева)",                 group = "client" }),

        awful.key({ modkey, ctrlkey, shiftkey   }, "k", function(c)
            if c.floating == true then
                c:relative_move(  0, 0, 0, dpi(-20))
            else
                awful.client.incwfact(0.05)
            end
        end,                                                                                  {description = "Уменьшить окно(вверх)",                 group = "client" }),

        awful.key({ modkey, ctrlkey, shiftkey   }, "j", function(c)
            if c.floating == true then
                c:relative_move( 0, 0, 0, dpi(20))
            else
                awful.client.incwfact(-0.05)
            end
        end,                                                                                  {description = "Увеличить окно(вверх)",                 group = "client" }),

        awful.key({ modkey, shiftkey  }, "c", function (c)
            local bg = beautiful.bg_titlebar or "#00000088"
            if beautiful.titlebar_hidden == true then
                vertical_bar(c, "left", bg, 40, false)
                beautiful.titlebar_hidden = false
            else
                vertical_bar(c, "left", bg, 40, true)
                beautiful.titlebar_hidden = true
            end
        end, {description = "(un)maximize horizontally", group = "client"})

--        awful.key({ modkey,           }, "m", function (c) c.maximized = not c.maximized c:raise() end, {description = "(un)maximize", group = "client"}),
--        awful.key({ modkey, ctrlkey }, "Return", function (c) c:swap(awful.client.getmaster()) end, {description = "move to master", group = "client"}),
)

return clientkeys