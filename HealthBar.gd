extends Control

func update_hp(hp):
	var heart = null
	match hp:
		1:
			heart = $GridContainer/Second
		2:
			heart = $GridContainer/Third
	if !heart:
		return
	$Tween.interpolate_property(heart, "rect_scale", Vector2(1, 1),
			Vector2(1.25, 1.25), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$Tween.start()
	$AnimationPlayer.play('shake')
	yield($Tween, "tween_completed")
	heart.visible = false