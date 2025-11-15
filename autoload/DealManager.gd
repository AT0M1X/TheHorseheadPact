extends Node

var deal_list = ["All shoot", "move down", "move up"]
var deal_to_pick = 0
var deal_turn_modifier = 5
var deal_accepted_flag = false
var current_deal

var next_forced_turn

signal deal_event_happened
signal forced_turn_happened
signal deal_event_accepted
signal deal_event_declined
signal deal(deal_type)
signal deal_event_turn_done
signal forced_turn_done

func pick_deal():
	current_deal = deal_list[deal_to_pick]
	deal_to_pick += 1
	reset_deals()

func reset_deals():
	if deal_to_pick == deal_list.size():
		deal_to_pick = 0

func do_deal_event_turn(turn_number):
	if not deal_accepted_flag and (turn_number % deal_turn_modifier + randi_range(-2, 2) == 0):
		pick_deal()
		deal_event_happened.emit()
		return true
	else:
		return false

func do_forced_turn(turn_number):
	if turn_number == next_forced_turn:
		deal.emit(current_deal)
		print(current_deal)
		forced_turn_happened.emit()
		deal_accepted_flag = false
		return true
	else:
		return false

func deal_accepted():
	deal_accepted_flag = true
	next_forced_turn = TurnManager.current_turn + randi_range(2, 5)
	deal_event_accepted.emit()

func deal_declined():
	deal_accepted_flag = false
	deal_event_declined.emit()
