extends Node

var player_current_attack = false

var current_scene = "world" #world cliff_side
var transition_scene = false

var player_exit_cliffside_posx = 218
var player_exit_cliffside_posy = 20
var player_start_posx = 214
var player_start_posy = 100

var game_first_loadin = true


func finish_changescenes():
	print("CHANGE SCENES CALLED")
	print("transition scene is: ", transition_scene)
	print("current scene is: ", current_scene)
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
