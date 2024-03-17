extends Node
class_name User_Controles
@export var unit:Unit
var direction:Vector2i

func _physics_process(_delta):
	if unit.is_moving:
		return
	var tile_map = Globals.tilemap
	var action_pressed = true
	
	if Input.is_action_pressed("move_R"):
		direction = Vector2i.RIGHT
	elif Input.is_action_pressed("move_L"):
		direction = Vector2i.LEFT
	elif Input.is_action_pressed("move_DOWN"):
		direction = Vector2i.DOWN
	elif Input.is_action_pressed("move_UP"):
		direction = Vector2i.UP
	else :
		action_pressed = false
		
	unit.ray_angle = ((direction as Vector2).angle())
	unit.current_dir = direction
	#if unit.ray.get_collider():
		#if unit.ray.get_collider().get_parent() is Unit:
			#print(unit.ray.get_collider().get_parent())
			#unit.ray.get_collider().get_parent().emit_signal("gain_infection")
			#unit.ray.get_collider().get_parent().ray.rotation = unit.ray_angle
			#unit.emit_signal("lost_infection")
			#return
					#
	if action_pressed and !unit.infection_delay:
		unit.ray.rotation = unit.ray_angle
		if unit.can_move_there(direction + tile_map.local_to_map(unit.global_position)):
			unit.target_pos = direction + tile_map.local_to_map(unit.global_position)
			# Auto step base infection
			
			unit.move_self()


func _enter_tree():
	#unit.is_infected = true
	unit.emit_signal("gain_infection")
	
func _exit_tree():
	#unit.is_infected = false
	unit.emit_signal("lost_infection")
