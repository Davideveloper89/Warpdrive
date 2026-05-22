local function xyz(fx, fy, fz) return { x = fx, y = fy, z = fz } end
local c = core
local wormhole_portals = {} -- Armazena os portais colocados
-- Bloco do portal normal
c.register_node("nh_nodes:wormhole", {
	description = "Wormhole Portal",
	drawtype = "nodebox",
	tiles = {
		"wormhole.png",   -- topo/baixo
		"wormhole.png", -- Se quiser, use aqui uma imagem de animação própria, para frente/trás do nodebox (efeito portal)
	},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,       -- jogador atravessa
	pointable = true,
	node_box = {type = "fixed", fixed = {-0.5, -0.5, -0.02, 0.5, 0.5, 0.02},}, -- plano fino
	selection_box = {type = "fixed", fixed = {-0.5, -0.5, -0.02, 0.5, 0.5, 0.02},},
	light_source = 14,
	walkable = false,
	pointable = true,
	groups = {cracky = 1},
	on_construct = function(pos)
		-- Adiciona o portal à lista
		table.insert(wormhole_portals, pos)
		if #wormhole_portals == 2 then c.chat_send_all("Os portais foram conectados!") end -- Se houver dois portais, conectá-los
		-- Efeito de partículas
		c.add_particlespawner({
			amount = 50,
			time = 0,
			minpos = vector.subtract(pos, 0.5),
			maxpos = vector.add(pos, 0.5),
			minvel = xyz(-0.5, -0.5, -0.5),
			maxvel = xyz(0.5, 0.5, 0.5),
			minsize = 0.5,
        		maxsize = 1,
			texture = "spark_particle.png^[colorize:#000000:255", -- opacidade completa de pintura sobre textura: 255 - hexa pra azul: #028dde
			glow = 10
		})
	end,
	on_destruct = function(pos)
		for _, p in ipairs(wormhole_portals) do -- Remove o portal da lista ao ser destruído
			if vector.equals(p, pos) then
				table.remove(wormhole_portals, _)
				break
			end
		end
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if #wormhole_portals < 2 then
			c.chat_send_player(player:get_player_name(), "O portal ainda não está conectado!")
			return
		end
		-- Descobre qual portal é o outro
		local target_pos = wormhole_portals[1]
		if vector.equals(pos, wormhole_portals[1]) then target_pos = wormhole_portals[2] end
		-- Teletransporta o jogador
		player:set_pos(target_pos)
		c.chat_send_player(player:get_player_name(), "Você entrou no buraco de minhoca!")
		c.sound_play("wormhole_activate", { pos = pos, gain = 1.0, max_hear_distance = 20 }) -- Som de teleporte
	end,
})
