extends CanvasLayer

func _ready() -> void:
	FJ_AudioManager.stop_bgm()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_right"):
		$Cursor.rect_position.y += 8
		$Select.play(0.01)
	if event.is_action_pressed("game_left"):
		$Cursor.rect_position.y -= 8
		$Select.play(0.01)
	if event.is_action_pressed("game_jump"):
		$Start.play()
		$FadeScreen.go_to_scene("res://Levels/Levels/Showcase.tscn")
		get_tree().paused = true
