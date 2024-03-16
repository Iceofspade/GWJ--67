extends Node2D
class_name Unit
signal moved
signal died
signal lost_infection
signal gain_infection
@onready var controler = preload("res://scenes/user_controler.tscn")
@export var ray:RayCast2D

var target_pos:Vector2i
var ray_angle:float

var is_infected = false
var is_moving = false
var is_dead = false
var infection_delay = false

@export var max_movement = 3

func _init():
	gain_infection.connect(add_infected)
	lost_infection.connect(remove_infection)
	
		
func _ready():
	if has_node("user_controler"):
		is_infected = true
		is_dead = true
	Globals.step.connect(ai_contole)
		
func _physics_process(_delta):
	# Uncomment for independant movement
	if !is_infected:
		ai_contole()
## Automatic check on contact swap bodies
	#elif ray.get_collider() and ray.get_collider().get_parent() is Unit and is_infected:
		#print(ray.get_collider().get_parent())
		#ray.get_collider().get_parent().emit_signal("gain_infection")
		#emit_signal("lost_infection")
		pass
		
func move_self():
	# Automatic on contact swap
	ray.rotation = ray_angle
	ray.force_raycast_update()
	if ray.get_collider() and ray.get_collider().get_parent() is Unit:
		print(ray.get_collider().get_parent())
		ray.get_collider().get_parent().emit_signal("gain_infection")
		ray.get_collider().get_parent().ray.rotation = ray_angle
		emit_signal("lost_infection")
	else:
		var tile_map = Globals.tilemap
		var tween = create_tween()
		tween.tween_property(self,"position", tile_map.map_to_local(target_pos),0.2)
		is_moving = true
		tween.play()
		await tween.finished
		is_moving = false
		return tween.finished

func can_move_there(pos:Vector2i):
	var tile_map = Globals.tilemap
	return !tile_map.get_cell_tile_data(0,pos).get_custom_data("Wall")

func ai_contole():
	pass

func add_infected():
	if has_node("user_controler"):
		modulate = Color.GREEN
		return
	var controls = controler.instantiate()
	is_infected  = true
	is_dead = true
	ray.enabled = true
	ray.show()
	controls.unit = self
	add_child(controls)
	infection_delay = true
	await get_tree().create_timer(0.2).timeout
	infection_delay = false

func remove_infection():
	if has_node("user_controler"):
		remove_child.call_deferred(get_node("user_controler"))
		is_infected = false
		modulate = Color.WHITE
		if is_dead:
			ray.enabled = false
			ray.hide()
