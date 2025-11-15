extends CanvasLayer

@onready var finger_counter: TextureRect = $"UI Root/Finger Counter"
@onready var turn_counter: Label = $"UI Root/Turn Counter"
@onready var honse_counter: Label = $"UI Root/Honse Counter"
@onready var accept_button: Button = $"UI Root/Accept Deal"
@onready var decline_button: Button = $"UI Root/Decline Deal"

var fingers := [
	preload("res://assets/art/0_-_Full_hand.png"),
	preload("res://assets/art/1_-_Missing_littlefinger.png"),
	preload("res://assets/art/2_-_Missing_ringfinger.png"),
	preload("res://assets/art/3_-_Missing_middlefinger.png"),
	preload("res://assets/art/4_-_Missing_thumb.png"),
	preload("res://assets/art/5_-_Broken_pointer.png")
]

func _ready():
	accept_button.visible = false
	decline_button.visible = false
	
	TurnManager.connect("update_finger_counter", _update_finger_counter)
	TurnManager.connect("update_turn_counter", _update_turn_counter)
	TurnManager.connect("update_honse_counter", _update_honse_counter)
	DealManager.connect("deal_event_start", _show_deal)
	
func _update_finger_counter(finger_count):
	_set_icon_by_index(5 - finger_count)
	
func _update_turn_counter(current_turn):
	turn_counter.text = "Round: %s" % current_turn
	
func _update_honse_counter(turns_to_forced):
	honse_counter.text = "Honse Turn In: %s" % turns_to_forced
	
func _set_icon_by_index(index):
	if index >= 0 and index < fingers.size():
		finger_counter.texture = fingers[index]

func _show_deal():
	accept_button.visible = true
	decline_button.visible = true

func _hide_deal():
	accept_button.visible = false
	decline_button.visible = false
	
func _on_accept_deal_pressed() -> void:
	DealManager.deal_accepted()
	_hide_deal()

func _on_decline_deal_pressed() -> void:
	DealManager.deal_declined()
	_hide_deal()
	
