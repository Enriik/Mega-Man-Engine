extends EnemyCore

export (float) var attack_range = 64

onready var pf_bhv = $PlatformBehavior
onready var attack_timer = $AttackTimer
onready var turn_towards_timer = $TurnTowardsTimer
onready var sprite_ani = $SpriteMain/Ani

var is_attack_ready = true

func _process(delta):
	if within_player_range(attack_range) and is_attack_ready:
		pf_bhv.jump_start()
		is_attack_ready = false
	
	if is_on_floor():
		sprite_ani.play("Idle")
	else:
		sprite_ani.play("Jump")

func _on_PlatformBehavior_landed():
	attack_timer.start()


func _on_AttackTimer_timeout():
	is_attack_ready = true


func _on_TurnTowardsTimer_timeout():
	turn_toward_player()


const let_it_be = preload("res://Entities/Enemy/Obj/Adv3_Bullet.tscn")
func _on_Lobster_taken_damage(value, target, player_proj_source) -> void:
	var blt = let_it_be.instance()
	get_parent().add_child(blt)
	blt.global_position = global_position
	var ag = global_position.angle_to_point(player.global_position)
	blt.bullet_behavior.angle_in_degrees = rad2deg(ag) - 180
	
	FJ_AudioManager.sfx_combat_shot.play()
