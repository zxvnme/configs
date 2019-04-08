-- api methods
local ui_set, ui_get, ui_reference, ui_new_checkbox, ui_new_slider, ui_set_visible, client_delay_call, client_set_event_callback = 
      ui.set, ui.get, ui.reference, ui.new_checkbox, ui.new_slider, ui.set_visible, client.delay_call, client.set_event_callback
-- new elements
local adaptive_double_tap = ui_new_checkbox("RAGE", "Other", "Adaptive Double tap")
local adaptive_double_tap_after_x_missed_shots = ui_new_slider("RAGE", "Other", "Amount of missed shots", 1, 3)
-- references
local double_tap_control = ui_reference("RAGE", "Other", "Double tap")
-- vars
local previous_double_tap_state = ui_get(double_tap_control)
local variables = {
	missed_shots = 0;
}

-- paint event callback
local function on_paint(ctx)
  ui_set_visible(adaptive_double_tap_after_x_missed_shots, false)
  if ui_get(adaptive_double_tap) then
    ui_set_visible(adaptive_double_tap_after_x_missed_shots, true)
  end
end
-- aim hit event callback
local function on_aim_hit(ctx)
  variables.missed_shots = 0
  ui_set(double_tap_control, "On hotkey")
end

-- aim miss event callback
local function on_aim_miss(ctx)
  if ui_get(adaptive_double_tap) then
    variables.missed_shots = variables.missed_shots + 1

	  if variables.missed_shots >= ui_get(adaptive_double_tap_after_x_missed_shots) then
      ui_set(double_tap_control, "Always on")
	  end
	end
end

-- register callbacks
client_set_event_callback("paint", on_paint)
client_set_event_callback("aim_miss", on_aim_miss)
client_set_event_callback("aim_hit", on_aim_hit)
