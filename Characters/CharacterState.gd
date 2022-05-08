extends Node

class_name CharacterState

const _CHARGE_STATE : String = "CHARGE"
const _RANGE_STATE : String = "RANGE"
const _BASIC_STATE : String = "BASIC"

var possible_states : Array = []
var _current_state : String


func _ready():
	possible_states.append(_BASIC_STATE)
	possible_states.append(_RANGE_STATE)
	possible_states.append(_CHARGE_STATE)

func can_set_state():
	return _current_state == ""

func set_state(state : String):
	var result = can_set_state()
	if !result:
		return result
	state = state.to_upper()
	if state == _BASIC_STATE:
		_current_state = _BASIC_STATE
	elif state == _RANGE_STATE:
		_current_state = _RANGE_STATE
	elif state == _CHARGE_STATE:
		_current_state = _CHARGE_STATE

	return result

func clear_state(state : String):
	if state.to_upper() != _current_state:
		print(state, " Does not match current state: ", _current_state)
		return
	_current_state = ""
