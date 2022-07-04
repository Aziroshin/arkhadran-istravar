extends Button


# Should point to the main node.
@export var main_scene_path: NodePath = "/root/Main"
# Resource path to the .tscn file for the dev scene.
@export var dev_scene_resource_path: String = ""
# Node path to the dev scene picker node.
@export var picker_path: NodePath = ".."

@onready var picker: Control = get_node(picker_path)


func _on_button_down() -> void:
	picker.load_scene(dev_scene_resource_path)
	picker.save_dev_scene_pick_config(dev_scene_resource_path)
