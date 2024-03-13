extends Unit

var go_up = true

func ai_contole():
	if is_moving or is_infected:
		return
	var tile_map = Globals.tilemap
	
	if ray.is_colliding():
		go_up=!go_up
		
	if go_up:
		target_pos = tile_map.local_to_map(global_position)+Vector2i.UP
		ray_angle = Vector2.UP.angle() 
	else:
		target_pos = tile_map.local_to_map(global_position)+Vector2i.DOWN
		ray_angle = Vector2.DOWN.angle() 
	if can_move_there(target_pos):
		move_self()
	pass
