if is_overlay
{
	draw_text(8,0,"Arrow keys to move map. Middle Mouse to zoom in and out. Press 'R' to create a new random map.");
	draw_text(8,16, "F1 to toggle generation parameter overlay. Mouse over parameter and + - to change gen values. CTRL +/- for large change.")
	draw_text(8,32, "PRT SCN to copy all values to clipboard. ESC to reset all values to defaults.")
	draw_text(8,48, "Press H to toggle in-depth help screen.")
	
}
// In Draw GUI event
if (obj_help.is_help) {
    // Draw dark overlay
    draw_set_alpha(0.9);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    
    // Reset alpha and set text color
    draw_set_alpha(1);
    draw_set_color(c_white);
    
    // Draw the help text with some padding
    var _padding = 20;
    draw_text_ext(
        _padding,
        _padding + obj_help.yoffset,
        obj_help.help_text,
        20,  // Line separation
        display_get_gui_width() - (_padding * 2)  // Max width
    );
}