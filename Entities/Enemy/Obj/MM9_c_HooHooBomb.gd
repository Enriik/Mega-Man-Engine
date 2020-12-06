extends EnemyCore

const BULLET_DAMAGE = 2
const BULLET = preload("res://Entities/Enemy/Obj/MM2_Bullet.tscn")

export (PackedScene) var enemy_explosion

onready var bullet_bhv := $BulletBehavior as FJ_BulletBehavior
onready var dmg_area = $DamageArea

func _physics_process(delta: float) -> void:
	var bodies = dmg_area.get_overlapping_bodies()
	
	for i in bodies:
		if i is TileMap:
			explode()
			return

func explode():
	var en = enemy_explosion.instance()
	get_parent().add_child(en)
	en.global_position = self.global_position
	en.contact_damage = self.contact_damage
	
	FJ_AudioManager.sfx_combat_large_explosion.play()
	
	split_bullets()
	
	queue_free_start(false)
	return

func split_bullets():
	var angles = [-120, -105, -75, -60]
	
	for i in angles:
		var blt = BULLET.instance()
		get_parent().add_child(blt)
		blt.global_position = self.global_position
		blt.contact_damage = BULLET_DAMAGE
		blt.bullet_behavior.angle_in_degrees = i
		blt.bullet_behavior.gravity = 600
		blt.bullet_behavior.speed = 240
		blt.bullet_behavior.acceleration = -120
