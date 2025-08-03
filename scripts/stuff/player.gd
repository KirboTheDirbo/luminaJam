extends CharacterBody2D

@export var spawn_position:Vector2
@export var jump_velocity:int

@export var lines: Array[String] = [
	"i need escape.",
	"theres a way to phase",
	"through the floor",
	"and find freedom.",
	"i need that orb first.",
	"do what comes natural."
]

#region vars & consts
var talking:bool = false
#region collision
var collide:bool = true
var in_thing:bool = false
#endregion
#region gravity
var gravity:float = 0
var up_velocity:float = 0
const speed:int= 190
const GRAVITY_LIMIT:int = 500
const UP_VELOCITY_LIMIT:int = 8000
#endregion
#region accel and friction
const ACCEL: float = 12.5
const FRICTION: float = 16.5
#endregion
var main_sm: LimboHSM
#endregion
#region essential code
func _ready() -> void:
	global_position=spawn_position
	initiate_state_machine()


func _process(delta: float) -> void:
	if is_on_ceiling():
		up_velocity = up_velocity/2
	clamp(up_velocity,0,700)

func _physics_process(delta: float) -> void:
	velocity.y = gravity - up_velocity
	horizontal_movement()

func dialogue_start() -> void:
	main_sm.dispatch("to_talk")
	$AnimationPlayer.play("talk_start")
	talking = true

func dialogue_end() -> void:
	$AnimationPlayer.play("talk_end")
	main_sm.dispatch("finish_state")
	talking = false
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
func player() -> void:
	pass
#endregion

#region state machine stuff
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("phase") and main_sm.get_active_state().name != "talk":
		main_sm.dispatch(&"to_phase")

func initiate_state_machine():
	main_sm = LimboHSM.new();add_child(main_sm)
	
	var idle_state:LimboState = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var walk_state:LimboState = LimboState.new().named("walk").call_on_enter(walk_start).call_on_update(walk_update)
	var fall_state:LimboState = LimboState.new().named("fall").call_on_enter(fall_start).call_on_update(fall_update)

	
	main_sm.add_child(idle_state);main_sm.add_child(fall_state)
	main_sm.add_child(walk_state);
	
	main_sm.initial_state = idle_state
	
	main_sm.add_transition(idle_state,walk_state,&"to_walk");main_sm.add_transition(main_sm.ANYSTATE,idle_state,&"finish_state")
	main_sm.add_transition(main_sm.ANYSTATE,fall_state,&"to_fall")
	main_sm.initialize(self);main_sm.set_active(true)

#region idle state
func idle_start() -> void:
	$AnimatedSprite2D.play("idle");$CollisionShape2D.disabled = false
	gravity =0
func idle_update(delta:float) -> void:
	up_velocity = move_toward(up_velocity,0,300 * delta)
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



#region fall state
func fall_start() -> void:
	$AnimatedSprite2D.play("fall")
func fall_update(delta:float) ->void:
#endregion
	up_velocity = move_toward(up_velocity,0,350 * delta)
	gravity = move_toward(gravity,GRAVITY_LIMIT,250*delta)
	if is_on_floor():
		main_sm.dispatch("finish_state")

#endregion

func run_dialogue():
	DialogueManager.start_Dialogue(global_position,lines)

func _on_area_2d_area_entered(area: Area2D) -> void:
	up_velocity = gravity * 2
	gravity = 0


func _on_level_1_do_dialogue() -> void:
	run_dialogue()


func _on_restart_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		lines = [
			"well i'm stuck.",
			"guess i'll press,",
			"r to RESTART."
		]
		run_dialogue()


func _on_level_2_do_dialogue(line: Array[String]) -> void:
	DialogueManager.start_Dialogue(global_position,line)
