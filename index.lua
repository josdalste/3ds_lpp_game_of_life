--------------------------------------------------------
-- Include Code
--------------------------------------------------------
dofile("/3ds/life/scripts/controller.lua")
--------------------------------------------------------
-- Set N3DS speed
--------------------------------------------------------
model = System.getModel()
if(model == 2 or model == 4) then
	System.setCpuSpeed(NEW_3DS_CLOCK)
end
--------------------------------------------------------
-- Set a random seed for unique patterns
--------------------------------------------------------
math.randomseed(os.time())
--------------------------------------------------------
-- Initial values needed
--------------------------------------------------------
btn_break = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
btn_time = {2, 4, 8, 16}
world = {}
cursorpos = {0,0}
en_timer = 1
check_ = 0
cell_array = {5, 10, 16, 20}
icon_pos = 0
min_size = 1
max_size = 4
cell_num = 2
stereo_enable = false
--------------------------------------------------------
-- Initialise the GPU
--------------------------------------------------------
Graphics.init()
--------------------------------------------------------
-- Load the graphics for the program
--------------------------------------------------------
bottom_screen = Graphics.loadImage("/3ds/life/graphics/bottom_screen.png")
pause = Graphics.loadImage("/3ds/life/graphics/pause.png")
load_icon = Screen.loadImage("/3ds/life/graphics/load.png")

function random_screen()
	local temp_num
	bg = Graphics.loadImage("/3ds/life/graphics/bg"..cell_array[cell_num]..".png")
	blocks = Graphics.loadImage("/3ds/life/graphics/blocks"..cell_array[cell_num]..".png")
	world_w = 400/cell_array[cell_num]
	world_h = 240/cell_array[cell_num]
	for h = 1, world_w do
		world[h] = {}
		for i = 1, world_h do
			temp_num = math.random(0, 1)
			world[h][i] = temp_num
		end
	end
	cursor = Graphics.loadImage("/3ds/life/graphics/cursor"..cell_array[cell_num]..".png")
end

function draw_screen(offset)
	Graphics.drawImage(0, 0, bg)
	for j = 1, world_w do
		for k = 1, world_h do
			if(world[j][k] == 1) then
				--Screen X, Y, Image X, Y, Width, Height, Graphics name
				Graphics.drawPartialImage(((j-1)*cell_array[cell_num])-offset, (k-1)*cell_array[cell_num], cell_array[cell_num], 0, cell_array[cell_num], cell_array[cell_num], blocks)
			end
		end
	end
	--------------------------------------------------------
	-- Cursor code
	--------------------------------------------------------
	if(en_timer == 1) then
		Graphics.drawImage(cursorpos[1]*cell_array[cell_num]-offset, cursorpos[2]*cell_array[cell_num], cursor)
	end
end

random_screen()
timer = Timer.new()
btntimer = Timer.new()
Timer.pause(timer)
--------------------------------------------------------
-- Main Loop
--------------------------------------------------------
while true do
	--------------------------------------------------------
	-- Set depth projection
	--------------------------------------------------------
	if(Screen.get3DLevel() > 0) then
		Screen.enable3D()
		stereo_enable = true
	else
		Screen.disable3D()
		stereo_enable = false
	end
	--------------------------------------------------------
	-- Update the screens
	--------------------------------------------------------
	Screen.refresh()
	--------------------------------------------------------
	-- Draw the upper screen information
	--------------------------------------------------------
	if(stereo_enable == false) then
		Graphics.initBlend(TOP_SCREEN)
		draw_screen(0)
		Graphics.termBlend()
	else
		round_3d = math.ceil(Screen.get3DLevel()*5)
		Graphics.initBlend(TOP_SCREEN, RIGHT_EYE)
		draw_screen(round_3d)
		Graphics.termBlend()
		Graphics.initBlend(TOP_SCREEN, LEFT_EYE)
		draw_screen((round_3d*-1))
		Graphics.termBlend()
	end
	--------------------------------------------------------
	-- Read the controls
	--------------------------------------------------------
	read_control()
	--------------------------------------------------------
	-- Controller code
	--------------------------------------------------------
	-- (Start) button
	if(read_control()[12] == 1) then
		if (btn_break[12] == 0) then
			if(en_timer == 0) then
				en_timer = en_timer + 1
				Timer.pause(timer)
			else
				en_timer = en_timer - 1
				Timer.resume(timer)
			end
			btn_break[12] = btn_time[cell_num]
		end
	end
		
	if(en_timer == 1) then
		-- (Y) button
		if(read_control()[3] == 1) then
			if (btn_break[3] == 0) then
				for z = 1, world_w do
					for x = 1, world_h do
						world[z][x] = 0
					end
				end
				btn_break[3] = btn_time[cell_num]
			end
		end
		-- (X) button
		if(read_control()[4] == 1) then
			if (btn_break[4] == 0) then
				random_screen()
				btn_break[4] = btn_time[cell_num]
			end
		end
		-- (L) button
		if(read_control()[5] == 1) then
			if (btn_break[5] == 0) then
				if(cell_num > min_size) then
					cell_num = cell_num - 1
					random_screen()
				end
				btn_break[5] = btn_time[cell_num]
			end
		end
		-- (R) button
		if(read_control()[6] == 1) then
			if (btn_break[6] == 0) then
				if(cell_num < max_size) then
					cell_num = cell_num + 1
					random_screen()
				end
				btn_break[6] = btn_time[cell_num]
			end
		end
		-- (+) controls
		if(read_control()[7] == 1) then
			if (btn_break[7] == 0) then
				cursorpos[1] = cursorpos[1] + 1
				btn_break[7] = btn_time[cell_num]
			end
		end
	
		if(read_control()[8] == 1) then
			if (btn_break[8] == 0) then
				cursorpos[2] = cursorpos[2] + 1
				btn_break[8] = btn_time[cell_num]
			end
		end
	
		if (read_control()[9] == 1) then
			if (btn_break[9] == 0) then
				cursorpos[1] = cursorpos[1] - 1
				btn_break[9] = btn_time[cell_num]
			end
		end
	
		if (read_control()[10] == 1) then
			if (btn_break[10] == 0) then
				cursorpos[2] = cursorpos[2] - 1
				btn_break[10] = btn_time[cell_num]
			end
		end
		
		-- (A) button
		if(read_control()[1] == 1) then
			if (btn_break[1] == 0) then
				if (world[cursorpos[1]+1][cursorpos[2]+1] == 1) then
					world[cursorpos[1]+1][cursorpos[2]+1] = 0
				else
					world[cursorpos[1]+1][cursorpos[2]+1] = 1
				end
				btn_break[1] = btn_time[cell_num]
			end
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
	end
	--------------------------------------------------------
	-- Timer code
	--------------------------------------------------------
	-- Button timer	
	time = Timer.getTime(timer)
	btntime = Timer.getTime(btntimer)
	if (btntime >= btn_time[cell_num]) then
		for a = 1, 12 do
			if(btn_break[a] > 0) then
				btn_break[a] = btn_break[a] - 1
			end
		end
	end
	-- World update timer
	if (time >= 50) then
		local world2 = {}
		for l = 1, world_w do
			world2[l] = {}
			for m = 1, world_h do
				local alive = 0
				
				-- Setup the values for the left/right/top/bottom check
				l_pos = l - 1
				r_pos = l + 1
				t_pos = m - 1
				b_pos = m + 1
				
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
		for h = 1, world_w do
			world[h] = world2[h]
		end
		Timer.reset(timer)
	end
	--------------------------------------------------------
	-- Draw the lower screen information
	--------------------------------------------------------
	Graphics.initBlend(BOTTOM_SCREEN)
	Graphics.drawImage(0,0,bottom_screen)
	if (en_timer == 1) then
		Graphics.drawImage(0,0, pause)
	end
	--------------------------------------------------------
	-- Terminate the lower screen GPU and flip the screens
	--------------------------------------------------------
	Graphics.termBlend()
	Screen.flip()
	Screen.waitVblankStart()	
end