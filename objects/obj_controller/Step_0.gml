// Step Event
var old_zoom = zoom;

// Handle zoom input
if (mouse_wheel_up()) {
    zoom = min(zoom + zoom_speed, zoom_max);
}
if (mouse_wheel_down()) {
    zoom = max(zoom - zoom_speed, zoom_min);
}

// Calculate new view size
var new_width = base_width / zoom;
var new_height = base_height / zoom;

// If zoom changed, adjust position to center on mouse
if (old_zoom != zoom) {
    var mouse_view_x = mouse_x - screen_x;
    var mouse_view_y = mouse_y - screen_y;
    
    // Calculate the position change needed to keep the mouse point stationary
    var zoom_diff = (zoom - old_zoom) / old_zoom;
    screen_x += mouse_view_x * zoom_diff;
    screen_y += mouse_view_y * zoom_diff;
}

// Handle movement input
screen_x += (keyboard_check(vk_right) - keyboard_check(vk_left)) * move_spd;
screen_y += (keyboard_check(vk_down) - keyboard_check(vk_up)) * move_spd;

// Clamp position to room bounds
var max_x = room_width - new_width;
var max_y = room_height - new_height;
screen_x = clamp(screen_x, 0, max_x);
screen_y = clamp(screen_y, 0, max_y);

// Update camera
camera_set_view_size(camera, new_width, new_height);
camera_set_view_pos(camera, screen_x, screen_y);

// toggle overlay
if keyboard_check_pressed(vk_f1)
{
	is_overlay = !is_overlay;	
}

if keyboard_check_pressed(vk_printscreen)
{
	copy_global_values_to_clipboard();	
}

if keyboard_check_pressed(vk_escape)
{
	reset_global_values();	
}

