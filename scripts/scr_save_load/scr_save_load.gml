/// @description Save and load functions for world generation

function save_world(filename) {
    var save_data = {
        // Map dimensions
        wrld_width: global.wrld_width,
        wrld_height: global.wrld_height,
        wrld_tile_size: global.wrld_tile_size,
        
        // Generation modifiers
        wrld_lake_modifier: global.wrld_lake_modifier,
        wrld_elevation_modifier: global.wrld_elevation_modifier,
        wrld_radius_falloff: global.wrld_radius_falloff,
        
        // Geography settings
        wrld_geography_base_scale: global.wrld_geography_base_scale,
        wrld_geography_octaves: global.wrld_geography_octaves,
        wrld_geography_persistence: global.wrld_geography_persistence,
        wrld_geography_deep_water: global.wrld_geography_deep_water,
        wrld_geography_shallow_water: global.wrld_geography_shallow_water,
        wrld_geography_beach: global.wrld_geography_beach,
        wrld_geography_plains: global.wrld_geography_plains,
        wrld_geography_hills: global.wrld_geography_hills,
        
        // Biome settings
        wrld_biome_base_scale: global.wrld_biome_base_scale,
        wrld_biome_octaves: global.wrld_biome_octaves,
        wrld_biome_persistence: global.wrld_biome_persistence,
        wrld_biome_lake: global.wrld_biome_lake,
        wrld_biome_swamp: global.wrld_biome_swamp,
        wrld_biome_plains: global.wrld_biome_plains,
        wrld_biome_forest: global.wrld_biome_forest,
        
        // Map data
        map_data: []
    };
    
    // Convert grid to array
    if (ds_exists(global.wrld_grid, ds_type_grid)) {
        for (var yy = 0; yy < global.wrld_height; yy++) {
            var row = [];
            for (var xx = 0; xx < global.wrld_width; xx++) {
                array_push(row, global.wrld_grid[# xx, yy]);
            }
            array_push(save_data.map_data, row);
        }
    }
    
    // Convert to string and save to file
    var json_string = json_stringify(save_data);
    var buffer = buffer_create(string_byte_length(json_string) + 1, buffer_fixed, 1);
    buffer_write(buffer, buffer_string, json_string);
    buffer_save(buffer, filename);
    buffer_delete(buffer);
    
    show_debug_message("World saved to: " + filename);
    return true;
}

function load_world(filename) {
    if (!file_exists(filename)) {
        show_debug_message("Save file not found: " + filename);
        return false;
    }
    
    // Read file
    var buffer = buffer_load(filename);
    var json_string = buffer_read(buffer, buffer_string);
    buffer_delete(buffer);
    
    // Parse JSON
    var save_data = json_parse(json_string);
    
    // Load world parameters
    global.wrld_width = save_data.wrld_width;
    global.wrld_height = save_data.wrld_height;
    global.wrld_tile_size = save_data.wrld_tile_size;
    global.wrld_lake_modifier = save_data.wrld_lake_modifier;
    global.wrld_elevation_modifier = save_data.wrld_elevation_modifier;
    global.wrld_radius_falloff = save_data.wrld_radius_falloff;
    
    // Geography settings
    global.wrld_geography_base_scale = save_data.wrld_geography_base_scale;
    global.wrld_geography_octaves = save_data.wrld_geography_octaves;
    global.wrld_geography_persistence = save_data.wrld_geography_persistence;
    global.wrld_geography_deep_water = save_data.wrld_geography_deep_water;
    global.wrld_geography_shallow_water = save_data.wrld_geography_shallow_water;
    global.wrld_geography_beach = save_data.wrld_geography_beach;
    global.wrld_geography_plains = save_data.wrld_geography_plains;
    global.wrld_geography_hills = save_data.wrld_geography_hills;
    
    // Biome settings
    global.wrld_biome_base_scale = save_data.wrld_biome_base_scale;
    global.wrld_biome_octaves = save_data.wrld_biome_octaves;
    global.wrld_biome_persistence = save_data.wrld_biome_persistence;
    global.wrld_biome_lake = save_data.wrld_biome_lake;
    global.wrld_biome_swamp = save_data.wrld_biome_swamp;
    global.wrld_biome_plains = save_data.wrld_biome_plains;
    global.wrld_biome_forest = save_data.wrld_biome_forest;
    
    // Recreate the grid
    if (ds_exists(global.wrld_grid, ds_type_grid)) {
        ds_grid_destroy(global.wrld_grid);
    }
    global.wrld_grid = ds_grid_create(global.wrld_width, global.wrld_height);
    
    // Load map data
    for (var yy = 0; yy < global.wrld_height; yy++) {
        for (var xx = 0; xx < global.wrld_width; xx++) {
            global.wrld_grid[# xx, yy] = save_data.map_data[yy][xx];
        }
    }
    
    show_debug_message("World loaded from: " + filename);
    return true;
}

// Optional: Function to get default save filename
function get_save_filename() {
    return "world_save_" + string(global.wrld_width) + "x" + 
           string(global.wrld_height) + "_" + 
           string_replace_all(string_format(current_time, 0, 0), " ", "") + 
           ".json";
}