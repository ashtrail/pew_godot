extends Control

func _ready():
	pass

func _on_Player_hp_updated(hp):
	$Hp.text = str(hp)

func _on_Player_score_updated(score):
	$Score.text = str(score)
