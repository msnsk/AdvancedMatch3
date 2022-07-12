extends Node2D

enum {
	READY,
	PLAY,
	GAMEOVER
}

const enemy_scns = [
	preload("res://Enemies/EnemyBeige.tscn"),
	preload("res://Enemies/EnemyBlue.tscn"),
	preload("res://Enemies/EnemyGreen.tscn"),
	preload("res://Enemies/EnemyPink.tscn"),
	preload("res://Enemies/EnemyYellow.tscn")
]

export (int) var power = 10
var life: int = 10
var level: int = 1
var state = READY
var enemy #Inherited Enemy node

onready var enemy_spawner = $EnemySpawner
onready var ui = $UI
onready var grid = $Grid
onready var sign_screen = $Screens/SignScreen
onready var end_screen = $Screens/EndScreen
onready var sign_timer = $Screens/SignTimer


func _ready():
	randomize()
	grid.connect("waiting_started", self, "_on_Grid_waiting_started")
	grid.connect("waiting_finished", self, "_on_Grid_waiting_finished")
	ui.update_level(level)
	ui.update_life(life)
	end_screen.hide()
	sign_screen.show()
	sign_timer.start()


func spawn_enemy():
	var index = randi() % enemy_scns.size()
	enemy = enemy_scns[index].instance()
	enemy_spawner.call_deferred("add_child", enemy)
	enemy.set_level(level)
	enemy.connect("attack_done", self, "_on_Enemy_attack_done")
	enemy.connect("tree_exited", self, "_on_Enemy_tree_exited")


func _on_SignTimer_timeout():
	match state:
		READY:
			sign_screen.get_node("SignLabel").text = "Go!"
			state = PLAY
		PLAY:
			sign_timer.stop()
			sign_screen.hide()
			spawn_enemy()
		GAMEOVER:
			sign_screen.hide()
			end_screen.show_result(level - 1)
			end_screen.show()


func lose():
	get_tree().paused = true
	state = GAMEOVER
	sign_screen.get_node("SignLabel").text = "GAME\nOVER!"
	sign_screen.show()
	sign_timer.start()


# Connected signal
func _on_Grid_waiting_started():
	if enemy != null:
		enemy.attack_timer.paused = true


# Connected signal
func _on_Grid_waiting_finished(total_combo):
	if enemy != null:
		enemy.hit(power, total_combo)


# Connected signal
func _on_Enemy_attack_done():
	life -= 1
	ui.update_life(life)
	if life <= 0:
		lose()


# Connected signal
func _on_Enemy_tree_exited():
	enemy = null
	level += 1
	ui.update_level(level)
	power += level - int(randi() % level)
	ui.update_power(power)
	spawn_enemy()
