local more_indicators_control = ui.new_checkbox("VISUALS", "Other ESP", "More indicators")

local force_bodyaim_control = ui.reference("RAGE", "Other", "Force body aim")
local double_tap_control = ui.reference("RAGE", "Other", "Double tap")

local screen_size_x, screen_size_y = client.screen_size()

local function on_paint(ctx)
	if not ui.get(more_indicators_control) then
		return
	end

	if ui.get(force_bodyaim_control) then
		client.draw_text(ctx, (screen_size_x / 2) , (screen_size_y / 2) - 75, 255, 255, 255, 255, "c+", 0, "FORCE BAIM")
	end

	if ui.get(double_tap_control) then
		client.draw_text(ctx, (screen_size_x / 2) , (screen_size_y / 2) - 50, 255, 255, 255, 255, "c+", 0, "2x TAP")
	end
end

client.set_event_callback("paint", on_paint)