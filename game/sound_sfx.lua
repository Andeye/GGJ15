SoundSfx = {
  sounds = {},
}


function SoundSfx:load()
  self.sounds["ding"] = love.audio.newSource("assets/sounds/sfx/elevator_ding_placeholder.wav", "static")
  self.sounds["fart"] = love.audio.newSource("assets/sounds/sfx/silly_farts_joe.wav", "static")
end


function SoundSfx:play(key)
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



return SoundSfx