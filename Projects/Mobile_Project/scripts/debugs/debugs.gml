function debugs(_message, always_display = false){
	if (global.debug || always_display) {
		show_debug_message(_message)
	}
}