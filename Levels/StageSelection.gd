extends CanvasLayer

var bot : bool = true

func _ready() -> void:
	FJ_AudioManager.stop_bgm()
	
	yield(get_tree().create_timer(1.6), "timeout")
	
	if not bot:
		return
	
	for i in 6:
		yield(get_tree().create_timer(0.05), "timeout")
		FJ_AudioManager.d = true
		move_down()
	
	yield(get_tree().create_timer(0.1), "timeout")
	
	FJ_AudioManager.a = true
	start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_right"):
		move_down()
	if event.is_action_pressed("game_left"):
		move_up()
	if event.is_action_pressed("game_jump"):
		start()
	if event.is_action_pressed("ui_accept"):
		bot = false

func move_up():
	$Cursor.rect_position.y -= 8
	$Select.play(0.01)

func move_down():
	$Cursor.rect_position.y += 8
	$Select.play(0.01)

func start():
	$Start.play()
	$Select.stop()
	$FadeScreen.go_to_scene("res://Levels/Levels/Showcase.tscn")
	get_tree().paused = true
