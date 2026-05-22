-- Armazena os portais colocados
local wormhole_portals = {}

-- Bloco do portal normal
minetest.register_node("warpdrive:wormhole", {
    description = "Wormhole Portal",
    tiles = {"wormhole.png"},
    light_source = 14,
    walkable = false,
    pointable = true,
    groups = {cracky = 1},

    on_construct = function(pos)
        -- Adiciona o portal à lista
        table.insert(wormhole_portals, pos)

        -- Se houver dois portais, conectá-los
        if #wormhole_portals == 2 then
            minetest.chat_send_all("Os portais foram conectados!")
        end

        -- Efeito de partículas
        minetest.add_particlespawner({
            amount = 100,
            time = 0,
            minpos = vector.subtract(pos, 1),
            maxpos = vector.add(pos, 1),
            minvel = {x = -1, y = 0, z = -1},
            maxvel = {x = 1, y = 1, z = 1},
            texture = "wormhole_particle.png",
            glow = 10
        })
    end,

    on_destruct = function(pos)
        -- Remove o portal da lista ao ser destruído
        for i, p in ipairs(wormhole_portals) do
            if vector.equals(p, pos) then
                table.remove(wormhole_portals, i)
                break
            end
        end
    end,

    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        if #wormhole_portals < 2 then
            minetest.chat_send_player(player:get_player_name(), "O portal ainda não está conectado!")
            return
        end

        -- Descobre qual portal é o outro
        local target_pos = wormhole_portals[1]
        if vector.equals(pos, wormhole_portals[1]) then
            target_pos = wormhole_portals[2]
        end

        -- Teletransporta o jogador
        player:set_pos(target_pos)
        minetest.chat_send_player(player:get_player_name(), "Você entrou no buraco de minhoca!")

        -- Som de teleporte
        minetest.sound_play("wormhole_activate", {pos = pos, gain = 1.0, max_hear_distance = 20})
    end,
})

