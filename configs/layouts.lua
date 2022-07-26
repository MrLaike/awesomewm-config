local bling = require('modules.bling')
local awful = require("awful")
local layout_machi = require('modules.layout-machi')
require("beautiful").layout_machi = layout_machi.get_icon()

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
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        equal,
        layout_machi.layout.create { new_placement_cb = layout_machi.layout.placement.empty},
        layout_suit.floating,
        mstab,
        layout_suit.tile,
        deck })
end)