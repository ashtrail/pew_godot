extends KinematicBody2D

export (int) var SPEED = 600
export (PackedScene) var Bullet = preload("res://entities/Bullet.tscn")
export (int) var MAX_HP = 3

signal hp_updated(hp)
signal score_updated(score)
signal game_over

var velocity = Vector2()
var screen_size
var hp
var score = 0
var moving = false

func _ready():
	add_to_group('player')
	hp = MAX_HP
	screen_size = get_viewport_rect().size
	emit_signal('score_updated', score)
	emit_signal('hp_updated', hp)
	$BodyAnimator.play('idle')
	$FaceAnimator.play('idle')

func shoot():
	if not $FireRate.is_stopped():
		return
	$AudioStreamPlayer.pitch_scale = 1 + rand_range(0.0, 0.2)
	$FaceAnimator.play('shooting')
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
	
	if velocity.length() > 0:
		if not moving:
			$BodyAnimator.play('moving')
		moving = true
	else:
		if moving:
			$BodyAnimator.play('idle')
		moving = false

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
	$Body.modulate = Color(1, 0, 0);
	$AudioStreamPlayer.pitch_scale = 1
	$FaceAnimator.play('hurt')
	$HurtBlink.start()
	emit_signal('hp_updated', hp)
	if hp <= 0:
		yield($FaceAnimator, 'animation_finished')
		die()

func die():
	emit_signal('game_over')


func _on_FaceAnimator_animation_finished(anim_name):
	if anim_name == 'shooting' or anim_name == 'hurt':
		$FaceAnimator.play('idle')

func _on_HurtBlink_timeout():
	$Body.modulate = Color(1, 1, 1);
