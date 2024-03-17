extends Unit

func move_self():
	# Automatic on contact swap
	ray.rotation = ray_angle
	ray.force_raycast_update()
	if ray.get_collider() and ray.get_collider().get_parent() is Unit:
		print(ray.get_collider().get_parent())
		if is_infected:
			ray.get_collider().get_parent().emit_signal("gain_infection")
			emit_signal("lost_infection")
		elif ray.get_collider().get_parent().is_infected:
			emit_signal("gain_infection")
			ray.get_collider().get_parent().emit_signal("lost_infection")
	else:
		var tile_map = Globals.tilemap
		var tween = create_tween()
		
		if tile_map.get_cell_tile_data(1,target_pos) and tile_map.get_cell_tile_data(1,target_pos).get_custom_data("Obstacle"):
			tween.tween_property(self,"scale", scale*1.2,0.2)
			tween.tween_property(self,"position", tile_map.map_to_local(target_pos+current_dir),0.2)
			tween.tween_property(self,"scale", Vector2(1,1),0.2)
			is_moving = true
			tween.play()
			animator.play("move")
			await tween.finished
			animator.stop()
			is_moving = false
			return tween.finished
		else:
			tween.tween_property(self,"position", tile_map.map_to_local(target_pos),0.2)
			is_moving = true
			tween.play()
			animator.play("move")
			await tween.finished
			animator.stop()
			is_moving = false
			return tween.finished

func can_move_there(pos:Vector2i):
	var tile_map = Globals.tilemap
	return !tile_map.get_cell_tile_data(0,pos).get_custom_data("Wall")

