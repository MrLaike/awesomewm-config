local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local apps = require("configs.apps")
local bling = require('modules.bling')
local layout_machi = require('modules.layout-machi')
local beautiful = require("beautiful")
local vertical_bar = require("modules.titlebar").vertical_bar
local dpi = require("beautiful.xresources").apply_dpi

require("modules.lockscreen").init()

local modkey = "Mod4"
local ctrlkey = "Control"
local shiftkey = "Shift"

bling.widget.window_switcher.enable {
    type = "thumbnail",

    hide_window_switcher_key = "Escape",
    minimize_key = "n",
    unminimize_key = "N",
    kill_client_key = "q",
    cycle_key = "Tab",
    previous_key = "Left",
    next_key = "Right",
    vim_previous_key = "h",
    vim_next_key = "l",

    cycleClientsByIdx = awful.client.focus.byidx,
    filterClients = awful.widget.tasklist.filter.all,
}

local move_client = function(client, direction)
    if (client.floating == true) then
        local temp = function()
            if (direction == "down") then
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

local bling_flush = function(client)
    bling.module.flash_focus.flashfocus(client.focus)
end

awful.mouse.append_global_mousebindings({
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end),
        awful.button({ modkey }, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({ modkey }, 3, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end)
    })
end)

-- Запусек программ
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "Return", function()
        awful.spawn(apps.terminal)
    end, { description = "Открыть терминал", group = "launcher" }),
    awful.key({ modkey }, "d", function()
        awful.spawn(apps.rofi_launcher)
    end, { description = "run rofi", group = "launcher" }),
    awful.key({ modkey }, "p", function()
        awful.spawn(apps.launcher)
    end, { description = "run search", group = "launcher" }),
    awful.key({ modkey, }, "s", function()
        awful.spawn(apps.rofi_search)
    end, { description = "Плашка с hotkey'ми", group = "awesome" }),
    awful.key({ }, "Print", function()
        awful.spawn(apps.flameshot)
    end, { description = "show the menubar", group = "fn" }),
})


-- Системные
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, ctrlkey }, "r", awesome.restart, { description = "Перезапустить awesome", group = "awesome" }),
    awful.key({ modkey, shiftkey }, "q", awesome.quit, { description = "Завершить сессию", group = "awesome" }),

    awful.key({ modkey, }, "/", hotkeys_popup.show_help, { description = "Плашка с hotkey'ми", group = "awesome" }),

    awful.key({ modkey, }, "Tab", function()
        awesome.emit_signal("bling::window_switcher::turn_on")
    end, { description = "Следующее окно", group = "client" }),

    awful.key({ modkey, }, "b", function()
        lock_screen_show()
    end, { description = "Фокус на верхнее окно", group = "client" }),
})

-- Слои из библиотеки machi
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, ".", function()
        layout_machi.default_editor.start_interactive()
    end, { description = "edit current layout", group = "layout" }),
    awful.key({ modkey, shiftkey }, ".", function()
        layout_machi.switcher.start(client.focus)
    end, { description = "switch between windows for a machi layout", group = "layout" }),
})


-- Функциональные клавиши
awful.keyboard.append_global_keybindings({
    awful.key({ }, "XF86MonBrightnessUp", function()
        awful.spawn(apps.backlight .. ' s 10%+')
    end, { description = "Увеличить яркость", group = "fn" }),
    awful.key({ }, "XF86MonBrightnessDown", function()
        awful.spawn(apps.backlight .. ' s 10%-')
    end, { description = "Уменьшить яркость", group = "fn" }),
    awful.key({ }, "XF86AudioRaiseVolume", function()
        awesome.emit_signal('widget::volume.up')
    end, { description = "Увеличить громкость", group = "fn" }),
    awful.key({ }, "XF86AudioMute", function()
        awesome.emit_signal('widget::volume.mute')
    end, { description = "Замутить", group = "fn" }),
    awful.key({ }, "XF86AudioLowerVolume", function()
        awesome.emit_signal('widget::volume.down')
    end, { description = "Уменьшить громкость", group = "fn" }),
})

-- Управление слоями и клиентами
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "j", function()
        awful.client.focus.bydirection("down")
        bling_flush(client.focus)
    end, { description = "Фокус на нижнее окно", group = "client" }),
    awful.key({ modkey, }, "h", function()
        awful.client.focus.bydirection("left")
        bling_flush(client.focus)
    end, { description = "Фокус на левое окно", group = "client" }),
    awful.key({ modkey, }, "l", function()
        awful.client.focus.bydirection("right")
        bling_flush(client.focus)
    end, { description = "Фокус на правое окно", group = "client" }),
    awful.key({ modkey, }, "k", function()
        awful.client.focus.bydirection("up")
        bling_flush(client.focus)
    end, { description = "Фокус на верхнее окно", group = "client" }),

    awful.key({ modkey, ctrlkey }, "h", function()
        awful.screen.focus_relative(1)
    end, { description = "Переключиться на другой экран", group = "screen" }),
    awful.key({ modkey, ctrlkey }, "l", function()
        awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, ctrlkey }, "k", awful.tag.viewprev, { description = "view previous", group = "tag" }),
    awful.key({ modkey, ctrlkey }, "j", awful.tag.viewnext, { description = "view next", group = "tag" }),

    awful.key({ modkey, shiftkey }, "j", function()
        move_client(client.focus, 'down')
    end, { description = "Переместить окно вниз", group = "client" }),
    awful.key({ modkey, shiftkey }, "h", function()
        move_client(client.focus, 'left')
    end, { description = "Переместить окно влево", group = "client" }),
    awful.key({ modkey, shiftkey }, "l", function()
        move_client(client.focus, 'right')
    end, { description = "Переместить окно вправо", group = "client" }),
    awful.key({ modkey, shiftkey }, "k", function()
        move_client(client.focus, 'up')
    end, { description = "Переместить окно вверх", group = "client" }),

    awful.key({ modkey, }, "=", function()
        awful.tag.incgap(1)
    end, { description = "show the menubar", group = "launcher" }),
    awful.key({ modkey, }, "-", function()
        awful.tag.incgap(-1)
    end, { description = "show the menubar", group = "launcher" }),

    awful.key({ modkey, }, "space", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ modkey, shiftkey }, "space", function()
        awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),

    awful.key({ modkey, ctrlkey, shiftkey }, "h", function()
        local client = client.focus
        if client.floating == true then
            client:relative_move(0, 0, dpi(-20), 0)
        else
            awful.tag.incmwfact(0.05)
        end
    end, { description = "Уменьшаем окно(слева)", group = "client" }),

    awful.key({ modkey, ctrlkey, shiftkey }, "l", function()
        local client = client.focus
        if client.floating == true then
            client:relative_move(0, 0, dpi(20), 0)
        else
            awful.tag.incmwfact(0.05)
        end
    end, { description = "Увеличить окно(слева)", group = "client" }),

    awful.key({ modkey, ctrlkey, shiftkey }, "k", function()
        local client = client.focus
        if client.floating == true then
            client:relative_move(0, 0, 0, dpi(-20))
        else
            awful.client.incwfact(0.05)
        end
    end, { description = "Уменьшить окно(вверх)", group = "client" }),

    awful.key({ modkey, ctrlkey, shiftkey }, "j", function()
        local client = client.focus
        if client.floating == true then
            client:relative_move(0, 0, 0, dpi(20))
        else
            awful.client.incwfact(-0.05)
        end
    end, { description = "Увеличить окно(вверх)", group = "client" }),
})

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey, }, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, { description = "Переключать полноэкранный режим окон", group = "client" }),
        awful.key({ modkey }, "q", function(c)
            c:kill()
        end, { description = "close", group = "client" }),
        awful.key({ modkey, }, "space", awful.client.floating.toggle, { description = "Переключать плавающий режим окон", group = "client" }),
        awful.key({ modkey, ctrlkey }, "Return", function(c)
            c:swap(awful.client.getmaster())
        end, { description = "move to master", group = "client" }),
        awful.key({ modkey, }, "o", function(c)
            c:move_to_screen()
        end, { description = "move to screen", group = "client" }),
        awful.key({ modkey, }, "t", function(c)
            c.ontop = not c.ontop
        end, { description = "toggle keep on top", group = "client" }),
        awful.key({ modkey, }, "n", function(c)
            c.minimized = true
        end, { description = "Свернуть окно", group = "client" }),
        awful.key({ modkey, }, "z", function(c)
            c.maximized = not c.maximized
            c:raise()
        end, { description = "(un)maximize", group = "client" }),

        awful.key({ modkey, shiftkey }, "w", function(c)
            c.sticky = false
            if c.floating then
                c.ontop = true
                c.sticky = true
                c.width = 533
                c.height = 300
                awful.placement.bottom_right(c.focus)
            end
        end, { description = "Прикрепляем плавающее окно поверх всех столов, в правом нижнем углу", group = "client" }),

        awful.key({ modkey, ctrlkey }, "n", function()
            local c = awful.client.restore()
            if c then
                c:emit_signal("request::activate", "key.unminimize", { raise = true })
            end
        end, { description = "Развернуть окно", group = "client" }),

        awful.key({ modkey, shiftkey }, "c", function(c)
            local bg = beautiful.bg_titlebar or "#00000088"
            if beautiful.titlebar_hidden == true then
                vertical_bar(c, "left", bg, 40, false)
                beautiful.titlebar_hidden = false
            else
                vertical_bar(c, "left", bg, 40, true)
                beautiful.titlebar_hidden = true
            end
        end, { description = "(un)maximize horizontally", group = "client" })

    })

end)

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers = { modkey },
        keygroup = "numrow",
        description = "only view tag",
        group = "tag",
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },

    awful.key {
        modifiers = { modkey, ctrlkey },
        keygroup = "numrow",
        description = "toggle tag",
        group = "tag",
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },

    awful.key {
        modifiers = { modkey, shiftkey },
        keygroup = "numrow",
        description = "move focused client to tag",
        group = "tag",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },

    awful.key {
        modifiers = { modkey, ctrlkey, shiftkey },
        keygroup = "numrow",
        description = "toggle focused client on tag",
        group = "tag",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
})
