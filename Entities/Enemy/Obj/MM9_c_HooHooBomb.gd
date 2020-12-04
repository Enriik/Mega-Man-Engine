extends EnemyCore

export (PackedScene) var enemy_explosion

onready var bullet_bhv := $BulletBehavior as FJ_BulletBehavior

onready var dmg_area = $DamageArea

func _physics_process(delta: float) -> void:
	var bodies = dmg_area.get_overlapping_bodies()
	
	for i in bodies:
		if i is TileMap:
			var en = enemy_explosion.instance()
			get_parent().add_child(en)
			en.global_position = self.global_position
			en.contact_damage = self.contact_damage
			
			FJ_AudioManager.sfx_combat_large_explosion.play()
			
			queue_free_start(false)
			return
