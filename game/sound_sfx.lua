SoundSfx = {
  sounds = {},
}


function SoundSfx:load()
  local dir = "assets/sounds/sfx"
  local files = love.filesystem.getDirectoryItems(dir)
  print("Loading sound effects:")
  for _, f in ipairs(files) do
  
    -- assuming that the extension is 3 characters long
    if string.sub(f,#f - 3,#f - 3) ~= "." then
      error("Sound effect " .. f .. " does not have a 3 character long extension!")
    end
    
    local filename = string.sub(f, 0, #f - 4)
    local extension = string.sub(f, #f - 2, #f)
    print("  " .. filename)
    self.sounds[filename] = love.audio.newSource(dir .. "/" .. filename .. "." .. extension, "static")
  end
  
  -- set specific sound volumes
  self:setVolume("button_click", .15)
  self:setVolume("button_release", .6)
end


function SoundSfx:play(key)
  print("Playing sound: " .. key)
  if self.sounds[key] then
    self.sounds[key]:play()
  end
end


function SoundSfx:pause(key)
  if self.sfx[key] then
    self.sfx[key]:pause()
  end
end


function SoundSfx:stop(key)
  if self.sfx[key] then
    self.sfx[key]:stop()
  end
end


function SoundSfx:setVolume(key, vol)
  if self.sounds[key] ~= nil then
    self.sounds[key]:setVolume(vol)
  end
end



return SoundSfx