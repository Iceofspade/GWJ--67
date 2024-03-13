extends Node
class_name User_Controles
@export var unit:Unit

func _physics_process(_delta):
	if unit.is_moving:
		return
	var tile_map = Globals.tilemap
	var direction:Vector2i
	
	if Input.is_action_pressed("move_R"):
		direction = Vector2i.RIGHT
	elif Input.is_action_pressed("move_L"):
		direction = Vector2i.LEFT
	elif Input.is_action_pressed("move_DOWN"):
		direction = Vector2i.DOWN
	elif Input.is_action_pressed("move_UP"):
		direction = Vector2i.UP
	else :
		direction = Vector2i.ZERO
		
		
	if unit.ray.get_collider():
		if  unit.ray.get_collider().get_parent() is Unit:
			print(unit.ray.get_collider().get_parent())
			unit.ray.rotation = ((direction as Vector2).angle()) 
			unit.ray.get_collider().get_parent().emit_signal("gain_infection")
			unit.emit_signal("lost_infection")
			return
					
	if direction:
		if unit.can_move_there(direction + tile_map.local_to_map(unit.global_position)):
			unit.target_pos = direction + tile_map.local_to_map(unit.global_position)
			unit.ray_angle = ((direction as Vector2).angle()) 
			# Auto step base infection

			unit.move_self()
			# Uncomment for step based swap bodies 
			Globals.emit_signal("step")
			
			
	# Manual base infection
	#if Input.is_action_just_pressed("infect") and unit.ray.get_collider():
		#if  unit.ray.get_collider().get_parent() is Unit:
			#print(unit.ray.get_collider().get_parent())
			#unit.ray.get_collider().get_parent().emit_signal("gain_infection")
			#unit.emit_signal("lost_infection")
func _enter_tree():
	#unit.is_infected = true
	unit.emit_signal("gain_infection")
	
func _exit_tree():
	#unit.is_infected = false
	unit.emit_signal("lost_infection")
