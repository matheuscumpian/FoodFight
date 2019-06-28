extends KinematicBody



#movement
var vel = Vector3()
var dir = Vector3()
var facing_direction = 0

const MAX_SPEED = 10
const ACCEL = 5
const DECCEL = 10 
const JUMP_SPEED = 15
const GRAVITY = -45

#Animation
const BLEND_MINIMUM = 45.4
const RUN_BLEND_AMOUNT = 0.1
const IDLE_BLEND_AMOUNT = 5
var move_state = 0



func _physics_process(delta):
	move(delta)
	face_foward()
	animate()
	pass
	
func move(delta):
	var movement_dir = get_2d_movement()
	var camera_xform = $Camera.get_global_transform()
	
	dir = Vector3(0,0,0)
	
	dir += camera_xform.basis.z.normalized() * movement_dir.y
	dir += camera_xform.basis.x.normalized() * movement_dir.x
	
	dir = move_vertically(dir, delta)
	vel = h_accel(dir, delta)
	
	move_and_slide(vel, Vector3.UP)
	
func face_foward():
	$Armature.rotation.y = facing_direction
	pass
	
func animate():
	
	var animate = $Armature/AnimationTreePlayer
	print("TAMANHO DO VETOR: " + str(vel.length()))
	if vel.length() > BLEND_MINIMUM:
		move_state += RUN_BLEND_AMOUNT
	else:
		move_state -= IDLE_BLEND_AMOUNT
	
	move_state = clamp(move_state, 0 ,1)
		
	animate.blend2_node_set_amount("Move", move_state)
	
func get_2d_movement():
	var movement2D = Vector2()
	if Input.is_action_pressed("foward") and not Input.is_action_pressed("back"):
		movement2D.y = -1
		facing_direction = 0
	if Input.is_action_pressed("back") and not Input.is_action_pressed("foward"):
		movement2D.y = 1
		facing_direction = PI
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		movement2D.x = -1
		facing_direction = PI / 2
	if Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		movement2D.x = 1
		facing_direction = PI * 1.5
	return movement2D.normalized()	
	
func move_vertically(dir, delta):
	vel.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y = JUMP_SPEED
	elif is_on_floor():
		vel.y = GRAVITY

	dir.y = 0
	dir = dir.normalized()
	return dir


func h_accel(dir, delta):
	var vel_2D = vel
	vel_2D.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(vel_2D) > 0:
		accel = ACCEL
	else:
		accel = DECCEL

	vel_2D = vel_2D.linear_interpolate(target, accel * delta)

	vel.x = vel_2D.x
	vel.z = vel_2D.z

	return vel