@tool
extends TileMap

const NEIGHBOURS = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]

enum TileType { None, Grass, Dirt, Water, Sand }

@export var offset_tilemap: TileMap
@export var atlas_source_id: int = 0
@export var terrain_atlas_coords: Dictionary = {
	TileType.Grass: [Vector2i(2, 1), Vector2i(0, 7), Vector2i(6, 5)],
	TileType.Dirt: [Vector2i(0, 3), Vector2i(4, 3)],
	TileType.Water: [Vector2i(6, 1), Vector2i(2, 5), Vector2i(2, 9)],
	TileType.Sand: [Vector2i(4, 7), Vector2i(0, 11)]
}

var neighbours_to_atlas_coord := {
	# First terrain combination: grass and dirt
	[TileType.Dirt, TileType.Dirt, TileType.Grass, TileType.Dirt]: Vector2i(0, 0),
	[TileType.Dirt, TileType.Grass, TileType.Dirt, TileType.Grass]: Vector2i(1, 0),
	[TileType.Grass, TileType.Dirt, TileType.Grass, TileType.Grass]: Vector2i(2, 0),
	[TileType.Dirt, TileType.Dirt, TileType.Grass, TileType.Grass]: Vector2i(3, 0),
	[TileType.Grass, TileType.Dirt, TileType.Dirt, TileType.Grass]: Vector2i(0, 1),
	[TileType.Dirt, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(1, 1),
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(2, 1),
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Dirt]: Vector2i(3, 1),
	[TileType.Dirt, TileType.Grass, TileType.Dirt, TileType.Dirt]: Vector2i(0, 2),
	[TileType.Grass, TileType.Grass, TileType.Dirt, TileType.Dirt]: Vector2i(1, 2),
	[TileType.Grass, TileType.Grass, TileType.Dirt, TileType.Grass]: Vector2i(2, 2),
	[TileType.Grass, TileType.Dirt, TileType.Grass, TileType.Dirt]: Vector2i(3, 2),
	[TileType.Dirt, TileType.Dirt, TileType.Dirt, TileType.Dirt]: Vector2i(0, 3),
	[TileType.Dirt, TileType.Dirt, TileType.Dirt, TileType.Grass]: Vector2i(1, 3),
	[TileType.Dirt, TileType.Grass, TileType.Grass, TileType.Dirt]: Vector2i(2, 3),
	[TileType.Grass, TileType.Dirt, TileType.Dirt, TileType.Dirt]: Vector2i(3, 3),
	
	# Second terrain combination: water and dirt
	[TileType.Dirt, TileType.Dirt, TileType.Water, TileType.Dirt]: Vector2i(4, 0),
	[TileType.Dirt, TileType.Water, TileType.Dirt, TileType.Water]: Vector2i(5, 0),
	[TileType.Water, TileType.Dirt, TileType.Water, TileType.Water]: Vector2i(6, 0),
	[TileType.Dirt, TileType.Dirt, TileType.Water, TileType.Water]: Vector2i(7, 0),
	[TileType.Water, TileType.Dirt, TileType.Dirt, TileType.Water]: Vector2i(4, 1),
	[TileType.Dirt, TileType.Water, TileType.Water, TileType.Water]: Vector2i(5, 1),
	[TileType.Water, TileType.Water, TileType.Water, TileType.Water]: Vector2i(6, 1),
	[TileType.Water, TileType.Water, TileType.Water, TileType.Dirt]: Vector2i(7, 1),
	[TileType.Dirt, TileType.Water, TileType.Dirt, TileType.Dirt]: Vector2i(4, 2),
	[TileType.Water, TileType.Water, TileType.Dirt, TileType.Dirt]: Vector2i(5, 2),
	[TileType.Water, TileType.Water, TileType.Dirt, TileType.Water]: Vector2i(6, 2),
	[TileType.Water, TileType.Dirt, TileType.Water, TileType.Dirt]: Vector2i(7, 2),
	[TileType.Dirt, TileType.Dirt, TileType.Dirt, TileType.Dirt]: Vector2i(4, 3),
	[TileType.Dirt, TileType.Dirt, TileType.Dirt, TileType.Water]: Vector2i(5, 3),
	[TileType.Dirt, TileType.Water, TileType.Water, TileType.Dirt]: Vector2i(6, 3),
	[TileType.Water, TileType.Dirt, TileType.Dirt, TileType.Dirt]: Vector2i(7, 3),
	
	# Third terrain combination: water and grass
	[TileType.Grass, TileType.Grass, TileType.Water, TileType.Grass]: Vector2i(0, 4),
	[TileType.Grass, TileType.Water, TileType.Grass, TileType.Water]: Vector2i(1, 4),
	[TileType.Water, TileType.Grass, TileType.Water, TileType.Water]: Vector2i(2, 4),
	[TileType.Grass, TileType.Grass, TileType.Water, TileType.Water]: Vector2i(3, 4),
	[TileType.Water, TileType.Grass, TileType.Grass, TileType.Water]: Vector2i(0, 5),
	[TileType.Grass, TileType.Water, TileType.Water, TileType.Water]: Vector2i(1, 5),
	[TileType.Water, TileType.Water, TileType.Water, TileType.Water]: Vector2i(2, 5),
	[TileType.Water, TileType.Water, TileType.Water, TileType.Grass]: Vector2i(3, 5),
	[TileType.Grass, TileType.Water, TileType.Grass, TileType.Grass]: Vector2i(0, 6),
	[TileType.Water, TileType.Water, TileType.Grass, TileType.Grass]: Vector2i(1, 6),
	[TileType.Water, TileType.Water, TileType.Grass, TileType.Water]: Vector2i(2, 6),
	[TileType.Water, TileType.Grass, TileType.Water, TileType.Grass]: Vector2i(3, 6),
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(0, 7),
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Water]: Vector2i(1, 7),
	[TileType.Grass, TileType.Water, TileType.Water, TileType.Grass]: Vector2i(2, 7),
	[TileType.Water, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(3, 7),
	
	# Fourth terrain combination: grass and sand
	[TileType.Sand, TileType.Sand, TileType.Grass, TileType.Sand]: Vector2i(4, 4),
	[TileType.Sand, TileType.Grass, TileType.Sand, TileType.Grass]: Vector2i(5, 4),
	[TileType.Grass, TileType.Sand, TileType.Grass, TileType.Grass]: Vector2i(6, 4),
	[TileType.Sand, TileType.Sand, TileType.Grass, TileType.Grass]: Vector2i(7, 4),
	[TileType.Grass, TileType.Sand, TileType.Sand, TileType.Grass]: Vector2i(4, 5),
	[TileType.Sand, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(5, 5),
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(6, 5),
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Sand]: Vector2i(7, 5),
	[TileType.Sand, TileType.Grass, TileType.Sand, TileType.Sand]: Vector2i(4, 6),
	[TileType.Grass, TileType.Grass, TileType.Sand, TileType.Sand]: Vector2i(5, 6),
	[TileType.Grass, TileType.Grass, TileType.Sand, TileType.Grass]: Vector2i(6, 6),
	[TileType.Grass, TileType.Sand, TileType.Grass, TileType.Sand]: Vector2i(7, 6),
	[TileType.Sand, TileType.Sand, TileType.Sand, TileType.Sand]: Vector2i(4, 7),
	[TileType.Sand, TileType.Sand, TileType.Sand, TileType.Grass]: Vector2i(5, 7),
	[TileType.Sand, TileType.Grass, TileType.Grass, TileType.Sand]: Vector2i(6, 7),
	[TileType.Grass, TileType.Sand, TileType.Sand, TileType.Sand]: Vector2i(7, 7),
	
	# Fifth terrain combination: water and sand
	[TileType.Sand, TileType.Sand, TileType.Water, TileType.Sand]: Vector2i(0, 8),
	[TileType.Sand, TileType.Water, TileType.Sand, TileType.Water]: Vector2i(1, 8),
	[TileType.Water, TileType.Sand, TileType.Water, TileType.Water]: Vector2i(2, 8),
	[TileType.Sand, TileType.Sand, TileType.Water, TileType.Water]: Vector2i(3, 8),
	[TileType.Water, TileType.Sand, TileType.Sand, TileType.Water]: Vector2i(0, 9),
	[TileType.Sand, TileType.Water, TileType.Water, TileType.Water]: Vector2i(1, 9),
	[TileType.Water, TileType.Water, TileType.Water, TileType.Water]: Vector2i(2, 9),
	[TileType.Water, TileType.Water, TileType.Water, TileType.Sand]: Vector2i(3, 9),
	[TileType.Sand, TileType.Water, TileType.Sand, TileType.Sand]: Vector2i(0, 10),
	[TileType.Water, TileType.Water, TileType.Sand, TileType.Sand]: Vector2i(1, 10),
	[TileType.Water, TileType.Water, TileType.Sand, TileType.Water]: Vector2i(2, 10),
	[TileType.Water, TileType.Sand, TileType.Water, TileType.Sand]: Vector2i(3, 10),
	[TileType.Sand, TileType.Sand, TileType.Sand, TileType.Sand]: Vector2i(0, 11),
	[TileType.Sand, TileType.Sand, TileType.Sand, TileType.Water]: Vector2i(1, 11),
	[TileType.Sand, TileType.Water, TileType.Water, TileType.Sand]: Vector2i(2, 11),
	[TileType.Water, TileType.Sand, TileType.Sand, TileType.Sand]: Vector2i(3, 11)
}


func _ready() -> void:
	#print("Dictionary keys:")
	for key in neighbours_to_atlas_coord.keys():
		#print(key)
		pass
	for coord in get_used_cells(0):
		#print("Initial tile at ", coord)
		set_display_tile(Vector2i(coord))


func _process(_delta):
	# Only update in editor mode
	if Engine.is_editor_hint():
		update_all_tiles()


func update_all_tiles() -> void:
	# Go through all the used cells and set their display tiles
	for coord in get_used_cells(0):
		set_display_tile(Vector2i(coord))


func set_tile(coords: Vector2i, atlas_coords: Vector2i) -> void:
	set_cell(0, coords, atlas_source_id, atlas_coords)
	set_display_tile(coords) # Update the OffsetTileMap immediately


func set_display_tile(pos: Vector2i) -> void:
	for i in range(NEIGHBOURS.size()):
		var new_pos = pos + NEIGHBOURS[i]
		offset_tilemap.set_cell(0, new_pos, atlas_source_id, calculate_display_tile(new_pos))


func calculate_display_tile(coords: Vector2i) -> Vector2i:
	var bottom_right = get_world_tile(coords - NEIGHBOURS[0])
	var bottom_left = get_world_tile(coords - NEIGHBOURS[1])
	var top_right = get_world_tile(coords - NEIGHBOURS[2])
	var top_left = get_world_tile(coords - NEIGHBOURS[3])

	var tile_key = [top_left, top_right, bottom_left, bottom_right]
	#print("Generated tile key for ", coords, ": ", tile_key)
	
	# Track number of terrain types
	var terrain_tiles = {}
	for tile in tile_key:
		if tile != TileType.None:
			terrain_tiles[tile] = true  # Use a dictionary to track unique types

	# If there are more than 2 unique terrains, return a special value (e.g., -1)
	if terrain_tiles.size() > 2:
		return Vector2i(-1, -1)  # Special value to indicate skipping tile placement

	# Existing behavior if 2 or fewer terrains are detected
	if tile_key in neighbours_to_atlas_coord:
		return neighbours_to_atlas_coord[tile_key]
	
	if bottom_right != TileType.None or bottom_left != TileType.None or top_right != TileType.None or top_left != TileType.None:
		
		if bottom_right == TileType.Grass or bottom_left == TileType.Grass or top_right == TileType.Grass or top_left == TileType.Grass:
			#print("Grass border found at ", coords)
			return terrain_atlas_coords[TileType.Grass][0]  # Return the first coordinate for grass
		elif bottom_right == TileType.Dirt or bottom_left == TileType.Dirt or top_right == TileType.Dirt or top_left == TileType.Dirt:
			#print("Dirt border found at ", coords)
			return terrain_atlas_coords[TileType.Dirt][0]  # Return the first coordinate for dirt
		elif bottom_right == TileType.Water or bottom_left == TileType.Water or top_right == TileType.Water or top_left == TileType.Water:
			#print("Water border found at ", coords)
			return terrain_atlas_coords[TileType.Water][0]  # Return the first coordinate for water
		elif bottom_right == TileType.Sand or bottom_left == TileType.Sand or top_right == TileType.Sand or top_left == TileType.Sand:
			#print("Sand border found at ", coords)
			return terrain_atlas_coords[TileType.Sand][0]  # Return the first coordinate for sand
	
	# If no valid neighbours, return a default tile
	#print("Tile key not found in dictionary, defaulting to (0, 0) at ", coords)
	return Vector2i(0, 0)


func get_world_tile(coords: Vector2i) -> TileType:
	var atlas_coord = get_cell_atlas_coords(0, coords)
	
	# Iterate through the dictionary to find which terrain type the atlas_coord belongs to
	for terrain in terrain_atlas_coords.keys():
		if atlas_coord in terrain_atlas_coords[terrain]:
			return terrain  # Return the terrain type if atlas_coord is found in its list
	
	return TileType.None  # Return None if no match is found
