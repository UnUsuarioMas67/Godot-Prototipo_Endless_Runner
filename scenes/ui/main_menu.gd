extends Node


func _ready():
	set_buttons_disabled(true)
	%OptionsContainer.modulate = Color.TRANSPARENT
	
	%PlayButton.pressed.connect(on_play_button_pressed)
	%ExitButton.pressed.connect(on_exit_button_pressed)
	
	var tween = create_tween()
	tween.tween_property(%OptionsContainer, "modulate", Color.WHITE, 0.4)
	tween.tween_callback(set_buttons_disabled.bind(false))


func set_buttons_disabled(disabled: bool):
	%PlayButton.disabled = disabled
	%ExitButton.disabled = disabled


func on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_exit_button_pressed():
	get_tree().quit()
