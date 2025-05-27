extends Node2D

signal completed

const NUM_NUMBERS = 9

var ring_numbers: Array[RingNumber]
var correct_answer: int

@onready var question_label: Label = $Question


func _ready() -> void:
	for rn: RingNumber in $Numbers.get_children():
		ring_numbers.append(rn)
	assert(ring_numbers.size() == NUM_NUMBERS)
	_reset()


func _reset() -> void:
	# 1-indexed numbers
	var randoms: Array = range(1, NUM_NUMBERS + 1)

	# scramble positions
	randoms.shuffle()
	for i in randoms.size():
		ring_numbers[i].number = randoms[i]

	# generate question
	# "auxillary + difference = correct_answer"
	randoms.shuffle()
	correct_answer = randoms[0]
	var auxillary: int = randoms[1]
	var difference: int = correct_answer - auxillary
	question_label.text = (
		"%s %s %s = ?" % [auxillary, "+" if difference > 0 else "-", abs(difference)]
	)
