extends Node

@export var spawnPositions = [
	Vector3(6, 4.5, 18),
	Vector3(-14, 5.5, -18),
	Vector3(-14, -2.5, -18),
	Vector3(16, 9.5, -12),
	Vector3(-20, 13.5, 4)
]
@export var orbHealValues = [
	600,
	600,
	600,
	1500,
	900
]
@onready var orb = get_node("Orb")
var position = -1
var spawnTimer = 0

func _ready():
	randomize()
	position = randi() % spawnPositions.size()
	orb.position = spawnPositions[position]

func _process(_delta):
	if spawnTimer >= 0:
		spawnTimer -= 1
	if spawnTimer == 0:
		orb.collision_layer = 4
		var newPosition = position
		while newPosition == position:
			newPosition = randi() % spawnPositions.size()
		position = newPosition
		orb.position = spawnPositions[position]

func _on_Player_orbCollected():
	orb.collision_layer = 0
	orb.position = Vector3(0, -10, 0)
	GlobalVariables.deathTimer = min(GlobalVariables.deathTimer + orbHealValues[position], GlobalVariables.deathTimerMax)
	spawnTimer = 15
