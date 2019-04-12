-- api methods
local client_draw_rectangle, entity_get_local_player, entity_get_prop, ui_get, ui_set, ui_set_visible, ui_reference, ui_new_checkbox, ui_new_hotkey, ui_new_combobox, renderer_text, renderer_measure_text, client_screen_size, client_set_event_callback =
      client.draw_rectangle, entity.get_local_player, entity.get_prop, ui.get, ui.set, ui.set_visible, ui.reference, ui.new_checkbox, ui.new_hotkey, ui.new_combobox, renderer.text, renderer.measure_text, client.screen_size, client.set_event_callback
-- new controls
local manual_antiaim_control = ui_new_checkbox("AA", "Other", "Manual antiaim")
local manual_antiaim_hotkey_control = ui_new_hotkey("AA", "Other", "Yaw flip hotkey", false)
local indicator_type_control = ui_new_combobox("AA", "Other", "Indicator style", {"Arrows", "Triangles"})
-- references
local antiaim_yaw_reference, antiaim_yaw_slider_reference = ui_reference("AA", "Anti-aimbot angles", "Yaw")
local antiaim_body_yaw_reference, antiaim_body_yaw_jitter_slider_reference = ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")
local antiaim_body, antiaim_body_num = ui_reference("AA", "Anti-aimbot angles", "Body yaw")
local antiaim_limit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit")
local antiaim_twist = ui_reference("AA", "Anti-aimbot angles", "Twist")
local antiaim_lowerbody = ui_reference("AA", "Anti-aimbot angles", "Lower body yaw")

-- credits: abbie (UID: 184)
local function draw_container(ctx, x, y, w, h)
    local c = {10, 60, 40, 40, 40, 60, 20}
    for i = 0,6,1 do
        client_draw_rectangle(ctx, x+i, y+i, w-(i*2), h-(i*2), c[i+1], c[i+1], c[i+1], 255)
    end
end
-- also thanks to Salvatore (UID: 1349) for usage of this function 
local function get_animstate()
  local x, y, z = entity_get_prop(entity_get_local_player(), "m_vecVelocity")

  local fl_speed = math.sqrt(x^2 + y^2)
  local maxdesync = (59 - 58 * fl_speed / 580)

  return fl_speed, maxdesync, (z^2 > 0)
end

-- vars
local left_direction, right_direction = false
local text = nil
local screen_width, screen_height = client_screen_size()
local left_text_width, left_text_height = nil, nil
local l_r, l_g, l_b, l_a = 255, 255, 255, 255
local right_text_width, right_text_height = nil, nil
local r_r, r_g, r_b, r_a = 255, 255, 255, 255

-- draw indicator
local function draw_indicator(type)
  local container_width, container_height = 50, 50

  if type == "Arrows" then
    text = { left = "<", right = ">" }
  elseif type == "Triangles" then
    text = { left = "◄", right = "►"}
  end

  left_text_width, left_text_height = renderer_measure_text("+", text.left)
  right_text_width, right_text_height = renderer_measure_text("+", text.right)

  -- left container with text
  draw_container(ctx, (screen_width / 2) - container_width - 5, screen_height - container_height - 10, container_width, container_height)
  renderer_text(((screen_width / 2) - container_width) + left_text_width, screen_height - container_height + left_text_height - 12.5, l_r, l_g, l_b, l_a, "c+", 0, text.left)

  -- right container with text
  draw_container(ctx, (screen_width / 2) + 5, screen_height - container_height - 10, container_width, container_height)
  renderer_text(((screen_width / 2) + container_width) - right_text_width, screen_height - container_height + right_text_height - 12.5, r_r, r_g, r_b, r_a, "c+", 0, text.right)
end
-- handle direction
local function handle_direction()
  if ui_get(manual_antiaim_hotkey_control) then
    left_direction = true
    right_direction = false
  else
    left_direction = false
    right_direction = true
  end
end
-- handle indicator colors
local function handle_colors()
  if left_direction then
    l_r, l_g, l_b, l_a = 255, 0, 0, 255
    r_r, r_g, r_b, r_a = 255, 255, 255, 255
  end

  if right_direction then
    l_r, l_g, l_b, l_a = 255, 255, 255, 255
    r_r, r_g, r_b, r_a = 255, 0, 0, 255
  end
end
-- handle whole manual antiaim
local function handle_antiaim(ctx)
  ui_set(antiaim_body_yaw_reference, "Off")
  ui_set(antiaim_yaw_reference, "180")
  ui_set(antiaim_body, "Static")
  ui_set(antiaim_limit, 60)
  ui_set(antiaim_twist, true)
  ui_set(antiaim_lowerbody, true)

  local fl_speed, max_desync, in_air = get_animstate()
  local yawing = 59 - (0.59 * 51)

  if left_direction then
    ui_set(antiaim_yaw_slider_reference, -yawing)
    ui_set(antiaim_body_num, -max_desync)
    client.log(ctx)
  end

  if right_direction then
    ui_set(antiaim_yaw_slider_reference, yawing)
    ui_set(antiaim_body_num, max_desync)
  end
end

-- paint callback
local function on_paint(ctx)
    ui_set_visible(manual_antiaim_hotkey_control, false)
    ui_set_visible(indicator_type_control, false)
    if ui_get(manual_antiaim_control) then
      ui_set_visible(manual_antiaim_hotkey_control, true)
      ui_set_visible(indicator_type_control, true)
      draw_indicator(ui_get(indicator_type_control))
    end
end
-- setup command callback
local function on_setup_command(ctx)
  if not ui_get(manual_antiaim_control) then
    return
  end

  handle_direction()
  handle_colors()
  handle_antiaim(ctx)
end

-- override callbacks
client_set_event_callback("setup_command", on_setup_command)
client_set_event_callback("paint", on_paint)