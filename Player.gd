extends KinematicBody

export var speed = 14

export var fall_acceleration = 75

onready var camera = get_node("Camera")

var velocity = Vector3.ZERO
var rot = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_axis = event.relative / 1000 * 3
		rot.y -= mouse_axis.x
		rot.x = clamp(rot.x - mouse_axis.y, -PI/2, PI/2)
		
		camera.rotation.x = rot.x
		rotation.y = rot.y

func _physics_process(delta):
	# We create a local variable to store the input direction
	var direction = Vector3.ZERO
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("strafe_right"):
		direction.x += 1
	if Input.is_action_pressed("strafe_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z += 1
	if Input.is_action_pressed("move_backward"):
		direction.z -= 1
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += 25
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
	# Ground velocity
	velocity.z = speed * (direction.x * sin(rotation.y + PI) + direction.z * cos(rotation.y + PI))
	velocity.x = speed * (direction.x * sin(rotation.y + (PI/2)) + direction.z * cos(rotation.y + (PI/2)))
#	velocity.x = direction.x * speed * sin(rotation.y)
#	velocity.z = direction.z * speed * sin(rotation.y)
	# Vertical velocity
	velocity.y -= fall_acceleration * delta
	# Move the character
	velocity = move_and_slide(velocity, Vector3.UP)
