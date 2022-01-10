
--[[
Nyan Engi control script © 2022 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International. See LICENSE.txt for additional information
--]]

local speeds = {
  veryslow = 0.010,
  slow = 0.025,
  default = 0.050,
  fast = 0.100,
  veryfast = 0.200,
}

local palette = {
  light = {amplitude = 15, center = 240},           -- light
  pastel = {amplitude = 55, center = 200},          -- pastel <3
  default = {amplitude = 127.5, center = 127.5},    -- default (nyan)
  vibrant = {amplitude = 50, center = 100},         -- muted
  deep = {amplitude = 25, center = 50},             -- dark
}

local sin = math.sin
local pi_div_3 = math.pi / 3

function make_rainbow(rainbow, game_tick, player_settings)
  local index = rainbow.player_index
  local created_tick = rainbow.tick
  -- local player_settings = settings[index]
  local frequency = speeds[player_settings["nyan-rainbow-speed"]]
  if player_settings["nyan-rainbow-sync"] == true then
    created_tick = index
  end
  local modifier = (game_tick)+(index*created_tick)
  local palette_key = player_settings["nyan-rainbow-palette"]
  local amplitude = palette[palette_key].amplitude
  local center = palette[palette_key].center
  return {
    r = sin(frequency*(modifier)+(0*pi_div_3))*amplitude+center,
    g = sin(frequency*(modifier)+(2*pi_div_3))*amplitude+center,
    b = sin(frequency*(modifier)+(4*pi_div_3))*amplitude+center,
    a = 255,
  }
end

local function initialize_settings(index)
  if not global.settings then
    global.settings = {}
  end
  local player_settings = settings.get_player_settings(index)
  global.settings[index] = {}
  global.settings[index]["nyan-rainbow-glow"] = player_settings["nyan-rainbow-glow"].value
  global.settings[index]["nyan-rainbow-color"] = player_settings["nyan-rainbow-color"].value
  global.settings[index]["nyan-rainbow-length"] = player_settings["nyan-rainbow-length"].value
  global.settings[index]["nyan-rainbow-scale"] = player_settings["nyan-rainbow-scale"].value
  global.settings[index]["nyan-rainbow-speed"] = player_settings["nyan-rainbow-speed"].value
  global.settings[index]["nyan-rainbow-sync"] = player_settings["nyan-rainbow-sync"].value
  global.settings[index]["nyan-rainbow-palette"] = player_settings["nyan-rainbow-palette"].value
  global.settings[index]["nyan-rainbow-taper"] = player_settings["nyan-rainbow-taper"].value
end

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  initialize_settings(event.player_index)
end)

script.on_event(defines.events.on_player_changed_position, function(event)
  local player_index = event.player_index
  if not (global.settings and global.settings[player_index]) then
    initialize_settings(player_index)
  end
  -- local settings = global.settings
  local player_settings = global.settings[player_index]
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
      target = player.position,
      surface = player.surface,
      x_scale = scale,
      y_scale = scale,
      render_layer = "radius-visualization",
      time_to_live = length,
    }
    if not global.sprites then
      global.sprites = {}
    end
    local sprite_data = {
      sprite = sprite,
      tick_to_die = event_tick + length,
      size = (scale + length) * 4,
      tick = event_tick,
      player_index = player_index,
    }
    global.sprites[sprite] = sprite_data
    local rainbow_color = make_rainbow(sprite_data, event_tick, player_settings)
    rendering.set_color(sprite, rainbow_color)
  end
  if light then
    light = rendering.draw_light{
      sprite = "nyan",
      target = player.position,
      surface = player.surface,
      intensity = .175,
      scale = scale * 2,
      render_layer = "light-effect",
      time_to_live = length,
    }
    if not global.lights then
      global.lights = {}
    end
    local light_data = {
      light = light,
      tick_to_die = event_tick + length,
      size = (scale + length) * 4,
      tick = event_tick,
      player_index = player_index,
    }
    global.lights[light] = light_data
    local rainbow_color = make_rainbow(light_data, event_tick, player_settings)
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
        local player_settings = settings[rainbow.player_index]
        local rainbow_color = make_rainbow(rainbow, game_tick, player_settings)
        local size = rainbow.size
        -- local scale = rainbow.scale
        if sprite then
          if player_settings["nyan-rainbow-taper"] then
            local scale = rendering.get_x_scale(sprite)
            scale = scale - scale / size
            rendering.set_x_scale(sprite, scale)
            rendering.set_y_scale(sprite, scale)
          end
          rendering.set_color(sprite, rainbow_color)
          -- global.sprites[id].scale = scale
          -- global.sprites[id].size = rainbow.size - 1
        elseif light then
          if player_settings["nyan-rainbow-taper"] then
            local scale = rendering.get_scale(light)
            scale = scale - scale / size
            rendering.set_scale(light, scale)
          end
          rendering.set_color(light, rainbow_color)
          -- global.lights[id].scale = scale
          -- global.lights[id].size = rainbow.size - 1
        end
      end
    end
  end
  -- game.print(#render_ids)
  -- game.print("[color=blue]"..table_size(global.sprites).."[/color]    [color=orange]"..table_size(global.lights).."[/color]     [color=red]"..#(rendering.get_all_ids("nyan-engi")).."[/color]")
end)
