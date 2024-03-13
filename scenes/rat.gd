extends Unit
var go_right = true




func ai_contole():
	if is_moving or is_infected:
		return
	var tile_map = Globals.tilemap
	
	if ray.is_colliding():
		go_right=!go_right
		
	if go_right:
		target_pos = tile_map.local_to_map(global_position)+Vector2i.RIGHT
		ray_angle = Vector2.RIGHT.angle() 
	else:
		target_pos = tile_map.local_to_map(global_position)+Vector2i.LEFT
		ray_angle = Vector2.LEFT.angle() 

	if can_move_there(target_pos):
		move_self()
	pass
