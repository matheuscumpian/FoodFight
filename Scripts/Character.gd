extends KinematicBody

const PROJECTILE_SPEED = 50
var ammo_types = {}
func _enter_tree():
	ammo_types = file_graber.get_files("res://Scenes/Ammo/ammo_scenes/")
	randomize()
func fire():
	var random_bullet = ammo_types[randi() % ammo_types.size()]
	var bullet = load(random_bullet).instance()
	add_child(bullet)
	#bullet.add_collision_exception_with(self)
	bullet.set_as_toplevel(true) #ignore the parent transform
	bullet.global_transform = $Foward.global_transform
	var character_forward = get_global_transform().basis[2].normalized()
	bullet.set_linear_velocity(character_forward * PROJECTILE_SPEED)
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("fire"):
		fire()
		

