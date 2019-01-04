extends Node2D

export (PackedScene) var Enemy

func _ready():
	randomize()

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