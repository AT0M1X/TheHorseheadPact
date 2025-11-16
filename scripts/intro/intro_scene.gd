extends Node


func _ready():
	$VideoStreamPlayer.play()
	$VideoStreamPlayer.finished.connect(_on_video_finished)

func _on_video_finished():
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")
