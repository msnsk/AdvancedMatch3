extends ColorRect


onready var number = $Number
onready var button_sound = $ButtonSound


func show_result(enemies_num):
	number.text = str(enemies_num)


func _on_RestartButton_pressed():
	button_sound.play()
	yield(button_sound, "finished")
	get_tree().paused = false
	get_tree().call_deferred("change_scene", "res://Game/Game.tscn")

