/// @enum TOUCH
/// input types
enum TOUCH {
	VIEW,
	GUI,
	FULL,
	COUNT
}

global.service_touch_several = {
	analog_threshold: 32,
	analog_deadzone: .2,
	drag_threshold: 16,
	hold_time_ms: 400,
	areas: [],
	
	/// @desc Adds a new touch area
	/// @param {real} x - Top-left X of the area (ignored for FULL)
	/// @param {real} y - Top-left Y of the area (ignored for FULL)
	/// @param {real} w - Width of the area (ignored for FULL)
	/// @param {real} h - Height of the area (ignored for FULL)
	/// @param {real} touch_type - Type of touch: VIEW, GUI, or FULL
	/// @returns {real} Area index
	create_area: function(x, y, w, h, touch_type) {
	    array_push(self.areas, {
	        x: x,
	        y: y,
	        w: w,
	        h: h,
			type: touch_type,
	        finger_id: -1,
	        _prev_down: false,
	        _prev_x: 0,
	        _prev_y: 0,
	        start_x: 0,
	        start_y: 0,
	        hold_start_time: 0,
	        _has_held: false,
	        _has_dragged: false
	    });
	    return array_length(self.areas) - 1;
	},

	/// @desc Returns interaction state for a given area index
	/// @param {real} index - Index returned by create_area
	/// @returns {struct} Touch state
	get: function(index) {
	    var area = self.areas[index];
	    var active_finger = -1;
	    var _down = false;
	    var _x = 0;
	    var _y = 0;
	    var is_pressed_now = false;

	    var finger_max = 5;
	    for (var i = 0; i < finger_max; i++) {
			var tx = 0, ty = 0;
			if (area.type == TOUCH.GUI) {
			    tx = device_mouse_x_to_gui(i);
			    ty = device_mouse_y_to_gui(i);
			} else {
			    tx = device_mouse_x(i);
			    ty = device_mouse_y(i);
			}
	        var is_down = device_mouse_check_button(i, mb_left);
	        var is_pressed = device_mouse_check_button_pressed(i, mb_left);

			var inside = (area.type == TOUCH.FULL) || 
			             (tx >= area.x && tx < area.x + area.w &&
			              ty >= area.y && ty < area.y + area.h);

	        var is_valid_press = (area.finger_id == i) || (area.finger_id == -1 && is_pressed && inside);

	        if (is_valid_press || (area.finger_id == i && is_down)) {
	            _down = is_down;
	            _x = tx;
	            _y = ty;
	            active_finger = i;
	            is_pressed_now = is_pressed && inside;
	            break;
	        }
	    }

	    if (_down && area.finger_id == -1) {
	        area.finger_id = active_finger;
	    }

	    var _x_gui = _x;
	    var _y_gui = _y;

	    var _is_pressed = is_pressed_now;
	    var _is_released = !(_down) && area._prev_down;

	    if (_is_released && active_finger == area.finger_id) {
	        area.finger_id = -1;
	    }

	    if (_is_pressed) {
	        area.start_x = _x;
	        area.start_y = _y;
	        area.hold_start_time = current_time;
	        area._has_held = false;
	        area._has_dragged = false;
	    }

		var _dx = _is_pressed ? 0 : (_x - area._prev_x);
		var _dy = _is_pressed ? 0 : (_y - area._prev_y);
	    var _dx_total = _x - area.start_x;
	    var _dy_total = _y - area.start_y;

	    if (_down && !area._has_dragged && (
	        abs(_dx_total) >= self.drag_threshold ||
	        abs(_dy_total) >= self.drag_threshold)) {
	        area._has_dragged = true;
	    }

	    if (_down && !area._has_held && !area._has_dragged &&
	        (current_time - area.hold_start_time >= self.hold_time_ms)) {
	        area._has_held = true;
	    }

	    var _is_holding = _down && area._has_held;
	    var _is_dragging = _down && area._has_dragged;

	    area._prev_down = _down;
	    area._prev_x = _x;
	    area._prev_y = _y;

	    var is_touch = _down || _is_released;

	    var analog_x = 0;
	    var analog_y = 0;
	    var analog_strength = 0;
	    var analog_direction = 0;

	    if (_down) {
	        var norm_x = _dx_total / self.analog_threshold;
	        var norm_y = _dy_total / self.analog_threshold;
	        var mag = point_distance(0, 0, norm_x, norm_y);

	        if (mag >= self.analog_deadzone) {
	            var scaled = (mag - self.analog_deadzone) / (1 - self.analog_deadzone);
	            scaled = clamp(scaled, 0, 1);
	            analog_x = (norm_x / mag) * scaled;
	            analog_y = (norm_y / mag) * scaled;
	            analog_strength = scaled;
	            analog_direction = point_direction(0, 0, analog_x, analog_y);
	        }
	    }

	    return {
	        x: is_touch ? _x : -1,
	        y: is_touch ? _y : -1,
	        x_gui: is_touch ? _x_gui : -1,
	        y_gui: is_touch ? _y_gui : -1,
	        dx: _down ? _dx : 0,
	        dy: _down ? _dy : 0,
	        dx_total: _down ? _dx_total : 0,
	        dy_total: _down ? _dy_total : 0,
	        is_down: _down,
	        is_pressed: _is_pressed,
	        is_released: _is_released,
	        is_holding: _is_holding,
	        is_dragging: _is_dragging,
			is_tap: _is_released && !area._has_dragged && !area._has_held,
	        has_dragged: area._has_dragged,
	        is_touch: is_touch,
	        analog_x: analog_x,
	        analog_y: analog_y,
	        analog_strength: analog_strength,
	        analog_direction: analog_direction,
			start_x: area.start_x,
			start_y: area.start_y
	    };
	},

	/// @desc Debug draw function for touch area and analog info
	/// @param {real} area_index - Area index to draw
	/// @param {bool} enable_analog - Show analog direction/strength
	/// @param {bool} enable_touch - Show touch circle and motion lines
	/// @note Call in Draw event for VIEW/FULL, Draw GUI for GUI
	draw: function(area_index, enable_analog = true, enable_touch = true) {
	    var result = self.get(area_index);
	    var area = self.areas[area_index];

	    if result.is_touch {
	        if enable_analog {
	            draw_set_color(c_gray);
	            draw_circle(area.start_x, area.start_y, self.analog_threshold, true);
	            draw_circle(area.start_x + result.analog_x * self.analog_threshold, area.start_y + result.analog_y * self.analog_threshold, 8, false);
	        }

	        if enable_touch {
	            var col = c_white;
	            if result.is_dragging col = c_orange;
	            if result.is_holding col = c_lime;
	            if result.is_holding && result.is_dragging col = c_aqua;

	            draw_set_color(col);
	            draw_circle(result.x, result.y, 6, true);

	            draw_set_color(c_blue);
	            draw_line(area.start_x, area.start_y, result.x, result.y);

	            draw_set_color(c_yellow);
	            draw_line(result.x, result.y, result.x + result.dx * 4, result.y + result.dy * 4);
	        }
	    }

	    draw_set_color(c_ltgray);
	    draw_rectangle(area.x, area.y, area.x + area.w, area.y + area.h, true);
	    draw_set_color(c_white);
	},
	
	clear: function() {
		self.areas = []
	},
	
	/// @desc Check if touch is inside a rectangle
	in_bounds_rect: function(touch_data, _x, _y, _w, _h) {
		return touch_data.is_touch &&
		       touch_data.x >= _x && touch_data.x < _x + _w &&
		       touch_data.y >= _y && touch_data.y < _y + _h;
	},
	
	in_bounds_circle: function(touch_data, _x, _y, _radius) {
	    return touch_data.is_touch &&
	           point_distance(touch_data.x, touch_data.y, _x, _y) <= _radius;
	}
}