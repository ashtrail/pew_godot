extends Area2D

export (int) var SPEED = 150
export (int) var CONTACT_DAMAGE = 1
export (int) var SCORE_VALUE = 1

signal died(score_value)
var target
var direction = Vector2()

func _ready():
	add_to_group('enemies')

func _process(delta):
	position += direction * SPEED * delta

func reset_direction():
	direction = Vector2()
	if !target or position == target.position:
		return
	var axis = randi() % 2
	match axis:
		0:
			if target.position.x > position.x:
				direction.x = 1
				$Sprite.flip_h = true
			else:
				direction.x = -1
				$Sprite.flip_h = false
		1:
			direction.y = 1 if target.position.y > position.y else -1

func _on_Enemy_body_entered(body):
	if body.is_in_group('bullets'):
		body.queue_free()
		die()
	elif body.is_in_group('player'):
		body.take_damage(CONTACT_DAMAGE)
		die()

func die():
	emit_signal('died', SCORE_VALUE)
	queue_free()
