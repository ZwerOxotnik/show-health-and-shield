--[[
Copyright (C) 2018-2019 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
Author: ZwerOxotnik
]]--

local module = {}
local variants = require("show_hp_and_shield/variants/list")

local function show_player_magic_UI(player)
	for _, target in pairs(game.connected_players) do
		local player_settings = settings.get_player_settings(target)
		variants[player_settings["shas_player_mana_mode"].value].show_mana(player, target)
		variants[player_settings["shas_player_spirit_mode"].value].show_spirit(player, target)
	end
end

local function check_characters()
	for _, player in pairs(game.connected_players) do
		local character = player.character
		if character and character.health ~= nil and not character.vehicle then
			show_player_magic_UI(player)
		end
	end
end

local function disable_spell_pack_UI()
	local interface_name = "spell-pack"

	if not (remote.interfaces[interface_name] and remote.interfaces[interface_name]["getstats"]) then
		module.events.on_tick = function() end
		return
	else
		-- WIP
		remote.call("spell-pack", "togglebars", "show-health-and-shield", false)
	end
end

local function check_spell_pack_mod()
	local interface_name = "spell-pack"

	if not (remote.interfaces[interface_name] and remote.interfaces[interface_name]["getstats"]) then
		module.events.on_tick = function() end
		return
	else
		-- WIP
		remote.call("spell-pack", "togglebars", "show-health-and-shield", false)
	end
end

module.on_init = disable_spell_pack_UI
module.on_load = check_spell_pack_mod

module.events = {
	on_tick = check_characters
}

return module
