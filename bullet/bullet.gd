extends Area2D  # The bullet should extend Area2D, not CharacterBody2D

# Speed of the bullet
const SPEED = 500.0  

# The direction property to store the bullet's movement direction
var direction = Vector2(1, 0)  # Default direction (right)

# Time before the bullet is deleted
const LIFETIME = 2.0  

func _ready():
	# Start a timer to delete the bullet after its lifetime
	var timer = Timer.new()
	timer.wait_time = LIFETIME
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timeout"))
	add_child(timer)
	timer.start()

	# Connect the "body_entered" signal to detect collisions
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	# Move the bullet in the specified direction
	position += direction * SPEED * delta

# Called when the bullet collides with something
func _on_body_entered(body):
	queue_free()

# Called when the timer runs out
func _on_timeout():
	queue_free()
