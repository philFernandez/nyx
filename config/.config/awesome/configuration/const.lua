local terminal = "wezterm"

return {
  -- Default Applications
  terminal = terminal,
  browser = "firefox",
  filemanager = "nautilus",
  discord = "discord",
  launcher = "rofi -show drun",
  music = terminal .. " --class music -e ncspot",
  emoji_launcher = "rofi -show emoji",
  key = {
    mod = "Mod4",
    alt = "Mod1",
    shift = "Shift",
    ctrl = "Control",
  },
}
