--
-- Custom Sounds
--
function default.node_sound_metal_defaults(table)
	table = table or {}
	table.footstep = table.footstep or {name="default_hard_footstep", gain=0.4}
	table.dig = table.dig or {name="metal_bang", gain=0.6}
	table.dug = table.dug or {name="default_dug_node", gain=1.0}

	default.node_sound_defaults(table)
	return table
end

--
-- Nodeboxes
--

local trash_can_nodebox = {
	{-0.375000,-0.500000,0.312500,0.375000,0.500000,0.375000},
	{0.312500,-0.500000,-0.375000,0.375000,0.500000,0.375000},
	{-0.375000,-0.500000,-0.375000,0.375000,0.500000,-0.312500},
	{-0.375000,-0.500000,-0.375000,-0.312500,0.500000,0.375000},
	{-0.312500,-0.500000,-0.312500,0.312500,-0.437500,0.312500},
}

local dumpster_selectbox = {-0.4375, -0.5, -0.9375, 1.4375, 0.75, 0.4375}

local dumpster_nodebox = {
	-- Top
	{-0.4375, 0.75, -0.9375, 1.4375, 0.875, 0.4375},
	-- Border
	{-0.5, 0.625 , -1.0, 1.5, 0.75, 0.5},
	-- Main Body
	{-0.4375, -0.4375, -0.9375, 1.4375, 0.625, 0.4375},
	-- Feet
	{-0.4375, -0.5, -0.9375, -0.1875, -0.4375, -0.6875},
	{1.1875, -0.5, -0.9375, 1.4375, -0.4375, -0.6875},
	{-0.4375, -0.5, 0.1875, -0.1875, -0.4375, 0.4375},
	{1.1875, -0.5, 0.1875, 1.4375, -0.4375, 0.4375},
}

--
-- Node Registration
--

-- Normal Trash Can
minetest.register_node("trash_can:trash_can_wooden",{
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
	tiles = {"trash_can_wooden_top.png", "trash_can_wooden_top.png", "trash_can_wooden.png"},
	description = "Wooden Trash Can",
	drawtype="nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = trash_can_nodebox
	},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
			"size[8,9]"..
			"button[0,0;2,1;empty;Empty Trash]"..
			"list[current_name;main;3,1;2,3;]"..
			"list[current_player;main;0,5;8,4;]"
		)
		meta:set_string("infotext", "Trash Can")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
				return inv:is_empty("main")
		end,
		on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
			" moves stuff in trash can at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
			" moves stuff to trash can at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
			" takes stuff from trash can at "..minetest.pos_to_string(pos))
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.empty then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			for i = 1, inv:get_size("main") do
				inv:set_stack("main", i, nil)
			end
			minetest.sound_play("trash", {to_player=sender:get_player_name(), gain = 1.0})
		end
	end,
})

-- Dumpster
minetest.register_node("trash_can:dumpster", {
	description = "Dumpster",
	paramtype = "light",
	paramtype2 = "facedir",
	inventory_image = "dumpster_wield.png",
	tiles = {
		"dumpster_top.png",
		"dumpster_bottom.png",
		"dumpster_side.png",
		"dumpster_side.png",
		"dumpster_side.png",
		"dumpster_side.png"
	},
	drawtype = "nodebox",
	selection_box = {
		type = "fixed",
		fixed = dumpster_selectbox,
	},
	node_box = {
		type = "fixed",
		fixed = dumpster_nodebox,
	},
	groups = {
		cracky = 3,
		oddly_breakable_by_hand = 1,
	},

	sounds = default.node_sound_metal_defaults(),

	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
			"size[8,9]"..
			"button[0,0;2,1;empty;Empty Trash]"..
			"list[current_name;main;1,1;6,3;]"..
			"list[current_player;main;0,5;8,4;]"
		)
		meta:set_string("infotext", "Dumpster")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
			" moves stuff in dumpster at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
			" moves stuff to dumpster at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
			" takes stuff from dumpster at "..minetest.pos_to_string(pos))
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.empty then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			for i = 1, inv:get_size("main") do
				inv:set_stack("main", i, nil)
			end
			minetest.sound_play("trash", {to_player=sender:get_player_name(), gain = 2.0})
		end
	end,
})

--
-- Crafting
--

-- Normal Trash Can
minetest.register_craft({
	output = 'trash_can:trash_can_wooden',
	recipe = {
		{'group:wood', '', 'group:wood'},
		{'group:wood', '', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

-- Dumpster
minetest.register_craft({
	output = 'trash_can:dumpster',
	recipe = {
		{'default:coalblock', 'default:coalblock', 'default:coalblock'},
		{'default:steel_ingot', 'dye:dark_green', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})

--
-- Misc
--

-- Remove any items thrown in trash can.
local old_on_step = minetest.registered_entities["__builtin:item"].on_step
minetest.registered_entities["__builtin:item"].on_step = function(self, dtime)
	if minetest.get_node(self.object:getpos()).name == "trash_can:trash_can_wooden" then
		self.object:remove()
		return
	end
	old_on_step(self, dtime)
end
