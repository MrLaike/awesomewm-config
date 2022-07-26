local awful = require("awful")

-- names/numbers of layouts
local names = { "一", "二", "三", "四", "五", "六", "七", "八", "九", }

screen.connect_signal("request::desktop_decoration", function(s)
    screen[s].padding = { left = 0, right = 0, top = 0, bottom = 0 }
    awful.tag(names, s, awful.layout.layouts[1])
end)