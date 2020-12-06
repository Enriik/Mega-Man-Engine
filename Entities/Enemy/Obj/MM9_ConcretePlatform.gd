extends EnemyCore

enum State {
	INITIAL,
	SHIFTING,
	MOVING
}

const ACTIVATE_SHIFT = Vector2(0, 2)

export (bool) var down
export (float) var shift_time = 0.08

onready var initial_gpos : Vector2 = global_position

var state = State.INITIAL

func _ready() -> void:
	if down:
		$SpriteMain/Sprite/AnimationPlayer.play("FlashingDown")
	else:
		$SpriteMain/Sprite/AnimationPlayer.play("FlashingUp")

func activate():
	state = State.SHIFTING
	position += ACTIVATE_SHIFT
	yield(get_tree().create_timer(shift_time), "timeout")
	state = State.MOVING
	position -= ACTIVATE_SHIFT
	
	play_sound()
	
	$BulletBehavior.active = true
	if down:
		$BulletBehavior.angle_in_degrees = 90
	else:
		$BulletBehavior.angle_in_degrees = -90

func _on_DetectArea2D_area_entered(area: Area2D) -> void:
	if not state == State.INITIAL:
		return
	if not area.get_owner() is Player:
		return
	
	activate()

func play_sound():
	if down:
		FJ_AudioManager.sfx_env_concrete_down.play()
	else:
		FJ_AudioManager.sfx_env_concrete_up.play()
