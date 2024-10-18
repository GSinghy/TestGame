extends CharacterBody2D

const GRAVITY = 1000.0
const SPEED = 200.0
const JUMP_SPEED = -400.0

enum State { Idle, Run }

var current_state: State = State.Idle  # Initialize directly with type annotation

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	velocity.x = 0  # Reset horizontal velocity

	# Handle input for movement
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
		current_state = State.Run
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
		current_state = State.Run
	else:
		if is_on_floor():
			current_state = State.Idle

	# Handle jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED

	# Apply gravity
	if !is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()
	update_animation()

	# Shoot bullet when X is pressed
	if Input.is_action_just_pressed("shoot"):
		shoot_bullet()

func update_animation() -> void:
	match current_state:
		State.Idle:
			animated_sprite.play("idle")
		State.Run:
			animated_sprite.play("run")

# Function to shoot a bullet
func shoot_bullet():
	var bullet_scene = preload("res://bullet/bullet.tscn")  # Ensure this path is correct
	var bullet = bullet_scene.instantiate()  # Create an instance of the bullet

	# Set the bullet's position to the player's global position (spawn from player)
	bullet.global_position = global_position

	# Set bullet's direction based on player input
	if Input.is_action_pressed("ui_left"):
		bullet.direction = Vector2(-1, 0)  # Shoot left
