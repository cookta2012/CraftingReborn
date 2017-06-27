--[[ Copyright (c) Troy Cook AKA cookta2012 2017
 * Crafting Reborn
--]]

--local CRAFTINGREBORN_VERSION = "0.0.1"
--require("defines");
require('lib/events_lib')
require('stdlib/event/event')
require("stdlib/table")
local Game = require('stdlib/game')

Event.register({defines.events_lib.on_player_starts_crafting}, function(event)
  local stringBuilder = ""
  for x,v in pairs(event.player.crafting_queue) do
    stringBuilder = stringBuilder .. " x:"..x.." | ";
    for e,r in pairs(event.player.crafting_queue[x]) do
      stringBuilder = stringBuilder .." e:"..e.." r:"..r.." | ";
    end;
  end;
  event.player.surface.print(stringBuilder);
  local stringBuilder = "";
  for z,x in pairs(event.items_consumed) do
    stringBuilder = stringBuilder .. z .. ": " .. x .." | ";
  end;
  event.player.surface.print(stringBuilder);
end)
