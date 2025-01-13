depth = -100;
gui_x = x;
gui_y = y;
base_width = camera_get_view_width(view_camera[0]);
base_height = camera_get_view_height(view_camera[0]);

// Variables that child objects will set
parameter_name = "";      // Display name
parameter_variable = "";  // The name of the global variable to modify
change_amount = 0.01;     // How much to change by
min_value = 0;            // Minimum allowed value
max_value = 1;            // Maximum allowed value
is_dragging = false;      // Track if currently dragging
is_clickable = false;     // Is this a clickable object type?
click_value = -1          // default click_value



function adjust_modifier() {
    var _calculated_change_amount = keyboard_check(vk_control) ? change_amount * 10 : change_amount;
    
    if (obj_controller.is_overlay && !is_clickable) {
        if (check_mouse_over()) {
            // Handle key press adjustments
            var change = (keyboard_check_pressed(ord("=")) || keyboard_check_pressed(vk_add)) - 
                        (keyboard_check_pressed(ord("-")) || keyboard_check_pressed(vk_subtract));
            
            if (change != 0) {
                var current_value = variable_global_get(parameter_variable);
                var new_value = clamp(current_value + (change * _calculated_change_amount), min_value, max_value);
                variable_global_set(parameter_variable, new_value);
            }
            
            // Handle click and drag
            if (mouse_check_button_pressed(mb_left)) {
                is_dragging = true;
            }
        }
        
        if (is_dragging) {
            if (mouse_check_button(mb_left)) {
                // Calculate value based on mouse x position relative to object
                var relative_x = (mouse_x - bbox_left) / (bbox_right - bbox_left);
                relative_x = clamp(relative_x, 0, 1);
                var new_value = lerp(min_value, max_value, relative_x);
                variable_global_set(parameter_variable, new_value);
            } else {
                is_dragging = false;
            }
        }
    }
}

function follow_screen() {
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var view_width = camera_get_view_width(cam);
    var view_height = camera_get_view_height(cam);
    
    var width_ratio = view_width / base_width;
    var height_ratio = view_height / base_height;
    
    x = cam_x + (gui_x * width_ratio);
    y = cam_y + (gui_y * height_ratio);
    
    image_xscale = 6 / (room_width / view_width);
    image_yscale = image_xscale;
}

function check_mouse_over() {
    return position_meeting(mouse_x, mouse_y, id);
}

function draw_info() {
    if (obj_controller.is_overlay) {
        image_index = (check_mouse_over() || is_dragging || (is_clickable && click_value == global.wrld_width)) ? 1 : 0;
        
        var current_value = variable_global_get(parameter_variable);
        var _string = $"{parameter_name}: {current_value}";
        var _sep = 10;
        var _width = 256;
        var _xscale = image_xscale;
        var _yscale = image_yscale;
        var _angle = 0;
        var _padding = 4 * (6 / (room_width / camera_get_view_width(view_camera[0])));
        
        draw_self();
        draw_text_ext_transformed(bbox_left + _padding, bbox_top + _padding, _string, _sep, _width, _xscale, _yscale, _angle);
        
		if !is_clickable
		{
	        // Draw value indicator line
	        var progress = (current_value - min_value) / (max_value - min_value);
	        var indicator_x = lerp(bbox_left, bbox_right, progress);
	        draw_line_width_color(
	            indicator_x, bbox_top, 
	            indicator_x, bbox_bottom, 
	            2 * _xscale, 
	            c_yellow, c_yellow
	        );
		}
    }
}
	
function click()
{
	if check_mouse_over() && is_clickable
	{
		if mouse_check_button_pressed(mb_left)
		{
			global.wrld_width = click_value;
			global.wrld_height = click_value;
		}
	}
}