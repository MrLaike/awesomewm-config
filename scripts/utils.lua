local in_array = function (key, array)
    for index, value in ipairs(array) do
        if key == value then
            return true
        end
    end
    return false
end

return {
    in_array = in_array,
}