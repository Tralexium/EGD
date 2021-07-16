extends KinematicBody2D

enum AnimationKind {
	IDLE,
	WALK,
	JUMP,
	DASH,
	LAND,
	SPIN_RIGHT,
	SPIN_LEFT,
}

export var acceleration := 4000.0
export var deceleration := 0.4
export var walk_speed := 450.0
export var dash_speed := 2000.0
export var max_fall_speed := 1000.0
export var jump_force := 1000.0
export var djump_force := 800.0
export var walljump_push := 1500.0
export var gravity := 2500.0
export var dash_duration := 0.07
export var dash_cooldown := 0.25
export var coyote_time := 0.1

var UP_DIR := Vector2.UP
var frozen := false

var velocity := Vector2.ZERO
var hor_direction := 1
var on_ground := false
var has_djump := false
var can_walljump := false
var dashed := false
var current_animation : int = AnimationKind.IDLE
var eyes_move_speed := 300.0
var eyes_hor_offset := 0
var eyes_ver_offset := -5
var eyes_hor_move_offset := 14
var eyes_ver_move_offset := 7

onready var n_StretchAnimations : AnimationPlayer = $StretchAnimations
onready var n_SpinAnimations : AnimationPlayer = $SpinAnimations
onready var n_PlayerBody : Sprite = $PlayerBody
onready var n_PlayerEyes : Sprite = $PlayerBody/PlayerEyes
onready var n_DashCooldown : Timer = $DashCooldown
onready var n_DashDuration : Timer = $DashDuration
onready var n_JumpCoyoteTime : Timer = $JumpCoyoteTime
onready var n_WalljumpCoyoteTime : Timer = $WalljumpCoyoteTime


func _process(delta: float) -> void:
	n_PlayerBody.self_modulate = ColorManager.primary_color
	n_PlayerEyes.self_modulate = ColorManager.light_color


func _physics_process(delta: float) -> void:
	# Check if on ground & restore double jump
	if test_move(global_transform, Vector2(0, ceil(velocity.y * delta) + 1)) and velocity.y >= 0:
		on_ground = true
		has_djump = true
		n_JumpCoyoteTime.start(coyote_time)
		if n_DashCooldown.is_stopped():
			dashed = false
		if velocity.y > max_fall_speed/2:
			_play_animation(AnimationKind.LAND)
	elif n_JumpCoyoteTime.is_stopped():
		on_ground = false
	
	# Check if we can walljump
	if is_on_wall():
		can_walljump = true
		n_WalljumpCoyoteTime.start(coyote_time)
	elif n_WalljumpCoyoteTime.is_stopped():
		can_walljump = false
	
	# Apply gravity
	if n_DashDuration.is_stopped():
		velocity.y += gravity * delta
	
	_movement()
	_move_eyes()
	_clamp_movement_speed()
	velocity = move_and_slide(velocity, UP_DIR)


func _movement() -> void:
	var _delta := get_physics_process_delta_time()
	var _hor_movement := int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	if _hor_movement != 0 and not frozen:
		hor_direction = _hor_movement
		if abs(velocity.x) < walk_speed:
			velocity.x += hor_direction * acceleration * _delta
			_play_animation(AnimationKind.WALK)
		elif abs(velocity.x) > walk_speed and n_DashDuration.is_stopped():
			velocity.x = lerp(velocity.x, 0, deceleration)
		elif n_DashDuration.is_stopped():
			velocity.x = hor_direction * walk_speed
			_play_animation(AnimationKind.WALK)
	elif n_DashDuration.is_stopped():
		velocity.x = lerp(velocity.x, 0, deceleration)
		_play_animation(AnimationKind.IDLE)
	
	if Input.is_action_just_pressed("jump") and n_DashDuration.is_stopped() and not frozen:
		if on_ground:
			velocity.y = -jump_force
			_play_animation(AnimationKind.JUMP)
		elif can_walljump:
			velocity.x = walljump_push * -hor_direction
			velocity.y = -djump_force
			if hor_direction == 1:
				_play_animation(AnimationKind.SPIN_RIGHT)
			else:
				_play_animation(AnimationKind.SPIN_LEFT)
		elif has_djump:
			has_djump = false
			velocity.y = -djump_force
			if hor_direction == 1:
				_play_animation(AnimationKind.SPIN_RIGHT)
			else:
				_play_animation(AnimationKind.SPIN_LEFT)
	
	if Input.is_action_just_pressed("dash") and !dashed and n_DashCooldown.is_stopped() and !is_on_wall() and not frozen:
		dashed = true
		_play_animation(AnimationKind.DASH)
		velocity.x = hor_direction * dash_speed
		velocity.y = 0
		n_DashCooldown.start(dash_cooldown)
		n_DashDuration.start(dash_duration)
	
	if Input.is_action_just_released("jump") and velocity.y < 0 and not frozen:
		velocity.y *= 0.5


func _move_eyes() -> void:
	var _delta := get_physics_process_delta_time()
	var _new_eye_pos = Vector2.ZERO
	_new_eye_pos.x = eyes_hor_offset + (eyes_hor_move_offset * hor_direction)
	if on_ground:
		_new_eye_pos.y = eyes_ver_offset
	else:
		_new_eye_pos.y = eyes_ver_offset + (eyes_ver_move_offset * sign(velocity.y))
	n_PlayerEyes.position = n_PlayerEyes.position.move_toward(_new_eye_pos, eyes_move_speed * _delta)


func _clamp_movement_speed() -> void:
	var _delta := get_physics_process_delta_time()

	velocity.x = clamp(velocity.x, -dash_speed, dash_speed)
	velocity.y = clamp(velocity.y, -jump_force, max_fall_speed)


func _play_animation(_animation: int) -> void:
	current_animation = _animation
	
	match current_animation:
		AnimationKind.IDLE:
			if n_StretchAnimations.current_animation != "land" and n_StretchAnimations.current_animation != "jump" and on_ground:
				n_StretchAnimations.play("idle")
		
		AnimationKind.WALK:
			if n_StretchAnimations.current_animation != "land" and n_StretchAnimations.current_animation != "jump" and on_ground:
				n_StretchAnimations.play("walk")
		
		AnimationKind.JUMP:
			n_StretchAnimations.play("jump")
		
		AnimationKind.LAND:
			n_StretchAnimations.play("land")
		
		AnimationKind.DASH:
			n_PlayerBody.rotation = 0
			n_SpinAnimations.stop()
			n_StretchAnimations.play("dash")
		
		AnimationKind.SPIN_RIGHT:
			n_SpinAnimations.stop()
			n_SpinAnimations.play("spin_right")
		
		AnimationKind.SPIN_LEFT:
			n_SpinAnimations.stop()
			n_SpinAnimations.play("spin_left")
