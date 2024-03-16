extends Unit

func move_self():
	var tile_map = Globals.tilemap
	var tween = create_tween()
	tween.tween_property(self,"position", tile_map.map_to_local(target_pos),0.2)
	is_moving = true
	ray.rotation = ray_angle
	tween.play()
	animator.play("move")
	await tween.finished
	is_moving = false
	animator.stop()
	return tween.finished

func can_move_there(pos:Vector2i):
	var tile_map = Globals.tilemap
	return !tile_map.get_cell_tile_data(0,pos).get_custom_data("Wall")

func ai_contole():
	pass
