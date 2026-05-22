local function xyz(fx, fy, fz) return { x = fx, y = fy, z = fz } end
local c = core
local wormhole_portals = {} -- Armazena os portais colocados
-- Bloco do portal normal
c.register_node("warpdrive:wormhole", {
	description = "Wormhole Portal",
	tiles = { "wormhole.png" },
	light_source = 14,
	walkable = false,
	pointable = true,
	groups = { cracky = 1 },
	on_construct = function(pos)
		-- Adiciona o portal à lista
		table.insert(wormhole_portals, pos)
		if #wormhole_portals == 2 then c.chat_send_all "Os portais foram conectados!" end -- Se houver dois portais, conectá-los
		-- Efeito de partículas
		c.add_particlespawner({
			amount = 100,
			time = 0,
			minpos = vector.subtract(pos, 1),
			maxpos = vector.add(pos, 1),
			minvel = xyz(-1, 0, -1),
			maxvel = xyz(1, 1, 1),
			texture = "wormhole_particle.png",
			glow = 10
		})
	end,
	on_destruct = function(pos)
		for _, p in ipairs(wormhole_portals) do -- Remove o portal da lista ao ser destruído
			if vector.equals(p, pos) then table.remove(wormhole_portals, _) break end
		end
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if #wormhole_portals < 2 then c.chat_send_player(player:get_player_name(), "O portal ainda não está conectado!") return end
		-- Descobre qual portal é o outro
		local target_pos = wormhole_portals[1]
		if vector.equals(pos, wormhole_portals[1]) then target_pos = wormhole_portals[2] end
		-- Teletransporta o jogador
		player:set_pos(target_pos)
		c.chat_send_player(player:get_player_name(), "Você entrou no buraco de minhoca!")
		c.sound_play("wormhole_activate", { pos = pos, gain = 1.0, max_hear_distance = 20 }) -- Som de teleporte
	end,
})
