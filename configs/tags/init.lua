local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local apps = require("configs.apps")
local bling = require('modules.bling')
local layout_machi = require('modules.layout-machi')


-- задаем теги
--local tags = {
--    {
--        type = "terminal",
--        title = "一",
--        --icon = icons.terminal,
--        default_app = apps.terminal,
--        layout = awful.layout.suit.tile
--    },
--    {
--        type = "internet",
--        title = "二",
--        --icon = icons.web_browser,
--        default_app = apps.browser,
--    },
--    {
--        type = "code",
--        title = "三",
--        --icon = icons.text_editor,
--        default_app = apps.editor,
--    },
--    {
--        type = "files",
--        title = "四",
--        --icon = icons.file_manager,
--        default_app = apps.filemanager,
--        --gap = beautiful.useless_gap,
--        --layout = awful.layout.suit.tile
--    },
--    {
--        type = "multimedia",
--        title = "五",
--        --icon = icons.multimedia,
--        default_app = apps.multimedia,
--    },
--    {
--        type = "games",
--        title = "六",
--        --icon = icons.games,
--        default_app = apps.game,
--    },
--    {
--        type = "graphics",
--        title = "七",
--        --icon = icons.graphics,
--        default_app = apps.graphics,
--    },
--    {
--        type = "sandbox",
--        title = "八",
--        --icon = icons.sandbox,
--        default_app = apps.sandbox,
--    },
--    {
--        type = "any",
--        title = "九",
--        --icon = icons.development,
--        default_app = apps.development,
--    },
--    {
--        type = "social",
--        title = "0",
--        default_app = "discord",
--        --gap = beautiful.useless_gap
--    }
--}

--awful.layout.layouts = {
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.tile,
--    awful.layout.suit.floating,
--    -- awful.layout.suit.max,
--    -- awful.layout.suit.tile.left,
--    -- awful.layout.suit.tile.bottom,
--    -- awful.layout.suit.tile.top,
--    -- awful.layout.suit.fair,
--    -- awful.layout.suit.fair.horizontal,
--    -- awful.layout.suit.spiral,
--    -- awful.layout.suit.spiral.dwindle,
--    -- awful.layout.suit.max.fullscreen,
--    -- awful.layout.suit.magnifier,
--    -- awful.layout.suit.corner.nw,
--    -- awful.layout.suit.corner.ne,
--    -- awful.layout.suit.corner.sw,
--    -- awful.layout.suit.corner.se,
--}

local mstab = bling.layout.mstab
local equal = bling.layout.equalarea
local deck = bling.layout.desk
local layout_suit = awful.layout.suit


layout_machi.editor.nested_layouts = {
    ["一"] = deck,
    ["二"] = layout_suit.spiral,
    ["三"] = layout_suit.fair,
    ["四"] = layout_suit.fair.horizontal,
    ["五"] = layout_machi.layout.default_cmd,
    ["六"] = deck,
    ["七"] = deck,
    ["八"] = deck,
    ["九"] = deck,
}
-- names/numbers of layouts
local names = { "一", "二", "三", "四", "五", "六", "七", "八", "九", }


tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        layout_machi.layout.create{ new_placement_cb = layout_machi.layout.placement.empty },
        equal,
        layout_suit.floating,
        mstab,
        layout_suit.tile,
        deck })
end)

screen.connect_signal("request::desktop_decoration", function(s)
    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}
    awful.tag(names, s, awful.layout.layouts[1])
end)

-- Create tags for each screen
--awful.screen.connect_for_each_screen(function(screen)
--    for i, tag in pairs(tags) do
--        awful.tag.add(
--            tag.title or i,
--            {
--                --icon = tag.icon,
--                icon_only = false,
--                layout = tag.layout or awful.layout.suit.tile,
--                gap_single_client = true,
--                gap = tag.gap,
--                screen = screen,
--                default_app = tag.default_app,
--                selected = i == 1
--            }
--        )
--    end
--end)
