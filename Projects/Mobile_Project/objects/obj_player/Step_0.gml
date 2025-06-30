if instance_exists(obj_gameplay){
	var _speed = 1;
	x += obj_gameplay.input.left.analog_x * _speed;
	y += obj_gameplay.input.left.analog_y * _speed;
}

global.service_dungeon.set_camera(self, 1)
image_speed = point_distance(x, y, xprevious, yprevious) / 2;
image_xscale = (obj_gameplay.input.left.analog_x < 0) ? -1 : 1