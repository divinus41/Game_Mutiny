pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
-- mutiny

-- dominique mowius
-- fethi isfarca

-- main functions

function _init()
	
	-- declare variables
	
	-- title 0
	-- gameplay 1
	-- win 2
	-- lose 3
	
	gamestate = 0
	
	-- frames per second
	-- at the beginning
	
	fps = 0
	
	-- maximum possible
	-- frames per second
	
	max_fps = 30
	
	-- music
	-- main theme
	
	sfx(5)
	
	-- algorithm
	
	init_area()
	init_ship()
	
	init_shark()
	
	init_player()
	
	init_pirates_spawn_points()
	init_pirates()
	init_pirates_drown()
	
	init_bloods()
	
end

-- update states

function _update()

	fpscounter() 

	if (gamestate == 0) then
	
		update_title()
		
	elseif (gamestate == 1) then
	
		update_gameplay()
		
	elseif (gamestate == 2) then
	
		update_win()
		
	elseif (gamestate == 3) then
	
		update_lose()
		
	end
	
end

function update_title()

	-- algorithm
	
	press_key_logic()
	
end

function update_gameplay()

	-- algorithm
	
	timer_increment_logic()
	
	player_map_coordinates_logic()	
	player_move_logic()
	player_collision_logic()
	player_fight_logic()
	player_win_logic()
	player_lose_logic()
	
	sharks_animation_logic()
	
	pirates_spawn_logic()
	pirates_movement_logic()
	pirates_collision_logic()
	pirates_fight_logic()
	pirates_delete_logic()
	pirates_drown_logic()
	
	bloods_delete_logic()
	
end

function update_win()

	-- algorithm
	
	press_key_logic()
	
end

function update_lose()

	-- algorithm
	
	press_key_logic()

end

-- draw states

function _draw()

	if (gamestate == 0) then
	
		draw_title()
		
	elseif (gamestate == 1) then
	
		draw_gameplay()
		
	elseif (gamestate == 2) then
	
		draw_win()
		
	elseif (gamestate == 3) then
	
		draw_lose()
		
	end
	
end

function draw_title()

	cls()
	
	-- algorithm
	
	output_game_name()
	output_version_number()
	
	output_water_text()
	output_sprite_headings()
	output_sprites()
	
	output_press_key_text()
	
end

function draw_gameplay()

	cls()
	
	-- algorithm
	
	output_map()
	
	--output_timer()
	--output_kills()
	
	output_sharks()
	
	output_bloods()
	
	output_player()
	
	output_pirates()
	output_pirates_drown()
	
end

function draw_win()

	cls()
	
	-- algorithm
	
	output_win_text()
	
	output_sprite_win()
	
	output_kills_timer()
	
end

function draw_lose()
		
	cls()
	
	-- algorithm
	
	output_lose_text()
	
	output_sprite_lose()
	
	output_kills_timer()
	
end

-- secondary functions

-- functions for _init()

function init_area()

	area =
	{
		celx = 0,
		cely = 0,
		sx = 0,
		sy = 0,
		celw = 16,
		celh = 16
	}

end

function init_ship()

	ship =
	{
		pixel_width = 32,
		pixel_height = 48
	}

end

function init_shark()

	sharks = {}
	
	minimum =
	{
		x = 7,
		y = 15
	}
	
	maximum = 
	{
		x = 100,
		y = 105
	}
	
	average = 60
	
	add_sharks(minimum.x, minimum.y, 1)
	add_sharks(minimum.x, average, 5)
	add_sharks(minimum.x, maximum.y, 3)
	
	add_sharks(maximum.x, minimum.y, 6)
	add_sharks(maximum.x, average, 2)
	add_sharks(maximum.x, maximum.y, 4)
		
end

function init_player()

	player =
	{
	
		frames = 
		{
			{ 33, 35 }, -- up
			{ 32, 34 }, -- down
			{ 36 }, -- right
			{ 39 }, -- left
			{ 36, 38 }, -- attack right
			{ 39, 41 }, -- attack left
			{ 61, 60 }, -- attack up
			{ 46, 44 } -- attack down
		},
		frames_index = 1,
		frame = 1,
		frames_duration = 10, 
		
		up = true,
		down = false,
		right = false,
		left = false,
		
		x = flr(rnd(ship.pixel_width)) + 40,
		y = flr(rnd(ship.pixel_height)) + 50,
		
		celx = 0,
		cely = 0,
		
		vx = 1,
		vy = 1,
		
		timer = 0,
		kills = 0
	}

end

function init_pirates_spawn_points()

	-- declare variable
	
	spawn = {}
	
	for y = 0, area.celw, 1 do
	
		for x = 0, area.celh, 1 do
			
			if (fget(mget(x, y), 0) or
							fget(mget(x, y), 1)) then
			 
			 local s = 
			 {
			  x = x,
			  y = y
			 }
			 
				add(spawn, s)
			
			end
			
		end
		
	end
	
end

function init_pirates()

	pirates = {}
	
end

function init_pirates_drown()

	pirates_drown = {}
	
end

function init_bloods()

	bloods = {}

end

-- functions for update_title()

function press_key_logic()

	if (btn(4)) then
	
		_init()
		
		gamestate = 1
		
	end
	
end

-- functions for update_gameplay()

function timer_increment_logic()

	if (fps % max_fps == 0) then
	
		player.timer += 1
		
	end

end

function player_map_coordinates_logic()
	
	player.celx = flr(player.x / 8)
	player.cely = flr(player.y / 8)

end

function player_move_logic()

	if (btn(0)) then -- left
	
		player.x -= player.vx
		
		player.frames_index = 4
		player.frame = 1
		
		player.up = false
		player.down = false
		player.left = true
		player.right = false
		
	elseif (btn(1)) then -- right
	
		player.x += player.vx
		
		player.frames_index = 3
		player.frame = 1
		
		player.up = false
		player.down = false
		player.left = false
		player.right = true
		
	elseif (btn(2)) then -- up
	
		player.y -= player.vy
		
		player.frames_index = 1
		player_framereset()
		
		player.up = true
		player.down = false
		player.left = false
		player.right = false
		
	elseif (btn(3)) then -- down
	
		player.y += player.vy
		
		player.frames_index = 2
		player_framereset()
		
		player.up = false
		player.down = true
		player.left = false
		player.right = false
		
	end
	
end

function player_collision_logic()

	if (player.y <= 1 and
					player.x >= 53 and
					player.x <= 61) then
					
		player.y = 1
		
	elseif (player.y >= 121 and
									player.x >= 30 and
									player.x <= 84) then
									
		player.y = 121
		
	end

end

function player_fight_logic()
	
	-- declare variable
	
	taken_radius = 8
	feedback_value = 10
	
	if (btnp(5)) then -- attack
		
		-- frameexchange
		
		if (player.right) then
		
			player.frames_index = 5
			player.frame += 1
			
		elseif (player.left) then
		
			player.frames_index = 6
			player.frame += 1
			
		elseif (player.up) then
		
			player.frames_index = 7
			player.frame += 1
			
		elseif (player.down) then
		
			player.frames_index = 8
			player.frame += 1
			
		end
		
		-- framereset
		
		if (player.frame > #player.frames[player.frames_index]) then
	
			player.frame = 1
		
		end
		
		-- feedback
		
		for pirate in all(pirates) do
		
			if (pirate.celx >= player.x - taken_radius and
							pirate.celx <= player.x + taken_radius and
							pirate.cely >= player.y - taken_radius and
							pirate.cely <= player.y + taken_radius) then
							
				sfx(1)
							
				if (player.up) then
				
					pirate.cely -= feedback_value
					
					add_bloods(pirate.celx - feedback_value, pirate.cely)
					
				elseif (player.down) then
				
					pirate.cely += feedback_value
					
					add_bloods(pirate.celx + feedback_value, pirate.cely)
					
				elseif (player.right) then
				
					pirate.celx += feedback_value
					
					add_bloods(pirate.celx, pirate.cely + feedback_value)
					
				elseif (player.left) then
				
					pirate.celx -= feedback_value
					
					add_bloods(pirate.celx, pirate.cely - feedback_value)
					
				end
				
			end
			
		end
		
	end

end

function player_win_logic()

	if (player.kills >= 100) then
	
		gamestate = 2
		
	end

end

function player_lose_logic()
	
	main = 
	{
		sprite = mget
										 (
											 player.celx,
										  player.cely + 1
									  )
	}
																
	if (fget(main.sprite, 2)) then
		
		sfx(-1)
		
		sfx(2)
		
		gamestate = 3
		
	end

end

function sharks_animation_logic()

	for shark in all(sharks) do
		
		sharks_framereset(shark)
	
	end

end

function pirates_spawn_logic()

	random_spawn = flr(rnd(random_spawn_value()))
	
	if (random_spawn == 1) then
	
		add_pirates()
	
	end

end

function pirates_movement_logic()

	for pirate in all(pirates) do
	
		-- shall run out of the 
		-- spawn point.
		
		if (pirate.celx >= 3 * 8 and
						pirate.celx <= 4 * 8) then
		
			pirate.celx += pirate.vx
			
			pirate.frames_index = 4
			pirate.frame = 1
			
			pirate.up = false
			pirate.down = false
			pirate.left = false
			pirate.right = true
			
		elseif (pirate.celx <= 11 * 8 and
										pirate.celx >= 10 * 8) then
		
			pirate.celx -= pirate.vx
			
			pirate.frames_index = 3
			pirate.frame = 1
			
			pirate.up = false
			pirate.down = false
			pirate.left = true
			pirate.right = false
		
		-- a-star- / pathfinding-algorithm
		
		elseif (pirate.cely < player.cely * 8 and
										pirate.celx > player.celx * 8) then
										
			pirate.cely += pirate.vy
			
			pirate.frames_index = 2
			pirates_framereset(pirate)
			
			pirate.up = false
			pirate.down = true
			pirate.left = false
			pirate.right = false
			
		elseif (pirate.cely == player.cely * 8 and
										pirate.celx > player.celx * 8) then
											
			pirate.celx -= pirate.vx
			
			pirate.frames_index = 4
			pirate.frame = 1
			
			pirate.up = false
			pirate.down = false
			pirate.left = true
			pirate.right = false
			
		elseif (pirate.cely > player.cely * 8 and
										pirate.celx > player.celx * 8) then
										
			pirate.celx -= pirate.vx
			
			pirate.frames_index = 4
			pirate.frame = 1
			
			pirate.up = false
			pirate.down = false
			pirate.left = true
			pirate.right = false			
			
		elseif (pirate.cely > player.cely * 8 and
										pirate.celx == player.celx * 8) then
										
			pirate.cely -= pirate.vy
			
			pirate.frames_index = 1
			pirates_framereset(pirate)
			
			pirate.up = true
			pirate.down = false
			pirate.left = false
			pirate.right = false			
			
		elseif (pirate.cely > player.cely * 8 and
										pirate.celx < player.celx * 8) then
										
			pirate.cely -= pirate.vy
			
			pirate.frames_index = 1
			pirates_framereset(pirate)
			
			pirate.up = true
			pirate.down = false
			pirate.left = false
			pirate.right = false				
			
		elseif (pirate.cely == player.cely * 8 and
										pirate.celx < player.celx * 8) then
										
			pirate.celx += pirate.vx
			
			pirate.frames_index = 3
			pirate.frame = 1
			
			pirate.up = false
			pirate.down = false
			pirate.left = false
			pirate.right = true			
			
		elseif (pirate.cely < player.cely * 8 and
										pirate.celx < player.celx * 8)	then																																		
			
			pirate.celx += pirate.vx
			
			pirate.frames_index = 3
			pirate.frame = 1
			
			pirate.up = false
			pirate.down = false
			pirate.left = false
			pirate.right = true			
			
		elseif (pirate.cely < player.cely * 8 and
										pirate.celx == player.celx * 8) then
										
			pirate.cely += pirate.vy
			
			pirate.frames_index = 2
  	pirates_framereset(pirate)
			
			pirate.up = false
			pirate.down = true
			pirate.left = false
			pirate.right = false			
		
		end
			
	end

end

function pirates_collision_logic()
	
	-- declare variables
	
	reach = 1
	
	random =
	{
		cel = 0,
		char = 0
	}
	
	for pirate in all(pirates) do
	
		for i = 1, #pirates, 1 do
		
			if (pirate.celx == pirates[i].celx and
							pirate.cely == pirates[i].cely) then
							
				random.cel = flr(rnd(2))
				random.char = flr(rnd(2))
				
				if (random.cel == 0 and
								random.char == 0) then
								
					pirate.celx += reach
					
				elseif (random.cel == 0 and
												random.char == 1) then		

					pirate.celx -= reach
					
				elseif (random.cel == 1 and
												random.char == 0) then		

					pirate.cely += reach
					
				elseif (random.cel == 1 and
												random.char == 1) then		

					pirate.cely -= reach
					
				end
				
			end
				
		end
			
	end
			
end

function pirates_fight_logic()
	
	-- declare variable
	
	taken_radius = 6
	feedback_value = 2
	
	for pirate in all(pirates) do
		
		-- frameexchange
		
		if (pirate.celx >= player.x - taken_radius and
						pirate.celx <= player.x + taken_radius and
						pirate.cely >= player.y - taken_radius and
						pirate.cely <= player.y + taken_radius) then
						
			sfx(1)
		
			if (pirate.left) then
			
				pirate.frames_index = 5
				
				if (fps % pirate.frames_duration == 0) then
	  		
	  		pirate.frame += 1
	  		
	  	end
				
			elseif (pirate.right) then										
		
				pirate.frames_index = 6
				
				if (fps % pirate.frames_duration == 0) then
	  		
	  		pirate.frame += 1
	  		
	  	end
	  	
	  elseif (pirate.up) then
	  
	  	pirate.frames_index = 7
				
				if (fps % pirate.frames_duration == 0) then
	  		
	  		pirate.frame += 1
	  		
	  	end
	  	
	  elseif (pirate.down) then
	  
	  	pirate.frames_index = 8
				
				if (fps % pirate.frames_duration == 0) then
	  		
	  		pirate.frame += 1
	  		
	  	end
				
			end
			
			-- framereset
			
			if (pirate.frame > #pirate.frames[pirate.frames_index]) then
	
				pirate.frame = 1
		
			end
			
			-- feedback
							
			if (pirate.up) then
				
				player.y -= feedback_value
				
				add_bloods((player.celx * 8), (player.cely * 8) - feedback_value)
					
			elseif (pirate.down) then
				
				player.y += feedback_value
			
				add_bloods((player.celx * 8), (player.cely * 8) + feedback_value)
					
			elseif (pirate.right) then
				
				player.x += feedback_value
				
				add_bloods((player.celx * 8) + feedback_value, (player.cely * 8))
					
			elseif (pirate.left) then
				
				player.x -= feedback_value
				
			 add_bloods((player.celx * 8) - feedback_value, (player.cely * 8))
					
			end
			
		end
		
	end

end

function pirates_delete_logic()

	-- declare variable
	
	local enemy = ""

	for pirate in all(pirates) do
	
		enemy = mget
										(
											pirate.celx / 8,
										 pirate.cely / 8
									 )
																
		if (fget(enemy, 2)) then
		
			sfx(4)
		
			if (pirate.celx < 60) then
			
				add_pirates_drown(pirate.celx - 25, pirate.cely)
			
			elseif (pirate.celx > 60) then
			
				add_pirates_drown(pirate.celx + 25, pirate.cely)
			
			elseif	(pirate.cely < 60) then
			
				add_pirates_drown(pirate.celx, pirate.cely - 25)
				
			elseif	(pirate.cely > 60) then
			
				add_pirates_drown(pirate.celx, pirate.cely + 25)
				
			end				
				
			player.kills += 1 
			
			del(pirates, pirate)
			
		end
		
	end

end

function pirates_drown_logic()

	for pirate_drown in all(pirates_drown) do
			
		pirates_drown_framereset(pirate_drown)
			 
	end

end

function bloods_delete_logic()

	for blood in all(bloods) do
	
		if (fps % max_fps == 0) then
		
			del(bloods, blood)
			
		end
		
	end

end

-- functions for update_win()

-- functions for update_lose()

-- functions for draw_title()

function output_game_name()

	spr
	(
		133,
		45,
		20,
		4,
		4
	)

end

function output_version_number()

	print
	(
		"v 1.0",
		80,
		25,
		3
	)

end

function output_water_text()

	print
	(
		"-- don't touch the water",
		13,
		40,
		7
	)

end

function output_sprite_headings()

	print
	(
		"attack",
		13,
		55,
		4
	)
	
	print
	(
		"move",
		83,
		55,
		12
	)

end

function output_sprites()

	spr(132, 20, 70) -- cross
	spr(128, 67, 75) -- left
	spr(129, 87, 70) -- up
	spr(130, 87, 80) -- down
	spr(131, 107, 75) -- right

end

function output_press_key_text()

	print
	(
		"press y to start the game",
		15,
		110,
		10
	)

end

-- functions for draw_gameplay()

function output_map()

	map
	(
		area.celx,
		area.cely,
		area.sx,
		area.sy,
		area.celw,
		area.celh
	)

end

function output_timer()

	print
	(
		"timer: "..player.timer,
		5,
		5,
		0
	)

end

function output_kills()

	print
	(
		"kills: "..player.kills,
		80,
		5,
		0
	)

end

function output_sharks()

	for shark in all(sharks) do
		
		spr
		(
			shark.frames
			[shark.frames_index]
			[shark.frame],
			
			shark.celx,
			shark.cely,
			shark.zoom_width,
			shark.zoom_height
		)
		
	end

end

function output_bloods()

	for blood in all(bloods) do
	
		spr
		(
			blood.sprite,
			blood.celx,
			blood.cely
		)
		
	end

end

function output_player()

	spr
	(
		player.frames
		[player.frames_index]
		[player.frame],
		
		player.x,
		player.y
	)
	
end

function output_pirates()

	for pirate in all(pirates) do
	
		spr
		(
			pirate.frames
			[pirate.frames_index]
			[pirate.frame],
			
			pirate.celx,
			pirate.cely
		)
		
	end
	
end

function output_pirates_drown()
	
	for pirate_drown in all(pirates_drown) do
	
		spr
		(
			pirate_drown.frames
			[pirate_drown.frames_index]
			[pirate_drown.frame],
			
			pirate_drown.celx,
			pirate_drown.cely
		)
		
	end
	
end

-- functions for draw_win()

function output_win_text()

	print
	(
		"you win!",
		40,
		30,
		1
	)

end

function output_sprite_win()

	spr 
	(
		204,
		40,
		50,
		4,
		4
	)

end

function output_kills_timer()

	print
	(
		player.kills.." killed",
		38,
		100,
		4
	)
	
	print
	(
		player.timer.." seconds survived",
		20,
		110,
		12
	)
	
	print
	(
		"press y to start the new game",
		0,
		120,
		10
	)

end

-- functions for draw_lose()

function output_lose_text()

	print
	(
		"you lose!",
		40,
		30,
		1
	)

end

function output_sprite_lose()

	spr 
	(
		137,
		40,
		50,
		4,
		4
	)

end

-- functions for add objects

function add_sharks(_x, _y, _f)

	local sh =
	{
	
		frames =
		{
			{ 64, 66, 68, 70, 72, 74, 76 }
		},
		frames_index = 1,
		frame = _f,
		frames_duration = 10,
		
		zoom_width = 2,
		zoom_height = 2,
		
		celx = _x,
		cely = _y
		
	}
	
	add(sharks, sh)
	
end

function add_pirates()
	
	-- declare variables
	
	index = flr(rnd(#spawn)) + 1
	
	local p =
	{
	
		frames =
		{
			{ 1, 3 }, -- up
			{ 0, 2 }, -- down
			{ 4 }, -- right
			{ 7 }, -- left
			{ 4, 6 }, -- attack right
			{ 7, 9 }, -- attack left
			{ 42, 10 }, -- attack up
			{ 59, 58 } -- attack down
		},
		frames_index = 1,
		frame = 1,
		frames_duration = 10,
		
		up = false,
		down = false,
		right = false,
		left = false,
		
		celx = spawn[index].x * 8,
		cely = spawn[index].y * 8,
		
		vx = 1,
		vy = 1
		
	}
	
	add(pirates, p)
	
end

function add_pirates_drown(_x, _y)

	local p_d =
	{
		
		frames =
		{
			-- kill
			
			{ 11, 12, 13, 14, 15, 27, 28, 29, 30, 31 }
		},
		frames_index = 1,
		frame = 1,
		frames_duration = 10,
		
		celx = _x,
		cely = _y
		
	}
	
	add(pirates_drown, p_d)

end

function add_bloods(_x, _y)

	local b =
	{
		sprite = 43,
		celx = _x,
		cely = _y
	}
	
	add(bloods, b)

end

-- functions for delete objects

-- functions for frameresets

function player_framereset()
	
	if (fps % player.frames_duration == 0) then
		
		player.frame += 1
		
		if (player.frame > #player.frames[player.frames_index]) then
	
			player.frame = 1
		
		end
		
	end
		
end

function sharks_framereset(_shark)

	if (fps % _shark.frames_duration == 0) then
		
		_shark.frame += 1
		
		if (_shark.frame > #_shark.frames[_shark.frames_index]) then
	
			_shark.frames_index = 1
			
			_shark.frame = 1
		
		end
		
	end
		
end

function pirates_framereset(_pirate)

	if (fps % _pirate.frames_duration == 0) then
		
		_pirate.frame += 1
		
		if (_pirate.frame > #_pirate.frames[_pirate.frames_index]) then
	
			_pirate.frame = 1
		
		end
		
	end
		
end

function pirates_drown_framereset(_pirate_drown)

	if (fps % _pirate_drown.frames_duration == 0) then
		
		_pirate_drown.frame += 1
		
		if (_pirate_drown.frame > #_pirate_drown.frames[_pirate_drown.frames_index]) then
	
			del(pirates_drown, _pirate_drown)
		
		end
		
	end

end

-- other auxiliary functions

function fpscounter()

	fps += 1
	
	if (fps % max_fps == 0) then
	
		fps = 0
		
	end

end

function random_spawn_value()

	if (player.timer < 20) then
	
		return 50
		
	elseif (player.timer >= 20 and
									player.timer < 40) then
									
		return 40
		
	elseif (player.timer >= 40 and
									player.timer < 180) then
									
		return 30
		
	elseif (player.timer >= 180) then
									
		return 20
		
	end

end
__gfx__
00222000002220000022200000222000002200000022000002200000002200000022000000022000002220007ccccccccccccccccccccccccccccccccccccccc
00fff20002fff00000fff20002fff00002f6000002ff00002ff00000006f200000ff2000000ff20000fff200c7222c77ccccccccccccccccccccccccc8cccc8c
06fff00000fff60006fff00000fff60000f6000000ff06000ff00000006f000060ff0000000ff00006fff000c7fff77cc722277cc7ccc77cccccccccc88cc88c
0655550005555500065555000555550000560000005060000500000000650000060500000000500006555500c77ff7ccc77ff7ccc77227ccc7722cccc78228cc
06555500055555000655550005555500005f0000005f000005f6660000f5000000f50000666f500006555500cc7577cccc7f77cccc7f77cccc7f77cccc7f77cc
0f222f000f222f000f222f000f222f000020000000200000020000000002000000020000000020000f222f00cccccccc7cccccc7ccccccccccc88cccccc88c77
0050f00000f0f00000f0500000f0f00000f0000000f000000f000000000f0000000f00000000f00000f0f000ccccccccc77c7777ccccccccccccccccc7ccc88c
0000500000505000005000000050500000500000005000000500000000050000000500000000500000505000cccccccccccccccccccccccccccccccccccccccc
0022200000222000002220000022200000220000002200000220088800220000802200880002200000222000cccccccccccccccccccccccccccccccccccccccc
00fff28002fff00000fff20002fff88002f7000002ff08802ff08000087f200088ff8800000ff28800fff200ccc8888cccc8cccccccccccccccccccccccccccc
07fff88000ff880007fff00000f8880000f7080000f887000ff00000087f000070f80000000ff88000fff000cccccc88ccc88c8ccccccccccccccccccccccccc
0766880006688880888866000666888000688000006870000600800000860000070680000000800006555500cc8cc8c8cc888888cc88c8ccccc8ccccccc8cccc
07666600066666008886660006666680006888000068000006f7870000f6000000f60800777f680806555500888cccc8c888888cc88888cccc888cccccc88ccc
0f222f000feeef008f222f000f222f000020008000288000060008008802000000020880000028000f222f008cc8822cccc888ccccc88cccccc88ccccccccccc
0060f00000f0f00000f0600000f0f00000f0000000f008000f000800800f0000000f00800000f00800f0f00088ccc88cccccc8cccccccccccccccccccccccccc
0000600000606000006000000060600000600000006000000600000000060000000600000000600000505000cccccccccccccccccccccccccccccccccccccccc
00111000001110000011100000111000001100000011000001100000001100000011000000011000002220000000000000111000001110000011100000000000
01fffb909bfff10001fffb909bfff10001b9000001b900001b900000009b1000009b10000009b10000fff2000000000001fffb9001fffb9001fffb9000000000
06fffb000bfff60006fffb000bfff60000b6000000bf06000bf00000006b000060fb0000000fb00000fff0000000800006fffb0000fffb0000fffb0000000000
06555b000b55550006555b000b5555000b5600000b506000b50000000065b0000605b00000005b00055555000008880006555b0006555b0005555b0000000000
06555500055555000655550005555500005f0000005f000005f6660000f5000000f50000666f5000055555000000880006555500065555000555550000000000
0f111f000f111f000f111f000f111f0000100000001000000100000000010000000100000000100006222f00000000000f111f000f111f0006111f0000000000
00f050000050f0000050f00000f0500000f0000000f000000f000000000f0000000f00000000f00000f0f0000000000000f0500000f0500000f0500000000000
00500000000050000000500000500000005000000050000005000000000500000005000000005000005050000000000000500000005000000050000000000000
00111000001110880011108000111080001100000011080001100000001100000011000000011000002220000022200000111000001110000000000000000000
01fffb909bfff18001ff8b909bfff88001b9008001b908001b900880009b1000889b10000009b10002fff00002fff0009bfff1009bfff1000000000000000000
07fffb000bff880007f88b000bff880000b7880000bf87000bf88000887b0000788b0000088fb00000fff60000fff0000bfff6000bfff0000000000000000000
07886b000b688600076868080b6686000b6880000b607000b68000000876b0000706b00000886b0005555500055555000b5555000b5555000000000000000000
07868800066666000766860008866600006f0080006f088008877700008600000086000077788000055555000555550005555500055555000000000000000000
081118000f111f000f11180888111f000010000800100008018880000801000008810000008810000f222f000f222f000f111f000f111f000000000000000000
00f060000060f0000060f00000f0600000f0000000f000000f008800800f0000000f00000080f00000f0f00000f0f0000050f0000050f0000000000000000000
00600008000060000000600000600000006000000060000006000000000600000006000080006000005050000050500000005000000050000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
c55ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
cc55ccccccccccccccccc55ccccccccccccccccc55ccccccccccccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccc0000000000000000
755557cccccccccccccccc55ccccccccccccccccc55cccccccccccccccccc7cccccccccccccccccccccccccccccccccc777ccccccccccccc0000000000000000
777777ccccccccccccc7755557cccccccccccc7755557cccccccccccccccc7cccccccccccccccccccccccccccccccccc757ccccccccccccc0000000000000000
cccccccccccccccccccc777777ccccccccccccc777777ccccccccccccccc757cccccccccccccccccccccccccccccccccc5cccccccccccccc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc757cccccccccccccccccccccccccccccccccc5cccccccccccccc0000000000000000
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5ccccccccccccccccccccccccccccccccccc5cccccccccccccc0000000000000000
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5ccccccccccccccccccccc55ccccccccccccccccccccccccccc0000000000000000
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc55ccccccc55cccccccccccccccccccccccccccc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc55cccccc7555577777cccccccccccccccccccccc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc755557777c777777cccccccccccccccccccccccccc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc777777cccccccccccccccccccccccccccccccccccc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77077777777000777777077777777077077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70777777770707077777077777777707707777070000000000000004040000000000000000000000000000000000000000000000000000000000000000000000
07777777707707707777077777777770770770770000000000000004440000000000000000000000000000000000000000000000000000000000000000000000
00000000777707777777077700000000777007770440000044000000400000000000000000000000000000000000000000000000000000000000000000000000
07777777777707777777077777777770777007770444000444004444444444000000000000000000000000000000000000000000000000000000000000000000
70777777777707777077077077777707770770770404404404007777477777000000000000000000000000000000000000000000000000000000000000000000
77077777777707777707070777777077707777070400444004007777477477000000000000000000000000000000000000000000000000000000000000000000
77777777777707777770007777777777077777700400000004007777477777000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000400000004040040400404000400400002200000001100000000000000000000000000000000000000000000
0000000000000000000000000000000000000000040000000404004040040444040040002ff0000001b900000000000000000000000000000000000000000000
0000000000000000000000000000000000000000040000000404004040040404004400000ff0000000b600000000000000000000000000000000000000000000
000000000000000000000000000000000000000004000000040444404004040400040000050000000b5600000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000400000000440000005f66600005f00000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004400000002000000001000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000004000000000f00000000f000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000005000000005000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444444444444444000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444440000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044444000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044440000000000005500000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044440000000000055000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044400000000000555000000005550000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044400000000775555557000000555700000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000444ccccccccc77777777cccc777777cc000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044cccccccccccccccccccccccccccccc000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000044cccccccccccccccccccccccccccccc000000000000000000000000
44444444444444444444444455555555c77ccccc0000000055555555cccccccc77cccccccccccccccccccccccccccccc00000000000000000000000000000000
44444444444445444454444455555555cc77cccc00000000ffffffffccccccccc77cccccccc77ccccccccc7ccccccccc00000000000000000000000000000000
444444444444f5f44f5f444455666655c7cc7ccc00000000ffffffffcccccccc7cc7cccccc7cc7ccccccccc7ccccccc700000000000000000000000000000000
444444444444ffff4f5f444477644677cccccccc00000000ffffffffcccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000
444444444444f5f4ffff444455644655cccccccc00000000ffffffffcccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000
444444444444f5f44f5f444455666655cccc77cc00000000ffffffffcccccccccccccccccccccccccc77ccccccccccc000000000000000000000000000000000
44444444444445444454444455555555ccccc77c00000000ffffffffccccccccccccccccc77cccccccc77ccccccccc7000000000000000000000000000000000
44444444444444444444444455555555cccc7cc700000000ffffffffcccccccccccccccc7cc7cccccc7cc7ccccccccc000000000000000000000000000000000
5444444444444445544444444444444500000000cccccccc00000000000000000000000000000000000000000000000000110000000220000000000000000000
5444444444444445544444444444444500000000ccc55ccc00000000000000000000000000000000000000000000000001b90000002f60000000000000000000
5445554444555445544444444444444500000000cc5445cc00000000000000000000000000000000000000000000000000bf0000000f60000000000000000000
6666666446666666544444444444444500000000c544445c0000000000000000000000000000000000000000000000000b500000000560000000000000000000
6666666006666666544444444444444500000000c544445c000000000000000000000000000000000000000000000000005f66600005f0000000000000000000
5445554444555445544444444444444500000000c544445c00000000000000000000000000000000000000000000000000100000000200000000000000000000
5444444444444445544444444444444500000000c544445c00000000000000000000000000000000000000000000000000f00000000f00000000000000000000
5444444444444445544444444444444500000000c544445c00000000000000000000000000000000000000000000000000500000000500000000000000000000
cccccccccccccccc444444445555555544444444c544445c44444444cccccccccccccccc00000000000000000000000044444444444444444000000000000000
cccccccccccccccc444444444444444444555544c544445c44444444cccccccccccccccc00000000000000000000000044444440000000000000000000000000
cccccccccccccccc4444444444444444445ff544c544445c44444444ccccccfccccfffcc00000000000000000000000044444440000000000000000000000000
ccccccc66ccccccc4444444444444444444f4444c544445c77777777ffcccfccccfcccfc00000000000000000000000044444440000000000000000000000000
ccccccc66ccccccc444444444444444445fff544c544445c44444444ccfcfccccfcccccf00000000000000000000000044444440000000000000000000000000
cccccccccccccccc444444444444444444444444c544445c44444444cccfccccfccccccc00000000000000000000000044444440000000000000000000000000
cccccccccccccccc444444444444444444444444c544445c44444444cccccccccccccccc00000000000000000000000044444400000000000000000000000000
cccccccccccccccc555555554444444444444444c544445c44444444cccccccccccccccc00000000000000000000000044444000000000000000000000000000
44444445544444445555555555555555ccccccc55ccccccc54444444444444450000000000000000000000000000000044444000000000000000000000000000
44444445544444445444444444444445cccccc5445ccccccc54444444444445c0000000000000000000000000000000044440000000000005500000000000000
44444445544444445444444444444445ccccc544445ccccccc544444444445cc0000000000000000000000000000000044440000000000055000000000000000
44444445544444445444444444444445cccc54444445ccccccc5444444445ccc0000000000000000000000000000000044400000000000555000000005550000
44444445544444445444444444444445ccc5444444445ccccccc54444445cccc0000000000000000000000000000000044400000000775555557000000555700
44444445544444445444444444444445cc544444444445ccccccc544445ccccc00000000000000000000000000000000444ccccccccc77777777cccc777777cc
44444445544444445444444444444445c54444444444445ccccccc5445cccccc0000000000000000000000000000000044cccccccccccccccccccccccccccccc
555555555555555554444444444444455444444444444445ccccccc55ccccccc0000000000000000000000000000000044cccccccccccccccccccccccccccccc
__gff__
1010101010101010101010000000000010101010101010101010100000000000000000000000000000001000000000000000000000000000000010100000000008080808080808080808080808080000080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000010220000000040000000000000000000000000004000000000000100000000404000000000000000000000000000000000000000000000000000000000000
__map__
c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7c7c7c7d5c7c7c7c7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7c7c7c7e5c7c7c7c7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7c7c7f4c0f5c7c7c7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7c7f4c0c0c0f5c7c7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7f4c0c0c0c0c0f5c7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7e0d0e6e6c3e6e6d1e1c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7e8c2c0c0c0c0c0c1e7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7e0d0c0c0c0c0c0d1e1c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7e0d2e6e6c3e6e6d3e1c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7e0d0c0c0c0c0c0d1e1c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7e0d2c0c0c0c0c0d3e1c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7e8c2c0c0c0c0c0c1e7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7e0f2e3e3e3e3e3f3e1c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7f6e2e2e2e2e2f7c7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
001a0000315502b55026550215501d5501955015550105500e5500e5500e5500e5500e5500d5500c5500b5500b5500a5500a55009550095500855008550075500655006550055500555004550015500000000000
000300001d05017050130500a0500e000130000a0000f000140001000020000150000d0000e0001a0001900019000180001600015000000000000000000000000000000000000000000000000000000000000000
001000000000032450107502945011750204500a75016450037500f45002750084500445001450014500145001440014400142001420044000140001400014000140001400014000140001400014000140001400
001b000034550325502915021150181500f1500b1501845016450205501f55025550114500f4500f45015550135500d55017550074500c550287501f7500f7500975005750047500275003550055503755000000
000700002a660236601b650136500963006630056100361002610016101b5001e500205001a7001870014700117000d7000a70008700057000370002700000000000000000000000000000000000000000000000
0010001c06750027500974007730017300673002730027400674001740017400874005750087500175005760097600a7600a75007740037300173001730047300a73002730027500475000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01024344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344

