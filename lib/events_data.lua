event_data = {};
event_data.players = {};

function is_crafting(player)
  return not not player.crafting_queue;
end;

function get_current_recipe(player)
  local current = {};
  current["recipe"] = player.crafting_queue[#player.crafting_queue]["recipe"];
  current["count"] = player.crafting_queue[#player.crafting_queue]["count"];
  return current;
end;

function halt_newest_crafting(player)
  --local
  player.cancel_crafting{index=#player.crafting_queue,count=player.crafting_queue[#player.crafting_queue]["count"]};
end;

function update_previous (player)
  event_data.players[player.index] = {};
  if is_crafting(player) then
    event_data.players[player.index].previous_crafting_queue_size = #game.players[player.index].crafting_queue;
  else
    event_data.players[player.index].previous_crafting_queue_size = 0;
  end;
end;
-- game.print(game.player.get_inventory(defines.inventory.player_main).get_contents())

function get_previous_count (player)
  return event_data.players[player.index].previous_crafting_queue_size;
end;

function take_inventory_snapshot(player)
  event_data.players[player.index].previous_inventory_contents = game.players[player.index].get_inventory(defines.inventory.player_main).get_contents()
end;

function get_inventory_snapshot(player)
  return event_data.players[player.index].previous_inventory_contents;
end;

local function get_inventory_contents(player)
  return game.players[player.index].get_inventory(defines.inventory.player_main).get_contents()
end

local function is_item_in_player(item, player)
  local found = false;
  for current_item_name, _ in pairs(get_inventory_contents(player)) do
    if item == current_item_name then
      found = true;
    end;
  end;
  return found;
end;


function get_inventory_difference(player)
  difference = {};
  -- get the previous inventory and subtract the current inventory
  for pre_current_item_name, pre_current_item_amount in pairs(get_inventory_snapshot(player)) do
    if not is_item_in_player(pre_current_item_name, player) then
      difference[pre_current_item_name] = pre_current_item_amount;
    else
      for current_item_name, current_item_amount in pairs(get_inventory_contents(player)) do
        if pre_current_item_name == current_item_name then
          if pre_current_item_amount - current_item_amount ~= 0 then
            difference[current_item_name] = pre_current_item_amount - current_item_amount;
          end;
        end;
      end;
    end;
  end;
  return difference;
end;

local function validate_ingredents(item_to_validate, item_ingredents)

  validator = {};
  validator["validated"] = some_bool;
  validator["extra_leftover"] = some_item_array;
  validator["extra_needed"] = some_items_needed_array;

  return validator;

end;
