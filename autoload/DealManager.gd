extends Node

var deal_list = ["All shoot", "move down", "move up", "move right", "move left"]
var deal_to_pick = 0
var deal_turn_modifier = 7
var deal_accepted_flag = false
var current_deal
var next_forced_turn
var fingers = 5

signal deal_event_start
signal deal_event_end
signal deal_event_accepted
signal deal_event_declined
signal deal_event_next_action(next_action: String)
signal forced_turn_start
signal forced_turn_end
signal forced_turn_action(action: String)

func pick_deal():
	current_deal = deal_list[deal_to_pick]
	deal_to_pick += 1
	next_forced_turn = TurnManager.current_turn + randi_range(2, 5)
	reset_deals()

func reset_deals():
	if deal_to_pick == deal_list.size():
		deal_to_pick = 0

func do_deal_event_turn(turn_number):
	if not deal_accepted_flag and (turn_number % deal_turn_modifier + randi_range(-2, 2) == 0):
		pick_deal()
		deal_event_start.emit()
		return true
	else:
		return false

func do_forced_turn(turn_number):
	if turn_number == next_forced_turn:
		forced_turn_start.emit()
		forced_turn_action.emit(current_deal)
		deal_event_next_action.emit("")
		deal_accepted_flag = false
		return true
	else:
		return false

func deal_accepted():
	deal_accepted_flag = true
	deal_event_accepted.emit()
	deal_event_end.emit()
	deal_event_next_action.emit(current_deal)
	TurnManager.emit_to_ui()

func deal_declined():
	next_forced_turn = null
	deal_accepted_flag = false
	deal_event_declined.emit()
	deal_event_end.emit()
	TurnManager.emit_to_ui()
	
	fingers -= 1
	TurnManager.update_finger_counter.emit(fingers)
	if fingers == 0:
		TurnManager.deal_die()

func forced_turn_completed():
	call_deferred("emit_signal", "forced_turn_end")
