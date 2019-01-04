extends Timer

enum ACCELERATION_TYPE {FASTER, SLOWER}

export (float) var INITIAL_DELAY = 1.0
export (float) var GOAL_DELAY = 1.0
export (int) var INITIAL_RATE = 20
export (int) var RATE_INCREASE = 0
export (ACCELERATION_TYPE) var TYPE = ACCELERATION_TYPE.FASTER
export (bool) var AUTOMATIC = false

var _rate
var _RATE_INCREASE

func _ready():
	one_shot = true
	wait_time = INITIAL_DELAY
	_rate = INITIAL_DELAY * 0.01 * INITIAL_RATE
	_RATE_INCREASE = RATE_INCREASE * 0.01 * _rate

func is_faster():
	return TYPE == ACCELERATION_TYPE.FASTER

func is_slower():
	return TYPE == ACCELERATION_TYPE.SLOWER

func accelerate():
	if wait_time == GOAL_DELAY:
		return
	_rate += _RATE_INCREASE
	if is_faster():
		wait_time -= _rate
	else:
		wait_time += _rate
	if is_faster() and wait_time < GOAL_DELAY or is_slower() and wait_time > GOAL_DELAY:
		wait_time = GOAL_DELAY

func _on_Timer_timeout():
	if AUTOMATIC :
		accelerate()
	start()
