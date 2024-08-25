extends TileMap

enum TileType { None, Grass, Dirt }

@export var offset_tilemap: TileMap
@export var grass_placeholder_atlas_coord: Vector2i
@export var dirt_placeholder_atlas_coord: Vector2i

var NEIGHBOURS = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]

var neighbours_to_atlas_coord := {
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(2, 1),
	[TileType.Dirt, TileType.Dirt, TileType.Dirt, TileType.Grass]: Vector2i(1, 3),
	[TileType.Dirt, TileType.Dirt, TileType.Grass, TileType.Dirt]: Vector2i(0, 0),
	[TileType.Dirt, TileType.Grass, TileType.Dirt, TileType.Dirt]: Vector2i(0, 2),
	[TileType.Grass, TileType.Dirt, TileType.Dirt, TileType.Dirt]: Vector2i(3, 3),
	[TileType.Dirt, TileType.Grass, TileType.Dirt, TileType.Grass]: Vector2i(1, 0),
	[TileType.Grass, TileType.Dirt, TileType.Grass, TileType.Dirt]: Vector2i(3, 2),
	[TileType.Dirt, TileType.Dirt, TileType.Grass, TileType.Grass]: Vector2i(3, 0),
	[TileType.Grass, TileType.Grass, TileType.Dirt, TileType.Dirt]: Vector2i(1, 2),
	[TileType.Dirt, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(1, 1),
	[TileType.Grass, TileType.Dirt, TileType.Grass, TileType.Grass]: Vector2i(2, 0),
	[TileType.Grass, TileType.Grass, TileType.Dirt, TileType.Grass]: Vector2i(2, 2),
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Dirt]: Vector2i(3, 1),
	[TileType.Dirt, TileType.Grass, TileType.Grass, TileType.Dirt]: Vector2i(2, 3),
	[TileType.Grass, TileType.Dirt, TileType.Dirt, TileType.Grass]: Vector2i(0, 1),
	[TileType.Dirt, TileType.Dirt, TileType.Dirt, TileType.Dirt]: Vector2i(0, 3)
}


func _ready() -> void:
	#print("Dictionary keys:")
	for key in neighbours_to_atlas_coord.keys():
		#print(key)
		pass
	for coord in get_used_cells(0):
		#print("Initial tile at ", coord)
		set_display_tile(Vector2i(coord))


func set_tile(coords: Vector2i, atlas_coords: Vector2i) -> void:
	set_cell(0, coords, 0, atlas_coords)
	set_display_tile(coords)


func set_display_tile(pos: Vector2i) -> void:
	for i in range(NEIGHBOURS.size()):
		var new_pos = pos + NEIGHBOURS[i]
		offset_tilemap.set_cell(0, new_pos, 0, calculate_display_tile(new_pos))


func calculate_display_tile(coords: Vector2i) -> Vector2i:
	var bottom_right = get_world_tile(coords - NEIGHBOURS[0])
	var bottom_left = get_world_tile(coords - NEIGHBOURS[1])
	var top_right = get_world_tile(coords - NEIGHBOURS[2])
	var top_left = get_world_tile(coords - NEIGHBOURS[3])

	var tile_key = [top_left, top_right, bottom_left, bottom_right]
	#print("Generated tile key for ", coords, ": ", tile_key)

	if tile_key in neighbours_to_atlas_coord:
		return neighbours_to_atlas_coord[tile_key]
	else:
		#print("Tile key not found in dictionary, defaulting to (0, 0)")
		return Vector2i(0, 0)


func get_world_tile(coords: Vector2i) -> TileType:
	var atlas_coord = get_cell_atlas_coords(0, coords)
	#print("Fetching world tile at ", coords, " with atlas coord: ", atlas_coord)
	if atlas_coord == grass_placeholder_atlas_coord:
		return TileType.Grass
	elif atlas_coord == dirt_placeholder_atlas_coord:
		return TileType.Dirt
	else:
		return TileType.None
