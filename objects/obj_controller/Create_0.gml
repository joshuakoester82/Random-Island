// Create Event
screen_x = 0;
screen_y = 0;
base_width = camera_get_view_width(view_camera[0]);
base_height = camera_get_view_height(view_camera[0]);
zoom = 1;
zoom_speed = 0.1;
zoom_min = 0.5;
zoom_max = 2;
move_spd = 10;
camera = view_camera[0];
is_overlay = true;

function copy_global_values_to_clipboard() {
    var output = "";
    
    // Map size parameters
    output += "global.map_size_small = " + string(global.map_size_small) + ";\n";
    output += "global.map_size_medium = " + string(global.map_size_medium) + ";\n";
    output += "global.map_size_large = " + string(global.map_size_large) + ";\n";
    output += "global.map_size_giant = " + string(global.map_size_giant) + ";\n";
    output += "global.wrld_width = " + string(global.wrld_width) + ";\n";
    output += "global.wrld_height = " + string(global.wrld_height) + ";\n";
    output += "global.wrld_tile_size = " + string(global.wrld_tile_size) + ";\n";
    
    // Geography parameters
    output += "global.wrld_lake_modifier = " + string(global.wrld_lake_modifier) + ";\n";
    output += "global.wrld_elevation_modifier = " + string(global.wrld_elevation_modifier) + ";\n";
    output += "global.wrld_radius_falloff = " + string(global.wrld_radius_falloff) + ";\n";
    
    // Base scales and octaves
    output += "global.wrld_geography_base_scale = " + string(global.wrld_geography_base_scale) + ";\n";
    output += "global.wrld_geography_octaves = " + string(global.wrld_geography_octaves) + ";\n";
    output += "global.wrld_geography_persistence = " + string(global.wrld_geography_persistence) + ";\n";
    
    // Biome parameters
    output += "global.wrld_biome_base_scale = " + string(global.wrld_biome_base_scale) + ";\n";
    output += "global.wrld_biome_octaves = " + string(global.wrld_biome_octaves) + ";\n";
    output += "global.wrld_biome_persistence = " + string(global.wrld_biome_persistence) + ";\n";
    
    // Geography thresholds
    output += "global.wrld_geography_deep_water = " + string(global.wrld_geography_deep_water) + ";\n";
    output += "global.wrld_geography_shallow_water = " + string(global.wrld_geography_shallow_water) + ";\n";
    output += "global.wrld_geography_beach = " + string(global.wrld_geography_beach) + ";\n";
    output += "global.wrld_geography_plains = " + string(global.wrld_geography_plains) + ";\n";
    output += "global.wrld_geography_hills = " + string(global.wrld_geography_hills) + ";\n";
    
    // Biome thresholds
    output += "global.wrld_biome_lake = " + string(global.wrld_biome_lake) + ";\n";
    output += "global.wrld_biome_swamp = " + string(global.wrld_biome_swamp) + ";\n";
    output += "global.wrld_biome_plains = " + string(global.wrld_biome_plains) + ";\n";
    output += "global.wrld_biome_forest = " + string(global.wrld_biome_forest) + ";\n";
    
    clipboard_set_text(output);
}
function reset_global_values()
{
	global.map_size_small = 64;
	global.map_size_medium = 128;
	global.map_size_large = 256;
	global.map_size_giant = 512;
	global.wrld_width = 256
	global.wrld_height = 256
	global.wrld_tile_size = 16
	global.wrld_lake_modifier = 0.49;
	global.wrld_elevation_modifier = 0.5;
	global.wrld_radius_falloff = 0.6;
	global.wrld_geography_base_scale = 10;
	global.wrld_geography_octaves = 4;
	global.wrld_geography_persistence = 0.45;
	global.wrld_biome_base_scale = 6;
	global.wrld_biome_octaves = 3;
	global.wrld_biome_persistence = 0.5;
	global.wrld_geography_deep_water = 0.25;
	global.wrld_geography_shallow_water = 0.3;
	global.wrld_geography_beach = 0.32;
	global.wrld_geography_plains = 0.5;
	global.wrld_geography_hills = 0.55;
	global.wrld_biome_lake = 0.35;
	global.wrld_biome_swamp = 0.37;
	global.wrld_biome_plains = 0.5;
	global.wrld_biome_forest = 0.6;
}