extends RigidBody2D

export (int) var SPEED

func _ready():
	add_to_group('bullets')

func init(pos, dir):
	position = pos
	set_linear_velocity(dir.normalized() * SPEED)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
