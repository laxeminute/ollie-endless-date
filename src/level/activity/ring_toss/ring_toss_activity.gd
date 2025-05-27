extends Node2D

signal completed

const NUM_NUMBERS = 9

var ring_numbers: Array[RingNumber]


func _ready() -> void:
	for rn: RingNumber in $Numbers.get_children():
		ring_numbers.append(rn)
	assert(ring_numbers.size() == NUM_NUMBERS)
	_reset()


func _reset() -> void:
	var randoms: Array = range(NUM_NUMBERS)
	randoms.shuffle()
	for i in randoms.size():
		## number is 1-indexed
		ring_numbers[i].number = randoms[i] + 1
