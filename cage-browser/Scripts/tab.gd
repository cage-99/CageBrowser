extends Panel

@export var TabName:String

var _otn

func _ready() -> void:
	$Panel/Label.text = TabName

func _process(delta: float) -> void:
	if TabName != _otn:
		$Panel/Label.text = TabName
		$Panel/Label.tooltip_text = TabName
		_otn = TabName
