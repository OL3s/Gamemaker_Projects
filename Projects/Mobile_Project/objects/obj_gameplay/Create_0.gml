var gui_w = display_get_gui_width()/2
area_indexLeft = global.service_touch_several.create_area(0, 0, gui_w, gui_w*2, TOUCH.GUI)
area_indexRightUp = global.service_touch_several.create_area(gui_w, 0, gui_w, gui_w, TOUCH.GUI)
area_indexRightDown = global.service_touch_several.create_area(gui_w, gui_w, gui_w, gui_w, TOUCH.GUI)
input = {
	left: undefined,
	rightUp: undefined,
	rightDown: undefined
}
global.service_dungeon.init_camera()