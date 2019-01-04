extends Node

func _ready():
	$ScoreValue.text = str(Global.score)

func _process(delta):
	if Input.is_action_pressed('restart'):
		get_tree().change_scene('res://levels/Main.tscn')
