extends CharacterBody2D

var Jumping : bool = false

@export var Speed : float = 10.0
@export var Friction : float = .10
@export var Gravity : int = 500
@export var Force : float = 0.05
@export var Jump : float = -2000.0
@export var JumpSpeed : float = 0.1

@onready var Sprite : Sprite2D = $Idle
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var variable_jump : Timer = $VariableJump

const MAX_SPEED = 400
const ACCELERATION = 2150
const FRICTION = 120
const MAX_GRAVITY = 20.0
const JUMP_HEIGHT = 700

var can_move : bool = true
var has_jumped : bool = false

@export var gravity : float = 20
@export var walk_speed : int = 40
@export var run_speed : int = 60

func get_jump():
	velocity.y = -JUMP_HEIGHT
	animated_sprite.play("jump")

func _physics_process(delta):
	var x_input : float = Input.get_action_strength("D") - Input.get_action_strength("A")
	var velocity_weight : float = delta * (ACCELERATION if x_input else FRICTION)
	
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true
	if can_move:
		velocity.x = move_toward(velocity.x, x_input * MAX_SPEED, ACCELERATION * delta)
			
		if is_on_floor():
			if Input.is_action_pressed("A") or Input.is_action_pressed("D"):
				animated_sprite.play("run")
		
		if Input.is_action_just_pressed("Space") and !has_jumped and is_on_floor():
			$"../../Audio/JumpSfx".play()
			has_jumped = true
			get_jump()
			variable_jump.start(1)
			
		
		if Input.is_action_just_released("Space") and velocity.y < 0:
			if variable_jump.time_left > 0.8:
				velocity.y = lerp(velocity.y, 0.0, 20.0 * delta)
		
		if is_on_floor():
			has_jumped = false
		
		if is_on_floor() and velocity == Vector2.ZERO:
			animated_sprite.play("idle")
			gravity = lerp(gravity, 12.0, 20.0 * delta)
			
		if !is_on_floor() and Input.is_action_pressed("S"):
			gravity = 60
			
		gravity = lerp(gravity, MAX_GRAVITY, 12.0 * delta)
		
		velocity.y += gravity
		
		move_and_slide()
