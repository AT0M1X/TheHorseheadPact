extends CanvasLayer

@onready var finger_counter: TextureRect = $"UI Root/Finger Counter"
@onready var turn_counter: Label = $"UI Root/Turn Counter"
@onready var honse_counter: Label = $"UI Root/Honse Counter"
@onready var honse_action: Label = $"UI Root/Honse Move"
@onready var accept_button: Button = $"UI Root/Deal/Accept Deal"
@onready var decline_button: Button = $"UI Root/Deal/Decline Deal"
@onready var deal: TextureRect = $"UI Root/Deal"
@onready var death: TextureRect = $"UI Root/Death"

@onready var audio = $Audio

@export var deal_lable: Label

var sound_break_finger = preload("res://assets/sound/av.wav")
var sound_deal = preload("res://assets/sound/What do you say.wav")
var sound_accept = preload("res://assets/sound/vrinsk.wav")

var fingers := [
	preload("res://assets/art/0_-_Full_hand.png"),
	preload("res://assets/art/1_-_Missing_littlefinger.png"),
	preload("res://assets/art/2_-_Missing_ringfinger.png"),
	preload("res://assets/art/3_-_Missing_middlefinger.png"),
	preload("res://assets/art/4_-_Missing_thumb.png"),
	preload("res://assets/art/5_-_Broken_pointer.png")
]

func _ready():
	_hide_deal()
	death.visible = false
	
	TurnManager.connect("update_finger_counter", _update_finger_counter)
	TurnManager.connect("update_turn_counter", _update_turn_counter)
	TurnManager.connect("update_honse_counter", _update_honse_counter)
	DealManager.connect("deal_event_start", _show_deal)
	DealManager.connect("deal_event_next_action", _update_honse_action)
	TurnManager.player_died.connect(_show_death)
	
func _update_finger_counter(finger_count):
	_set_icon_by_index(5 - finger_count)
	_play_audio(sound_break_finger)
	
func _update_turn_counter(current_turn):
	turn_counter.text = "Round: %s" % current_turn
	
func _update_honse_counter(turns_to_forced):
	if turns_to_forced >= 0:
		honse_counter.text = "Honse Turn In: %s" % turns_to_forced
	else:
		honse_counter.text = "Honse Turn In: ?"
	
func _update_honse_action(action):
	honse_action.text = "%s" % action
	
func _set_icon_by_index(index):
	if index >= 0 and index < fingers.size():
		finger_counter.texture = fingers[index]

func _show_deal():
	_deal_text_update()
	deal.visible = true
	accept_button.visible = true
	decline_button.visible = true
	_play_audio(sound_deal)

func _hide_deal():
	deal.visible = false
	accept_button.visible = false
	decline_button.visible = false
	
func _on_accept_deal_pressed() -> void:
	DealManager.deal_accepted()
	_play_audio(sound_accept)
	_hide_deal()

func _on_decline_deal_pressed() -> void:
	DealManager.deal_declined()
	_hide_deal()
	
func _play_audio(audio_stream):
	#audio.pitch_scale = randf_range(0.9, 1.1)
	audio.stream = audio_stream
	audio.play()
	
func _show_death():
	_hide_deal()
	death.visible = true

func _deal_text_update():
	deal_lable.text = "In %s" % (DealManager.next_forced_turn - TurnManager.current_turn) + " turns"
	match DealManager.current_deal:
		"All shoot":
			deal_lable.text = deal_lable.text + " all penguin shoot at you."
		"move up":
			deal_lable.text = deal_lable.text + " I move you up."
		"move down":
			deal_lable.text = deal_lable.text + " I move you down."
		"move right":
			deal_lable.text = deal_lable.text + " I move you right."
		"move left":
			deal_lable.text = deal_lable.text + " I move you left."
