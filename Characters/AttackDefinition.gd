extends Node

class_name AttackDefinition

signal initiate_attack

var _attack_name : String
var _agression_level : float
var _probability : float
var _setup : bool = false

func _ready():
	pass

func send_attack():
	if !_setup:
		print("An attack was sent on a definition that was not setup!í ¾í´®í ¾í´®í ¾í´®í ¾í´®í ¾í´®í ¾")
		return
	emit_signal("initiate_attack")

func get_agression_level():
	return _agression_level

func get_probability():
	return _probability

func setup_basic_attack(parent):
	if _setup:
		print("Attack was already setup.")
		return
	parent.add_child(self)
	connect("initiate_attack", parent, "_initiate_basic_attack")
	_attack_name = "BASIC"
	_agression_level = 0.0
	_probability = 1.0
	_setup = true
	return self

func setup_ranged_attack(parent):
	if _setup:
		print("Attack was already setup.")
		return
	parent.add_child(self)
	connect("initiate_attack", parent, "_initiate_range_attack")
	_attack_name = "RANGE"
	_agression_level = 1.5
	_probability = 0.5
	_setup = true
	return self

func setup_charge_attack(parent):
	if _setup:
		print("Attack was already setup.")
		return
	parent.add_child(self)
	connect("initiate_attack", parent, "_initiate_charge_attack")
	_attack_name = "CHARGE"
	_agression_level = 2.5
	_probability = 0.125
	_setup = true
	return self

