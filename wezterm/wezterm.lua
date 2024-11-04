local wezterm = require('wezterm')
local act = wezterm.action

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then config = wezterm.config_builder() end

-- settings
config.color_scheme = "Tokyo Night"
config.font = wezterm.font("DejaVu Sans Mono")
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = ""

-- Keys
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
  -- Send C-a when pressing C-a twice
    { key = "a", mods = "LEADER", action = act.SendKey { key = "a", mods = "CTRL"} },
    { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
    -- Vertical split with CTRL + |
    { key = "|", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    -- Horizontal split with CTRL + -
    { key = "-", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    -- Close current pane with CTRL + x (optional)
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },

}

return config
