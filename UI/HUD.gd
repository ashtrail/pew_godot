extends Control

func _ready():
	pass

func _on_Player_hp_updated(hp):
	$HealthBar.update_hp(hp)

func _on_Player_score_updated(score):
	$Score.text = str(score)
	$AnimationPlayer.play('increment_score')
