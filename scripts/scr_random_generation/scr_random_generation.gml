/// @description World generation functions

// Constants for map generation
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



// Terrain types
enum WRLD_TERRAIN {
    DEEP_WATER,
    SHALLOW_WATER,
    BEACH,
    PLAINS,
    FOREST,
    SWAMP,
    LAKE,
	HILLS,
    MOUNTAINS
}

function wrld_generate() {
	show_debug_message($"height: {global.wrld_height}, width: {global.wrld_width}")
    global.wrld_grid = ds_grid_create(global.wrld_width, global.wrld_height);
    
    // First pass 
    wrld_reset_noise();
    wrld_generate_geography();
    
    // Second pass
    wrld_reset_noise();
    wrld_generate_biomes();
	
	// Third pass
	// TODO: Add river/bridge generation
	// TODO: Add towns, caves, etc
}

function wrld_get_radius_falloff(xx, yy) {
    // Get distance from center (0-1 range)
    var center_x = global.wrld_width / 2;
    var center_y = global.wrld_height / 2;
    
    var dist_x = (xx - center_x) / center_x;
    var dist_y = (yy - center_y) / center_y;
    var distance = sqrt(dist_x * dist_x + dist_y * dist_y);
    
    // Add some noise to the distance
    var noise_scale = 4;  // Large scale noise
    var noise = wrld_noise(xx / global.wrld_width  * noise_scale, yy / global.wrld_height * noise_scale) * 0.3; // 30% noise influence
    
    // Create falloff (1 at center, 0 at edges)
    var falloff = 1.0 - distance;
    falloff = max(0, falloff + noise);
    
    // Make the falloff much more gentle
    falloff = power(falloff, global.wrld_radius_falloff);  // Less aggressive power
    
    // Keep more of the center area intact
    falloff = lerp(1, falloff, 0.6);  // Only apply 60% of the falloff effect
    
    return falloff;
}

function wrld_generate_geography() {
    var base_scale = global.wrld_geography_base_scale;
    var octaves = global.wrld_geography_octaves;
    var persistence = global.wrld_geography_persistence;
	
	// Get bounded thresholds
    var deep_water_threshold = min(global.wrld_geography_deep_water, global.wrld_geography_shallow_water);
    var shallow_water_threshold = min(global.wrld_geography_shallow_water, global.wrld_geography_beach);
    var beach_threshold = min(global.wrld_geography_beach, global.wrld_geography_plains);
    var plains_threshold = min(global.wrld_geography_plains, global.wrld_geography_hills);
    var hills_threshold = global.wrld_geography_hills; // Mountains are always above this
	
	global.wrld_geography_plains = min(global.wrld_geography_plains, global.wrld_geography_hills);
	global.wrld_geography_beach = min(global.wrld_geography_beach, global.wrld_geography_plains);
	global.wrld_geography_shallow_water = min(global.wrld_geography_shallow_water, global.wrld_geography_beach);
	global.wrld_geography_deep_water = min(global.wrld_geography_deep_water, global.wrld_geography_shallow_water);
    
    for(var xx = 0; xx < global.wrld_width; xx++) {
        for(var yy = 0; yy < global.wrld_height; yy++) {
            var total = 0;
            var frequency = 1;
            var amplitude = 1;
            var max_value = 0;
            
            for(var i = 0; i < octaves; i++) {
                var nx = xx / global.wrld_width * base_scale * frequency;
                var ny = yy / global.wrld_height * base_scale * frequency;
                
                total += wrld_noise(nx, ny) * amplitude;
                max_value += amplitude;
                amplitude *= persistence;
                frequency *= 2;
            }
            
            var elevation = (total / max_value + 1) * global.wrld_elevation_modifier;
            
            // Apply a more gentle falloff
            elevation = lerp(elevation, elevation * wrld_get_radius_falloff(xx, yy), 0.7);
            elevation = power(elevation, 1.3);
            
            // Use bounded thresholds
            if(elevation < deep_water_threshold) {
                global.wrld_grid[# xx, yy] = WRLD_TERRAIN.DEEP_WATER;
            }
            else if(elevation < shallow_water_threshold) {
                global.wrld_grid[# xx, yy] = WRLD_TERRAIN.SHALLOW_WATER;
            }
            else if(elevation < beach_threshold) {
                global.wrld_grid[# xx, yy] = WRLD_TERRAIN.BEACH;
            }
            else if(elevation < plains_threshold) {
                global.wrld_grid[# xx, yy] = WRLD_TERRAIN.PLAINS;
            }
            else if(elevation < hills_threshold) {
                global.wrld_grid[# xx, yy] = WRLD_TERRAIN.HILLS;
            }
            else {
                global.wrld_grid[# xx, yy] = WRLD_TERRAIN.MOUNTAINS;
            }
        }
    }
}

// Second pass: Generate biomes on land
function wrld_generate_biomes() {
    var biome_scale = global.wrld_biome_base_scale;  
    var biome_octaves = global.wrld_biome_octaves;
    var biome_persistence = global.wrld_biome_persistence;
    
    // Get bounded thresholds
    var lake_threshold = min(global.wrld_biome_lake, global.wrld_biome_swamp);
    var swamp_threshold = min(global.wrld_biome_swamp, global.wrld_biome_plains);
    var plains_threshold = min(global.wrld_biome_plains, global.wrld_biome_forest);
    var forest_threshold = global.wrld_biome_forest; 
    
    for(var xx = 0; xx < global.wrld_width; xx++) {
        for(var yy = 0; yy < global.wrld_height; yy++) {
            // Only process land tiles (plains from first pass)
            if(global.wrld_grid[# xx, yy] == WRLD_TERRAIN.PLAINS) {
                var total = 0;
                var frequency = 1;
                var amplitude = 1;
                var max_value = 0;
                
                // Generate biome noise
                for(var i = 0; i < biome_octaves; i++) {
                    var nx = xx / global.wrld_width * biome_scale * frequency;
                    var ny = yy / global.wrld_height * biome_scale * frequency;
                    
                    total += wrld_noise(nx + 1000, ny + 1000) * amplitude;
                    max_value += amplitude;
                    amplitude *= biome_persistence;
                    frequency *= 2;
                }
                
                var biome_value = (total / max_value + 1) * global.wrld_lake_modifier;
                
                // Use bounded thresholds
                if(biome_value < lake_threshold) {
                    global.wrld_grid[# xx, yy] = WRLD_TERRAIN.LAKE;
                }
                else if(biome_value < swamp_threshold) {
                    global.wrld_grid[# xx, yy] = WRLD_TERRAIN.SWAMP;
                }
                else if(biome_value < plains_threshold) {
                    global.wrld_grid[# xx, yy] = WRLD_TERRAIN.PLAINS;
                }
                else if(biome_value < forest_threshold) {
                    global.wrld_grid[# xx, yy] = WRLD_TERRAIN.FOREST;
                }
            }
        }
    }
}

// Clean up function
function wrld_cleanup() {
    if(ds_exists(global.wrld_grid, ds_type_grid)) {
        ds_grid_destroy(global.wrld_grid);
    }
}

function enforce_threshold_relationships() {
    // Geography thresholds - each value must stay between its neighbors
    global.wrld_geography_deep_water = min(max(global.wrld_geography_deep_water, 0), global.wrld_geography_shallow_water);
    global.wrld_geography_shallow_water = min(max(global.wrld_geography_shallow_water, 
        global.wrld_geography_deep_water), 
        global.wrld_geography_beach);
        
    global.wrld_geography_beach = min(max(global.wrld_geography_beach, 
        global.wrld_geography_shallow_water), 
        global.wrld_geography_plains);
        
    global.wrld_geography_plains = min(max(global.wrld_geography_plains, 
        global.wrld_geography_beach), 
        global.wrld_geography_hills);
        
    global.wrld_geography_hills = max(global.wrld_geography_hills, 
        global.wrld_geography_plains);
        
    // Biome thresholds
    global.wrld_biome_lake = min(max(global.wrld_biome_lake, 0), global.wrld_biome_swamp);
    global.wrld_biome_swamp = min(max(global.wrld_biome_swamp,
        global.wrld_biome_lake),
        global.wrld_biome_plains);
        
    global.wrld_biome_plains = min(max(global.wrld_biome_plains,
        global.wrld_biome_swamp),
        global.wrld_biome_forest);
        
    global.wrld_biome_forest = max(global.wrld_biome_forest,
        global.wrld_biome_plains);
}


// Permutation table
global.wrld_perm = array_create(512);
global.wrld_noise_initialized = false;

// Initialize the permutation table with randomization
function wrld_init_noise() {
    if (global.wrld_noise_initialized) return;
    
    // Create base array of 0-255
    var base_perm = array_create(256);
    for(var i = 0; i < 256; i++) {
        base_perm[i] = i;
    }
    
    // Shuffle the array using Fisher-Yates
    for(var i = 255; i > 0; i--) {
        var j = irandom(i);
        var temp = base_perm[i];
        base_perm[i] = base_perm[j];
        base_perm[j] = temp;
    }
    
    // Double the permutation table
    for (var i = 0; i < 256; i++) {
        global.wrld_perm[i] = base_perm[i];
        global.wrld_perm[256 + i] = base_perm[i];
    }
    
    global.wrld_noise_initialized = true;
}

// Fade function
function wrld_fade(t) {
    return t * t * t * (t * (t * 6 - 15) + 10);
}

// Linear interpolation
function wrld_lerp(t, a, b) {
    return a + t * (b - a);
}

// Gradient function
function wrld_grad(hash, x, y) {
    var h = hash & 15;
    var u = h < 8 ? x : y;
    var v = h < 4 ? y : (h == 12 || h == 14 ? x : 0);
    return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
}

// Main Perlin noise function
function wrld_noise(x, y) {
    if (!global.wrld_noise_initialized) wrld_init_noise();
    
    // Floor values
    var X = floor(x) & 255;
    var Y = floor(y) & 255;
    
    // Get relative x and y
    x -= floor(x);
    y -= floor(y);
    
    // Compute fade curves
    var u = wrld_fade(x);
    var v = wrld_fade(y);
    
    // Hash coordinates
    var A = global.wrld_perm[X] + Y;
    var B = global.wrld_perm[X + 1] + Y;
    
    // Add blended results
    return wrld_lerp(v, 
        wrld_lerp(u, 
            wrld_grad(global.wrld_perm[A], x, y),
            wrld_grad(global.wrld_perm[B], x - 1, y)
        ),
        wrld_lerp(u, 
            wrld_grad(global.wrld_perm[A + 1], x, y - 1),
            wrld_grad(global.wrld_perm[B + 1], x - 1, y - 1)
        )
    );
}

function wrld_reset_noise() {
    randomize();          
    global.wrld_noise_initialized = false;
    wrld_init_noise();
}