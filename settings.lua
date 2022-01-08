local rainbowSpeedSetting = {
  type = "string-setting",
  name = "nyan-rainbow-speed",
  setting_type = "runtime-per-user",
  default_value = "default",
  allowed_values = {
    "off",
    "veryslow",
    "slow",
    "default",
    "fast",
    "veryfast"
  }
}

-- local rainbowPaletteSetting = {
--   type = "string-setting",
--   name = "nyan-rainbow-palette",
--   setting_type = "runtime-per-user",
--   default_value = "default",
--   allowed_values = {
--     "pastel",
--     "light",
--     "default",
--     "vibrant",
--     "deep"
--   }
-- }

local rainbowTypeSetting = {
  type = "bool-setting",
  name = "nyan-rainbow-sync",
  setting_type = "runtime-per-user",
  default_value = false
}

local rainbowLengthSetting = {
  type = "string-setting",
  name = "nyan-rainbow-length",
  setting_type = "runtime-per-user",
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
  default_value = "5",
  allowed_values = {
    -- "0.25",
    -- "0.5",
    "1",
    -- "1.5",
    "2",
    "3",
    "4",
    "5",
    "6",
    "8",
    "10",
    "15",
    -- "20"
  }
}

local rainbowGlowSetting = {
  type = "bool-setting",
  name = "nyan-rainbow-glow",
  setting_type = "runtime-per-user",
  default_value = false
}
local rainbowColorSetting = {
  type = "bool-setting",
  name = "nyan-rainbow-color",
  setting_type = "runtime-per-user",
  default_value = true
}

data:extend({
  rainbowSpeedSetting,
  -- rainbowPaletteSetting,
  rainbowTypeSetting,
  rainbowLengthSetting,
  rainbowScaleSetting,
  rainbowGlowSetting,
  rainbowColorSetting
})
