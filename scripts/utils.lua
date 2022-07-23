local in_array = function (key, array)
    for index, value in ipairs(array) do
        if key == value then
            return true
        end
    end
    return false
end

local custom_shape = function(cr, width, height, radius)
    local gears = require("gears")
    local beautiful = require("beautiful")
    radius = beautiful.wibar_radius or radius or 6
    gears.shape.rounded_rect(cr, width, height, radius)
end


return {
    in_array = in_array,
    custom_shape = custom_shape,
}