extends Node

func _ready() -> void:
	OS.window_fullscreen = true
	GameHUD.player_vital_bar.hide()
	
	yield(get_tree().create_timer(5.5), "timeout")
	$ColorRect/Control/AnimationPlayer.play("New Anim")
	yield($ColorRect/Control/AnimationPlayer, "animation_finished")
	get_tree().quit()
