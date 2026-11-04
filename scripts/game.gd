extends Control
## 游戏内容页：玩法逻辑的落脚点


func _ready() -> void:
	$Center/VBox/BackButton.pressed.connect(_on_back_pressed)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")
