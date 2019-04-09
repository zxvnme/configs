-- api methods
local ui_set, ui_get, ui_reference, ui_new_checkbox, ui_new_slider, ui_new_combobox, ui_set_visible, entity_get_players, entity_get_prop, entity_get_local_player, client_delay_call, client_userid_to_entindex, client_set_event_callback = 
      ui.set, ui.get, ui.reference, ui.new_checkbox, ui.new_slider, ui.new_combobox, ui.set_visible, entity.get_players, entity.get_prop, entity.get_local_player, client.delay_call, client.userid_to_entindex, client.set_event_callback
-- new elements
local adaptive_double_tap = ui_new_checkbox("RAGE", "Other", "Adaptive Double tap")
local adaptive_double_tap_triggers = ui_new_combobox("RAGE", "Other", "Triggers", {"First shot missed", "X Misses", "HP Lower than"})
local adaptive_double_tap_after_x_missed_shots = ui_new_slider("RAGE", "Other", "Missed shots amount", 2, 5)
local adaptive_double_tap_if_hp_lower_than_x = ui_new_slider("RAGE", "Other", "Value", 2, 100)
-- references
local double_tap_control = ui_reference("RAGE", "Other", "Double tap")
-- vars
local enemies = entity_get_players(true)
local previous_double_tap_state = ui_get(double_tap_control)
local variables = {
  weapon_type = nil;
	missed_shots = 0;
}

-- utils
local function triggers_check()
  if ui_get(adaptive_double_tap_triggers) == "First shot missed" then
    return 1
  elseif ui_get(adaptive_double_tap_triggers) == "X Misses" then
    return ui_get(adaptive_double_tap_after_x_missed_shots)
  end
end

local function reset()
  variables.missed_shots = 0
  ui_set(double_tap_control, "On hotkey")
end

-- item equip callback
local function on_item_equip(ctx)
  if ui_get(adaptive_double_tap) and ctx.userid ~= nil and client_userid_to_entindex(ctx.userid) == entity_get_local_player() then
    variables.weapon_type = ctx.weptype
  end
end

-- paint event callback
local function on_paint(ctx)
  ui_set_visible(adaptive_double_tap_triggers, false)
  ui_set_visible(adaptive_double_tap_after_x_missed_shots, false)
  ui_set_visible(adaptive_double_tap_if_hp_lower_than_x, false)
  if ui_get(adaptive_double_tap) then
    ui_set_visible(adaptive_double_tap_triggers, true)
    if ui_get(adaptive_double_tap_triggers) == "HP Lower than" then
      ui_set_visible(adaptive_double_tap_if_hp_lower_than_x, true)
    end
    if ui_get(adaptive_double_tap_triggers) == "X Misses" then
      ui_set_visible(adaptive_double_tap_after_x_missed_shots, true)
    end
  end
end

-- run command callback
local function on_run_command(ctx)
  if ui_get(adaptive_double_tap) and (variables.weapon_type == 0 or variables.weapon_type == 7 or variables.weapon_type == 8 or variables.weapon_type == 9) then
    reset()
  end

  if ui_get(adaptive_double_tap_triggers) == "HP Lower than" then
    for i=1, #enemies do
      local entity_health = entity_get_prop(enemies[i], "m_iHealth")
      if entity_health <= ui_get(adaptive_double_tap_if_hp_lower_than_x) then
        ui_set(double_tap_control, "Always on")
      end
      if entity_health <= 0 then
        reset()
      end
    end
  end
end

-- player death callback
local function on_player_death(ctx)
  reset()
end

-- aim hit event callback
local function on_aim_hit(ctx)
  reset()
end

-- aim miss event callback
local function on_aim_miss(ctx)
  if not ui_get(adaptive_double_tap) then
    return
  end
  
  if ui_get(adaptive_double_tap_triggers) == "First shot missed" or ui_get(adaptive_double_tap_triggers) == "X Misses" then
    variables.missed_shots = variables.missed_shots + 1

    if variables.missed_shots >= triggers_check() then
      ui_set(double_tap_control, "Always on")
    end
  end
end

-- register callbacks
client_set_event_callback("item_equip", on_item_equip)
client_set_event_callback("run_command", on_run_command)
client_set_event_callback("player_death", on_player_death)
client_set_event_callback("paint", on_paint)
client_set_event_callback("aim_miss", on_aim_miss)
client_set_event_callback("aim_hit", on_aim_hit)