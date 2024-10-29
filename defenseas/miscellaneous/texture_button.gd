extends TextureButton

func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_hover"))
	connect("mouse_exited", Callable(self, "_on_exit_hover"))
	connect("pressed", Callable(self, "_on_pressed"))
	connect("button_up", Callable(self, "_on_button_up"))

func _on_hover():
	modulate = Color(1, 1, 1, 0.7)  # Plus transparent quand survolé

func _on_exit_hover():
	modulate = Color(1, 1, 1, 1)  # Rétablir l'opacité normale

func _on_pressed():
	modulate = Color(1, 1, 1, 0.4)  # Encore plus foncé quand pressé

func _on_button_up() -> void:
	modulate = Color(1, 1, 1, 0.7)
