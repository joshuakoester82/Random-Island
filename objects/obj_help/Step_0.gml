if keyboard_check_pressed(ord("H"))
{
	is_help = !is_help;
}

if (is_help) {
    // Calculate the total height of the text
    var _padding = 20;
    var _sep = 20;  // Line separation
    var _width = display_get_gui_width() - (_padding * 2);
    var _text_height = string_height_ext(help_text, _sep, _width);
    var _view_height = display_get_gui_height();
    
    // Calculate maximum scroll (negative number)
    offsetmax = min(0, -(_text_height - _view_height + _padding * 2));
    offsetmin = 0;
    
    // Handle scroll input
    if (mouse_wheel_down()) {
        yoffset = clamp(yoffset - offset_speed, offsetmax, offsetmin);
    }
    if (mouse_wheel_up()) {
        yoffset = clamp(yoffset + offset_speed, offsetmax, offsetmin);
    }
}

