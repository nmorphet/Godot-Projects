extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true
var alive = true

func _physics_process(delta):
	#if player_chase:
		#velocity = (player.get_global_position() - position).normalized() * movementSpeed * delta
	#else:
		#velocity = lerp(velocity, Vector2.ZERO, 0.07)
	#move_and_collide(velocity)
	deal_with_damage()
	update_health()
	if alive == true:
		if player_chase:
			
			move_and_collide(Vector2(0,0))
			
			position += (player.position - position)/speed	
			
			$AnimatedSprite2D.play("walk_side")
			
			if(player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			
		else:
			$AnimatedSprite2D.play("idle_front")
	else:
		
		$AnimatedSprite2D.play("death")
		$AnimatedSprite2D.animation_finished
		
		

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
		
func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 100
			$take_damage_cooldown.start()
			can_take_damage = false
			if health <= 0:
				alive = false


func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	
func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	healthbar.visible = true





func _on_animated_sprite_2d_animation_finished():
	self.queue_free()
	print("animation finished")
		
