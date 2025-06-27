global.service_resolution = {
	base_width: 160,
	base_height: 90,

	apply: function() {
		var cam = view_camera[0];

		// Enable view 0
		view_enabled = true;
		view_visible[0] = true;

		// Set base room size
		room_set_width(room, self.base_width);
		room_set_height(room, self.base_height);

		// Resize camera to base
		camera_set_view_size(cam, self.base_width, self.base_height);
		camera_set_view_pos(cam, 0, 0);

		// Resize port to screen
		var dw = display_get_width();
		var dh = display_get_height();
		view_set_wport(0, dw);
		view_set_hport(0, dh);
		view_set_xport(0, 0);
		view_set_yport(0, 0);
	}
};
