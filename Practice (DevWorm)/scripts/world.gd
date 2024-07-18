extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if global.game_first_loadin == true:
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	else:
		$player.position.x = global.player_exit_cliffside_posx
		$player.position.y = global.player_exit_cliffside_posy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scenes()


func _on_cliffside_transition_point_body_entered(body):
	if body.has_method("player"):
		print("body entered, trans scene is: ", global.transition_scene)
		global.transition_scene = true
		print("now it is: ", global.transition_scene)
		


#func _on_cliffside_transition_point_body_exited(body):
	#if body.has_method("player"):
		#global.transition_scene = false


func change_scenes():
	if global.transition_scene == true:
		if global.current_scene == "world":
			print("change to file")
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			print("finish")
			global.game_first_loadin = false
			global.finish_changescenes()
