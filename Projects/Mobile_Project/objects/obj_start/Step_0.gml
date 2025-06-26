touch = global.service_touch_several.get(touch_index);
if touch.is_tap { room_goto(rom_nextFloor); audio_play_sound(snd_click, 1, 0) }
if touch.is_holding { room_goto(rom_tutorial); audio_play_sound(snd_click, 1, 0) }