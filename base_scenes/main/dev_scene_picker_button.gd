extends Button


# Should point to the main node.
@export var main_scene_path: NodePath = "/root/Main"
@export var dev_scene_resource_path: String = ""
@export var picker_path: NodePath = ".."

@onready var main_scene: Node3D = get_node(main_scene_path)
@onready var picker: Control = get_node(picker_path)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	var dev_scene_resource: Resource = load(dev_scene_resource_path)
	var dev_scene: Node3D = dev_scene_resource.instantiate()
	if picker.current_dev_scene:
		main_scene.remove_child(picker.current_dev_scene)
	main_scene.add_child(dev_scene)
	picker.current_dev_scene = dev_scene
