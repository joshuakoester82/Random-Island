function restart()
{
	if keyboard_check_pressed(ord("R"))
	{
		with(obj_tile)
		{
			instance_destroy();	
		}
		wrld_cleanup();
		randomize();
		wrld_reset_noise();
		wrld_generate();
		create_tile_grid();
		set_tiles_from_map();
	}
}
function wrld_draw_map() {
    if(!ds_exists(global.wrld_grid, ds_type_grid)) exit;
    
    for(var xx = 0; xx < global.wrld_width; xx++) {
        for(var yy = 0; yy < global.wrld_height; yy++) {
            var terrain = global.wrld_grid[# xx, yy];
            var color;
            
            switch(terrain) {
                case WRLD_TERRAIN.DEEP_WATER:
                    color = make_color_rgb(0, 0, 128);  // Dark blue
                    break;
                case WRLD_TERRAIN.SHALLOW_WATER:
                    color = make_color_rgb(0, 0, 255);  // Blue
                    break;
                case WRLD_TERRAIN.BEACH:
                    color = make_color_rgb(255, 223, 128);  // Sand color
                    break;
                case WRLD_TERRAIN.PLAINS:
                    color = make_color_rgb(34, 139, 34);  // Forest green
                    break;
                case WRLD_TERRAIN.FOREST:
                    color = make_color_rgb(0, 100, 0);   // Dark green
                    break;
                case WRLD_TERRAIN.SWAMP:
                    color = make_color_rgb(70, 90, 70);   // Murky green
                    break;
                case WRLD_TERRAIN.LAKE:
                    color = make_color_rgb(65, 105, 225);  // Royal blue
                    break;
                case WRLD_TERRAIN.MOUNTAINS:
                    color = make_color_rgb(128, 128, 128);  // Gray
                    break;
            }
            
            draw_rectangle_color(
                xx * global.wrld_tile_size, 
                yy * global.wrld_tile_size, 
                (xx * global.wrld_tile_size) + global.wrld_tile_size - 1, 
                (yy * global.wrld_tile_size) + global.wrld_tile_size - 1, 
                color, color, color, color, 
                false
            );
        }
    }
}
function create_tile_grid() {
    if(!ds_exists(global.wrld_grid, ds_type_grid)) exit;
    
    for(var _i = 0; _i < global.wrld_height; _i++) {
        for(var _j = 0; _j < global.wrld_width; _j++) {
            var _y = _i * global.wrld_tile_size;
            var _x = _j * global.wrld_tile_size;
            var _depth = 0;
            var _obj = obj_tile;
            
            // Use ds_grid_get instead of array access
            var _terrain_type = ds_grid_get(global.wrld_grid, _j, _i);
            instance_create_depth(_x, _y, _depth, _obj);
        }
    }
}

function set_tiles_from_map() {
    if(!ds_exists(global.wrld_grid, ds_type_grid)) exit;
    
    with(obj_tile) {
        var _grid_x = x div global.wrld_tile_size;
        var _grid_y = y div global.wrld_tile_size;
        // Use ds_grid_get instead of array access
        var _terrain_type = ds_grid_get(global.wrld_grid, _grid_x, _grid_y);
        
        switch(_terrain_type) {
            case WRLD_TERRAIN.DEEP_WATER:
                tile_type = WRLD_TERRAIN.DEEP_WATER;
                image_index = 0;
                break;
            
            case WRLD_TERRAIN.SHALLOW_WATER:
                tile_type = WRLD_TERRAIN.SHALLOW_WATER;
                image_index = 1;
                break;
            
            case WRLD_TERRAIN.BEACH:
                tile_type = WRLD_TERRAIN.BEACH;
                image_index = 2;
                break;
            
            case WRLD_TERRAIN.PLAINS:
                tile_type = WRLD_TERRAIN.PLAINS;
                image_index = 3;
                break;
            
            case WRLD_TERRAIN.FOREST:
                tile_type = WRLD_TERRAIN.FOREST;
                image_index = 4;
                break;
            
            case WRLD_TERRAIN.SWAMP:
                tile_type = WRLD_TERRAIN.SWAMP;
                image_index = 5;
                break;
            
            case WRLD_TERRAIN.LAKE:
                tile_type = WRLD_TERRAIN.LAKE;
                image_index = 1;
                break;
            
            case WRLD_TERRAIN.HILLS:
                tile_type = WRLD_TERRAIN.HILLS;
                image_index = 6;
                break;
            
            case WRLD_TERRAIN.MOUNTAINS:
                tile_type = WRLD_TERRAIN.MOUNTAINS;
                image_index = 7;
                break;
            
            default:
                tile_type = -1;
                image_index = 0;
        }
    }
}

// Create Event for obj_world_generation_controller
randomize();
wrld_reset_noise();
wrld_generate();
create_tile_grid();
set_tiles_from_map();