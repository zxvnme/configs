-- api methods
local ui_get, ui_reference, ui_new_checkbox, client_draw_indicator, client_screen_size, client_set_event_callback = 
      ui.get, ui.reference, ui.new_checkbox, client.draw_indicator, client.screen_size, client.set_event_callback

-- new elements
local more_indicators_control = ui_new_checkbox("VISUALS", "Other ESP", "More indicators")
-- references
local force_bodyaim_control = ui_reference("RAGE", "Other", "Force body aim")
local double_tap_control = ui_reference("RAGE", "Other", "Double tap")
local on_shot_aa_control = ui_reference("AA", "Other", "On shot anti-aim")
-- vars
local screen_size_x, screen_size_y = client_screen_size()

-- paint event callback
local function on_paint(ctx)
	if not ui_get(more_indicators_control) then
		return
	end

	if ui_get(force_bodyaim_control) then
		client_draw_indicator(ctx, 39, 174, 96, 255, "FORCE BAIM")
	end

	if ui_get(double_tap_control) then
		client_draw_indicator(ctx, 39, 174, 96, 255, "DOUBLE TAP")
	end

	if ui_get(on_shot_aa_control) then
		client_draw_indicator(ctx, 39, 174, 96, 255, "ON SHOT AA")
	end
end

-- register callbacks
client_set_event_callback("paint", on_paint)
