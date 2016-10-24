--------------------------------------------------------
-- Include Code
--------------------------------------------------------
dofile("romfs:/scripts/controller.lua")
dofile("romfs:/scripts/cpu_speed.lua")

--------------------------------------------------------
-- Initialise the GPU
--------------------------------------------------------
Graphics.init()

--------------------------------------------------------
-- Set a random seed for unique patterns
--------------------------------------------------------
math.randomseed(os.time())

--------------------------------------------------------
-- Initial values needed
--------------------------------------------------------
btn_time = {2, 2, 4, 8, 16}
world = {}
cursorpos = {0,0}
cell_array = {4, 5, 10, 16, 20}
grid_size = {{100, 60},{80, 48},{40, 24},{25, 15},{20, 12}}
update_time = {0, 0, 2, 2, 3}
check_ = 0
icon_pos = 0
min_size = 1
max_size = 5
cell_num = 3
update_num = 0
stereo_enable = false
paused = false
start = true
random = true

--------------------------------------------------------
-- Load the graphics for the program
--------------------------------------------------------
-- /3ds/life/ for .3dsx
bottom_screen = Graphics.loadImage("romfs:/graphics/bottom_screen.png")
pause = Graphics.loadImage("romfs:/graphics/pause.png")
logo = Graphics.loadImage("romfs:/graphics/logo.png")
start_bg = Graphics.loadImage("romfs:/graphics/top_screen.png")

--------------------------------------------------------
-- Draw the initial screen layout
--------------------------------------------------------
function random_screen()
	local temp_num
	bg = Graphics.loadImage("romfs:/graphics/bg"..cell_array[cell_num]..".png")
	cursor = Graphics.loadImage("romfs:/graphics/cursor"..cell_array[cell_num]..".png")
	blocks = Graphics.loadImage("romfs:/graphics/blocks"..cell_array[cell_num]..".png")
	world_w = grid_size[cell_num][1]
	world_h = grid_size[cell_num][2]
	for h = 1, world_w do
		world[h] = {}
		for i = 1, world_h do
			temp_num = math.random(0, 1)
			world[h][i] = temp_num
		end
	end
end

--------------------------------------------------------
-- Draw the images
--------------------------------------------------------
function draw_screen(offset)
	Graphics.drawImage(0, 0, bg)
	for a = 1, world_w do
		for b = 1, world_h do
			if (world[a][b] == 1) then
				local start_x = ((a-1)*cell_array[cell_num])-offset
				local start_y = (b-1)*cell_array[cell_num]
				Graphics.drawImage(start_x,start_y, blocks)
			end
		end
	end
	
	--------------------------------------------------------
	-- Draw cursor if required
	--------------------------------------------------------
	if(paused == true) then
		Graphics.drawImage(cursorpos[1]*cell_array[cell_num]-offset, cursorpos[2]*cell_array[cell_num], cursor)
	end
end

--------------------------------------------------------
-- Draw lower screen information
--------------------------------------------------------
function lower_screen_info(bool)
	Graphics.initBlend(BOTTOM_SCREEN)
	Graphics.drawImage(0,0,bottom_screen)
	if (bool == true) then
		Graphics.drawImage(0,0, pause)
	end
	Graphics.termBlend()
	Screen.flip()
	Screen.waitVblankStart()
end

--------------------------------------------------------
-- Draw the upper screen information
--------------------------------------------------------
function upper_screen_info()
	if(Screen.get3DLevel() > 0) then
		Screen.enable3D()
		Graphics.initBlend(TOP_SCREEN, RIGHT_EYE)
		draw_screen(1)
		Graphics.termBlend()
		Graphics.initBlend(TOP_SCREEN, LEFT_EYE)
		draw_screen(-1)
		Graphics.termBlend()
	else
		Screen.disable3D()
		Graphics.initBlend(TOP_SCREEN)
		draw_screen(0)
		Graphics.termBlend()
	end
end

--------------------------------------------------------
-- Code for the sim paused
--------------------------------------------------------
function pause_sim()
	update_num = 0
	common_code(false)
	lower_screen_info(true)
end

--------------------------------------------------------
-- Code for the controls
--------------------------------------------------------
function controls(bool)
	read_control()
	-- (Start) button
	if (read_control()["st"] == 1 and prev_ctrl["st"] == 0) then
		prev_ctrl["st"] = 1
		if (bool == true) then 
			paused = true
		else
			paused = false
		end
	end
	if(paused == true) then
		-- (Y) button
		if (read_control()["y"] == 1 and prev_ctrl["y"] == 0) then
			prev_ctrl["y"] = 1
			for z = 1, world_w do
				for x = 1, world_h do
					world[z][x] = 0
				end
			end
		end
			
		-- (X) button
		if (read_control()["x"] == 1 and prev_ctrl["x"] == 0) then
			prev_ctrl["x"] = 1
			random_screen()
		end
			
		-- (L) button
		if (read_control()["l"] == 1 and prev_ctrl["l"] == 0) then
			prev_ctrl["l"] = 1
			if(cell_num > min_size) then
				cell_num = cell_num - 1
				random_screen()
			end
		end
			
		-- (R) button
		if (read_control()["r"] == 1 and prev_ctrl["r"] == 0) then
			prev_ctrl["r"] = 1
			if(cell_num < max_size) then
				cell_num = cell_num + 1
				random_screen()
			end
		end
			
		-- D-pad controls
		if (read_control()["dr"] == 1 and prev_ctrl["dr"] == 0) then
			prev_ctrl["dr"] = 1
			cursorpos[1] = cursorpos[1] + 1
		end
			
		if (read_control()["dd"] == 1 and prev_ctrl["dd"] == 0) then
			prev_ctrl["dd"] = 1
			cursorpos[2] = cursorpos[2] + 1
		end
		
		if (read_control()["dl"] == 1 and prev_ctrl["dl"] == 0) then
			prev_ctrl["dl"] = 1
			cursorpos[1] = cursorpos[1] - 1
		end
		
		if (read_control()["du"] == 1 and prev_ctrl["du"] == 0) then
			prev_ctrl["du"] = 1
			cursorpos[2] = cursorpos[2] - 1
		end
		
		-- Realign the cursor onscreen if needed
		if (cursorpos[1] < 0) then 
			cursorpos[1] = world_w-1
		elseif (cursorpos[1] > world_w-1) then
			cursorpos[1] = 0
		end
		
		if (cursorpos[2] < 0) then
			cursorpos[2] = world_h-1
		elseif (cursorpos[2] > world_h-1) then
			cursorpos[2] = 0
		end
		
		-- (A) button
		if (read_control()["a"] == 1 and prev_ctrl["a"] == 0) then
			if(cx > 20 or cx < -20 or cy > 20 or cy < -20) then
				prev_ctrl["a"] = 0
			else
				prev_ctrl["a"] = 1
			end
			if (world[cursorpos[1]+1][cursorpos[2]+1] == 1) then
				world[cursorpos[1]+1][cursorpos[2]+1] = 0
			else
				world[cursorpos[1]+1][cursorpos[2]+1] = 1
			end
		end
		
		-- Circle Pad
		cx,cy = Controls.readCirclePad()
		-- Circle pad max values are ~ +160 to ~ -160.
		local x_pos_array = {{20, 55, 1}, {55, 90, 2}, {90, 125, 3}, {125, 160, 4}}
		local x_neg_array = {{-20, -55, 1}, {-55, -90, 2}, {-90, -125, 3}, {-125, -160, 4}}
		local y_pos_array = {{20, 55, 1}, {55, 90, 2}, {90, 125, 3}, {125, 160, 4}}
		local y_neg_array = {{-20, -55, 1}, {-55, -90, 2}, {-90, -125, 3}, {-125, -160, 4}}
		
		for v = 1, 4 do
			if (cx > x_pos_array[v][1] and cx < x_pos_array[v][2]) then
				cursorpos[1] = cursorpos[1] + x_pos_array[v][3]
			end
			
			if (cx < x_neg_array[v][1] and cx > x_neg_array[v][2]) then
				cursorpos[1] = cursorpos[1] - x_neg_array[v][3]
			end
			
			if (cy > y_pos_array[v][1] and cy < y_pos_array[v][2]) then
				cursorpos[2] = cursorpos[2] - y_pos_array[v][3]
			end
			
			if (cy < y_neg_array[v][1] and cy > y_neg_array[v][2]) then
				cursorpos[2] = cursorpos[2] + y_neg_array[v][3]
			end
		end
	end
end

--------------------------------------------------------
-- Code shared between paused and active states
--------------------------------------------------------
function common_code(cont)
	Screen.refresh()
	controls(cont)
	upper_screen_info()
end

--------------------------------------------------------
-- Code for the sim running
--------------------------------------------------------
function resume_sim()
	common_code(true)
	if (update_time[cell_num] == update_num) then
		update_num = 0
		local world2 = {}
		local world_w = world_w
		local world_h = world_h
		for l = 1, world_w do
			world2[l] = {}
			for m = 1, world_h do
				local alive = 0
				-- Setup the values for the left/right/top/bottom check
				local l_pos = l - 1
				local r_pos = l + 1
				local t_pos = m - 1
				local b_pos = m + 1
				-- Correct for the looping
				if (l_pos < 1) then l_pos = world_w end
				if (r_pos > world_w) then r_pos = 1 end
				if (t_pos < 1) then t_pos = world_h end
				if (b_pos > world_h) then b_pos = 1 end
				-- Check the left/right of the current object
				if (world[l_pos][m] == 1) then
					alive = alive + 1
				end
				if (world[r_pos][m] == 1) then
					alive = alive + 1
				end
				-- Check the top/bottom of the current object
				if (world[l][t_pos] == 1) then
					alive = alive + 1
				end
				if (world[l][b_pos] == 1) then
					alive = alive + 1
				end
				-- Check Diagonals
				if (alive < 4) then
					--Check the top left
					if (world[l_pos][t_pos] == 1) then
						alive = alive + 1
					end
					-- Check the top right
					if (world[r_pos][t_pos] == 1) then
						alive = alive + 1
					end
					-- Check the bottom left
					if (world[l_pos][b_pos] == 1) then
						alive = alive + 1
					end				
					-- Check the bottom right
					if (world[r_pos][b_pos] == 1) then
						alive = alive + 1
					end
				end
				if (alive < 2 and world[l][m] == 1 or alive > 3 and world[l][m] == 1) then
					world2[l][m] = 0
				elseif (alive == 2 and world[l][m] == 1 or alive == 3 and world[l][m] == 1 or alive == 3 and world[l][m] == 0) then
					world2[l][m] = 1
				else
					world2[l][m] = 0
				end
			end
		end
		world = world2
	else
		update_num = update_num + 1
	end
	lower_screen_info(false)
end

--------------------------------------------------------
-- Code for the start screen
--------------------------------------------------------
function draw_start_top(offset)
	Graphics.drawImage(0, 0, start_bg)
	Graphics.drawImage(offset, 0, logo)
	Graphics.termBlend()
end

function start_screen()
	read_control()
	-- (Start) button
	if (read_control()["st"] == 1) then
		prev_ctrl["st"] = 1
		start = false
		paused = true
	end
	Screen.refresh()
	if(Screen.get3DLevel() > 0) then
		Screen.enable3D()
		Graphics.initBlend(TOP_SCREEN, RIGHT_EYE)
		draw_start_top(1)
		Graphics.initBlend(TOP_SCREEN, LEFT_EYE)
		draw_start_top(-1)
	else
		Screen.disable3D()
		Graphics.initBlend(TOP_SCREEN)
		draw_start_top(0)
	end
	Graphics.initBlend(BOTTOM_SCREEN)
	Screen.flip()
	Graphics.termBlend()
	Screen.waitVblankStart()
end

--------------------------------------------------------
-- The main loop
--------------------------------------------------------
while true do
	if (start == true) then
		start_screen()
	else
		if (random == true) then
			random_screen()
			random = false
		end
		
		if (paused == true) then
			pause_sim()
		else
			resume_sim()
		end
	end
end