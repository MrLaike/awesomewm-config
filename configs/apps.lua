-- pactl info | grep 'Sink:' | awk '{split($0,a); print a[3];}'
local alsa_output = '@DEFAULT_SINK@' --'alsa_output.pci-0000_05_00.6.analog-stereo';
local apps = {
    rofi_launcher   = 'rofi -show combi',
    launcher        = 'launcher',
    rofi_search     = 'rofi -modi "Global Search":"~/.config/rofi/search/rofi-spotlight.sh" -show "Global Search" -config ~/.config/rofi/search/rofi.rasi',
    krita           = 'krita',
    terminal        = 'alacritty',
    browser         = "firefox",
    filemanager     = "thunar",
    editor          = os.getenv("EDITOR") or "nvim",
    multimedia      = 'mpv',
    game            = 'steam',
    graphics        = 'krita',
    development     = '',
    sandbox         = '',
    feh             = 'feh',
    flameshot       = 'flameshot gui',

    backlight       = 'brightnessctl',
    pactl           = {
        volume      = "pactl set-sink-volume " .. alsa_output,
        mute        = "pactl set-sink-mute " .. alsa_output
    }
}

apps['editor_cmd'] = apps.terminal .. " -e " .. apps.editor

return apps
