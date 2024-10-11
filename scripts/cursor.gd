extends Node2D

@export var dual_grid_tilemap: TileMap

@onready var cursor = $"."


func _ready():
	cursor.visible = true

func _process(_delta: float) -> void:
	var coords: Vector2i = dual_grid_tilemap.local_to_map(position)

	if Input.is_action_pressed("left_click"):
		dual_grid_tilemap.set_tile(coords, dual_grid_tilemap.dirt_atlas_coord)
	elif Input.is_action_pressed("right_click"):
		dual_grid_tilemap.set_tile(coords, dual_grid_tilemap.grass_atlas_coord)


func _physics_process(_delta: float) -> void:
	var world_pos = get_world_pos_tile(get_global_mouse_position())
	global_position = world_pos + Vector2i(8, 8)


func get_world_pos_tile(world_pos: Vector2) -> Vector2i:
	var x_int: int = int(floor(world_pos.x / 16) * 16)
	var y_int: int = int(floor(world_pos.y / 16) * 16)
	return Vector2i(x_int, y_int)
