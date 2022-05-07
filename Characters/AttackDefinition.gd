extends Node

class_name AttackDefinition

var _attack_name : String
var _agression_level : float
var _probability : float
var _setup : bool = false

func _ready():
	pass

func get_agression_level():
	return _agression_level

func get_probability():
	return _probability

func setup_basic_attack():
	if _setup:
		print("Attack was already setup.")
		return
	_attack_name = "basic"
	_agression_level = 0.0
	_probability = 1.0
	return self

func setup_ranged_attack():
	if _setup:
		print("Attack was already setup.")
		return
	_attack_name = "range"
	_agression_level = 1.5
	_probability = 0.5
	return self

func setup_charge_attack():
	if _setup:
		print("Attack was already setup.")
		return
	_attack_name = "charge"
	_agression_level = 2.5
	_probability = 0.125
	return self

