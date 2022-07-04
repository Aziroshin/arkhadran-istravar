extends GridContainer

# Should point to the main node.
@export var main_scene_path: NodePath = "/root/Main"
@export var config_file_path := ""
@export var config_section := ""
#@export var enable_integration_warnings := true
@export var show_integration_errors := true

@onready var main_scene: Node3D = get_node(main_scene_path)
@onready var current_dev_scene: Node3D

const CONFIG_VALUE_NAME_DEV_SCENE_RESOURCE_PATH := "dev_scene_resource_path"


###########################################################################
# Config
###########################################################################
# Checks whether we have everything to access the config.
func check_config_access() -> bool:
	if config_file_path == "" or config_section == "":
		if show_integration_errors:
			push_error("No config file path and/or section configured for %s" % name)
		return false
	return true
	
	
# Saves config value and returns true or fails and returns false.
func save_config_value(section: String, key: String, value) -> bool:
	if check_config_access():
		var config := ConfigFile.new()
		config.load(config_file_path)
		config.set_value(section, key, value)
		config.save(config_file_path)
		return true
	return false
	
	
func load_config_value(section: String, key: String) -> Variant:
	var config := ConfigFile.new()
	config.load(config_file_path)
	return config.get_value(config_section, key)


# Supposed to be called from whatever triggers the saving, and has
# access to the scene's resource path, e.g. a button somewhere.
func save_dev_scene_pick_config(scene_resource_path: String) -> bool:
	return save_config_value(\
		config_section,\
		CONFIG_VALUE_NAME_DEV_SCENE_RESOURCE_PATH,\
		scene_resource_path\
	)

func load_scene(resource_path: String):
	var dev_scene_resource: Resource = load(resource_path)
	var dev_scene: Node3D = dev_scene_resource.instantiate()
	if current_dev_scene:
		main_scene.remove_child(current_dev_scene)
	current_dev_scene = dev_scene
	main_scene.call_deferred("add_child", dev_scene)
	
	
func _ready() -> void:
	var saved_dev_scene_resource_path: Variant = load_config_value(
		config_section,
		CONFIG_VALUE_NAME_DEV_SCENE_RESOURCE_PATH
	)
	if saved_dev_scene_resource_path:
		load_scene(saved_dev_scene_resource_path)
