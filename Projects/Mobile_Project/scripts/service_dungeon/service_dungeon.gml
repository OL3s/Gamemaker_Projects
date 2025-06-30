global.service_dungeon = {
	cam_x: 100,
	cam_y: 100,
	init_camera: function() {
		var cam_width = 320;
		var cam_height = cam_width * 9 / 16;
	
		var cam = camera_create_view(0, 0, cam_width, cam_height);
		view_enabled = true;
		view_visible[0] = true;
		view_camera[0] = cam;
	
		global._camera_id = cam;
	},
	set_camera: function(object, zoom) {
		var cam = view_camera[0];
		var w = 320 / zoom;
		var h = w * 9 / 16;

		var target_x = object.x - w / 2
		var target_y = object.y - h / 2

		var smooth = 0.1;
		self.cam_x = lerp(self.cam_x, target_x, smooth);
		self.cam_y = lerp(self.cam_y, target_y, smooth);

		camera_set_view_size(cam, w, h);
		camera_set_view_pos(cam, self.cam_x, self.cam_y);
	},
	init_room_size: function(dungeon_array) {
		var h = array_length(dungeon_array);
		var w = array_length(dungeon_array[0]);

		var tile_size = 16;
		room_width = w * tile_size;
		room_height = h * tile_size;
	}
}