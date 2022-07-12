extends Node2D


onready var label = $LabelPos/Label
onready var anim_player = $AnimationPlayer


func display_combo(combo_count: int):
	label.text = "Combo " + str(combo_count)
	anim_player.play("up")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "up":
		queue_free()
