--[[

   Death Messages init.lua

   Copyright 2018 Hamlet <h4mlet@riseup.net>
   Copyright 2016 EvergreenTree, bigfoot547, maikerumine et al.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.

]]--


--
-- Intllib support
--

local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")


--
-- Constants
--

local title = "Death Messages"
local version = "0.2.0"
local mod_name = "death_messages"
local death_sound = "player_death"
local pronoun = S("Your character")
local word_color = "(c@#ffffff)"
local nickname_color = "(c@#00CED1)"
local weapon_color = "(c@#FF8C00)"
local message_color_1 = "(c@#ff0000)"
local message_color_2 = "(c@#00bbff)"


--
-- Variables
--

local mob_id = ""
local mob_name = ""


--
-- Setting loader
--

dofile(MP.."/settings.txt")


--
-- Messages' table
--

local messages = {}

-- Drowning death messages
messages.water = {
	S(" drowned."),
	S(" ran out of air."),
	S(" failed at swimming lessons."),
	S(" tried to impersonate an anchor."),
	S(" forgot he wasn't a fish."),
	S(" blew one too many bubbles.")
}

-- Burning death messages
messages.fire = {
	S(" burned to a crisp."),
	S(" got a little too warm."),
	S(" got too close to the camp fire."),
	S(" just got roasted, hotdog style."),
	S(" got burned up. More light that way.")
}

-- Lava death messages
messages.lava = {
	S(" melted into a ball of fire."),
	S(" thought lava was cool."),
	S(" melted into a ball of fire."),
	S(" couldn't resist that warm glow of lava."),
	S(" dug straight down."),
	S(" went into the lava curtain."),
	S(" thought it was a hottub."),
	S(" is melted."),
	S(" didn't know lava was hot.")
}

messages.toxic = {
	S(" melted into a ball of radioactivity."),
	S(" thought chemical waste was cool."),
	S(" melted into a jittering pile of flesh."),
	S(" couldn't resist that warm glow of toxic water."),
	S(" dug straight down."),
	S(" went into the toxic curtain."),
	S(" thought it was a toxic-tub."),
	S(" is radioactive."),
	S(" didn't know toxic water was radioactive.")
}

-- Other death messages
messages.other = {
	S(" died."),
	S(" did something fatal."),
	S(" gave up on life."),
	S(" is somewhat dead now."),
	S(" passed out -permanently."),
	S(" kinda screwed up."),
	S(" couldn't fight very well."),
	S(" got 0wn3d."),
	S(" got SMOKED."),
	S(" got hurted by Oerkki."),
	S(" got blowed up.")
}

-- MOB After Messages
messages.mobs = {
	S(" and was eaten with a gurgling growl."),
	S(" then was cooked for dinner."),
	S(" then went to the supermarket."),
	S(" badly."),
	S(" terribly."),
	S(" horribly."),
	S(" in a haphazard way."),
	S(" that sparkles in the twilight with that evil grin."),
	S(" and now is covered by blood."),
	S(" so swiftly, that not even Chuck Norris could block."),
	S(" for talking smack about Oerkkii's mother."),
	S(" and grimmaced wryly.")
}

-- PVP Messages
messages.pvp = {
	S(" fisted"),
	S(" sliced up"),
	S(" rekt"),
	S(" punched"),
	S(" hacked"),
	S(" skewered"),
	S(" blasted"),
	S(" tickled"),
	S(" gotten"),
	S(" sword checked"),
	S(" turned into a jittering pile of flesh"),
	S(" buried"),
	S(" served"),
	S(" poked"),
	S(" attacked viciously"),
	S(" busted up"),
	S(" schooled"),
	S(" told"),
	S(" learned"),
	S(" chopped up"),
	S(" deader than ded ded ded"),
	S(" CHOSEN to be the ONE"),
	S(" all kinds of messed up"),
	S(" smoked like a Newport"),
	S(" hurted"),
	S(" ballistic-ed"),
	S(" jostled"),
	S(" messed-da-frig-up"),
	S(" lanced"),
	S(" shot"),
	S(" knocked da heck out"),
	S(" pooped on")
}

-- Player Messages
messages.player = {
	S(" for talking smack about thier mother."),
	S(" for cheating at Tic-Tac-Toe."),
	S(" for being a stinky poop butt."),
	S(" for letting Baggins grief."),
	S(" because it felt like the right thing to do."),
	S(" for spilling milk."),
	S(" for wearing a n00b skin."),
	S(" for not being good at PVP."),
	S(" because they are a n00b."),
	S(" for reasons uncertain."),
	S(" for using a tablet."),
	S(" with the quickness."),
	S(" while texting.")
}


--
-- Random message function
--

function get_message(mtype)
	if RANDOM_MESSAGES then
		return messages[mtype][math.random(1, #messages[mtype])]
	else
		return messages[1] -- 1 is the index for the non-random message
	end
end


--
-- Events
--

-- Character's death by accident (i.e. water, fire, lava, toxic)
minetest.register_on_dieplayer(function(player)

	local player_name = player:get_player_name()
	local node = minetest.registered_nodes[minetest.get_node(player:getpos()).name]
	local pos = player:getpos()
	-- local death = {x=0, y=23, z=-1.5}
	minetest.sound_play("player_death", {pos = pos, gain = 1})
	-- pos.x = math.floor(pos.x + 0.5)
	-- pos.y = math.floor(pos.y + 0.5)
	-- pos.z = math.floor(pos.z + 0.5)
	local param2 = minetest.dir_to_facedir(player:get_look_dir())
	local player_name = player:get_player_name()
	if minetest.is_singleplayer() then
		player_name = pronoun
	end

	-- Death by lava
	if node.name == "default:lava_source" then
		minetest.chat_send_all(
		string.char(0x1b)..nickname_color..player_name..
		string.char(0x1b)..message_color_1..get_message("lava"))
		--player:setpos(death)

	elseif node.name == "default:lava_flowing"  then
		minetest.chat_send_all(
		string.char(0x1b)..nickname_color..player_name..
		string.char(0x1b)..message_color_1..get_message("lava"))
		--player:setpos(death)

	-- Death by drowning
	elseif player:get_breath() == 0 then
		minetest.chat_send_all(
		string.char(0x1b)..nickname_color..player_name..
		string.char(0x1b)..message_color_1..get_message("water"))
		--player:setpos(death)

	-- Death by fire
	elseif node.name == "fire:basic_flame" then
		minetest.chat_send_all(
		string.char(0x1b)..nickname_color..player_name..
		string.char(0x1b)..message_color_1..get_message("fire"))
		--player:setpos(death)

	-- Death by Toxic water
	elseif node.name == "es:toxic_water_source" then
		minetest.chat_send_all(
		string.char(0x1b)..nickname_color..player_name..
		string.char(0x1b)..message_color_1..get_message("toxic"))
		--player:setpos(death)

	elseif node.name == "es:toxic_water_flowing" then
		minetest.chat_send_all(
		string.char(0x1b)..nickname_color..player_name..
		string.char(0x1b)..message_color_1..get_message("toxic"))
		--player:setpos(death)

	elseif node.name == "groups:radioactive" then
		minetest.chat_send_all(
		string.char(0x1b)..nickname_color..player_name..
		string.char(0x1b)..message_color_1..get_message("toxic"))
		--player:setpos(death)

	-- Death by something else
	else
		--minetest.chat_send_all(
		--string.char(0x1b).."(c@#ffffff)"..player_name..
		--string.char(0x1b)..message_color_1..get_message("other"))
		--toospammy
		--minetest.after(0.5, function(holding)
			--player:setpos(death)  --gamebreaker?
		--end)
	end

	--minetest.chat_send_all(string.char(0x1b).."(c@#000000)"..
	--"[DEATH COORDINATES] "..string.char(0x1b).."(c@#ffffff)"..
	--player_name..string.char(0x1b).."(c@#000000)"..
	--" left a corpse full of diamonds here: "..
	--minetest.pos_to_string(pos) .. string.char(0x1b).."(c@#aaaaaa)"
	--.." Come and get them!")
	--player:setpos(death)
	--minetest.sound_play("pacmine_death", { gain = 0.35})  NOPE!!!

end)


-- Character's death by killer mob or PvP

-- get tool/item when hitting get_name() returns item name
-- (e.g. "default:stone")

minetest.register_on_punchplayer(function(player, hitter)

	local pos = player:getpos()
	-- local death = {x=0, y=23, z=-1.5}

	if not (player or hitter) then
		return false
	end

	if not hitter:get_player_name() == "" then
		return false
	end

	minetest.after(0, function(holding)

		if player:get_hp() == 0 and hitter:get_player_name() ~= ""
		and holding == hitter:get_wielded_item() ~= "" then

			local holding = hitter:get_wielded_item()

				if holding:to_string() ~= "" then

				local weap = holding:get_name(holding:get_name())

					if holding then

						minetest.chat_send_all(
							string.char(0x1b)..nickname_color..
											player:get_player_name()..
							string.char(0x1b)..message_color_1..
												S(" was")..
							string.char(0x1b)..message_color_1..
												get_message("pvp")..
							string.char(0x1b)..message_color_1..
												S(" by ")..
							string.char(0x1b)..nickname_color..
											hitter:get_player_name()..
							string.char(0x1b)..word_color..
												S(" with ")..
							string.char(0x1b)..weapon_color..weap..
							string.char(0x1b)..message_color_2..
												get_message("player")
						) --TODO: make custom mob death messages

					end
				end

				if player=="" or hitter=="" then
					return
				end -- no killers/victims
					return true


		elseif hitter:get_player_name() == "" and player:get_hp() == 0 then

			mob_id = hitter:get_luaentity().name
			mob_name = mob_id

			--
			-- Default tools' stringID to name conversion
			--

			-- Picks

			if mob_id == "default:pick_wood"
				then mob_name = S("a Wooden Pick")

			elseif mob_id == "default:pick_stone"
				then mob_name = S("a Stone Pick")

			elseif mob_id == "default:pick_steel"
				then mob_name = S("a Steel Pick")

			elseif mob_id == "default:pick_bronze"
				then mob_name = S("a Bronze Pick")

			elseif mob_id == "default:pick_mese"
				then mob_name = S("a Mese Pick")

			elseif mob_id == "default:pick_diamond"
				then mob_name = S("a Diamond Pick")

			-- Shovels

			elseif mob_id == "default:shovel_wood"
				then mob_name = S("a Wooden Shovel")

			elseif mob_id == "default:shovel_stone"
				then mob_name = S("a Stone Shovel")

			elseif mob_id == "default:shovel_steel"
				then mob_name = S("a Steel Shovel")

			elseif mob_id == "default:shovel_bronze"
				then mob_name = S("a Bronze Shovel")

			elseif mob_id == "default:shovel_mese"
				then mob_name = S("a Mese Shovel")

			elseif mob_id == "default:shovel_diamond"
				then mob_name = S("a Diamond Shovel")

			-- Axes

			elseif mob_id == "default:axe_wood"
				then mob_name = S("a Wooden Axe")

			elseif mob_id == "default:axe_stone"
				then mob_name = S("a Stone Axe")

			elseif mob_id == "default:axe_steel"
				then mob_name = S("a Steel Axe")

			elseif mob_id == "default:axe_bronze"
				then mob_name = S("a Bronze Axe")

			elseif mob_id == "default:axe_mese"
				then mob_name = S("a Mese Axe")

			elseif mob_id == "default:axe_diamond"
				then mob_name = S("a Diamon Axe")

			-- Swords

			elseif mob_id == "default:sword_wood"
				then mob_name = S("a Wooden Sword")

			elseif mob_id == "default:sword_stone"
				then mob_name = S("a Stone Sword")

			elseif mob_id == "default:sword_steel"
				then mob_name = S("a Steel Sword")

			elseif mob_id == "default:sword_bronze"
				then mob_name = S("a Bronze Sword")

			elseif mob_id == "default:sword_mese"
				then mob_name = S("a Mese Sword")

			elseif mob_id == "default:sword_diamond"
				then mob_name = S("a Diamond Sword")

			end


			--
			-- Support for Animal Mobs
			--

			if minetest.get_modpath("mobs_animal") then

				if mob_id == "mobs_animal:cow"
					then mob_name = S("a cow")

				elseif mob_id == "mobs_animal:pumba"
					then mob_name = S("a warthog")

				end

			end


			--
			-- Support for Monster Mobs
			--

			if minetest.get_modpath("mobs_monster") then

				if mob_id == "mobs_monster:dungeon_master"
					then mob_name = S("a dungeon master")

				elseif mob_id == "mobs_monster:sand_monster"
					then mob_name = S("a sand monster")

				elseif mob_id == "mobs_monster:oerkki"
					then mob_name = S("an Oerkki")

				elseif mob_id == "mobs_monster:stone_monster"
					then mob_name = S("a stone monster")

				elseif mob_id == "mobs_monster:lava_flan"
					then mob_name = S("a lava flan")

				elseif mob_id == "mobs_monster:spider"
					then mob_name = S("a spider")

				elseif mob_id == "mobs_monster:mese_monster"
					then mob_name = S("a mese monster")

				elseif mob_id == "mobs_monster:tree_monster"
					then mob_name = S("a tree monster")

				elseif mob_id == "mobs_monster:dirt_monster"
					then mob_name = S("a dirt monster")

				end

			end


			--
			-- Support for Monster Mobs
			--

			if minetest.get_modpath("mobs_goblins") then

				if mob_id == "mobs_goblins:goblin_cobble"
					then mob_name = S("a goblin")

				elseif mob_id == "mobs_goblins:goblin_digger"
					then mob_name = S("a goblin")

				elseif mob_id == "mobs_goblins:goblin_coal"
					then mob_name = S("a goblin")

				elseif mob_id == "mobs_goblins:goblin_iron"
					then mob_name = S("a goblin")

				elseif mob_id == "mobs_goblins:goblin_copper"
					then mob_name = S("a goblin")

				elseif mob_id == "mobs_goblins:goblin_gold"
					then mob_name = S("a goblin")

				elseif mob_id == "mobs_goblins:goblin_diamond"
					then mob_name = S("a goblin")

				elseif mob_id == "mobs_goblins:goblin_king"
					then mob_name = S("a goblin king")

				end

			end


			--
			-- Support for Mobs Crocs
			--

			if minetest.get_modpath("mobs_crocs") then

				if mob_id == "mobs_crocs:crocodile"
					then mob_name = S("a crocodile")

				elseif mob_id == "mobs_crocs:crocodile_float"
					then mob_name = S("a crocodile")

				elseif mob_id == "mobs_crocs:crocodile_swim"
					then mob_name = S("a crocodile")
				
				end
			
			end


			--
			-- Support for Mobs Sharks
			--

			if minetest.get_modpath("mobs_sharks") then
			
				if mob_id == "mobs_sharks:shark_lg"
					then mob_name = S("a large shark")

				elseif mob_id == "mobs_sharks:shark_md"
					then mob_name = S("a medium shark")

				elseif mob_id == "mobs_sharks:shark_sm"
					then mob_name = S("a small shark")

				end
			end


			minetest.chat_send_all(
				string.char(0x1b)..nickname_color..
									player:get_player_name()..
				string.char(0x1b)..message_color_1..S(" was")..
				string.char(0x1b)..message_color_1..get_message("pvp")..
				string.char(0x1b)..message_color_1..S(" by ")..

				--string.char(0x1b)..weapon_color
				-- ..hitter:get_luaentity().name..
				--too many mobs add to crash

				string.char(0x1b)..weapon_color..mob_name..
				--too many mobs add to crash

				string.char(0x1b)..message_color_2..get_message("mobs")
			) --TODO: make custom mob death messages

		if player=="" or hitter=="" or hitter=="*" then
			return end -- no mob killers/victims

		else
			return false
		end

	end)

end)
