local wt = require("wezterm")
local act = wt.action
local config = {}

config.color_scheme = "GruvboxDarkHard"

config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#d5c4a1",
      fg_color = "#3c3836",
    },

    background = "#1d2021",
  },
}

config.default_prog = { "fish" }

config.freetype_load_target = "HorizontalLcd"
config.font = wt.font("JetBrains Mono")
config.font_size = 11.5
config.initial_cols = 126
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
  { key = "e", mods = "SUPER", action = act.SpawnCommandInNewTab({ args = { "nvim" } }) },
  { key = "e", mods = "SUPER|CTRL", action = act.SpawnCommandInNewWindow({ args = { "nvim" } }) },
  { key = "g", mods = "SUPER", action = act.SpawnCommandInNewTab({ args = { "lazygit" } }) },
  { key = "h", mods = "SUPER", action = act.ActivateTabRelative(-1) },
  { key = "h", mods = "SUPER|CTRL", action = act.MoveTabRelative(-1) },
  { key = "l", mods = "SUPER", action = act.ActivateTabRelative(1) },
  { key = "l", mods = "SUPER|CTRL", action = act.MoveTabRelative(1) },
  { key = "s", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "s", mods = "SUPER|CTRL", action = act.SpawnWindow },
  { key = 'u', mods = 'SUPER|CTRL', action = wt.action.CharSelect {
    copy_on_select = true,
    copy_to = 'ClipboardAndPrimarySelection',
  }},
}

config.line_height = 1.05

config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = true

config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"

config.window_frame = {
  inactive_titlebar_bg = "#1d2021",
  active_titlebar_bg = "#1d2021",
  font = wt.font("JetBrains Mono", { stretch = "Condensed", weight = "Regular" }),
  font_size = 10.0,
}

config.window_padding = { top = 8, right = 8, bottom = 8, left = 8 }

return config
