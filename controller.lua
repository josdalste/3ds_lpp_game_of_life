function read_control()
	local value = {}
	local pad = Controls.read()
	if (Controls.check(pad,KEY_A)) then
		value ["a"] = 1
	else
		prev_ctrl["a"] = 0
	end
	if (Controls.check(pad,KEY_B)) then
		value ["b"] = 1
	else
		prev_ctrl["b"] = 0
	end
	if (Controls.check(pad,KEY_Y)) then
		value ["y"] = 1
	else
		prev_ctrl["y"] = 0
	end
	if (Controls.check(pad,KEY_X)) then
		value ["x"] = 1
	else
		prev_ctrl["x"] = 0
	end
	if (Controls.check(pad,KEY_L)) then
		value ["l"] = 1
	else
		prev_ctrl["l"] = 0
	end
	if (Controls.check(pad,KEY_R)) then
		value ["r"] = 1
	else
		prev_ctrl["r"] = 0
	end
	if (Controls.check(pad, KEY_DRIGHT)) then
		value ["dr"] = 1
	else
		prev_ctrl["dr"] = 0
	end
	if (Controls.check(pad, KEY_DDOWN)) then
		value ["dd"] = 1
	else
		prev_ctrl["dd"] = 0
	end
	if (Controls.check(pad, KEY_DLEFT)) then
		value ["dl"] = 1
	else
		prev_ctrl["dl"] = 0
	end
	if (Controls.check(pad, KEY_DUP)) then
		value ["du"] = 1
	else
		prev_ctrl["du"] = 0
	end
	if (Controls.check(pad, KEY_SELECT)) then
		value ["se"] = 1
	else
		prev_ctrl["se"] = 0
	end
	if (Controls.check(pad, KEY_START)) then
		value ["st"] = 1
	else
		prev_ctrl["st"] = 0
	end
	if (Controls.check(pad, KEY_HOME)) then
		System.showHomeMenu()
	end
	return value
end