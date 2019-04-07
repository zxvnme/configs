local more_indicators_control = ui.new_checkbox("VISUALS", "Other ESP", "More indicators")

local force_bodyaim_control = ui.reference("RAGE", "Other", "Force body aim")
local double_tap_control = ui.reference("RAGE", "Other", "Double tap")
local on_shot_aa_control = ui.reference("AA", "Other", "On shot anti-aim")

local screen_size_x, screen_size_y = client.screen_size()

local function on_paint(ctx)
	if not ui.get(more_indicators_control) then
		return
	end

	if ui.get(force_bodyaim_control) then
		client.draw_indicator(ctx, 39, 174, 96, 255, "FORCE BAIM")

	end

	if ui.get(double_tap_control) then
		client.draw_indicator(ctx, 39, 174, 96, 255, "DOUBLE TAP")
	end

	if ui.get(on_shot_aa_control) then
		client.draw_indicator(ctx, 39, 174, 96, 255, "ON SHOT AA")
	end
end

client.set_event_callback("paint", on_paint)
