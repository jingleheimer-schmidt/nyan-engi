
require "util"

local speeds = {
  veryslow = 0.010,
  slow = 0.025,
  default = 0.050,
  fast = 0.100,
  veryfast = 0.200,
}

local pallette = {
  pastel = {amplitude = 55, center = 200},      -- pastel
  light = {amplitude = 66, center = 166},       -- light
  default = {amplitude = 127, center = 127},    -- default
  vibrant = {amplitude = 77, center = 77},      -- neon
  deep = {amplitude = 55, center = 55},         -- nyan
}

function make_rainbow(rainbow, game_tick, settings)
  local index = rainbow.player_index
  local created_tick = rainbow.tick
  -- local game_tick = game.tick
  local player_settings = settings[index]
  local frequency = speeds[player_settings["nyan-rainbow-speed"]]
  -- local frequency = 0.050
  if player_settings["nyan-rainbow-sync"] == true then
    created_tick = index
  end
  -- if false == true then
  --   created_tick = index
  -- end
  local pi_3 = 1.0471975512 --[[or math.pi/3]]
  local modifier = (game_tick)+(index*created_tick)
  local palette_key = player_settings["nyan-rainbow-palette"]
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

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  local player_index = event.player_index
  local setting_name = event.setting
  global.settings[player_index][setting_name] = settings.get_player_settings(player_index)[setting_name].value
end)

local function initialize_settings()
  if not global.settings then
    global.settings = {}
  end
  for index, player in pairs(game.players) do
    local player_settings = settings.get_player_settings(player.index)
    global.settings[index] = {}
    global.settings[index]["nyan-rainbow-glow"] = player_settings["nyan-rainbow-glow"].value
    global.settings[index]["nyan-rainbow-color"] = player_settings["nyan-rainbow-color"].value
    global.settings[index]["nyan-rainbow-length"] = player_settings["nyan-rainbow-length"].value
    global.settings[index]["nyan-rainbow-scale"] = player_settings["nyan-rainbow-scale"].value
    global.settings[index]["nyan-rainbow-speed"] = player_settings["nyan-rainbow-speed"].value
    global.settings[index]["nyan-rainbow-sync"] = player_settings["nyan-rainbow-sync"].value
    global.settings[index]["nyan-rainbow-palette"] = player_settings["nyan-rainbow-palette"].value
  end
  game.print(serpent.block(global.settings))
end

script.on_init(function()
  initialize_settings()
end)

script.on_configuration_changed(function()
  initialize_settings()
end)

script.on_event(defines.events.on_player_changed_position, function(event)
  local player_index = event.player_index
  local settings = global.settings
  -- all_settings[player_index] = settings.get_player_settings(player_index)
  local player_settings = settings[player_index]
  local sprite = player_settings["nyan-rainbow-color"]
  local light = player_settings["nyan-rainbow-glow"]
  local player = {}
  if sprite or light then
    player = game.get_player(player_index)
  else
    return
  end
  local event_tick = event.tick
  local length = tonumber(player_settings["nyan-rainbow-length"])
  local scale = tonumber(player_settings["nyan-rainbow-scale"])
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
    local rainbow_color = make_rainbow(sprite_data, event_tick, settings)
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
    local rainbow_color = make_rainbow(light_data, event_tick, settings)
    -- local rainbow_color = {1,1,1,1}
    rendering.set_color(light, rainbow_color)
  end
end)

script.on_event(defines.events.on_tick, function(event)

  local render_ids = rendering.get_all_ids("nyan-engi")
  if not render_ids then
    return
  end
  local game_tick = event.tick
  local settings = global.settings
  for _, id in pairs(render_ids) do
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
        local rainbow_color = make_rainbow(rainbow, game_tick, settings)
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
