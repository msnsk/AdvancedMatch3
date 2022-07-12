extends Node2D

onready var damage_label = $DamageLabel
onready var anim_playser = $AnimationPlayer

func _ready():
	anim_playser.play("show")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "show":
		queue_free()
