extends "res://story/LifepodIsFloating.gd"

func makeAt(pos):
	var i = .makeAt(pos)
	i.disconnect("tree_entered",i,"addProcessedCargo")
	i.connect("ready",i,"addProcessedCargo",[i])
	return i
