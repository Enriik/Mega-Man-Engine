extends Level

var first_time : int = 2

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed():
			if event.scancode == KEY_TAB:
				touhou_screen_toggle()
			if event.scancode == KEY_1:
				first_time = 1
				touhou_screen_toggle()
			if event.scancode == KEY_3:
				touhou_fade_out()
			if event.scancode == KEY_4:
				$SeizureCtrler.stop()

func _ready() -> void:
	GlobalVariables.touhou = false

func touhou_screen_toggle():
	if not GlobalVariables.touhou:
		if first_time > 0:
			$MainAnim/Anim.play("FlashToDarkscale")
			first_time -= 1
		else:
			$MainAnim.play("StartTouhou")
		GlobalVariables.touhou = true
	else:
		$MainAnim.play("StopTouhou")
		GlobalVariables.touhou = false
	
	$SeizureWarn/AnimationPlayer.stop()
	$SeizureWarn/Label.hide()

func show_seizure_warning():
	$SeizureWarn/AnimationPlayer.play("Show")

func touhou_fade_out():
	$MainAnim/Anim.play("FlashToNormal")
	GlobalVariables.touhou = false
