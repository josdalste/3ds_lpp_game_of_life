function read_control()
	value = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	pad = Controls.read()
	if (Controls.check(pad,KEY_A)) then
		value [1] = 1
	end
	if (Controls.check(pad,KEY_B)) then
		value [2] = 1
	end
	if (Controls.check(pad,KEY_Y)) then
		value [3] = 1
	end
	if (Controls.check(pad,KEY_X)) then
		value [4] = 1
	end
	if (Controls.check(pad,KEY_L)) then
		value [5] = 1
	end
	if (Controls.check(pad,KEY_R)) then
		value [6] = 1
	end
	if (Controls.check(pad, KEY_DRIGHT)) then
		value [7] = 1
	end
	if (Controls.check(pad, KEY_DDOWN)) then
		value [8] = 1
	end
	if (Controls.check(pad, KEY_DLEFT)) then
		value [9] = 1
	end
	if (Controls.check(pad, KEY_DUP)) then
		value [10] = 1
	end
	if (Controls.check(pad, KEY_SELECT)) then
		value [11] = 1
	end
	if (Controls.check(pad, KEY_START)) then
		value [12] = 1
	end
	if (Controls.check(pad, KEY_HOME)) then
		System.showHomeMenu()
	end
	return value
end