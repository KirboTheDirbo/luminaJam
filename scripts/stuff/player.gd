extends CharacterBody2D

#region vars & consts
var talking:bool = false
#region collision
var collide:bool = true
var in_thing:bool = false
#endregion
#region gravity
var gravity:float = 0
const speed:int= 190
const GRAVITY_LIMIT:int = 500
#endregion
#region accel and friction
const ACCEL: float = 12.5
const FRICTION: float = 16.5
#endregion
var main_sm: LimboHSM
#endregion
#region essential code
func _ready() -> void:
	
	initiate_state_machine()


#endregion
#region a bunch of general movement code
func get_input() -> Vector2:
	var input:Vector2 = Vector2.ZERO;input.x = Input.get_axis("left","right")
	input = input.normalized()
	return input

func horizontal_movement() -> void:
	var inputDir:Vector2 = get_input()
	if talking:
		inputDir = Vector2.ZERO
	if inputDir.x != 0: accelerate(inputDir)
	else: add_friction()
	flip_sprite(inputDir.x); move_and_slide()

func accelerate(dir) -> void:
	velocity.x = move_toward(velocity.x, speed * dir.x,ACCEL)
func add_friction() -> void:
	velocity.x = move_toward(velocity.x,0,FRICTION)
func flip_sprite(dir) -> void:
	if dir == 1: $AnimatedSprite2D.flip_h = false
	elif dir == -1:$AnimatedSprite2D.flip_h = true
#endregion

#region state machine stuff

func initiate_state_machine():
	main_sm = LimboHSM.new();add_child(main_sm)
	
	var idle_state:LimboState = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var walk_state:LimboState = LimboState.new().named("walk").call_on_enter(walk_start).call_on_update(walk_update)
	var fall_state:LimboState = LimboState.new().named("fall").call_on_enter(fall_start).call_on_update(fall_update)
	var phase_state:LimboState = LimboState.new().named("phase").call_on_enter(phase_start)
	
	main_sm.add_child(idle_state);main_sm.add_child(fall_state)
	main_sm.add_child(walk_state);main_sm.add_child(phase_state)
	
	main_sm.initial_state = idle_state
	
	main_sm.add_transition(idle_state,walk_state,&"to_walk");main_sm.add_transition(main_sm.ANYSTATE,idle_state,&"finish_state")
	main_sm.initialize(self);main_sm.set_active(true)

#region idle state
func idle_start() -> void:
	$AnimatedSprite2D.play("idle");$collider.disabled = false
	gravity =0
func idle_update(delta:float) -> void:
	if velocity.x != 0: main_sm.dispatch("to_walk")
	if not is_on_floor(): main_sm.dispatch("to_fall")
#endregion
#region walk state
func walk_start() -> void:
	$AnimatedSprite2D.play("run")
func walk_update(delta:float) -> void:
	if not is_on_floor(): main_sm.dispatch("to_fall")
	elif velocity.x == 0: main_sm.dispatch("finish_state")
#endregion

func phase_start():
	$CollisionShape2D.disabled = true
#region fall state
func fall_start() -> void:
	$AnimatedSprite2D.play("fall")
func fall_update(delta:float) ->void:
	gravity = move_toward(gravity,GRAVITY_LIMIT,250*delta)
	if is_on_floor():
		main_sm.dispatch("finish_state")

#endregion
#endregion
