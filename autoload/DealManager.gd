extends Node

var dealList = ["All shoot", "move down", "move up"]
var dealToPick = 0
var deal_turn_modifier = 5
var dealAccepted = false
var currentDeal

var nextForcedTurn

signal dealEventHappened
signal forcedTurnHappened
signal dealEventAccepted
signal dealEventDeclined
signal deal

func pick_deal ():
	currentDeal = dealList[dealToPick]
	dealToPick =+ 1
	reset_deals()

func reset_deals ():
	if(dealToPick == dealList.size()):
		dealToPick = 0

func do_deal_event_turn(turn_number):
	if (!dealAccepted && (turn_number % deal_turn_modifier + randi_range(-2,2) == 0)):
		pick_deal()
		dealEventHappened.emit()
		return true
	else:
		false

func do_forced_turn(turn_number):
	if (turn_number == nextForcedTurn):
		deal.emit(currentDeal)
		print(currentDeal)
		forcedTurnHappened.emit()
		dealAccepted = false
		return true
	else:
		return false

func deal_accepted():
	dealAccepted = true
	nextForcedTurn = TurnManager.current_turn + randi_range(2,5)
	dealEventAccepted.emit()

func deal_declined():
	dealAccepted = false
	dealEventDeclined.emit()
