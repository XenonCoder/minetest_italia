local serverguide_Book_title="The Italian Minetest server guide"

local serverguide_Tab_Text_1="Server info\nCiao e benvenuto sul server italiano di Minetest\nDigita /guide per aprire questa guida \nIl server è in sviluppo continuo, partecipa anche tu segnalando bug, problemi \no dimostrando la tua bravura nel costruire fantastiche strutture.\nSe vuoi contattarci ci trovi nella sezione italiana del forum ufficiale di minetest.\nResta con noi e insieme potremmo creare un mondo virtuale senza paragoni."
local serverguide_Tab_Text_2="Regole del Server \nLe regole del server sono semplici, basta un pò di buon senso:\nNon chiedere privilegi o diritti amministrativi\nNon usare un linguaggio o nomi offensivi\nNon invadere costruzioni altrui a 365 gradi (griefing)\nNon rubare o usare nomi di altri utenti\nNon imbrogliare (hacking)\nNon importunare inutilmente utenti e admin\nNon spammare nella chat e non pubblicizzare altri server."
local serverguide_Tab_Text_3="Staff (moderatori o admin)\nAdmin:\n CarlBishop - pandaro - Hamlet\nModeratori:\nHALINA - ciccio - Blockman"
local serverguide_Tab_Text_4="Comandi:\nImposta il punto di spawn con /sethome usa /home per tornare al punto di spawn \nUsa /status per l'elenco utenti online\nUsa /msg nomeutente messaggio per inviare un messaggio privato"
local serverguide_Tab_Text_5="Aiuto\nContatta un admin o un moderatore solo se\n incontri un problema che non riesci a risolvere da solo\nPer scendere dal carrello click destro (quello che usi per piazzare blocchi).\nPer scendere in corsa senza perdere il carrello o per rimuovere il carrello usa shift tasto sinistro"

local serverguide_Tab_1="Server"
local serverguide_Tab_2="Regole"
local serverguide_Tab_3="Staff"
local serverguide_Tab_4="Comandi"
local serverguide_Tab_5="Aiuto"

local function serverguide_guide(user,text_to_show)
local text=""
if text_to_show==1 then text=serverguide_Tab_Text_1 end
if text_to_show==2 then text=serverguide_Tab_Text_2 end
if text_to_show==3 then text=serverguide_Tab_Text_3 end
if text_to_show==4 then text=serverguide_Tab_Text_4 end
if text_to_show==5 then text=serverguide_Tab_Text_5 end

local form="size[8.5,9]" ..default.gui_bg..default.gui_bg_img..
	"button[0,0;1.5,1;tab1;" .. serverguide_Tab_1 .. "]" ..
	"button[1.5,0;1.5,1;tab2;" .. serverguide_Tab_2 .. "]" ..
	"button[3,0;1.5,1;tab3;" .. serverguide_Tab_3 .. "]" ..
	"button[4.5,0;1.5,1;tab4;" .. serverguide_Tab_4 .. "]" ..
	"button[6,0;1.5,1;tab5;" .. serverguide_Tab_5 .. "]" ..
	"button_exit[7.5,0; 1,1;tab6;X]" ..
	"label[0,1;"..text .."]"
minetest.show_formspec(user:get_player_name(), "serverguide",form)
end

minetest.register_on_player_receive_fields(function(player, form, pressed)
	if form=="serverguide" then
	if pressed.tab1 then serverguide_guide(player,1) end
	if pressed.tab2 then serverguide_guide(player,2) end
	if pressed.tab3 then serverguide_guide(player,3) end
	if pressed.tab4 then serverguide_guide(player,4) end
	if pressed.tab5 then serverguide_guide(player,5) end
	end
end)


minetest.register_tool("serverguide:book", {
	description = serverguide_Book_title,
	inventory_image = "default_book.png",
	on_use = function(itemstack, user, pointed_thing)
	serverguide_guide(user,1)
	return itemstack
	end,
on_place = function(itemstack, placer, pointed_thing)
	local pos = pointed_thing.under
	local node = minetest.get_node_or_nil(pos)
	local def = node and minetest.registered_nodes[node.name]
	if not def or not def.buildable_to then
		pos = pointed_thing.above
		node = minetest.get_node_or_nil(pos)
		def = node and minetest.registered_nodes[node.name]
		if not def or not def.buildable_to then return itemstack end
	end
	if minetest.is_protected(pos, placer:get_player_name()) then return itemstack end
	local fdir = minetest.dir_to_facedir(placer:get_look_dir())
	minetest.set_node(pos, {name = "serverguide:guide",param2 = fdir,})
	itemstack:take_item()
	return itemstack
end
})
minetest.register_alias("guide", "serverguide:book")
minetest.register_craft({output = "serverguide:book",recipe = {{"default:stick","default:stick"},}})


minetest.register_node("serverguide:guide", {
	description = serverguide_Book_title,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	drop="serverguide:book",
	node_box = {
		type = "fixed",
		fixed = {0.35,-0.3,0.45,-0.35,-0.5,-0.45},
	},
	tiles = {
	"default_gold_block.png^default_book.png",
	"default_gold_block.png",
	"default_gold_block.png",
	"default_gold_block.png",
	"default_gold_block.png",
	"default_gold_block.png",},
	groups = {cracky=1,oddly_breakable_by_hand=3},
	sounds=default.node_sound_wood_defaults(),
on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", serverguide_Book_title)
end,
on_rightclick = function(pos, node, clicker)
	serverguide_guide(clicker,1)
end

})

minetest.register_on_newplayer(function(player)
player:get_inventory():add_item("main", "serverguide:book")
end)

minetest.register_chatcommand("guide", {
	params = "",
	description = serverguide_Book_title,
	func = function(name, param)
		serverguide_guide(minetest.get_player_by_name(name),1)
		return true
	end
})
