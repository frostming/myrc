local wezterm = require('wezterm')

return {
    font = wezterm.font('OperatorMono Nerd Font Mono', {weight="Book"}),
    font_size = 15,
    color_scheme = 'Dracula',
    window_frame = {
        font_size = 15.0,
    },
    window_padding = {
        left = 15,
        right = 15,
        top = 0,
        bottom = 0,
    },
    window_background_opacity = 0.85,
    use_ime = true, -- fixed chinese input
    default_cwd = wezterm.home_dir .. 'wkspace/github',
    keys = {
        { key = 'l', mods = 'CMD', action = 'ShowLauncher' },
        { key = 'w', mods = 'CMD', action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
        { key = '"', mods = 'CMD', action = wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
        { key = '/', mods = 'CMD', action = wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    },
}
