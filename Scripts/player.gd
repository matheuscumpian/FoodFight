extends "res://Scripts/Character.gd"


var gravity = Vector3(0,-12,0)
var speed = 10
var jump_speed = 7
var spin = 0.1
var can_jump = false
const RUN_BLEND_AMOUNT = 0.05
const IDLE_BLEND_AMOUNT = 0.05
const BLEND_MINIMUM = 1 
var move_state = 0
var looking = 0
var velocity = Vector3()

func _physics_process(delta):
	velocity += gravity * delta
	
	get_input()
	velocity = move_and_slide(velocity, Vector3.UP)
	if can_jump and is_on_floor():
		velocity.y = jump_speed
		
	animate()
	change_lookDirection()
	

func change_lookDirection():

	$Armature.rotation.y = looking

	pass
func get_input():

	var vy = velocity.y

	velocity = Vector3()
	
	if is_on_floor():
		if Input.is_action_pressed("foward") and not Input.is_action_pressed("back"):
			velocity += transform.basis.z * speed
			looking = 0
		if Input.is_action_pressed("back") and not Input.is_action_pressed("foward"):
			velocity -= transform.basis.z * speed 
			looking = PI
		if Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
			velocity -= transform.basis.x * speed 
			looking = PI * 1.5
		if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
			velocity += transform.basis.x * speed
			looking = PI * 0.5
	
	can_jump = false 
	if Input.is_action_just_pressed("jump"):
		can_jump = true
		
	velocity.y = vy
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-lerp(0,spin,event.relative.x / 10))
	
	
func animate():
	var animate = $Armature/AnimationTreePlayer
	if abs(velocity.z) > BLEND_MINIMUM:
		move_state += RUN_BLEND_AMOUNT
	else:
		move_state -= IDLE_BLEND_AMOUNT
	
	move_state = clamp(move_state, 0 ,1)
		
	animate.blend2_node_set_amount("Move", move_state)
	


