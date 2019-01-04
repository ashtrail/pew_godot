extends KinematicBody2D

export (int) var SPEED = 20
export (PackedScene) var Bullet
export (int) var MAX_HP = 3

signal hp_updated(hp)
signal score_updated(score)
signal game_over

var velocity = Vector2()
var screen_size
var hp
var score = 0

func _ready():
	add_to_group('player')
	hp = MAX_HP
	screen_size = get_viewport_rect().size
	emit_signal('score_updated', score)
	emit_signal('hp_updated', hp)

func shoot():
	if not $FireRate.is_stopped():
		return
	var bullet_dir = -(position - get_global_mouse_position())
	var bullet = Bullet.instance()
	get_parent().add_child(bullet)
	bullet.init(position, bullet_dir)
	$FireRate.start()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * SPEED

	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)

func _on_Enemy_killed(score_value):
	score += score_value
	emit_signal('score_updated', score)

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		die()
	else:
		emit_signal('hp_updated', hp)

func die():
	emit_signal('game_over')
