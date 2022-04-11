local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local const = require("configuration.const")
local mod, shft, ctrl, alt = const.key.mod, const.key.shift, const.key.ctrl, const.key.alt

local function extend(dt, ...)
  for j = 1, select("#", ...) do
    local t = select(j, ...)
    if t then
      local k = #dt
      for i = 1, #t do
        dt[k + i] = t[i]
      end
    end
  end
  return dt
end

local globals = {}
local clients = {}

-- Movement --------------------------------------------------------------------

local key_to_movement = {
  left = {
    keys = { "h", "Left" },
    n = { dpi(-20), 0, 0, 0 },
  },
  down = {
    keys = { "j", "Down" },
    n = { 0, dpi(20), 0, 0 },
  },
  up = {
    keys = { "k", "Up" },
    n = { 0, dpi(-20), 0, 0 },
  },
  right = {
    keys = { "l", "Right" },
    n = { dpi(20), 0, 0, 0 },
  },
}

for d, values in pairs(key_to_movement) do
  for _, k in ipairs(values.keys) do
    extend(globals, {
      awful.key({ mod }, k, function()
        helpers.move_focus(client.focus, d)
      end, {
        description = "focus " .. d,
        group = "movement",
      }),
      awful.key({ mod, ctrl }, k, function()
        helpers.resize_dwim(client.focus, d)
      end, {
        description = "resize " .. d,
        group = "movement",
      }),
    })
    extend(clients, {
      awful.key({ mod, shft }, k, function(c)
        helpers.move_client_dwim(c, d)
      end, {
        description = "move " .. d,
        group = "movement",
      }),
      awful.key({ mod, shft, ctrl }, d, function(c)
        c:relative_move(unpack(values.n))
      end, {
        description = "float move " .. d,
        group = "movement",
      }),
    })
  end
end

-- Awesome ---------------------------------------------------------------------

extend(globals, {
  -- Restart awesome
  awful.key({ mod, ctrl }, "r", awesome.restart, {
    description = "restart awesome",
    group = "awesome",
  }),

  -- Quit awesome
  awful.key({ mod, shft }, "x", function()
    awesome.quit()
  end, {
    description = "quit awesome",
    group = "awesome",
  }),

  -- Close all clients in current focused screen
  awful.key({ mod, shft }, "q", function()
    local clients = awful.screen.focused().clients
    for _, c in pairs(clients) do
      c:kill()
    end
  end, {
    description = "kill all visable clients for current screen",
    group = "awesome",
  }),
})

extend(clients, {
  -- Close client
  awful.key({ mod }, "q", function(c)
    c:kill()
  end, { description = "close", group = "client" }),

  awful.key({ alt }, "F4", function(c)
    c:kill()
  end, { description = "close", group = "client" }),
})

-- Launchers -------------------------------------------------------------------

extend(globals, {
  awful.key({ mod }, "Return", function()
    awful.spawn(const.terminal)
  end, {
    description = "launch terminal",
    group = "launcher",
  }),

  awful.key({ mod, ctrl }, "Return", function()
    awful.spawn(const.launcher)
  end, {
    description = "launch application",
    group = "launcher",
  }),
})

awful.keyboard.append_global_keybindings(globals)
client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings(clients)
end)
