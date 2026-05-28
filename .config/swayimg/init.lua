swayimg.set_mode("viewer")
swayimg.text.set_timeout(0)

swayimg.viewer.on_key("Escape", function()
  swayimg.exit()
end)

swayimg.viewer.on_key("j", function()
  swayimg.viewer.switch_image("prev")
end)

swayimg.viewer.on_key("k", function()
  swayimg.viewer.switch_image("next")
end)
