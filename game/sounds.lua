Sounds = {
  sfx = {},
  music = {},
}

function Sounds:load()
  self.sfx["ding"] = love.audio.newSource("assets/sounds/sfx/elevator_ding_placeholder.wav", "static")
  self.sfx["fart"] = love.audio.newSource("assets/sounds/sfx/silly_farts_joe.wav", "static")

  self.music["bossanova"] = love.audio.newSource("assets/sounds/music/bossanova.mp3", "static")
  self.music["ding"] = love.audio.newSource("assets/sounds/sfx/elevator_ding_placeholder.wav", "static")
end


function Sounds:playSfx(key)
  if self.sfx[key] then
    self.sfx[key]:play()
  end
end


function Sounds:playMusic(key)
  if self.music[key] then
    self.music[key]:play()
  end
end


function Sounds:loopMusic(key)
  if self.music[key] then
    self.music[key]:setLooping(true)
  end
end

function Sounds:setVolumeMusic(key, value)
  if self.music[key] then
    self.music[key]:setVolume(value)
  end
end


function Sounds:pauseSfx(key)
  if self.sfx[key] then
    self.sfx[key]:pause()
  end
end


function Sounds:stopSfx(key)
  if self.sfx[key] then
    self.sfx[key]:stop()
  end
end


return Sounds
