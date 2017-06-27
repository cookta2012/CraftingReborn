--- A defines module for retrieving colors by name
-- Extends the Factorio defines table
-- @usage require('stdlib/defines/custom_events')
Event = require('stdlib/event/event');
require("lib/events_data");

defines.events_lib = {
  pre_on_player_starts_crafting = script.generate_event_name(),
  on_player_starts_crafting = script.generate_event_name(),
  on_player_stops_crafting = script.generate_event_name(),
  on_player_is_crafting = script.generate_event_name();
};

-- init data storage for custom_events
Event.register({defines.events.on_player_joined_game}, function(event)
  update_previous(game.players[event.player_index]);
end);

-- define on_player_is_crafting
Event.register({defines.events.on_tick}, function (event)
  for index,player in pairs(game.players) do  --loop through all players on the server
    if is_crafting(player) then
      local tEvent = {}
      tEvent.tick = event.tick;
      tEvent.name = "on_player_is_crafting"
      tEvent.player = player;
      script.raise_event(defines.events_lib.on_player_is_crafting,tEvent);
    end
    if get_previous_count(player) > 0 and not is_crafting(player) then
      tEvent.tick = event.tick;
      tEvent.name = "on_player_stops_crafting"
      tEvent.player = player;
      script.raise_event(defines.events_lib.on_player_stops_crafting,tEvent);
    end
    update_previous(player);
  end
end);

-- define on_player_starts_crafting
Event.register({defines.events_lib.on_player_is_crafting}, function (event)
  if get_previous_count(event.player) < #event.player.crafting_queue then
    tEvent = {};
    tEvent.tick = event.tick;
    tEvent.name = "on_player_starts_crafting"
    tEvent.player = event.player;
    if event.player.character.active then
      script.raise_event(defines.events_lib.pre_on_player_starts_crafting,tEvent);
    end;
  end;
  --event.player.surface.print("crafting....");
  return;
end);


Event.register({defines.events_lib.pre_on_player_starts_crafting}, function (event)
  event.player.character.active = false;
  local curRecipe = get_current_recipe(event.player);
  halt_newest_crafting(event.player);
  take_inventory_snapshot(event.player);
  event.player.begin_crafting{count=curRecipe["count"],recipe=curRecipe["recipe"],silent=true};
  tEvent.name = "on_player_starts_crafting";
  tEvent.player = event.player;
  tEvent.current_recipe = curRecipe;
  tEvent.items_consumed = get_inventory_difference(event.player);
  event.player.character.active = true;
  --event.player.surface.print("crafting....")
  script.raise_event(defines.events_lib.on_player_starts_crafting,tEvent);
  return;
end);
