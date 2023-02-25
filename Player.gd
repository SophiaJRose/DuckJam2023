extends KinematicBody

export var normalRunSpeed = 20
export var runAcceleration = 3

export var fall_acceleration = 75

onready var camera = get_node("Camera")

var velocity = Vector3.ZERO
var speed = 0
var rot = Vector3.ZERO
var directionalInput = Vector3.ZERO
var beginJump = false

var direction = Vector3.ZERO

enum state {
	STAND,
	RUN,
	JUMP
}
var playerState = state.STAND
signal orbCollected

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
	# Easy reset
	if Input.is_action_pressed("restart"):
		translation = Vector3.ZERO
	
	# Get Input and Determine State
	directionalInput = Vector3.ZERO
	beginJump = false
	if is_on_floor():
		playerState = state.STAND
	if Input.is_action_pressed("strafe_right"):
		directionalInput.x += 1
		if playerState == state.STAND:
			playerState = state.RUN
	if Input.is_action_pressed("strafe_left"):
		directionalInput.x -= 1
		if playerState == state.STAND:
			playerState = state.RUN
	if Input.is_action_pressed("move_forward"):
		directionalInput.z += 1
		if playerState == state.STAND:
			playerState = state.RUN
	if Input.is_action_pressed("move_backward"):
		directionalInput.z -= 1
		if playerState == state.STAND:
			playerState = state.RUN
	if Input.is_action_pressed("jump") and is_on_floor():
		beginJump = true
		playerState = state.JUMP
		direction = directionalInput.normalized()
	
	if playerState == state.STAND:
		velocity = Vector3(0, velocity.y - fall_acceleration * delta, 0)
		direction = Vector3.ZERO
	elif playerState == state.RUN:
		direction = directionalInput.normalized()
		speed = clamp(speed + runAcceleration, 0, normalRunSpeed)
		velocity.z = speed * (direction.x * sin(rotation.y + PI) + direction.z * cos(rotation.y + PI))
		velocity.x = speed * (direction.x * sin(rotation.y + (PI/2)) + direction.z * cos(rotation.y + (PI/2)))
		velocity.y -= fall_acceleration * delta
	elif playerState == state.JUMP:
		if beginJump:
			velocity.y = 25
		# Halt air movement by pressing opposite direction
		if directionalInput.z * direction.z < 0:
			direction.z = 0.3 * directionalInput.z
		elif directionalInput.z * direction.z == 0 and directionalInput.z != 0:
			direction.z = 0.5 * directionalInput.z
		if directionalInput.x * direction.x < 0:
			direction.x = 0.3 * directionalInput.x
		elif directionalInput.x * direction.x == 0 and directionalInput.x != 0:
			direction.x = 0.5 * directionalInput.x
			
		# Ground velocity
		velocity.z = speed * (direction.x * sin(rotation.y + PI) + direction.z * cos(rotation.y + PI))
		velocity.x = speed * (direction.x * sin(rotation.y + (PI/2)) + direction.z * cos(rotation.y + (PI/2)))
		# Vertical velocity
		velocity.y -= fall_acceleration * delta
		
	# Debug text
#	print("directionalInput:" + String(directionalInput) + "\ndirection:" + String(direction) + "\nbeginJump:" + String(beginJump))

	# Check for orb collisions, then move
	var collision = move_and_collide(velocity * delta, true, true, true)
	if collision != null and collision.collider.is_in_group("Orb"):
		emit_signal("orbCollected")
	velocity = move_and_slide(velocity, Vector3.UP)
