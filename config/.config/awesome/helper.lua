local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = {}

function helpers.move_focus(c, direction)
  if not c then
    return
  end

  local layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
  if layout == "max" then
    if direction == "left" or direction == "down" then
      awful.client.focus.byidx(-1)
    else
      awful.client.focus.byidx(1)
    end
  else
    awful.client.focus.bydirection(direction)
  end

  if c.focus then
    c.focus:raise()
  end
end

local direction_translate = {
  ["up"] = "top",
  ["down"] = "bottom",
  ["left"] = "left",
  ["right"] = "right",
}
function helpers.move_to_edge(c, direction)
  local old = c:geometry()
  local new = awful.placement[direction_translate[direction]](
    c,
    { honor_padding = true, honor_workarea = true, margins = beautiful.useless_gap * 2, pretend = true }
  )
  if direction == "up" or direction == "down" then
    c:geometry({ x = old.x, y = new.y })
  else
    c:geometry({ x = new.x, y = old.y })
  end
end

-- Resize DWIM (Do What I Mean)
-- Resize client or factor
-- Constants --
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05
---------------
function helpers.resize_dwim(c, direction)
  if c and c.floating then
    if direction == "up" then
      c:relative_move(0, 0, 0, -floating_resize_amount)
    elseif direction == "down" then
      c:relative_move(0, 0, 0, floating_resize_amount)
    elseif direction == "left" then
      c:relative_move(0, 0, -floating_resize_amount, 0)
    elseif direction == "right" then
      c:relative_move(0, 0, floating_resize_amount, 0)
    end
  elseif awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
    if direction == "up" then
      awful.client.incwfact(-tiling_resize_factor)
    elseif direction == "down" then
      awful.client.incwfact(tiling_resize_factor)
    elseif direction == "left" then
      awful.tag.incmwfact(-tiling_resize_factor)
    elseif direction == "right" then
      awful.tag.incmwfact(tiling_resize_factor)
    end
  end
end

-- Move client DWIM (Do What I Mean)
-- Move to edge if the client / layout is floating
-- Swap by index if maximized
-- Else swap client by direction
function helpers.move_client_dwim(c, direction)
  if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
    helpers.move_to_edge(c, direction)
  elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
    if direction == "up" or direction == "left" then
      awful.client.swap.byidx(-1, c)
    elseif direction == "down" or direction == "right" then
      awful.client.swap.byidx(1, c)
    end
  else
    awful.client.swap.bydirection(direction, c, nil)
  end
end
