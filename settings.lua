local rainbowSpeedSetting = {
  type = "string-setting",
  name = "nyan-rainbow-speed",
  setting_type = "runtime-per-user",
  order = "f",
  default_value = "default",
  allowed_values = {
    "veryslow",
    "slow",
    "default",
    "fast",
    "veryfast"
  }
}

local rainbowPaletteSetting = {
  type = "string-setting",
  name = "nyan-rainbow-palette",
  setting_type = "runtime-per-user",
  order = "e",
  default_value = "default",
  allowed_values = {
    "light",
    "pastel",
    "default",
    "vibrant",
    "deep"
  }
}

local rainbowTypeSetting = {
  type = "bool-setting",
  name = "nyan-rainbow-sync",
  setting_type = "runtime-per-user",
  order = "d",
  default_value = false
}

local rainbowTaperSetting = {
  type = "bool-setting",
  name = "nyan-rainbow-taper",
  setting_type = "runtime-per-user",
  order = "c",
  default_value = true
}

local rainbowLengthSetting = {
  type = "string-setting",
  name = "nyan-rainbow-length",
  setting_type = "runtime-per-user",
  order = "h",
  default_value = "120",
  allowed_values = {
    "15",
    "30",
    "60",
    "90",
    "120",
    "180",
    "210",
    "300",
    "600"
  }
}

local rainbowScaleSetting = {
  type = "string-setting",
  name = "nyan-rainbow-scale",
  setting_type = "runtime-per-user",
  order = "g",
  default_value = "5",
  allowed_values = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "8",
    "11",
    "20",
  }
}

local rainbowGlowSetting = {
  type = "bool-setting",
  name = "nyan-rainbow-glow",
  setting_type = "runtime-per-user",
  order = "a",
  default_value = true
}
local rainbowColorSetting = {
  type = "bool-setting",
  name = "nyan-rainbow-color",
  setting_type = "runtime-per-user",
  order = "b",
  default_value = true
}

data:extend({
  rainbowSpeedSetting,
  rainbowPaletteSetting,
  rainbowTypeSetting,
  rainbowLengthSetting,
  rainbowScaleSetting,
  rainbowGlowSetting,
  rainbowColorSetting,
  rainbowTaperSetting
})
