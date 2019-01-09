extends Node2D

export (PackedScene) var Enemy

func _ready():
	randomize()
	$Player.connect('game_over', self, '_on_Player_game_over')
	$Player.connect('score_updated', self, '_on_Player_score_updated')

func spawn_enemy():
	$SpawnZone/PathFollow.set_offset(randi())
	var enemy = Enemy.instance()
	enemy.target = $Player
	enemy.position = $SpawnZone/PathFollow.position
	$Enemies.add_child(enemy)
	enemy.connect('died', $Player, '_on_Enemy_killed')

func _on_SpawnTimer_timeout():
	spawn_enemy()

func _on_Player_game_over():
	Global.score = $Player.score
	get_tree().change_scene('res://levels/GameOver.tscn')

func _on_Player_score_updated(score):
	if score > 0:
		$SpawnTimer.accelerate()
	if score == 50 or score == 100 or score == 150:
		$AudioStreamPlayer.pitch_scale += 0.1
