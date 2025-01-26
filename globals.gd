extends Node

var startTimeMs = 0
var endTimeMs = 0
var bubbelsUsed = 0

func gameStarted() -> void:
	startTimeMs = Time.get_ticks_msec()

func gameEnded() -> void:
	endTimeMs = Time.get_ticks_msec()

func getTotalTimeSpentSeconds() -> int:
	return floor((endTimeMs - startTimeMs) / 1000)

func useBubbel() -> void:
	bubbelsUsed += 1
