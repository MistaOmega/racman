function FreezeMover(moby, still_moby)
	local trigger = Ratchetron:ReadMemory(GAME_PID, still_moby.pvars + 0xb0, 8)
	Ratchetron:WriteMemory(GAME_PID, moby.pvars + 0xb0, 8, trigger)
	moby.state = 1
end

function MoveGemlikThings()
	moby = Moby:findFirst(0xb6)

	local x = ratchet.x
	local y = ratchet.y
	local z = ratchet.z - 4.0
	local z_rot = ratchet.rotation_z + 1.5
	
	print("X: " .. x .. "\tY: " .. y .. "\tZ: " .. z .. "\tZRot: " .. z_rot)
	
	moby.x = 304.60836791992
	moby.y = 506.22927856445
	moby.z = 311.6533203125
	moby.rotation_z = -1.1160578727722
	moby.rotation_y = 0
	moby.rotation_x = 1.58
	moby.scale = 1.9
	
	local step_x = 388.14318847656 - 338.66586303711
	local step_y = 535.12243652344 - 511.99465942383

	local mobies_6a = Moby:findAll(0x6a)
	local mobies_68 = Moby:findAll(0x68)

	FreezeMover(mobies_6a[2], mobies_6a[1])
	FreezeMover(mobies_68[2], mobies_68[1])

	for i = 1, 2 do
		local offset = (i - 1) * 2

		moby = mobies_6a[i]
		moby.x = 338.66586303711 + step_x * offset
		moby.y = 511.99465942383 + step_y * offset
		moby.z = 313.5
		moby.rotation_z = -1.05
		moby.scale = 1.5

		moby = mobies_68[i]
		moby.x = 388.14318847656 + step_x * offset
		moby.y = 535.12243652344 + step_y * offset
		moby.z = 313.41269165039
		moby.rotation_z = -1.1
		moby.scale = 1.5
	end
end

function MoveRatchet()
	ratchet.x = 388.14318847656 + (388.14318847656 - 338.66586303711) * 2
	ratchet.y = 535.12243652344 + (535.12243652344 - 511.99465942383) * 2
	ratchet.z = 319.41269165039
end

function OnLoad()
	waiting_for_planet_load = false

	if game.planet == 0xd then  -- If on Gemlik
		MoveGemlikThings()
		MoveRatchet()
	else
		waiting_for_planet_load = true
		game:setFastLoads(true)
		game:loadPlanet(0xd)
	end
end

function OnTick(ticks)
	if waiting_for_planet_load then
		if game.state == 0 and ratchet.state == 0 then  -- If game state is player controllable, level must have finished loading
			MoveGemlikThings()
			MoveRatchet()
			
			waiting_for_planet_load = false
		end
	else
		if (ticks % 10) == 0 then  -- Do this every 10 ticks
			if moby.scale ~= 1.5 then  -- The thing must have moved back, prob after player died
				MoveGemlikThings()
			end
		end
	end
end

function OnUnload()

end