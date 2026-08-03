swayimg.mode = "viewer"
swayimg.text.visible = false

local function pan(dx, dy)
  local pos = swayimg.viewer.get_position()
  if pos then
    swayimg.viewer.set_abs_position(pos.x + dx, pos.y + dy)
  end
end

local function pan_step()
  local size = swayimg.get_window_size()
  return math.max(40, math.floor(math.min(size.width, size.height) / 10))
end

swayimg.viewer.on_key("Escape", function()
  swayimg.exit()
end)

swayimg.viewer.on_key("q", function()
  swayimg.exit()
end)

swayimg.viewer.on_key("[", function()
  swayimg.viewer.open("prev")
end)

swayimg.viewer.on_key("]", function()
  swayimg.viewer.open("next")
end)

swayimg.viewer.on_key("h", function() pan(-pan_step(), 0) end)
swayimg.viewer.on_key("l", function() pan(pan_step(), 0) end)
swayimg.viewer.on_key("k", function() pan(0, -pan_step()) end)
swayimg.viewer.on_key("j", function() pan(0, pan_step()) end)
