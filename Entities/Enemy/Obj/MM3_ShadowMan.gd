extends BossCore

enum Phase1State {
	IDLE,
	JUMPING,
	RESTARTING
}
enum Phase2State {
	DASHING,
	JUMPING
}
enum Phase3State {
	INITIAL,
	ENDING_ATTACK,
	FLEEING
}

const SHADOW_BLADE = preload("res://Entities/Enemy/Obj/MM3_ShadowBlade.tscn")
const EXPLOSION_EFF = preload("res://Entities/Effects/LargeExplosion/LargeExplosion.tscn")
const PHASE_2_HP = 16

onready var anim = $SpriteMain/Sprite/AnimationPlayer
onready var platform_bhv = $PlatformBehavior

var curr_phase = 1
var phase_1_state = Phase1State.IDLE
var phase_2_state = Phase2State.JUMPING
var phase_3_state = Phase3State.INITIAL
var pose_done : bool

func _ready() -> void:
	GameHUD.boss_vital_bar_palette.primary_sprite.modulate = NESColorPalette.WHITE4
	GameHUD.boss_vital_bar_palette.second_sprite.modulate = NESColorPalette.TORQUOISE2
	GameHUD.boss_vital_bar_palette.outline_sprite.modulate = NESColorPalette.BLACK1
	
	hide()
	anim.play("PoseAppear")
	yield(anim, "animation_finished")
	start_show_boss_health_bar()
	anim.play("Pose")
	yield(anim, "animation_finished")
	start_fill_up_health_bar()
	yield(self, "boss_done_posing")
	pose_done = true

func _physics_process(delta: float) -> void:
	if not pose_done:
		return
	
	if curr_phase == 1:
		phase_1_process()
	if curr_phase == 2:
		phase_2_process()
	if curr_phase == 3:
		phase_3_process()
		

func phase_1_process():
	if phase_1_state == Phase1State.IDLE:
		phase_1_state = Phase1State.JUMPING
		anim.play("Jump")
		platform_bhv.velocity.y = -280
		platform_bhv.WALK_SPEED = 60
		$FireBladesDelayTimer.start()
	if phase_1_state == Phase1State.JUMPING:
		if get_sprite_main_direction() == 1:
			platform_bhv.simulate_walk_left = true
			platform_bhv.simulate_walk_right = false
		else:
			platform_bhv.simulate_walk_left = false
			platform_bhv.simulate_walk_right = true
		if platform_bhv.on_floor:
			phase_1_state = Phase1State.RESTARTING
			anim.play("Idle")
			$Phase1RestartTimer.start()
	if phase_1_state == Phase1State.RESTARTING:
		platform_bhv.simulate_walk_left = false
		platform_bhv.simulate_walk_right = false
	
	if current_hp <= PHASE_2_HP:
		curr_phase = 2

func phase_2_process():
	if phase_2_state == Phase2State.DASHING:
		platform_bhv.WALK_SPEED = 150
		if $DashTimer.is_stopped():
			phase_2_state = Phase2State.JUMPING
			platform_bhv.velocity.y = -450
			anim.play("Jump")
			$FireBladeDirectDelayTimer.start()
			turn_toward_player()
	elif phase_2_state == Phase2State.JUMPING:
		platform_bhv.WALK_SPEED = 40
		if platform_bhv.on_floor:
			phase_2_state = Phase2State.DASHING
			anim.play("Dash")
			$DashTimer.wait_time = rand_range(0.2, 1)
			$DashTimer.start()
	
	if get_sprite_main_direction() == 1:
		platform_bhv.simulate_walk_left = true
		platform_bhv.simulate_walk_right = false
	else:
		platform_bhv.simulate_walk_left = false
		platform_bhv.simulate_walk_right = true

func phase_3_process():
	if phase_3_state == Phase3State.INITIAL:
		invis_timer.stop()
		flicker_anim.stop()
		sprite_main.show()
		$DamageSprite.hide()
		can_damage = false
		can_hit = false
		damage_sprite_ani.stop()
		platform_bhv.WALK_SPEED = 0
		eat_player_projectile = false
		platform_bhv.velocity.y = 0
		$DashTimer.stop()
		$FireBladeDirectDelayTimer.stop()
		destroy_all_enemies()
		phase_3_state = Phase3State.ENDING_ATTACK
	if phase_3_state == Phase3State.ENDING_ATTACK:
		if not platform_bhv.on_floor:
			anim.play("Jump")
		else:
			flee()
			phase_3_state = Phase3State.FLEEING

func fire_blades():
	var directions = [180, 115] if sprite_main.scale.x == 1 else [0, 65]
	
	anim.play("JumpAttack")
	FJ_AudioManager.sfx_combat_shadow_blade.play()
	
	for i in directions:
		var blt = SHADOW_BLADE.instance()
		get_parent().add_child(blt)
		blt.global_position = self.global_position
		blt.bullet_behavior.angle_in_degrees = i

func flee():
	anim.play("Throwing")
	yield(anim, "animation_finished")
	anim.play("Throw")
	
	for times in 9:
		for count in 3:
			var eff = EXPLOSION_EFF.instance()
			get_parent().add_child(eff)
			eff.global_position = self.global_position + Vector2(rand_range(-32, 32), rand_range(-32, 32))
		
		FJ_AudioManager.sfx_combat_buster_minicharged.play()
		
		if times == 7:
			anim.play("Flee")
		
		yield(get_tree().create_timer(0.12), "timeout")
	
	yield(anim, "animation_finished")
	GameHUD.boss_vital_bar.hide()
	queue_free()

func _on_FireBladeDirectDelayTimer_timeout() -> void:
	anim.play("JumpAttack")
	FJ_AudioManager.sfx_combat_shadow_blade.play()
	
	var blt = SHADOW_BLADE.instance()
	get_parent().add_child(blt)
	blt.global_position = self.global_position
	if player != null:
		var ag = self.global_position.angle_to_point(player.global_position)
		blt.bullet_behavior.angle_in_degrees = rad2deg(ag) - 180
	else:
		blt.bullet_behavior.angle_in_degrees = -get_sprite_main_direction() * 180

func _on_PlatformBehavior_by_wall() -> void:
	sprite_main.scale.x = -sprite_main.scale.x

func _on_FireBladesDelayTimer_timeout() -> void:
	fire_blades()

func _on_Phase1RestartTimer_timeout() -> void:
	phase_1_state = Phase1State.IDLE

func _on_MM3_ShadowMan_taken_damage(value, target, player_proj_source) -> void:
	if current_hp <= 1:
		current_hp = 1
		GameHUD.update_boss_vital_bar(current_hp)
		curr_phase = 3
