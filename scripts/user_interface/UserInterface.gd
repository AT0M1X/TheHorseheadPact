extends CanvasLayer

@onready var finger_counter: TextureRect = $"UI Root/Finger Counter"
@onready var turn_counter: Label = $"UI Root/Turn Counter"
@onready var honse_counter: Label = $"UI Root/Honse Counter"

var fingers := [
	preload("res://assets/art/0_-_Full_hand.png"),
	preload("res://assets/art/1_-_Missing_littlefinger.png"),
	preload("res://assets/art/2_-_Missing_ringfinger.png"),
	preload("res://assets/art/3_-_Missing_middlefinger.png"),
	preload("res://assets/art/4_-_Missing_thumb.png"),
	preload("res://assets/art/5_-_Broken_pointer.png")
]

func _ready():
	return
	#TurnManager.connect("update_finger_counter", _update_finger_counter)
	#TurnManager.connect("update_turn_counter", _update_turn_counter)
	#TurnManager.connect("update_honse_counter", _update_honse_counter)
	
func _update_finger_counter(finger_count):
	_set_icon_by_index(5 - finger_count)
	
func _update_turn_counter(current_turn):
	turn_counter.text = "Round: %s" % current_turn
	
func _update_honse_counter():
	return
	
func _set_icon_by_index(index):
	if index >= 0 and index < fingers.size():
		finger_counter.texture = fingers[index]
