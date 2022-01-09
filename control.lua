
require "util"

local speeds = {
  veryslow = 0.010,
  slow = 0.025,
  default = 0.050,
  fast = 0.100,
  veryfast = 0.200,
}

local pallette = {
  pastel = {amplitude = 55, center = 200},
  light = {amplitude = 66, center = 166},
  default = {amplitude = 127, center = 127},
  vibrant = {amplitude = 77, center = 77},
  deep = {amplitude = 55, center = 55},
}

-- script.on_nth_tick(60, function(event)
--   if not global.settings then
--     global.settings = {}
--   end
--   for index, player in pairs(game.connected_players) do
--     global.settings[index] = {}
--     local settings = {
--       speed = settings.get_player_settings(index)["nyan-rainbow-speed"].value,
--       sync = settings.get_player_settings(index)["nyan-rainbow-sync"].value,
--       palette = settings.get_player_settings(index)["nyan-rainbow-palette"].value,
--     }
--     global.settings[index] = settings
--   end
--   game.print(serpent.block(global.settings))
-- end)

function make_rainbow(rainbow, game_tick, all_settings)
  local index = rainbow.player_index
  local created_tick = rainbow.tick
  -- local game_tick = game.tick
  local player_settings = all_settings[index]
  local frequency = speeds[player_settings["nyan-rainbow-speed"].value]
  -- local frequency = 0.050
  if player_settings["nyan-rainbow-sync"].value == true then
    created_tick = index
  end
  -- if false == true then
  --   created_tick = index
  -- end
  local pi_3 = 1.0471975512 --[[or math.pi/3]]
  local modifier = (game_tick)+(index*created_tick)
  local palette_key = player_settings["nyan-rainbow-palette"].value
  -- local palette_key = "default"
  local amplitude = pallette[palette_key].amplitude
  local center = pallette[palette_key].center
  -- local rainbow_color = {
  return {
    r = math.sin(frequency*(modifier)+(0*pi_3))*amplitude+center,
    g = math.sin(frequency*(modifier)+(2*pi_3))*amplitude+center,
    b = math.sin(frequency*(modifier)+(4*pi_3))*amplitude+center,
    -- a = pallette[settings.get_player_settings(index)["nyan-rainbow-palette"].value],
    a = 255,
  }
  -- return rainbow_color
end

script.on_event(defines.events.on_player_changed_position, function(event)
  local player_index = event.player_index
  local all_settings = {}
  all_settings[player_index] = settings.get_player_settings(player_index)
  local player_settings = all_settings[player_index]
  local sprite = player_settings["nyan-rainbow-color"].value
  local light = player_settings["nyan-rainbow-glow"].value
  local player = {}
  if sprite or light then
    player = game.get_player(player_index)
  else
    return
  end
  local event_tick = event.tick
  local length = tonumber(player_settings["nyan-rainbow-length"].value)
  local scale = tonumber(player_settings["nyan-rainbow-scale"].value)
  if sprite then
    sprite = rendering.draw_sprite{
      sprite = "nyan",
      -- tint = rainbow,
      target = player.position,
      surface = player.surface,
      x_scale = scale,
      y_scale = scale,
      render_layer = "radius-visualization",
      -- visible = false,
      time_to_live = length,
    }
    if not global.sprites then
      global.sprites = {}
    end
    local sprite_data = {
      sprite = sprite,
      tick_to_die = event_tick + length,
      size = scale * length,
      -- id = sprite or light,
      tick = event_tick,
      player_index = player_index,
      -- scale = scale,
      -- visible = {sprite = false, light = false}
    }
    global.sprites[sprite] = sprite_data
    local rainbow_color = make_rainbow(sprite_data, event_tick, all_settings)
    -- local rainbow_color = {1,1,1,1}
    rendering.set_color(sprite, rainbow_color)
    -- rendering.bring_to_front(sprite)
  end
  if light then
    light = rendering.draw_light{
      sprite = "nyan",
      -- color = rainbow,
      target = player.position,
      surface = player.surface,
      intensity = .25,
      scale = scale * 1.5,
      render_layer = "radius-visualization",
      -- visible = false,
      time_to_live = length,
    }
    if not global.lights then
      global.lights = {}
    end
    local light_data = {
      light = light,
      tick_to_die = event_tick + length,
      size = scale * length,
      -- id = sprite or light,
      tick = event_tick,
      player_index = player_index,
      -- scale = scale * 1.5,
      -- visible = {sprite = false, light = false}
    }
    global.lights[light] = light_data
    local rainbow_color = make_rainbow(light_data, event_tick, all_settings)
    -- local rainbow_color = {1,1,1,1}
    rendering.set_color(light, rainbow_color)
  -- end
    -- rendering.bring_to_front(light)
  end
  -- if not global.rainbows then
  --   global.rainbows = {}
  -- end
  -- if not global.rainbows[player_index] then
  --   global.rainbows[player_index] = {}
  -- end
  -- table.insert(global.rainbows[player_index], {
  --   sprite = sprite,
  --   light = light,
  --   tick_to_die = event.tick + length,
  --   size = scale * length,
  --   id = sprite or light,
  --   tick = event.tick,
  --   player_index = player_index,
  --   visible = {sprite = false, light = false}
  -- })

end)

script.on_event(defines.events.on_tick, function(event)
  -- if global.rainbows then
  --   for p, player in pairs(global.rainbows) do
  --     for r, rainbow in pairs(player) do
  --       -- if rainbow then
  --         -- if not (rainbow.sprite or rainbow.light) then
  --         --   global.rainbows[p][r] = nil
  --         -- if not (rendering.is_valid(rainbow.sprite) or rendering.is_valid(rainbow.light)) then
  --         --   rendering.destroy(rainbow.sprite)
  --         --   rendering.destroy(rainbow.light)
  --         --   global.rainbows[p][r] = nil
  --         --   break
  --         if (rainbow.tick_to_die <= game.tick) then
  --           -- rendering.set_time_to_live(rainbow.sprite, 1)
  --           -- rendering.set_time_to_live(rainbow.light, 1)
  --           -- rendering.destroy(rainbow.sprite)
  --           -- rendering.destroy(rainbow.light)
  --           global.rainbows[p][r] = nil
  --         else
  --           rainbow.tick = game.tick
  --           local rainbow_color = make_rainbow(rainbow)
  --           if not rainbow_color then return end
  --           if rainbow.light then
  --             local light_scale = rendering.get_scale(rainbow.light)
  --             rendering.set_scale(rainbow.light, (light_scale - light_scale/rainbow.size))
  --             rendering.set_color(rainbow.light, rainbow_color)
  --             if not rainbow.visible.light then
  --               rendering.set_visible(rainbow.light, true)
  --               global.rainbows[p][r].visible.light = true
  --             end
  --           end
  --           if rainbow.sprite then
  --             local sprite_scale = rendering.get_x_scale(rainbow.sprite)
  --             rendering.set_x_scale(rainbow.sprite, (sprite_scale - sprite_scale/rainbow.size))
  --             rendering.set_y_scale(rainbow.sprite, (sprite_scale - sprite_scale/rainbow.size))
  --             rendering.set_color(rainbow.sprite, rainbow_color)
  --             if not rainbow.visible.sprite then
  --               rendering.set_visible(rainbow.sprite, true)
  --               global.rainbows[p][r].visible.sprite = true
  --             end
  --           end
  --           global.rainbows[p][r].size = rainbow.size - 1
  --         end
  --       -- end
  --     end
  --     game.print("[color=blue]"..#global.rainbows[p].."[/color]     [color=red]"..#(rendering.get_all_ids("nyan-engi")).."[/color]")
  --   end
  -- end
  local render_ids = rendering.get_all_ids("nyan-engi")
  if not render_ids then
    return
  end
  local game_tick = event.tick
  local all_settings = {}
  for _, player in pairs(game.connected_players) do
    local index = player.index
    -- local player_settings = {
    --   speed = settings.get_player_settings(index)["nyan-rainbow-speed"].value,
    --   sync = settings.get_player_settings(index)["nyan-rainbow-sync"].value,
    --   palette = settings.get_player_settings(index)["nyan-rainbow-palette"].value,
    -- }
    all_settings[index] = settings.get_player_settings(index)
  end
  for _, id in pairs(render_ids) do
    -- local rainbow = {}
    -- if global.sprites and global.sprites[id] then
    --   rainbow = global.sprites[id]
    -- end
    local rainbow = global.sprites[id] or global.lights[id]
    if rainbow then
      local sprite = rainbow.sprite
      local light = rainbow.light
      if rainbow.tick_to_die <= game_tick then
        if sprite then
          global.sprites[id] = nil
        elseif light then
          global.lights[id] = nil
        end
      else
        local rainbow_color = make_rainbow(rainbow, game_tick, all_settings)
        -- local rainbow_color = {1,1,1,1}
        -- local size = rainbow.size
        -- local scale = rainbow.scale
        -- scale = scale - scale / size
        -- rendering.set_x_scale(sprite, (sprite_scale - sprite_scale / size))
        -- rendering.set_y_scale(sprite, (sprite_scale - sprite_scale / size))
        if sprite then
          -- local scale = rendering.get_x_scale(sprite)
          -- scale = scale - scale / size
          -- rendering.set_x_scale(sprite, scale)
          -- rendering.set_y_scale(sprite, scale)
          rendering.set_color(sprite, rainbow_color)
          -- global.sprites[id].scale = scale
          -- global.sprites[id].size = rainbow.size - 1
        elseif light then
          -- local scale = rendering.get_scale(light)
          -- scale = scale - scale / size
          -- rendering.set_scale(light, scale)
          rendering.set_color(light, rainbow_color)
          -- global.lights[id].scale = scale
          -- global.lights[id].size = rainbow.size - 1
        end
        -- if not rainbow.visible.sprite then
        --   rendering.set_visible(rainbow.sprite, true)
        --   global.sprites[id].visible.sprite = true
        -- end
        -- global.sprites[id].size = rainbow.size - 1
      end
    -- else rainbow = global.lights[id]
    --   if rainbow then
    --     if rainbow.tick_to_die <= game.tick then
    --       global.lights[id] = nil
    --     else
    --       -- rainbow.tick = game.tick
    --       local rainbow_color = make_rainbow(rainbow)
    --       -- if not rainbow_color then return end
    --       local light = rainbow.light
    --       local size = rainbow.size
    --       -- local light_scale = rendering.get_scale(light)
    --       local light_scale = rainbow.scale
    --       light_scale = light_scale - light_scale/size
    --       global.lights[id].scale = light_scale
    --       -- rendering.set_scale(light, (light_scale - light_scale/size))
    --       rendering.set_scale(light, scale)
    --       rendering.set_color(light, scale)
    --       -- if not rainbow.visible.light then
    --       --   rendering.set_visible(rainbow.light, true)
    --       --   global.lights[id].visible.light = true
    --       -- end
    --       global.lights[id].size = rainbow.size - 1
    --     end
    --   end
    end
  end
  -- game.print("[color=blue]"..table_size(global.sprites).."[/color]    [color=orange]"..table_size(global.lights).."[/color]     [color=red]"..#(rendering.get_all_ids("nyan-engi")).."[/color]")
end)












--
--
-- --[[ and now here's the attempted lamp section of the mod --]]
--
-- if not global.lamps then
--   global.lamps = {}
-- end
--
-- function initialize_lamps()
--   for every, surface in pairs(game.surfaces) do
--     for each, lamp in pairs(surface.find_entities_filtered{type={"lamp"}}) do
--       if not global.lamps then
--         global.lamps = {}
--       end
--       global.lamps[lamp.unit_number] = {
--         entity = lamp,
--         glow = nil,
--       }
--     end
--   end
-- end
--
-- script.on_init(function()
--   initialize_lamps()
-- end)
--
-- script.on_configuration_changed(function()
--   initialize_lamps()
-- end)
--
-- script.on_nth_tick(5, function(event)
--   local frequency = 0.050
--   local rainbow_speed = settings.global["lamp-rainbow-speed"].value
--   if rainbow_speed == "off" then
--     for unit_number, data in pairs(global.lamps) do
--       if data.glow then
--         rendering.destroy(data.glow)
--         data.glow = nil
--       end
--     end
--     return
--   else
--     frequency = speeds[rainbow_speed]
--   end
--   -- game.print(serpent.block(global.lamps))
--   for unit_number, data in pairs(global.lamps) do
--     if data and data.entity and data.entity.valid then
--       if (not data.entity.get_control_behavior() and data.entity.status == 1) then
--         local id = data.entity.unit_number
--         local nth_tick = event.nth_tick
--         local tick = event.tick
--         if settings.global["lamp-rainbow-sync"].value == true then
--           id = 0
--         end
--         local rainbow = {
--           r = math.sin(frequency*((tick/nth_tick)+(id*10))+(0*math.pi/3))*127+128,
--           g = math.sin(frequency*((tick/nth_tick)+(id*10))+(2*math.pi/3))*127+128,
--           b = math.sin(frequency*((tick/nth_tick)+(id*10))+(4*math.pi/3))*127+128,
--           a = pallette[settings.global["lamp-rainbow-palette"].value],
--         }
--         -- rainbow.a = 0.1
--         if not data.glow then
--           data.glow = rendering.draw_sprite{
--             sprite = "utility/light_medium",
--             color = rainbow,
--             target = data.entity,
--             surface = data.entity.surface,
--             -- intensity = 0.25,
--             -- scale = 1,
--             x_scale = 2,
--             y_scale = 2,
--             render_layer = "light-effect",
--             -- render_mode = "subtractive",
--             -- glow_size = 6,
--             -- glow_color_intensity = 1,
--             -- glow_render_mode = "additive",
--           }
--           rendering.bring_to_front(data.glow)
--         else
--           rendering.set_color(data.glow, rainbow)
--         end
--       else
--         if data.glow then
--           rendering.destroy(data.glow)
--           data.glow = nil
--         end
--       end
--     else
--       global.lamps[unit_number] = nil
--     end
--   end
-- end
-- )
--
-- function on_built(event)
--   local entity = event.created_entity or event.entity or event.destination
--   if entity.type == "lamp" then
--     global.lamps[entity.unit_number] = {
--       entity = entity,
--       glow = nil,
--     }
--   end
-- end
--
-- script.on_event(defines.events.on_built_entity, on_built)
-- script.on_event(defines.events.on_entity_cloned, on_built)
-- script.on_event(defines.events.on_robot_built_entity, on_built)
-- script.on_event(defines.events.script_raised_built, on_built)
-- script.on_event(defines.events.script_raised_revive, on_built)
