extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false

const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("idle_front")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	update_health()
	
	if health <= 0:
		player_alive = false #would add end screen here
		health = 0
		print("player dead")
		self.queue_free()

func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else :
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_side")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_side")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_side")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_side")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_front")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_front")	
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_back")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_back")
	move_and_slide()


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func player():
	pass

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	
func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_side")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_side")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_front")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_back")
			$deal_attack_timer.start()


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
	
func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
	if global.current_scene == "cliff_side":
		$world_camera.enabled = false
		$cliffside_camera.enabled = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
		

func _on_regen_timer_timeout():
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
		if health <= 0:
			health = 0
