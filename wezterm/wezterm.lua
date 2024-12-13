local wezterm = require("wezterm")
local io = require 'io'
local os = require 'os'

local act = wezterm.action
local config = wezterm.config_builder()

config.color_scheme = "Gruvbox Dark (Gogh)"
config.hide_tab_bar_if_only_one_tab = true
config.enable_scroll_bar = true
config.audible_bell = "Disabled"
config.window_background_opacity = 1
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_fancy_tab_bar = true
config.max_fps = 120
config.initial_rows = 36
config.initial_cols = 140
config.adjust_window_size_when_changing_font_size = false

local function close_copy_mode()
	return act.Multiple({
		act.CopyMode("ClearSelectionMode"),
		act.CopyMode("ClearPattern"),
		act.CopyMode("Close"),
    act.CopyMode 'MoveToScrollbackBottom'
	})
end


wezterm.on('trigger-vim-with-scrollback', function(window, pane)
  -- Retrieve the text from the pane
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

  -- Create a temporary file to pass to vim
  local name = os.tmpname()
  local f = io.open(name, 'w+')
  f:write(text)
  f:flush()
  f:close()

  -- Open a new window running vim and tell it to open the file
  window:perform_action(
    act.SpawnCommandInNewWindow {
      args = {
        "/opt/nvim-linux64/bin/nvim",
        "-c",
        "setlocal nonumber nolist showtabline=0 foldcolumn=0|Man!'",
        "-c",
        "autocmd VimEnter * normal G",
        name,
      },
    },
    pane
  )

  -- Wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous wrt. running
  -- this script and are not awaitable, so we just pick a number.
  --
  -- Note: We don't strictly need to remove this file, but it is nice
  -- to avoid cluttering up the temporary directory.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)


config.keys = {

	{ key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "q", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "h", mods = "ALT", action = act.ActivateTabRelativeNoWrap(-1) },
	{ key = "l", mods = "ALT", action = act.ActivateTabRelativeNoWrap(1) },
	{ key = "H", mods = "ALT", action = act.MoveTabRelative(-1) },
	{ key = "L", mods = "ALT", action = act.MoveTabRelative(1) },
	{ key = "Enter", mods = "CTRL", action = act.ToggleFullScreen },
	{ key = "v", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "x", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "f", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "e", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "d", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "a", mods = "ALT", action = wezterm.action.ActivateCopyMode },
	{ mods = "ALT", key = "r", action = wezterm.action.RotatePanes("Clockwise") },
  { key = 'o', mods = 'ALT', action = act.EmitEvent 'trigger-vim-with-scrollback', },
}

config.key_tables = {
	copy_mode = {
    -- All possible keymaps are available here: https://wezfurlong.org/wezterm/copymode.html#configurable-key-assignments
		{ key = "i", mods = "NONE", action = close_copy_mode() },
		{ key = "a", mods = "NONE", action = close_copy_mode() },
		{ key = "Escape", mods = "NONE", action = act.Multiple({ act.CopyMode("ClearSelectionMode"), act.CopyMode("ClearPattern") }), },

		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },

		{ key = "/", mods = "NONE", action = act.Multiple({ act.CopyMode("ClearPattern"), act.Search({ CaseInSensitiveString = "" }) }), },
		{ key = "?", mods = "SHIFT", action = act.Multiple({ act.CopyMode("ClearPattern"), act.Search({ CaseInSensitiveString = "" }) }), },
		{ key = "n", mods = "NONE", action = wezterm.action({ CopyMode = "NextMatch" }) },
		{ key = "N", mods = "SHIFT", action = wezterm.action({ CopyMode = "PriorMatch" }) },

		{ key = "h", mods = "NONE", action = wezterm.action({ CopyMode = "MoveLeft" }) },
		{ key = "j", mods = "NONE", action = wezterm.action({ CopyMode = "MoveDown" }) },
		{ key = "k", mods = "NONE", action = wezterm.action({ CopyMode = "MoveUp" }) },
		{ key = "l", mods = "NONE", action = wezterm.action({ CopyMode = "MoveRight" }) },

		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
    { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent', },
    { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom', },
    { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop', },
    { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd', },
    { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine', },
    { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent', },
    { key = 'd', mods = 'CTRL', action = act.CopyMode { MoveByPage = 0.5 }, },
    { key = 'u', mods = 'CTRL', action = act.CopyMode { MoveByPage = -0.5 }, },
    { key = 'y', mods = 'NONE', action = act.Multiple {
        { CopyTo = 'ClipboardAndPrimarySelection' },
        act.CopyMode("Close"),
        act.CopyMode('MoveToScrollbackBottom'),
      },
    },
    { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
    { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
    { key = 'f', mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = false } }, },
    { key = 'F', mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = false } }, },
    { key = 't', mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = true } }, },
    { key = 'T', mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = true } }, },
	},
	search_mode = {
		{ key = "Escape", mods = "NONE", action = wezterm.action({ CopyMode = "Close" }) },
		{ key = "Enter", mods = "NONE", action = "ActivateCopyMode" },
	},
}

return config
