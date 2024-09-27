-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Gruvbox Dark (Gogh)'
local act = wezterm.action

config.keys = {
  {
    key = 't',
    mods = 'ALT',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'q',
    mods = 'ALT',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  { key = 'h',     mods = 'ALT',  action = act.ActivateTabRelativeNoWrap(-1) },
  { key = 'l',     mods = 'ALT',  action = act.ActivateTabRelativeNoWrap(1) },
  { key = 'H',     mods = 'ALT',  action = act.MoveTabRelative(-1) },
  { key = 'L',     mods = 'ALT',  action = act.MoveTabRelative(1) },
  { key = "Enter", mods = "CTRL", action = act.ToggleFullScreen },
  {
    key = 'v',
    mods = 'ALT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'x',
    mods = 'ALT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = "s",
    mods = "ALT",
    action = act.ActivatePaneDirection "Left",
  },
  {
    key = "f",
    mods = "ALT",
    action = act.ActivatePaneDirection "Right",
  },
  {
    key = "e",
    mods = "ALT",
    action = act.ActivatePaneDirection "Up",
  },
  {
    key = "d",
    mods = "ALT",
    action = act.ActivatePaneDirection "Down",
  },
}

config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"
config.window_background_opacity = 1
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_fancy_tab_bar = true
config.max_fps = 120
config.initial_rows = 36
config.initial_cols = 140

-- and finally, return the configuration to wezterm
return config
